# ===================================================================
# IMini Data Accelerators - Function-Based Approach
# ===================================================================

function iminipsco {
    param([Hashtable]$data)
    $pso = [PSCustomObject]::new()
    if ($data) {
        foreach ($key in $data.Keys) {
            $pso.PSObject.Properties.Add([PSNoteProperty]::new($key, $data[$key]))
        }
    }
    return $pso
}

function iminipso {
    param([Hashtable]$data)
    $pso = [PSObject]::new()
    if ($data) {
        foreach ($key in $data.Keys) {
            $pso.PSObject.Properties.Add([PSNoteProperty]::new($key, $data[$key]))
        }
    }
    return $pso
}

function iminiht {
    param([Hashtable]$data)
    return $data ?? @{}
}

function iminidic {
    param([Hashtable]$data)
    $dic = [System.Collections.Generic.Dictionary[string, object]]::new()
    if ($data) {
        foreach ($key in $data.Keys) {
            $dic.Add($key.ToString(), $data[$key])
        }
    }
    return $dic
}

function iminisl {
    param([Hashtable]$data)
    $sl = [System.Collections.SortedList]::new()
    if ($data) {
        foreach ($key in $data.Keys) {
            $sl.Add($key, $data[$key])
        }
    }
    return $sl
}

# ===================================================================
# Usage Examples
# ===================================================================

$MiniPSCO = iminipsco @{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }
$MiniPSO = iminipso @{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }
$MiniHT = iminiht @{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }
$MiniDic = iminidic @{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }
$MiniSl = iminisl @{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }

# Verify types
$MiniPSCO.GetType()  # PSCustomObject
$MiniPSO.GetType()   # PSObject
$MiniHT.GetType()    # Hashtable
$MiniDic.GetType()   # Dictionary[string,object]
$MiniSl.GetType()    # SortedList

Write-Host "✅ All IMini functions ready to use!"