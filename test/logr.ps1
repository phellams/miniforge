# Test Logr Function
using module ..\helpers\logr.psm1

# Enable Logging
$global:__logging = $true

# Example usage: actions
logr 'This is my message with create action and inf type' 'create' 'inf' 'logr'
logr 'This is my message with update action and wrn type' 'update' 'wrn' 'logr'
logr 'This is my message with delete action and err type' 'delete' 'err' 'logr'
logr 'This is my message with push action and inf type' 'push' 'inf' 'logr'
logr 'This is my message with pull action and wrn type' 'pull' 'wrn' 'logr'
logr 'This is my message with check action and err type' 'check' 'err' 'logr'
logr 'This is my message with read action and inf type' 'read' 'inf' 'logr'