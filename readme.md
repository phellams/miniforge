# MiniForge PowerShell Module

<img src="https://img.shields.io/badge/mit-license-blue?style=for-the-badge" alt="license" /> <img src="https://img.shields.io/badge/utility-module-cyan?style=for-the-badge" alt="utility-module-blue" />

The ***MiniForge*** module provides the `Invoke-miniforge` function or via alisa `miniforge` or `imini`, a unified tool for performing **CUD** (Create, Update, Delete) and **array manipulation** (push/pull) on various PowerShell data structures, including **Hashtables**, **PSObjects**, and **PSCustomObjects**. It abstracts the underlying differences in how properties/keys are managed across these types.

# Features

- **CUD** (Create, Update, Delete) operations on **Hashtables**, **PSObjects**, and **PSCustomObjects**
- **array manipulation** (push/pull) on **Hashtables**, **PSObjects**, and **PSCustomObjects**
- **Debug** logging for fine-grained control
- **Easy-to-use** aliases: `miniforge`, `imini`
- **easy-intergration** with other modules and scripts, modules comes as a standard module allowing `import-module` or can be loaded as a module via `using module .\Invoke-miniforge.psm1`

## Getting Started

### 🔨 Using the module as standalone library `.psm1`

1. if you want to use this module as a normal module download the module from [https://github.com/sgkens/miniforge)](https://github.com/sgkens/miniforge) navigate to the `miniforge` folder and execute:
    ```powershell
    cd miniforge
    Import-Module .\
    ```

### 🔨 Using the module as as a normal module

2. if you want to use the module as a standalone library module, download the module from [https://github.com/sgkens/miniforge)](https://github.com/sgkens/miniforge)  and extract the `miniforge.psm1` file into a folder on your system.
3.  Load the module into your script environment:
    ```powershell
    using module .\Invoke-miniforge.psm1
    ```

## 🟡 Invoke-Miniforge 

***Alias***: `miniforge` `imini`

This is the main function exposed by the module.

### Parameters

| Name       | Type                                  | Description                                                          | Required |
| :--------- | :------------------------------------ | :------------------------------------------------------------------- | :------- |
| **Data**   | `Hashtable, PSObject, PSCustomObject` | The target data structure to modify.                                 | Yes      |
| **Action** | `String`                              | The operation to perform: `add`, `update`, `remove`, `push`, `pull`. | Yes      |
| **Name**   | `String`                              | The property or key name to target.                                  | Yes      |
| **Value**  | `PSObject`                            | The value to set (for add/update/push) or remove (for pull).         | No       |
| **debug**  | `SwitchParameter`                     | Enable debug logging.                                                | No       |

> **Note!** \
> `Debug` Mode can be enabled via the global variable `$global:__miniforge.debug` or via the `debug` switch parameter.

## Examples

### `🟣` Adding a Property to a PSCustomObject

```powershell
$obj = [PSCustomObject]@{ ID = 1 }
Invoke-miniforge -Data $obj -Action add -Name 'Status' -Value 'New'
```
***🔺ShortHand***

```powershell
miniforge -d $obj -a add -n 'Status' -v 'New'
```

The above example adds a new property named 'Status' to the PSCustomObject `$obj` with the value 'New'.

### `🟣` Updating a Key in a Hashtable

```PowerShell
$ht = @{ Price = 100.00 }
Invoke-miniforge -Data $ht -Action update -Name 'Price' -Value 109.99
```

***🔺ShortHand***

```PowerShell
miniforge -d $ht -a update -n 'Price' -v 109.99
```

The above example updates the value of the 'Price' key in the Hashtable `$ht`.

### `🟣` Pushing an Item to an Array

This action is only allowed if the target property's value is currently an array (string[], object[], etc.).

```PowerShell

$obj = [PSCustomObject]@{ Tags = @('red', 'green') }
Invoke-miniforge -Data $obj -Action push -Name 'Tags' -Value 'blue'
```

***🔺ShortHand***

```PowerShell
miniforge -d $obj -a push -n 'Tags' -v 'blue'
```

The above example pushes the value 'blue' to the 'Tags' array in the PSCustomObject `$obj`.

### `🟣` Pulling (Removing) an Item from an Array

This action removes the specified Value from the array property.

```PowerShell

$ht = @{ Colors = @('red', 'green', 'blue') }
Invoke-miniforge -Data $ht -Action pull -Name 'Colors' -Value 'green'
```

The above example removes the value 'green' from the 'Colors' array in the Hashtable `$ht`.

### `🟣` Removing a Property from a PSCustomObject

This action removes the specified property from the PSCustomObject.

```PowerShell

$obj = [PSCustomObject]@{ ID = 1 }
Invoke-miniforge -Data $obj -Action remove -Name 'ID'
```

The above example removes the 'ID' property from the PSCustomObject `$obj`.

### `🟣` Removing a Key from a Hashtable

This action removes the specified key from the Hashtable.

```PowerShell

$ht = @{ Price = 100.00 }
Invoke-miniforge -Data $ht -Action remove -Name 'Price'
```

The above example removes the 'Price' key from the Hashtable `$ht`.

# TODO

- [ ] Add tests

## 📝 License

This module is released under the [MIT License](https://opensource.org/licenses/MIT).