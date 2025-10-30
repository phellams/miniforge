@{

    RootModule             = "miniforge.psm1"
    ModuleVersion          = '0.2.0'
    CompatiblePSEditions   = @()
    GUID                   = '019a3292-7cc5-7405-97a4-c61c3ae8ce9a'
    Author                 = 'Garvey k. Snow'
    CompanyName            = 'phellams'
    Copyright              = '2025 Garvey k. Snow. All rights reserved.'
    Description            = 'A unified tool for performing CUD (Create, Update, Delete) and **array manipulation (push/pull) on various PowerShell data structures, including Hashtables, PSObjects, and PSCustomObjects.'
    PowerShellVersion      = '7.0'
    PowerShellHostName     = ''
    PowerShellHostVersion  = '' 
    DotNetFrameworkVersion = ''
    ClrVersion             = '00.0.01'
    ProcessorArchitecture  = ''
    RequiredModules        = @()
    RequiredAssemblies     = @()
    ScriptsToProcess       = @()
    TypesToProcess         = @()
    FormatsToProcess       = @()
    NestedModules          = @()
    FunctionsToExport      = @( 
        'invoke-forgeaction'
    )
    CmdletsToExport        = @()
    VariablesToExport      = @()
    AliasesToExport        = @(
        'miniforge',
        'imini'
    )
    DscResourcesToExport   = @()
    ModuleList             = @()
    FileList               = @()
    PrivateData            = @{
        PSData = @{
            Tags                       = @('automation', 'data-structures', 'hashtable', 'psobject', 'pscustomobject', 'array', 'array-manipulation', 'module', 'powershell', 'powershellcore', 'tool', 'utility', 'utility-module')
            LicenseUrl                 = 'https://choosealicense.com/licenses/mit'
            ProjectUrl                 = 'https://gitlab.com/phellams/miniforge'
            IconUrl                    = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/miniforge/dist/png/miniforge-logo-512x512.png'
            ReleaseNotes               = @()
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
            # CHOCOLATE ---------------------
            LicenseUri                 = 'https://choosealicense.com/licenses/mit'
            ProjectUri                 = 'https://gitlab.com/phellams/miniforge.git'
            IconUri                    = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/miniforge/dist/png/miniforge-logo-512x512.png'
            Docsurl                    = 'https://pages.gitlab.io/phellams/miniforge'
            MailingListUrl             = 'https://gitlab.com/phellams/miniforge/issues'
            projectSourceUrl           = 'https://gitlab.com/phellams/miniforge'
            bugTrackerUrl              = 'https://gitlab.com/phellams/miniforge/issues'
            Summary                    = 'A unified tool for performing CUD (Create, Update, Delete) and **array manipulation** (push/pull) on various PowerShell data structures.'
            chocodescription           = @"
The ***MiniForge*** module provides the `Invoke-miniforge` function or via alisa `miniforge` or `imini`, a unified tool for performing **CUD** (Create, Update, Delete) and **array manipulation** (push/pull) on various PowerShell data structures, including **Hashtables**, **PSObjects**, and **PSCustomObjects**. It abstracts the underlying differences in how properties/keys are managed across these types.

# Features

- **CUD** (Create, Update, Delete) operations on **Hashtables**, **PSObjects**, and **PSCustomObjects**
- **array manipulation** (push/pull) on **Hashtables**, **PSObjects**, and **PSCustomObjects**
- **Debug** logging for fine-grained control
- **Easy-to-use** aliases: ``miniforge``, ``imini``
- **easy-intergration** with other modules and scripts, modules comes as a standard module allowing ``import-module`` or can be loaded as a module via ``using module .\Invoke-miniforge.psm1``
"@
        }
        # CHOCOLATE ---------------------
    }
    HelpInfoURI            = 'https://gitlab.com/phellams/miniforge/blob/main/README.md'
    DefaultCommandPrefix   = ''
}

