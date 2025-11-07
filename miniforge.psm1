$global:__logging = $true
$global:__miniforge = @{ rootpath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }


# ---- Helper Functions ----
function kvinc([string]$keyName, [string]$KeyValue, [string]$type='none') {

    [string]$string = ''
    
    $utility = @{
        kvinc_bracket_color  = "95"
        kvinc_bracket_format = ";1"
        kvinc_type_color     = "90"
        kvinc_type_format    = ";1"
        kvinc_key_color      = "94"
        kvinc_key_format     = ";1"
        kvinc_value_color    = "90"
        kvinc_value_format   = ";1"
    }
    
    $string += "`e[$($utility.kvinc_bracket_color)$($utility.kvinc_bracket_format)m{`e[0m"

    switch ($type) {
        # NOTE: Add in more options
        'inf' { $string += "`e[37$($utility.kvinc_type_format)mINF`e[0m ≡" }
        'wrn' { $string += "`e[33$($utility.kvinc_type_format)mWRN`e[0m ≡" }
        'err' { $string += "`e[31$($utility.kvinc_type_format)mERR`e[0m ≡" }
        'property' { $string += "`e[31$($utility.kvinc_type_format)mPROPERTY`e[0m ≡" }
        'value' { $string += "`e[31$($utility.kvinc_type_format)mVALUE`e[0m ≡" }
        'key' { $string += "`e[31$($utility.kvinc_type_format)mKEY`e[0m ≡" }
        'type' { $string += "`e[31$($utility.kvinc_type_format)mTYPE`e[0m ≡" }
        default { }
    }

    $string += " `e[$($utility.kvinc_key_color)$($utility.kvinc_key_format)m$keyName`e[0m "
    $string += " `e[$($utility.kvinc_bracket_color)$($utility.kvinc_bracket_format)m:`e[0m"
    $string += " `e[$($utility.kvinc_value_color)$($utility.kvinc_value_format)m$KeyValue`e[0m "
    $string += " `e[$($utility.kvinc_bracket_color)$($utility.kvinc_bracket_format)m}`e[0m"

    return $string
}

function ckvstring ([string]$Message) {

    $kvinc = $global:__automator_devops.kvinc
    $pattern = '(?<Prefix>\{(?<Level>inf|wrn|err):)?kv:(?<Key>[^=]+)=(?<Value>.*?)\}'

    $finalMessage = $Message

    # Get all matches first
    $allMatches = [regex]::Matches($finalMessage, $pattern)

    # Process matches from right to left to avoid index shifting issues
    for ($i = $allMatches.Count - 1; $i -ge 0; $i--) {
        $match = $allMatches[$i]
        $level = $match.Groups['Level'].Value.Trim()
        $key = $match.Groups['Key'].Value
        $value = $match.Groups['Value'].Value.Trim()

        $replacement = $kvinc.Invoke($key, $value, $level)
        $finalMessage = $finalMessage.Remove($match.Index, $match.Length).Insert($match.Index, $replacement)
    }

    return $finalMessage

}

function logr([string]$Message, [string]$Action, [string]$Type, [string]$LogName = 'logr') {

    $utility = @{
        logr_logname_color  = "95"
        logr_logname_format = ";1"
        logr_type_format    = ";1"
        logr_action_format  = ";1"
        logr_message_color  = "90"
        logr_message_format = ";1"
    }
    
    # Build log message with ANSI colors
    $logMessage = "`e[$($utility.logr_logname_color)$($utility.logr_logname_format)m$LogName`e[0m -> "
    
    # Add type prefix with color
    # Use ASCII (ANSI) color codes for type prefix
    switch ($Type) {
        'err' { $logMessage += "`e[31$($utility.logr_type_format)merr`e[0m" }      # Red
        'inf' { $logMessage += "`e[37$($utility.logr_type_format)minf`e[0m" }      # Gray/White
        'wrn' { $logMessage += "`e[33$($utility.logr_type_format)mwrn`e[0m" }      # Yellow
        default {  }
    }
    # Add separator
    $logMessage += ' | '
    
    # Add action with color using ASCII (ANSI) escape codes
    $logMessage += switch ($Action) {
        'read' { "`e[32mread`e[0m" }        # Green
        'update' { "`e[33mupdate`e[0m" }      # Yellow
        'delete' { "`e[31mdelete`e[0m" }      # Red
        'push' { "`e[34mpush`e[0m" }        # Blue
        'pull' { "`e[35mpull`e[0m" }        # Magenta
        'create' { "`e[36mcreate`e[0m" }      # Cyan
        'check' { "`e[37mcheck`e[0m" }       # White (default foreground)
    }
    
    $logMessage += " -> "
    # Add message
    $logMessage += "`e[$($utility.logr_message_color)$($utility.logr_message_format)m$Message`e[0m ≡"

    if ($global:__logging -eq $true -or $script:log -eq $true -or $verbose -eq $true) {
        [System.Console]::WriteLine($logMessage)
    }
}

# PsObject type use a special cmdlet to add properties add-member or you can use the 
# dot notation but need the type accellerator noteProperty eg: $Data | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
# or $Data.add([NoteProperty]::new($Name, $Value))
function check_collections_pso($dataSet) {
    if ($dataSet -eq 'PSObject' -or 
        $dataSet -eq 'PSCustomObject') {
        return $true
    }
    else {
        return $false
    }
}

function check_collections_other($dataSet) {
    if ($dataSet -eq 'Hashtable' -or     
        $dataSet -eq 'Dictionary' -or
        $dataSet -eq 'OrderedDictionary' -or
        $dataSet -eq 'SortedList' -or
        $dataSet -eq 'SortedList<int,string>') {
        return $true
    }
    else {
        return $false
    }

}

# ---- Helper Functions ----

# ---- Main Function: Invoke-ForgeAction ----
function Invoke-ForgeAction {
    <#
    .SYNOPSIS
    Performs Create, Update, Delete (CUD) and array push/pull operations on 
    Hashtable, PSObject, or PSCustomObject data structures.
    
    .DESCRIPTION
    This function allows for unified manipulation of key/value pairs across
    different object types. Actions include 'add', 'update', 'remove' for 
    properties, and 'push' and 'pull' for array-type properties.
    
    .PARAMETER Data
    The target object (Hashtable, PSObject, or PSCustomObject) to modify.
    
    .PARAMETER Action
    The operation to perform: 'get', 'add', 'update', 'remove', 'push', or 'pull'.
    
    .PARAMETER Name
    The name of the property or key to act upon.
    
    .PARAMETER Value
    The value to be added, updated, pushed, or pulled (removed).
    
    .PARAMETER log
    Switch value to output debug infomation to the console 

    .EXAMPLE
    $ht = @{ 'Key1' = 'Value1' }
    Invoke-ForgeAction -Data $ht -Action add -Name 'Key2' -Value 'Value2'
    [System.Console]::WriteLine("New Data: $($ht | Out-String)")
    
    .EXAMPLE
    $obj = [PSCustomObject]@{ Tags = @('A', 'B') }
    Invoke-ForgeAction -Data $obj -Action push -Name 'Tags' -Value 'C'
    [System.Console]::WriteLine("New Data: $($obj.Tags)")
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Alias('miniforge', 'imini')]
    param(
        [Parameter(Mandatory = $true, valuefrompipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        $Data,

        [Parameter(Mandatory = $true)]
        [ValidateSet('create', 'read', 'update', 'delete', 'push', 'pull')]
        [string]$Action,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        $Value
    )

    begin {
        # --- Core Logic ---
        if (-not $Data) {
            logr "Data object is null. Cannot perform action '$($Action)' on '$($Name)'." 'error' 'err' 'miniforge'
            return
        }
        [string] $dataType = $Data.GetType().Name
        [string] $valueType = if ($null -ne $Value) { $Value.GetType().Name } else { 'null' }
    }

    process {
        try {
            switch ($Action) { 
                <# ..........................................
                CREATE ACTION
                ..........................................
                Synopsis: Creates a new property or key in the data structure.
                Supports: [psobject], [pscustomobject], [hashtable], [dictionary], [ordereddictionary], [sortedlist], [sortedlist<int,string>]
                .............................................#>
                'create' {
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        # with create check if key already exists and prevent overwrite
                        if ($Data.ContainsKey($Name)) {
                            logr "$(kvinc "Property" $name) already exists in ⇒ (`e[13;4m$dataType`e[0m), use update instead." 'create' 'wrn' 'miniforge'
                            return
                        }
                        $Data.Add($Name, $Value)
                        logr "$(kvinc "Property" $name) added to ⇒ (`e[13;4m$dataType`e[0m)" 'create' 'inf' 'miniforge'
                    }
                    else { 
                        # with create check if key already exists and prevent overwrite
                        if ($Data.PSObject.Properties.Name -contains $Name) {
                            logr "$(kvinc "Property" $name) already exists in ⇒ (`e[13;4m$dataType`e[0m), use update instead." 'create' 'wrn' 'miniforge'
                            return
                        }
                        # PSCustomObject or PSObject
                        $Data | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -Force
                        logr "$(kvinc "Property" $name) added to ⇒ (`e[13;4m$dataType`e[0m) dataSet." 'create' 'inf' 'miniforge'
                    }
                }
            
                'update' {
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        if ($Data.ContainsKey($Name)) {
                            logr "$(kvinc "Property" $Name) updated in ⇒ (`e[13;4m$dataType`e[0m)" 'update' 'inf' 'miniforge'
                            $Data[$Name] = $Value
                        }
                        else {
                            logr "$(kvinc "Property" $Name) not found for update in ⇒ (`e[13;4m$dataType`e[0m)" 'update' 'wrn' 'miniforge'
                        }
                    }
                    else {
                        # PSCustomObject or PSObject
                        if ($Data.PSObject.Properties.Name -contains $Name) {
                            logr "$(kvinc "Property" $Name) updated in ⇒ (`e[13;4m$dataType`e[0m)" 'update' 'inf' 'miniforge'
                            $Data.$Name = $Value
                        }
                        else {
                            logr "$(kvinc "Property" $Name) not found for update in ⇒ (`e[13;4m$dataType`e[0m)" 'update' 'wrn' 'miniforge'
                        }
                    }
                }

                'delete' {
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        if ($Data.ContainsKey($Name)) {
                            $Data.Remove($Name)
                            logr "$(kvinc "Property" $Name) deleted in ⇒ (`e[13;4m$dataType`e[0m)" 'delete' 'inf' 'miniforge'
                        }
                        else {
                           logr "$(kvinc "Property" $Name) not found for delete in ⇒ (`e[13;4m$dataType`e[0m)" 'delete' 'wrn' 'miniforge'
                        }
                    }
                    else {
                        # PSCustomObject or PSObject
                        if ($Data.PSObject.Properties.Name -contains $Name) {
                            $Data.PSObject.Properties.Remove($Name)
                            logr "$(kvinc "Property" $Name) deleted in ⇒ (`e[13;4m$dataType`e[0m)" 'delete' 'inf' 'miniforge'
                        }
                        else {
                            logr "$(kvinc "Property" $Name) not found for delete in ⇒ (`e[13;4m$dataType`e[0m)" 'delete' 'wrn' 'miniforge'
                        }
                    }
                }

                'read' {
                    # 1. CRITICAL: Check if $Data exists *before* doing anything with it.
                    if (-not $Data) {
                        logr "Data object is null. Cannot read property ⇒ (`e[13;4m$Name`e[0m)." 'read' 'err' 'miniforge'
                        return $null
                    }
    
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
    
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        # This path is for collections like Hashtable, Dictionary, etc.
        
                        # NOTE: A null check on $Data is still needed here if $Data could become null 
                        # unexpectedly, but the first check covers it.
                        if ($Data.ContainsKey($Name)) {
                            logr "$(kvinc "Property" $Name) retrieved in ⇒ (`e[13;4m$dataType`e[0m)." 'read' 'inf' 'miniforge'
                            return $Data[$Name]
                        }
                        else {
                            logr "$(kvinc "Property" $Name) not found for read in ⇒ (`e[13;4m$dataType`e[0m)." 'read' 'wrn' 'miniforge'
                            return $null
                        }
                    }
                    else {
                        # This path is for PSCustomObject or PSObject
        
                        # NOTE: Using $Data.PSObject.Properties.Name is often safer than $Data.$Name 
                        # when dealing with mixed types.
                        if ($Data.PSObject.Properties.Name -contains $Name) {
                            logr "$(kvinc "Property" $Name) retrieved in ⇒ (`e[13;4m$dataType`e[0m)." 'read' 'inf' 'miniforge'
                            return $Data.$Name
                        }
                        else {
                            logr "$(kvinc "Property" $Name) not found for read in ⇒ (`e[13;4m$dataType`e[0m)." 'read' 'wrn' 'miniforge'
                            return $null
                        }
                    }
                }

                'push' {
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
                    # Ensure the property/key exists and its value is an array type
                    $currentValue = $null
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        if ($Data.ContainsKey($Name)) { $currentValue = $Data[$Name] }
                    }
                    else {
                        if ($Data.PSObject.Properties.Name -contains $Name) { $currentValue = $Data.$Name }
                    }

                    if ($currentValue -is [System.Array]) {
                        # Will Match array Types
                        # ---------------------
                        # - [psobject[]]
                        # - [pscustomobject[]]
                        # - [string[]]
                        # - [hashtable[]]
                        # - [int[]]
                        # - [object[]]
                    
                        # Push/Append the new value to the existing array
                        $newValue = @($currentValue) + $Value
                    
                        if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                            $Data[$Name] = $newValue
                        }
                        else {
                            $Data.$Name = $newValue
                        }
                        logr "$(kvinc "Property" $Name) pushed to ⇒ (`e[13;4m$dataType`e[0m)." 'push' 'inf' 'miniforge'
                    }
                    else {
                         logr "Push action only works on array-type properties. ⇒ (`e[13;4m$Name`e[0m) is not an array." 'push' 'wrn' 'miniforge'
                         logr "Supported Types $(kvinc "ArrayTypes" "[psobject[]], [pscustomobject[]], [string[]], [hashtable[]], [int[]], [object[]]" "inf")" 'push' 'inf' 'miniforge'
                    }
                }
                <# ..........................................
                PULL ACTION
                ..........................................
                Synopsis: Removes the specified Value from the array property.
                Supports: [psobject[]], [pscustomobject[]], [string[]], [hashtable[]], [int[]], [object[]]
                .............................................#>
                'pull' {
                    logr "Checking collection type: '`e[13;4m$dataType`e[0m' against supported collection types." 'check' 'inf' 'miniforge'
                    # Ensure the property/key exists and its value is an array type
                    $currentValue = $null
                    if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                        if ($Data.ContainsKey($Name)) { $currentValue = $Data[$Name] }
                    }
                    else {
                        if ($Data.PSObject.Properties.Name -contains $Name) { $currentValue = $Data.$Name }
                    }

                    if ($currentValue -is [System.Array]) {
                        # Pull/Remove the value from the existing array by filtering
                        $newValue = @($currentValue) | Where-Object { $_ -ne $Value }
                    
                        if (check_collections_other($dataType) -and -not check_collections_pso($dataType)) {
                            $Data[$Name] = $newValue
                        }
                        else {
                            $Data.$Name = $newValue
                        }
                         logr "Pulled (removed) value from array $(kvinc "Property" $Name "inf")" 'success' 'inf' 'miniforge'
                    }
                    else { 
                         logr "Supported Types $(kvinc "ArrayTypes" "[psobject[]], [pscustomobject[]], [string[]], [hashtable[]], [int[]], [object[]]" "inf") " 'push' 'inf' 'miniforge'
                    }
                }
            }
        }
        catch {
             logr "FATAL ERROR: An unexpected error occurred during action '$($Action)' on '$($Name)'. Error: $($_.Exception.Message)" 'error' 'err' 'miniforge'
             logr "Action: $($Action) | Name: $($Name) | Value: $($Value) | Type: $($dataType) | Data: $($Data)" 'error' 'err' 'miniforge'
             logr "Stack Trace: $($_.ScriptStackTrace)" 'error' 'err' 'miniforge'
             logr "Exception: $($_.Exception)" 'error' 'err' 'miniforge'
        }
    }
}

$module_config = @{
    function = @('Invoke-ForgeAction')
    alias    = @('miniforge', 'imini')
}


Export-ModuleMember @module_config