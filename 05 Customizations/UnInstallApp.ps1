if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$url = "http://sp2016/"
$appTitle = "SPHostedAddIn"

$installedapps = Get-SPAppInstance -Web $url 
$yourInstalledapp = $installedapps | where {$_.Title -eq $appTitle}
Uninstall-SPAppInstance -Identity $yourInstalledapp
