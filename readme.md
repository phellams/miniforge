<div align="center">
    <H1>MINIFORGE</H1>
    <img src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/misc/hr/wings-diamond.svg" alt="hr">
    <img src="https://img.shields.io/badge/MIT-License-blue?style=flat-square&labelColor=%23002F6C&color=%23E2522F" alt="license" /> <img src="https://img.shields.io/badge/Utility-Module-blue?style=flat-square&labelColor=%23002F6C&color=%23E2522F" alt="utility-module-blue" />
</div>
</br>

The **MiniForge** module provides the `Invoke-ForgeAction` function (with aliases `miniforge` and `imini`), a unified tool for performing **CRUD** (Create, Read, Update, Delete) and **array manipulation** (push/pull) operations on various PowerShell data structures. It abstracts the underlying differences in how properties/keys are managed across **Hashtables**, **PSObjects**, **PSCustomObjects**, **Dictionary**, and **SortedList** types.



## 🟠 Table of Contents

- [Quick Start](#-quick-start)
- [Features](#features)
- [Getting Started](#getting-started)
- [Cmdlets](#cmdlets)
- [Examples](#examples)
  - [🟢 ***Create***](#create)
  - [🟡 ***Update***](#update)
  - [🟣 ***Push***](#push)
  - [🟠 ***Pull***](#pull)
  - [🔴 ***Delete***](#delete)
  - [🔵 ***Read***](#read)
- [Data Accelerators](#data-accelerators)
- [Complete Example Workflow](#complete-example-workflow)
- [Supported Data Types](#supported-data-types-comparison)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)
- [TODO](#-todo)
- [License](#-license)

---

### Installation Resources:
 
|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|
|-|-|-|
|💼 Releases/Tags | <a href="https://gitlab.com/phellams/miniforge/-/releases"> <img src="https://img.shields.io/gitlab/v/release/phellams%2Fminiforge?include_prereleases&style=flat-square&logoColor=%2300B2A9&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab-release"></a> | <a href="https://gitlab.com/phellams/fastfsc/-/tags"> <img src="https://img.shields.io/gitlab/v/tag/phellams%2Fminiforge?include_prereleases&style=flat-square&logoColor=%&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab tags"></a> |


---

## 🚀 Quick Start

```powershell
# Import the module
Import-Module .\miniforge.psm1

# using with another module
using module .\miniforge.psm1

# Create a data object
$data = [PSCustomObject]@{ Name = 'Test' }

# or create another data type using miniforge data accelerators

# SortedList 
$sl = imini

# Use the function with full syntax
Invoke-ForgeAction -Data $data -Action create -Name 'Status' -Value 'Active'

# Or use the short alias
miniforge $data update 'Status' 'Complete'

# Even shorter
imini $data read 'Status'
```

---

# Features

- **CRUD Operations** (*Create*, *Read*, *Update*, *Delete*) on:
    - **Hashtables**
    - **PSObjects** and **PSCustomObjects**
    - **Dictionary** (`System.Collections.Generic.Dictionary`)
    - **SortedList** (`System.Collections.Generic.SortedList`)
- **Array Manipulation** (*push*, *pull*) for array-type properties in:
    - Arrays: `[string[]]`, `[object[]]`, `[int[]]`, `[hashtable[]]`
    - Custom arrays: `[psobject[]]`, `[pscustomobject[]]`
- **Debug Logging** with colored console output
    - Enable globally via `$global:__logging = $true`
    - Disable globally via `$global:__logging = $false`
- **Easy-to-use** aliases: `miniforge`, `imini`
- **Flexible Integration**: Import as a module or load via `using module`

## Getting Started

### 🔨 Installation

1. Download or clone the module from [https://github.com/sgkens/miniforge](https://github.com/sgkens/miniforge)
2. Navigate to the `miniforge` directory

### 🔨 Loading the Module

**Option 1: Import Module (Standard)**

```powershell
cd path\to\miniforge
Import-Module .\miniforge.psm1
```

**Option 2: Using Module Statement**

```powershell
using module .\miniforge.psm1
```

**Option 3: Install to PowerShell Modules Path**

Copy the entire `miniforge` folder to one of your PowerShell module paths, then:

```powershell
Import-Module miniforge
```

To find your module paths, run: `$env:PSModulePath -split ';'`


# Cmdlets

### 🟢 Invoke-ForgeAction

**Aliases**: `miniforge`, `imini`

This is the main (and only) function exposed by the module.

#### Parameters

| Name       | Type                                  | Description                                                          | Required |
| :--------- | :------------------------------------ | :------------------------------------------------------------------- | :------- |
| **Data**   | *PSObject*, *PSCustomObject*, *Hashtable*, *Dictionary*, *SortedList* | The target data structure to modify. | Yes |
| **Action** | *String* | The operation to perform: `create`, `read`, `update`, `delete`, `push`, `pull` | Yes |
| **Name**   | *String* | The property or key name to target. | Yes |
| **Value**  | *Any* | The value to set (for create/update/push) or remove (for pull). Not required for read/delete. | No |

#### Logging Control

**Enable logging globally:**

```powershell
$global:__logging = $true
```

**Disable logging globally:**

```powershell
$global:__logging = $false
```

# Examples

### **Create**

🟢 **Adding a Property to a PSCustomObject**

```powershell
$obj = [PSCustomObject]@{ ID = 1 }
Invoke-ForgeAction -Data $obj -Action create -Name 'Status' -Value 'Active'
# Output: $obj now has { ID = 1; Status = 'Active' }
```

**Shorthand:**

```powershell
miniforge -Data $obj -Action create -Name 'Status' -Value 'Active'
# or even shorter with aliases:
imini $obj create 'Status' 'Active'
```

🟢 **Adding a Key to a Hashtable**

```powershell
$ht = @{ Name = 'Test' }
Invoke-ForgeAction -Data $ht -Action create -Name 'Price' -Value 99.99
# Output: $ht now has @{ Name = 'Test'; Price = 99.99 }
```

🟢 **Adding to a Dictionary**

```powershell
$dict = [System.Collections.Generic.Dictionary[string,string]]::new()
Invoke-ForgeAction -Data $dict -Action create -Name 'Server' -Value 'localhost'
```

> **Note:** The `create` action will prevent overwriting existing properties. Use `update` to modify existing values.

---

### **Update**

🟡 **Updating a Key in a Hashtable**

```powershell
$ht = @{ Price = 100.00; Name = 'Product' }
Invoke-ForgeAction -Data $ht -Action update -Name 'Price' -Value 109.99
# Output: $ht now has @{ Price = 109.99; Name = 'Product' }
```

**Shorthand:**

```powershell
miniforge $ht update 'Price' 109.99
```

🟡 **Updating a PSCustomObject Property**

```powershell
$obj = [PSCustomObject]@{ Status = 'Pending'; Count = 10 }
Invoke-ForgeAction -Data $obj -Action update -Name 'Status' -Value 'Complete'
# Output: $obj now has { Status = 'Complete'; Count = 10 }
```

> **Note:** The `update` action will warn if the property doesn't exist. Use `create` to add new properties.

---

### **Push** 

🟠 **Pushing an Item to an Array Property**

The `push` action appends a value to an existing array. The target property must already be an array type.

```powershell
$obj = [PSCustomObject]@{ Tags = @('red', 'green') }
Invoke-ForgeAction -Data $obj -Action push -Name 'Tags' -Value 'blue'
# Output: $obj.Tags is now @('red', 'green', 'blue')
```

**Shorthand:**

```powershell
miniforge $obj push 'Tags' 'blue'
```

🟠 **Pushing to a Hashtable Array**

```powershell
$config = @{ Servers = @('server1', 'server2') }
Invoke-ForgeAction -Data $config -Action push -Name 'Servers' -Value 'server3'
# Output: $config.Servers is now @('server1', 'server2', 'server3')
```

🟠 **Supported Array Types**

```powershell
# Works with: [string[]], [object[]], [int[]], [hashtable[]], [psobject[]], [pscustomobject[]]
$data = @{ Numbers = @(1, 2, 3) }
Invoke-ForgeAction -Data $data -Action push -Name 'Numbers' -Value 4
```

> **Note:** The property must already exist as an array. Use `create` first to initialize array properties.

---

### **Pull** 

🟣 **Pulling (Removing) an Item from an Array**

The `pull` action removes a specific value from an array property.

```powershell
$ht = @{ Colors = @('red', 'green', 'blue') }
Invoke-ForgeAction -Data $ht -Action pull -Name 'Colors' -Value 'green'
# Output: $ht.Colors is now @('red', 'blue')
```

**Shorthand:**

```powershell
miniforge $ht pull 'Colors' 'green'
```

🟣 **Removing from PSCustomObject Array**

```powershell
$user = [PSCustomObject]@{ Roles = @('Admin', 'Editor', 'Viewer') }
Invoke-ForgeAction -Data $user -Action pull -Name 'Roles' -Value 'Editor'
# Output: $user.Roles is now @('Admin', 'Viewer')
```

> **Note:** If the value appears multiple times in the array, all instances will be removed.

---

### **Delete** 

🔴 **Removing a Property from a PSCustomObject**

The `delete` action completely removes a property or key from the data structure.

```powershell
$obj = [PSCustomObject]@{ ID = 1; Name = 'Test'; Status = 'Active' }
Invoke-ForgeAction -Data $obj -Action delete -Name 'Status'
# Output: $obj now has { ID = 1; Name = 'Test' }
```

**Shorthand:**

```powershell
miniforge $obj delete 'Status'
```

🔴 **Removing a Key from a Hashtable**

```powershell
$ht = @{ Price = 100.00; Name = 'Product'; SKU = 'ABC123' }
Invoke-ForgeAction -Data $ht -Action delete -Name 'SKU'
# Output: $ht now has @{ Price = 100.00; Name = 'Product' }
```

🔴 **Removing from Dictionary or SortedList**

```powershell
$dict = [System.Collections.Generic.Dictionary[string,string]]::new()
$dict.Add('Key1', 'Value1')
$dict.Add('Key2', 'Value2')
Invoke-ForgeAction -Data $dict -Action delete -Name 'Key1'
# Output: $dict only contains Key2
```

> **Note:** The `delete` action will warn if the property doesn't exist.


---

### **Read** 

🔵 **Getting a Property Value**

The `read` action retrieves the value of a property or key from the data structure.

```powershell
$obj = [PSCustomObject]@{ ID = 1; Name = 'TestUser'; Email = 'test@example.com' }
$id = Invoke-ForgeAction -Data $obj -Action read -Name 'ID'
# Output: $id contains 1
```

**Shorthand:**

```powershell
$email = miniforge $obj read 'Email'
```

🔵 **Reading from a Hashtable**

```powershell
$config = @{ Server = 'localhost'; Port = 8080; SSL = $true }
$port = Invoke-ForgeAction -Data $config -Action read -Name 'Port'
# Output: $port contains 8080
```

🔵 **Reading from Dictionary**

```powershell
$settings = [System.Collections.Generic.Dictionary[string,string]]::new()
$settings.Add('Theme', 'Dark')
$theme = Invoke-ForgeAction -Data $settings -Action read -Name 'Theme'
# Output: $theme contains 'Dark'
```

> **Note:** The `read` action returns `$null` and logs a warning if the property doesn't exist.

---

### 🟢 Convert-IminiData

Convert and hashtable into `psobject`, `pscustomobject`, `dictionary`, `SortedList`

```powershell
@{ count=126; files=@('file1.txt', 'file2.txt') } | Convert-IminiData -Type PsCustomObject
@{ count=126; files=@('file1.txt', 'file2.txt') } | Convert-IminiData -Type PsObject
@{ count=126; files=@('file1.txt', 'file2.txt') } | Convert-IminiData -Type Dictionary
@{ count=126; files=@('file1.txt', 'file2.txt') } | Convert-IminiData -Type SortedList
```


# Data Accelerators

### 🔷 New-Iminpso 

**Alias**: `iminpso`

Generates a `PSObject` from `hashtable`.

```powershell
$pso = iminipso @{ prop1 = 'prop1value'; level = 1 }
```

### 🔷  New-Iminipsco

**Alias**: iminipsco

Generates a `PSCustomObject` from `hashtable`.

```powershell
$psco = iminipsco @{ prop1 = 'prop1value'; level = 1 }
```

### 🔷 New-Iminiht

**Alias**: iminiht

Generates a `Hashtable` from `hashtable`.

```powershell
$psht = iminipsco @{ prop1 = 'prop1value'; level = 1 }
```

### 🔷 New-Iminidic

**Alias**: iminidic

Generates a `System.Collections.Generic.Dictionary[string, object]` from `Hashtable`.

```powershell
$psdic = iminidic @{ prop1 = 'prop1value'; level = 1 }
```

### 🔷 New-Iminisl

**Alias**: iminisl

Generates a `System.Collections.SortedList` from `Hashtable`.

```powershell
$psdsl = iminisl @{ prop1 = 'prop1value'; level = 1 }
```

## Complete Example Workflow

Here's a comprehensive example showing multiple operations:

```powershell
# Import the module
Import-Module .\miniforge.psm1

# Enable logging to see what's happening
$global:__logging = $true

# Create a configuration object
$appConfig = [PSCustomObject]@{
    AppName = 'MyApp'
    Version = '1.0.0'
    Features = @('Auth', 'API')
}

# Add a new property
Invoke-ForgeAction -Data $appConfig -Action create -Name 'Environment' -Value 'Development'

# Update the version
Invoke-ForgeAction -Data $appConfig -Action update -Name 'Version' -Value '1.1.0'

# Add a feature to the array
Invoke-ForgeAction -Data $appConfig -Action push -Name 'Features' -Value 'Logging'

# Read a value
$env = Invoke-ForgeAction -Data $appConfig -Action read -Name 'Environment'
Write-Host "Current Environment: $env"

# Remove a feature from the array
Invoke-ForgeAction -Data $appConfig -Action pull -Name 'Features' -Value 'API'

# Delete a property
Invoke-ForgeAction -Data $appConfig -Action delete -Name 'Environment'

# Display final result
$appConfig | Format-List
```

---

## Supported Data Types Comparison

| Data Type | Create | Read | Update | Delete | Push/Pull Arrays |
|:----------|:------:|:----:|:------:|:------:|:----------------:|
| **Hashtable** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **PSObject** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **PSCustomObject** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Dictionary** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **SortedList** | ✅ | ✅ | ✅ | ✅ | ✅ |

**Array Support**: `[string[]]`, `[object[]]`, `[int[]]`, `[hashtable[]]`, `[psobject[]]`, `[pscustomobject[]]`

---

## Advanced Usage

### Working with Nested Objects

```powershell
$server = @{
    Config = @{
        Host = 'localhost'
        Port = 8080
    }
}

# Access nested hashtable and modify it
$nestedConfig = $server.Config
Invoke-ForgeAction -Data $nestedConfig -Action update -Name 'Port' -Value 9090
```

### Pipeline Support

```powershell
# The Data parameter accepts pipeline input
$myHashtable = @{ Status = 'Active' }
$myHashtable | Invoke-ForgeAction -Action create -Name 'Count' -Value 100
```

### Disable Logging for Production

```powershell
# At the start of your script
$global:__logging = $false

# All Invoke-ForgeAction calls will now run silently
miniforge $data create 'Key' 'Value'
```

---

## Troubleshooting

### Property Already Exists Error

If you see a warning about a property already existing when using `create`:

```powershell
# Use update instead of create for existing properties
Invoke-ForgeAction -Data $obj -Action update -Name 'ExistingProp' -Value 'NewValue'
```

### Property Not Found Error

If you see a warning about a property not found when using `update`, `read`, or `delete`:

```powershell
# Use create first to add the property
Invoke-ForgeAction -Data $obj -Action create -Name 'NewProp' -Value 'Value'
```

### Push/Pull Only Works on Arrays

The `push` and `pull` actions require the property to be an array:

```powershell
# First, create an array property
Invoke-ForgeAction -Data $obj -Action create -Name 'Items' -Value @()

# Then push values to it
Invoke-ForgeAction -Data $obj -Action push -Name 'Items' -Value 'Item1'
```

---

<!-- ROADMAP -->
# Roadmap

🟡 **Task List**
- [x] Add Support for Dictionary, SortedList
- [ ] Add comprehensive Pester tests
- [ ] Create module manifest (.psd1) with proper versioning
- [x] Add support for Dictionary
- [ ] Optimize performance for large datasets
- [x] Add `-WhatIf` and `-Confirm` support



# Contributing

Feel free to contribute!  Fork the repo and submit a **merge request** with your improvements.  Or, open an **issue** with the `enhancement` tag to discuss your ideas.

1. Fork the Project from `git clone https://gitlab.com/phellams/miniforge.git`
2. Create your Feature Branch check out the branch dev `git switch dev`.
   1. `git switch -c feature/AmazingFeature`
   2. or 
   3. `git checkout -b feature/AmazingFeature`
3. Commit your Changes `git commit -m 'Add some AmazingFeature'`
4. Push to the Branch `git push origin feature/AmazingFeature`
5. [Open a Merge Request](https://gitlab.com/phellams/miniforge/-/merge_requests/new)


# 📝 License

This module is released under the [MIT License](https://opensource.org/licenses/MIT).

# 📧 Contact

For issues, questions, or suggestions, please open an issue on the [GitHub repository](https://github.com/sgkens/miniforge).