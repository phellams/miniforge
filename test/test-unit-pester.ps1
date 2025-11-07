BeforeAll {
    Import-Module -Name .\ -Force
    # Disable logging for cleaner test output
    $global:__logging = $false
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

    # --- Test CREATE Action ---
    Context 'Action: create' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData

        It "should create a property/key 'NewProp' in a $($dataType)" {
            # Execute the function
            Invoke-ForgeAction -Data $data -Action create -Name 'NewProp' -Value 'NewValue'

            # Assert: Check if the property/key exists and has the correct value
            if ($dataType -eq 'Hashtable') {
                $data.ContainsKey('NewProp') | Should -Be $true
                $data.NewProp | Should -Be 'NewValue'
            }
            else {
                $data | Get-Member -Name 'NewProp' -MemberType NoteProperty | Should -Not -BeNullOrEmpty
                $data.NewProp | Should -Be 'NewValue'
            }
        }

        It "should prevent duplicate property creation in a $($dataType)" {
            # Try to create the same property again
            Invoke-ForgeAction -Data $data -Action create -Name 'NewProp' -Value 'DifferentValue'

            # Assert: Value should NOT be changed (original value maintained)
            if ($dataType -eq 'Hashtable') {
                $data.NewProp | Should -Be 'NewValue'
            }
            else {
                $data.NewProp | Should -Be 'NewValue'
            }
        }
    }

    # --- Test UPDATE Action ---
    Context 'Action: update' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData

        It "should update the 'Name' property/key in a $($dataType)" {
            $newValue = "UPDATED-$dataType"

            Invoke-ForgeAction -Data $data -Action update -Name 'Name' -Value $newValue

            # Assert: Check the new value
            $data.Name | Should -Be $newValue
        }

        It "should warn when updating non-existent property in a $($dataType)" {
            # Try to update a property that doesn't exist
            Invoke-ForgeAction -Data $data -Action update -Name 'NonExistent' -Value 'TestValue'

            # Assert: Property should not be created
            if ($dataType -eq 'Hashtable') {
                $data.ContainsKey('NonExistent') | Should -Be $false
            }
            else {
                $data.PSObject.Properties.Name -contains 'NonExistent' | Should -Be $false
            }
        }
    }

    # --- Test DELETE Action ---
    Context 'Action: delete' -ForEach $DataSets {
        $dataType = $_.Type

        BeforeEach {
            # Create a fresh copy for each test
            if ($dataType -eq 'Hashtable') {
                $script:testData = @{ Id = $_.InitialData.Id; Name = $_.InitialData.Name }
            } elseif ($dataType -eq 'PSObject') {
                $script:testData = New-Object PSObject -Property @{ Id = $_.InitialData.Id; Name = $_.InitialData.Name }
            } else {
                $script:testData = [PSCustomObject]@{ Id = $_.InitialData.Id; Name = $_.InitialData.Name }
            }
        }

        It "should delete the 'Name' property/key from a $($dataType)" {
            Invoke-ForgeAction -Data $script:testData -Action delete -Name 'Name'

            # Assert: Check that the property/key is gone
            if ($dataType -eq 'Hashtable') {
                $script:testData.ContainsKey('Name') | Should -Be $false
            }
            else {
                $script:testData.PSObject.Properties.Name -contains 'Name' | Should -Be $false
            }
        }

        It "should warn when deleting non-existent property from a $($dataType)" {
            Invoke-ForgeAction -Data $script:testData -Action delete -Name 'NonExistent'

            # Assert: Id property should still exist (no side effects)
            if ($dataType -eq 'Hashtable') {
                $script:testData.ContainsKey('Id') | Should -Be $true
            }
            else {
                $script:testData.PSObject.Properties.Name -contains 'Id' | Should -Be $true
            }
        }
    }

    # --- Test PUSH Action (Array Manipulation) ---
    Context 'Action: push' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData
        
        It "should push a new item to the 'Tags' array in a $($dataType)" {
            Invoke-ForgeAction -Data $data -Action push -Name 'Tags' -Value 'C'

            # Assert: Check the new array count and content
            $data.Tags.Count | Should -Be 3
            $data.Tags | Should -Contain 'C'
            $data.Tags | Should -Contain 'A'
            $data.Tags | Should -Contain 'B'
        }
        
        It "should not modify non-array property when 'push' targets it in a $($dataType)" {
            $originalName = $data.Name
            
            Invoke-ForgeAction -Data $data -Action push -Name 'Name' -Value 'ShouldNotWork'

            # Assert: Ensure the property was NOT modified
            $data.Name | Should -Be $originalName
        }
    }
    
    # --- Test PULL Action (Array Manipulation) ---
    Context 'Action: pull' -ForEach $DataSets {
        $dataType = $_.Type
        
        BeforeEach {
            # Reset Tags array for each test
            if ($dataType -eq 'Hashtable') {
                $script:pullData = @{ Id = $_.InitialData.Id; Name = $_.InitialData.Name; Tags = @('A', 'B', 'C') }
            } elseif ($dataType -eq 'PSObject') {
                $script:pullData = New-Object PSObject -Property @{ Id = $_.InitialData.Id; Name = $_.InitialData.Name; Tags = @('A', 'B', 'C') }
            } else {
                $script:pullData = [PSCustomObject]@{ Id = $_.InitialData.Id; Name = $_.InitialData.Name; Tags = @('A', 'B', 'C') }
            }
        }
        
        It "should pull an item ('B') from the 'Tags' array in a $($dataType)" {
            Invoke-ForgeAction -Data $script:pullData -Action pull -Name 'Tags' -Value 'B'

            # Assert: Check the new array count and content
            $script:pullData.Tags.Count | Should -Be 2
            $script:pullData.Tags | Should -Not -Contain 'B'
            $script:pullData.Tags | Should -Contain 'A'
            $script:pullData.Tags | Should -Contain 'C'
        }

        It "should pull all instances of a value from the 'Tags' array in a $($dataType)" {
            # Add duplicate value
            Invoke-ForgeAction -Data $script:pullData -Action push -Name 'Tags' -Value 'A'
            
            # Now pull 'A' - should remove all instances
            Invoke-ForgeAction -Data $script:pullData -Action pull -Name 'Tags' -Value 'A'

            # Assert: 'A' should be completely removed
            $script:pullData.Tags | Should -Not -Contain 'A'
            $script:pullData.Tags | Should -Contain 'B'
            $script:pullData.Tags | Should -Contain 'C'
        }
    }

    # --- Test READ Action ---
    Context 'Action: read' -ForEach $DataSets {
        $dataType = $_.Type
        $data = $_.InitialData

        It "should read an existing property value from a $($dataType)" {
            $result = Invoke-ForgeAction -Data $data -Action read -Name 'Name'

            # Assert: Should return the correct value
            $result | Should -Not -BeNullOrEmpty
            $result | Should -Be $data.Name
        }

        It "should return null when reading non-existent property from a $($dataType)" {
            $result = Invoke-ForgeAction -Data $data -Action read -Name 'NonExistent'

            # Assert: Should return null
            $result | Should -BeNullOrEmpty
        }
    }
}

AfterAll {
    # Re-enable logging if needed
    $global:__logging = $true
}