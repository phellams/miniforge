# miniforge.psm1

function Invoke-ForgeAction {
    # .SYNOPSIS
    # Performs Create, Update, Delete (CUD) and array push/pull operations on 
    # Hashtable, PSObject, or PSCustomObject data structures.
    #
    # .DESCRIPTION
    # This function allows for unified manipulation of key/value pairs across
    # different object types. Actions include 'add', 'update', 'remove' for 
    # properties, and 'push' and 'pull' for array-type properties.
    #
    # .PARAMETER Data
    # The target object (Hashtable, PSObject, or PSCustomObject) to modify.
    #
    # .PARAMETER Action
    # The operation to perform: 'add', 'update', 'remove', 'push', or 'pull'.
    #
    # .PARAMETER Name
    # The name of the property or key to act upon.
    #
    # .PARAMETER Value
    # The value to be added, updated, pushed, or pulled (removed).
    #
    # .EXAMPLE
    # $ht = @{ 'Key1' = 'Value1' }
    # Invoke-ForgeAction -Data $ht -Action add -Name 'Key2' -Value 'Value2'
    # [System.Console]::WriteLine("New Data: $($ht | Out-String)")
    #
    # .EXAMPLE
    # $obj = [PSCustomObject]@{ Tags = @('A', 'B') }
    # Invoke-ForgeAction -Data $obj -Action push -Name 'Tags' -Value 'C'
    # [System.Console]::WriteLine("New Data: $($obj.Tags)")
    
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Alias('miniforge', 'imini')]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Data,

        [Parameter(Mandatory = $true)]
        [ValidateSet('add', 'update', 'remove', 'push', 'pull')]
        [string]$Action,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        $Value,

        [switch] $debug
    )

    # --- Core Logic ---
    $dataType = $Data.GetType().Name
    
    if ($global:__miniforge.debug -or $debug) {
        [System.Console]::WriteLine("Target Data Type: $($dataType)")
        [System.Console]::WriteLine("Action Requested: $($Action)")
        [System.Console]::WriteLine("Property Name: $($Name)")
    }

    function logr($string) {
        if ($global:__miniforge.debug -or $debug) {
            [System.Console]::WriteLine($string)
        }
    }

    try {
        switch ($Action) {
            'add' {
                if ($dataType -eq 'Hashtable') {
                    $Data.Add($Name, $Value)
                    logr("SUCCESS: Added key $($Name) to Hashtable.")
                }
                else {
                    # PSCustomObject or PSObject
                    $Data | Add-Member -MemberType NoteProperty -Name $Name -Value $Value -Force
                    logr("SUCCESS: Added property $($Name) to $($dataType).")
                }
            }
            
            'update' {
                if ($dataType -eq 'Hashtable') {
                    if ($Data.ContainsKey($Name)) {
                        $Data[$Name] = $Value
                        logr("SUCCESS: Updated key $($Name) in Hashtable.")
                    }
                    else {
                        logr("ERROR: Key $($Name) not found for update in Hashtable.")
                    }
                }
                else {
                    # PSCustomObject or PSObject
                    if ($Data.PSObject.Properties.Name -contains $Name) {
                        $Data.$Name = $Value
                        logr("SUCCESS: Updated property $($Name) in $($dataType).")
                    }
                    else {
                        logr("ERROR: Property $($Name) not found for update in $($dataType).")
                    }
                }
            }

            'remove' {
                if ($dataType -eq 'Hashtable') {
                    $Data.Remove($Name)
                    logr("SUCCESS: Removed key $($Name) from Hashtable.")
                }
                else {
                    # PSCustomObject or PSObject
                    $Data.PSObject.Properties.Remove($Name)
                    logr("SUCCESS: Removed property $($Name) from $($dataType).")
                }
            }

            'push' {
                # Ensure the property/key exists and its value is an array type
                $currentValue = $null
                if ($dataType -eq 'Hashtable') {
                    if ($Data.ContainsKey($Name)) { $currentValue = $Data[$Name] }
                }
                else {
                    if ($Data.PSObject.Properties.Name -contains $Name) { $currentValue = $Data.$Name }
                }

                if ($currentValue -is [System.Array]) {
                    # Push/Append the new value to the existing array
                    $newValue = @($currentValue) + $Value
                    
                    if ($dataType -eq 'Hashtable') {
                        $Data[$Name] = $newValue
                    }
                    else {
                        $Data.$Name = $newValue
                    }
                    logr("SUCCESS: Pushed value to array property $($Name).")
                }
                else {
                    logr("ERROR: Push action only works on array-type properties. $($Name) is not an array.")
                }
            }

            'pull' {
                # Ensure the property/key exists and its value is an array type
                $currentValue = $null
                if ($dataType -eq 'Hashtable') {
                    if ($Data.ContainsKey($Name)) { $currentValue = $Data[$Name] }
                }
                else {
                    if ($Data.PSObject.Properties.Name -contains $Name) { $currentValue = $Data.$Name }
                }

                if ($currentValue -is [System.Array]) {
                    # Pull/Remove the value from the existing array by filtering
                    $newValue = @($currentValue) | Where-Object { $_ -ne $Value }
                    
                    if ($dataType -eq 'Hashtable') {
                        $Data[$Name] = $newValue
                    }
                    else {
                        $Data.$Name = $newValue
                    }
                    logr("SUCCESS: Pulled (removed) value from array property $($Name).")
                }
                else {
                    logr("ERROR: Pull action only works on array-type properties. $($Name) is not an array.")
                }
            }
        }
    }
    catch {
        logr("FATAL ERROR: An unexpected error occurred during action $($Action) on $($Name). Error: $($_.Exception.Message)")
    }
}

Export-ModuleMember -Function Invoke-ForgeAction -Alias miniforge, imini