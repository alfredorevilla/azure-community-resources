# Define parameters for the script
param(
  # The TenantId is mandatory. It is the unique identifier (Guid or FQDN) of the Entra ID tenant.
  [Parameter(Mandatory = $true)]
  [string]$TenantId,

  # The DeviceObjectId is mandatory. It is the unique identifier of the device.
  [Parameter(Mandatory = $true)]
  [guid]$DeviceObjectId,

  # The UserId is mandatory. It is the unique identifier of the device registered user to be removed.
  [Parameter(Mandatory = $true)]
  [guid]$UserId,

  # The ClientId is optional. If not provided, a default value is used.
  # It is the unique identifier of the client application exposing the required Microsoft Graph permissions.
  [Parameter(Mandatory = $false)]
  [guid]$ClientId = "17a6e0ad-a3ea-4364-9b1a-f0bdc4af8dde"
)

# Check if the MSAL.PS module is installed. If not, install it.
if (-not (Get-Module -ListAvailable -Name MSAL.PS)) {
  Install-Module -Name MSAL.PS -Force
}

# Check if the Microsoft.Graph module is installed. If not, install it.
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
  Install-Module -Name Microsoft.Graph -Force
}

# Get an access token for the Microsoft Graph API
$token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive  -Scopes ".default"

# Connect to the Microsoft Graph API using the access token
Connect-MgGraph -AccessToken ($token.AccessToken | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome

# Remove the specified user from the specified device
Remove-MgDeviceRegisteredUserByRef -DeviceId $DeviceObjectId -DirectoryObjectId $UserId

# Disconnect from Microsoft Graph API
Disconnect-MgGraph