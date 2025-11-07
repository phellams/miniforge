import-module -name .\miniforge.psm1

# setup
$psobject = New-Object PSObject -Property @{ Id = 2; Name = 'TestB'; Tags = @('A', 'B') }
$pscustomobject = [PSCustomObject]@{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') }
$hashtable = @{ Id = 3; Name = 'TestC'; Tags = @('A', 'B') }
$dictionary = [System.Collections.Generic.Dictionary[string,string]]::new()
$sortedlist = [System.Collections.Generic.SortedList[int,string]]::new()

$dictionary.Add('Key1', 'Value1')
$sortedlist.Add(1, 'Value1')

# Test Add action pso type object pscustom and psobject
Invoke-ForgeAction -Data $psobject -Action create -Name 'NewProp_PSCustom' -Value 'NewValue'
Invoke-ForgeAction -Data $pscustomobject -Action create -Name 'NewProp_PSObject' -Value 'NewValue'
Invoke-ForgeAction -Data $hashtable -Action create -Name 'NewProp_Hashtable' -Value 'NewValue'
Invoke-ForgeAction -Data $dictionary -Action create -Name 'NewProp_Dictionary' -Value 'NewValue'
#Invoke-ForgeAction -Data $ordereddictionary -Action create -Name 'NewProp_OrderedDictionary' -Value 'NewValue'
Invoke-ForgeAction -Data $sortedlist -Action create -Name 'NewProp_SortedList' -Value 'NewValue'

# # Test Dupliate Data
Invoke-ForgeAction -Data $psobject -Action create -Name 'NewProp_PSCustom' -Value 'NewValue'
Invoke-ForgeAction -Data $pscustomobject -Action create -Name 'NewProp_PSObject' -Value 'NewValue'
Invoke-ForgeAction -Data $hashtable -Action create -Name 'NewProp_Hashtable' -Value 'NewValue'
Invoke-ForgeAction -Data $dictionary -Action create -Name 'NewProp_Dictionary' -Value 'NewValue'
#Invoke-ForgeAction -Data $ordereddictionary -Action create -Name 'NewProp_OrderedDictionary' -Value 'NewValue'
Invoke-ForgeAction -Data $sortedlist -Action create -Name 'NewProp_SortedList' -Value 'NewValue'

# Test Read action for all data types
Invoke-ForgeAction -Data $psobject -Action read -Name 'NewProp_PSCustom'
Invoke-ForgeAction -Data $pscustomobject -Action read -Name 'NewProp_PSObject'
Invoke-ForgeAction -Data $hashtable -Action read -Name 'NewProp_Hashtable'
Invoke-ForgeAction -Data $dictionary -Action read -Name 'NewProp_Dictionary'
#Invoke-ForgeAction -Data $ordereddictionary -Action read -Name 'NewProp_OrderedDictionary'
Invoke-ForgeAction -Data $sortedlist -Action read -Name 'NewProp_SortedList'

# # Test Update action for all data types
Invoke-ForgeAction -Data $psobject -Action update -Name 'NewProp_PSCustom' -Value 'This is the updated value'
Invoke-ForgeAction -Data $pscustomobject -Action update -Name 'NewProp_PSObject' -Value 'This is the updated value'
Invoke-ForgeAction -Data $hashtable -Action update -Name 'NewProp_Hashtable' -Value 'This is the updated value'
Invoke-ForgeAction -Data $dictionary -Action update -Name 'NewProp_Dictionary' -Value 'This is the updated value'
#Invoke-ForgeAction -Data $ordereddictionary -Action update -Name 'NewProp_OrderedDictionary' -Value 'This is the updated value'
Invoke-ForgeAction -Data $sortedlist -Action update -Name 'NewProp_SortedList' -Value 'This is the updated value'

# Test Push action for all data types
# ------------------------------------
Invoke-ForgeAction -Data $psobject -Action create -Name 'NewProp_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $pscustomobject -Action create -Name 'NewProp_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $hashtable -Action create -Name 'NewProp_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $dictionary -Action create -Name 'NewProp_array' -Value @('A', 'B')
#Invoke-ForgeAction -Data $ordereddictionary -Action create -Name 'NewProp_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $sortedlist -Action create -Name 'NewProp_array' -Value @('A', 'B')

Invoke-ForgeAction -Data $psobject -Action push -Name 'NewProp_array' -Value 'NewValue'
Invoke-ForgeAction -Data $pscustomobject -Action push -Name 'NewProp_array' -Value 'NewValue'
Invoke-ForgeAction -Data $hashtable -Action push -Name 'NewProp_array' -Value 'NewValue'
Invoke-ForgeAction -Data $dictionary -Action push -Name 'NewProp_array' -Value 'NewValue'
# Invoke-ForgeAction -Data $ordereddictionary -Action push -Name 'NewProp_array' -Value 'NewValue'
Invoke-ForgeAction -Data $sortedlist -Action push -Name 'NewProp_array' -Value 'NewValue'

# ------------------------------------

# Test Pull action for all data types
# add array
Invoke-ForgeAction -Data $psobject -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $pscustomobject -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $hashtable -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $dictionary -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')
# Invoke-ForgeAction -Data $ordereddictionary -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')
Invoke-ForgeAction -Data $sortedlist -Action create -Name 'NewProp_pullable_array' -Value @('A', 'B')

Invoke-ForgeAction -Data $psobject -Action pull -Name 'NewProp_pullable_array' -value 'B'
Invoke-ForgeAction -Data $pscustomobject -Action pull -Name 'NewProp_pullable_array' -value 'B'
Invoke-ForgeAction -Data $hashtable -Action pull -Name 'NewProp_pullable_array' -value 'B'
Invoke-ForgeAction -Data $dictionary -Action pull -Name 'NewProp_pullable_array' -value 'B'
# Invoke-ForgeAction -Data $ordereddictionary -Action pull -Name 'NewProp_pullable_array' -value 'B'
Invoke-ForgeAction -Data $sortedlist -Action pull -Name 'NewProp_pullable_array' -value 'B'


# Test Delete action for all data types
Invoke-ForgeAction -Data $psobject -Action delete -Name 'NewProp_PSCustom'
Invoke-ForgeAction -Data $pscustomobject -Action delete -Name 'NewProp_PSObject'
Invoke-ForgeAction -Data $hashtable -Action delete -Name 'NewProp_Hashtable'
Invoke-ForgeAction -Data $dictionary -Action delete -Name 'NewProp_Dictionary'
#Invoke-ForgeAction -Data $ordereddictionary -Action delete -Name 'NewProp_OrderedDictionary'
Invoke-ForgeAction -Data $sortedlist -Action delete -Name 'NewProp_SortedList'


# Output
$psobject
$pscustomobject
$hashtable
$dictionary
# $ordereddictionary
$sortedlist


# Test Update action for all data types
#Invoke-ForgeAction -Data $DataSets -Action update -Name 'Name' -Value 'UPDATED'