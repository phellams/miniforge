$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$ModulePath = Join-Path -Path $Here -ChildPath 'miniforge.psm1'

# Load the function from the module file into the test session
# This BeforeAll block ensures the function is available for all tests
BeforeAll {
    . $ModulePath 
}

Describe 'Invoke-ForgeAction CRUD Operations' {
    # Define data sets for testing
    # Pester's -ForEach parameter makes it easy to run the same test logic 
    # against different starting objects.
    $DataSets = @(
        @{ 
            Type        = 'PSCustomObject'; 
            InitialData = [PSCustomObject]@{ Id = 1; Name = 'TestA'; Tags = @('A', 'B') } 
        },
        @{ 
            Type        = 'PSObject'; 
            InitialData = New-Object PSObject -Property @{ Id = 2; Name = 'TestB'; Tags = @('A', 'B') } 
        },
        @{ 
            Type        = 'Hashtable'; 
            InitialData = @{ Id = 3; Name = 'TestC'; Tags = @('A', 'B') } 
        }
    )

    # --- Setup a Mock for Console Output ---
    # We must mock Console.WriteLine to capture the success/error messages, 
    # since the function is constrained to not use Write-Output or Write-Error.
    Mock -Command '[System.Console]::WriteLine' -ScriptBlock { 
        param($message) 
        # Output the message to the Pester pipeline for assertion
        Write-Output $message
    } -Global

    # --- Test ADD Action ---
    Context 'Action: add' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData | Select-Object -ExcludeProperty 'Tags' | Select-Object -ExcludeProperty 'Name'

        It "should add a property/key 'NewProp' to a $($dataType)" {
            # Clone the object so the original is not modified by the test
            $clone = $data.PSObject.Copy()

            # Execute the function and capture Console output
            $output = Invoke-ForgeAction -Data $clone -Action add -Name 'NewProp' -Value 'NewValue'

            # Assert 1: Check if the property/key exists
            if ($dataType -eq 'Hashtable') {
                $clone.ContainsKey('NewProp') | Should Be $true
                $clone.NewProp | Should Be 'NewValue'
            }
            else {
                $clone | Get-Member -Name 'NewProp' -MemberType NoteProperty | Should Not BeNullOrEmpty
                $clone.NewProp | Should Be 'NewValue'
            }

            # Assert 2: Check the success message
            $output | Should -Contain "SUCCESS: Added property/key 'NewProp'"
        }
    }

    # --- Test UPDATE Action ---
    Context 'Action: update' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData | Select-Object -ExcludeProperty 'Tags' # Only use Name and Id

        It "should update the 'Name' property/key in a $($dataType)" {
            $clone = $data.PSObject.Copy()
            $newValue = "UPDATED-$dataType"

            $output = Invoke-ForgeAction -Data $clone -Action update -Name 'Name' -Value $newValue

            # Assert 1: Check the new value
            $clone.Name | Should Be $newValue

            # Assert 2: Check the success message
            $output | Should -Contain "SUCCESS: Updated property/key 'Name'"
        }
    }

    # --- Test REMOVE Action ---
    Context 'Action: remove' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData | Select-Object -ExcludeProperty 'Tags' # Only use Name and Id

        It "should remove the 'Name' property/key from a $($dataType)" {
            $clone = $data.PSObject.Copy()

            $output = Invoke-ForgeAction -Data $clone -Action remove -Name 'Name'

            # Assert 1: Check that the property/key is gone
            if ($dataType -eq 'Hashtable') {
                $clone.ContainsKey('Name') | Should Be $false
            }
            else {
                $clone | Get-Member -Name 'Name' -MemberType NoteProperty | Should BeNullOrEmpty
            }

            # Assert 2: Check the success message
            $output | Should -Contain "SUCCESS: Removed property/key 'Name'"
        }
    }

    # --- Test PUSH Action (Array Manipulation) ---
    Context 'Action: push' -ForEach $DataSets {
        $dataType = $_.Type
        
        It "should push a new item to the 'Tags' array in a $($dataType)" {
            $clone = $_.InitialData.PSObject.Copy()

            $output = Invoke-ForgeAction -Data $clone -Action push -Name 'Tags' -Value 'C'

            # Assert 1: Check the new array count and content
            $clone.Tags.Count | Should Be 3
            $clone.Tags | Should -Contain 'C'
            
            # Assert 2: Check the success message
            $output | Should -Contain "SUCCESS: Pushed value to array property Tags"
        }
        
        It "should output an error if 'push' targets a non-array property/key in a $($dataType)" {
            $clone = $_.InitialData.PSObject.Copy()
            
            $output = Invoke-ForgeAction -Data $clone -Action push -Name 'Name' -Value 'Error'

            # Assert 1: Check the error message (captured via the mock)
            $output | Should -Contain "ERROR: Push action only works on array-type properties. Name is not an array."
            
            # Assert 2: Ensure the property was NOT modified
            $clone.Name | Should Not Be 'Error'
        }
    }
    
    # --- Test PULL Action (Array Manipulation) ---
    Context 'Action: pull' -ForEach $DataSets {
        $dataType = $_.Type
        
        It "should pull an item ('B') from the 'Tags' array in a $($dataType)" {
            $clone = $_.InitialData.PSObject.Copy()
            
            $output = Invoke-ForgeAction -Data $clone -Action pull -Name 'Tags' -Value 'B'

            # Assert 1: Check the new array count and content
            $clone.Tags.Count | Should Be 1
            $clone.Tags | Should Not -Contain 'B'
            $clone.Tags | Should -Contain 'A'
            
            # Assert 2: Check the success message
            $output | Should -Contain "SUCCESS: Pulled (removed) value from array property Tags"
        }
    }
}