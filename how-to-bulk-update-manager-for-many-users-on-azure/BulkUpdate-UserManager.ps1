<#
.SYNOPSIS
This script updates the manager field for a list of users in Entra ID.

.DESCRIPTION
The script reads a list of users from a CSV file and updates the manager field for each user in Entra ID. The CSV file should have two columns: UserPrincipalName and ManagerUserPrincipalName.

.PARAMETER TenantId
The Tenant ID of your Entra ID.

.PARAMETER CsvFilePath
The path to the CSV file containing the list of users.

.PARAMETER ResultCsvPath
The path where the result CSV file will be saved. By default, it's "results.csv".

.PARAMETER ClientId
The Client ID of your Entra ID app. By default, it's "4aea3c9f-2aa8-4ab7-8fa2-743dac870920".

.EXAMPLE
.\BulkUpdate-UserManager.ps1 -TenantId "your-tenant-id" -CsvFilePath "users.csv"
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$TenantId,

  [Parameter(Mandatory = $true)]
  [string]$CsvFilePath,

  [Parameter(Mandatory = $false)]
  [string]$ResultCsvPath = "results.csv",

  [Parameter(Mandatory = $false)]
  [string]$ClientId = "4aea3c9f-2aa8-4ab7-8fa2-743dac870920"
)

# Check if MSAL.PS module is installed
if (-not (Get-Module -ListAvailable -Name MSAL.PS)) {
  # Install MSAL.PS module
  Install-Module -Name MSAL.PS -Force
}

# Check if Microsoft.Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
  # Install Microsoft.Graph module
  Install-Module -Name Microsoft.Graph -Force
}
# Read the list of users obtained from the CSV file into the PowerShell session
$CsvUsers = Import-Csv -Path $CsvFilePath -Encoding UTF8

# Obtain an access token
$token = Get-MsalToken -ClientId $ClientId -TenantId $TenantId -Interactive  -Scopes "User.ReadWrite.All"

Connect-MgGraph -AccessToken ($token.AccessToken | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome

# Retrieve the IDs of those users in Entra ID
$Results = foreach ($User in $CsvUsers) {
  try {
    $UserPrincipalName = $User.UserPrincipalName
    $ManagerValue = $User.ManagerUserPrincipalName
    if ($UserPrincipalName -notmatch "\S") {
      throw "UserPrincipalName is empty"
    }
    if ($ManagerValue -notmatch "\S") {
      throw "ManagerUserPrincipalName is empty"
    }

    # Retrieve the manager in Entra ID
    $Manager = Get-MgUser -UserId $ManagerValue -ErrorAction Stop

    # Set the Manager attribute for the user to the manager's ID
    $ManagerRef = @{
      "@odata.id" = "https://graph.microsoft.com/v1.0/users/{0}" -f $Manager.Id
    }
    Set-MgUserManagerByRef -UserId $UserPrincipalName -BodyParameter $ManagerRef -ErrorAction Stop

    # Add a status property to the user object indicating success
    $User | Add-Member -NotePropertyName "Status" -NotePropertyValue "Success"
    $User | Add-Member -NotePropertyName "Details" -NotePropertyValue ""
  }
  catch {
    # Add a status property to the user object indicating an error occurred
    $User | Add-Member -NotePropertyName "Status" -NotePropertyValue "Error"
    $User | Add-Member -NotePropertyName "Details" -NotePropertyValue $_.Exception.Message
  }
  $User
}

# Export the results to the ResultCsvPath
$Results | Export-Csv -Path $ResultCsvPath -NoTypeInformation