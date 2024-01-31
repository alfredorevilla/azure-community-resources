```ps
# Replace the following variables
$TenantId = "string"
$DeviceObjectId = "guid"
$UserId = "guid"

$ClientId = "17a6e0ad-a3ea-4364-9b1a-f0bdc4af8dde"

$token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive  -Scopes ".default"
Connect-MgGraph -AccessToken ($token.AccessToken | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome

Remove-MgDeviceRegisteredUserByRef -DeviceId $DeviceObjectId -DirectoryObjectId $UserId
```