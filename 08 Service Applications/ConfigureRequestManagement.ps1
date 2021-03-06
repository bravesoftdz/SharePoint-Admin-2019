if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null) 
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#Get a reference to the web app
$w = Get-SPWebApplication -identity http://sp2016/

#Get the request management settings for that web app
$rmset = $w | Get-SPRequestManagementSettings

#Create a new request management rule criteria instance for the Url property
$criteria = New-SPRequestManagementRuleCriteria -Property Url -Value ".*\.docx" -MatchType Regex

#Create Machine Pool
$mp = Add-SPRoutingMachinePool -RequestManagementSettings $rmset -Name IgnitePool -MachineTargets ($rmset | Get-SPRoutingMachineInfo -Name SP2016)

#Create Routing Rule using citeria instance an machine pool
$rmset | Add-SPRoutingRule -Name "DOCX Rule" -Criteria $criteria -MachinePool $mp

#Get a reference to the routing rule and show rules
$r = $rmset | Get-SPRoutingRule
$r.Criteria 

#Create a new criteria rule for everything
$allCriteria = New-SPRequestManagementRuleCriteria -Property Url -Value ".*" -MatchType Regex

#Add a routing rule based on this criteria and set the ExecutionGroup property to 1
$rmset | Add-SPRoutingRule -Name "Catch All Rule" -Criteria $allCriteria -MachinePool $mp -ExecutionGroup 1

