param(
  [Parameter(Mandatory = $true)]
  [string]$TenantId,

  [Parameter(Mandatory = $true)]
  [guid]$DeviceObjectId,

  [Parameter(Mandatory = $true)]
  [guid]$UserId,

  [Parameter(Mandatory = $false)]
  [guid]$ClientId
)

if (-not (Get-Module -ListAvailable -Name MSAL.PS)) {
  Install-Module -Name MSAL.PS -Force
}

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
  Install-Module -Name Microsoft.Graph -Force
}

$token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive  -Scopes ".default"

Connect-MgGraph -AccessToken ($token.AccessToken | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome

Remove-MgDeviceRegisteredUserByRef -DeviceId $DeviceObjectId -DirectoryObjectId $UserId