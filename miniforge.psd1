@{

    RootModule             = "miniforge.psm1"
    ModuleVersion          = '0.2.1'
    CompatiblePSEditions   = @()
    GUID                   = '019a5fd1-507f-7ac9-afb2-68e6f3f7bb89' # TODO: Generate a new GUID
    Author                 = 'Garvey k. Snow'
    CompanyName            = 'phellams'
    Copyright              = '2025 Garvey k. Snow. All rights reserved.'
    Description            = 'A unified tool for performing CUD (Create, Update, Delete) and **array manipulation (push/pull) on various PowerShell data structures, including Hashtables, PSObjects, and PSCustomObjects.'
    PowerShellVersion      = '7.*'
    PowerShellHostName     = ''
    PowerShellHostVersion  = '' 
    DotNetFrameworkVersion = ''
    ClrVersion             = ''
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
            IconUrl                    = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phellams/dist/png/phellams-logo-512x512.png'
            ReleaseNotes               = @()
            Prerelease                 = ''
            RequireLicenseAcceptance   = $false
            ExternalModuleDependencies = @()
            # CHOCOLATE ---------------------
            LicenseUri                 = 'https://choosealicense.com/licenses/mit'
            ProjectUri                 = 'https://gitlab.com/phellams/miniforge.git'
            IconUri                    = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phellams/dist/png/phellams-logo-512x512.png'
            Docsurl                    = 'https://pages.gitlab.io/phellams/miniforge'
            MailingListUrl             = 'https://gitlab.com/phellams/miniforge/issues'
            projectSourceUrl           = 'https://gitlab.com/phellams/miniforge'
            bugTrackerUrl              = 'https://gitlab.com/phellams/miniforge/issues'
            Summary                    = 'A unified tool for performing CUD (Create, Update, Delete) and **array manipulation** (push/pull) on various PowerShell data structures.'
            chocodescription           = @"
# Features

- **CRUD Operations** (*Create*, *Read*, *Update*, *Delete*) on:
    - **Hashtables**
    - **PSObjects** and **PSCustomObjects**
    - **Dictionary** (``System.Collections.Generic.Dictionary``)
    - **SortedList** (``System.Collections.Generic.SortedList``)
- **Array Manipulation** (*push*, *pull*) for array-type properties in:
    - Arrays: ``[string[]]``, ``[object[]]``, ``[int[]]``, ``[hashtable[]]``
    - Custom arrays: ``[psobject[]]``, ``[pscustomobject[]]``
- **Debug Logging** with colored console output
    - Enable globally via `$global:__logging = $true`
    - Disable globally via `$global:__logging = $false`
- **Easy-to-use** aliases: ``miniforge``, ``imini``     
- **Flexible Integration**: Import as a module or load via ``using module``
"@
        }
        # CHOCOLATE ---------------------
    }
    HelpInfoURI            = 'https://gitlab.com/phellams/miniforge/blob/main/README.md'
    DefaultCommandPrefix   = ''
}

