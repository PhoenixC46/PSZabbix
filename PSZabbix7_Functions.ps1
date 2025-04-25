$Path = ".\PSZabbix"
$Instance = [pscustomobject](Get-Content $Path"\InstanceData.txt" -Raw | ConvertFrom-StringData)
$ZbxHostname = $Instance.Hostname
$ZbxURI = "https://" + $ZbxHostname + "/api_jsonrpc.php"
$AuthKey = $Instance.AuthKey
$AuthHead = "Bearer " + $AuthKey
$ZbxMethod = "POST"
$ZbxHeader = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$ZbxHeader.Add("Content-Type", "application/json")
[datetime]$OriginTime = '1970-01-01 00:00:00'
function Test-ZbxAPI($ZbxBody)
{$ZbxHeader = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$ZbxHeader.Add("Content-Type", "application/json")
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"apiinfo.version`",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}

function Get-ZbxGetData($ZbxQuery, $ZbxParam)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    If ($null -eq $params.output -and $method -like "*.get")
    {$params["output"] = "extend"}
    return ConvertTo-Json @{
        jsonrpc = "2.0"
	    method = $ZbxQuery
	    params = $ZbxParam
	    id = 1
    } -Depth 20
}

function Get-ZbxData {
    param ( 
        [parameter(Mandatory = $true)][string]$dataName,
        [parameter(Mandatory = $false)][string]$Ack = "extend",
        [parameter(Mandatory = $false)][string]$NewTrig = "extend",
        [parameter(Mandatory = $false)][string]$hostids,
        [parameter(Mandatory = $false)][string]$TimeFrom = (((Get-Date).AddDays(-1)).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fffZ"),
        [parameter(Mandatory = $false)][string]$TimeTill = (((Get-Date).AddSeconds(-1)).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
    )
    Write-Host "Is Type:"$dataName
    If($dataName -eq "graph.get" -or $dataName -eq "history.get" -or $dataName -eq "hostinterface.get"){
        If($null -ne $hostids) {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend";"hostids"="$hostids"})).result} 
        Else {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend"})).result}
        
    }
    ElseIf($dataName -eq "auditlog.get"){
        $TimeFrom = [Math]::Floor((New-TimeSpan -Start $OriginTime -End $TimeFrom).TotalSeconds)
        $TimeTill = [Math]::Floor((New-TimeSpan -Start $OriginTime -End $TimeTill).TotalSeconds)
        (Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend";"time_from"="$TimeFrom";"time_till"="$TimeTill"})).result
    }
    ElseIf($dataName -eq "alert.get"){
        (Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend";"actionids"="3"})).result
    }
    ElseIf($dataName -eq "trigger.get"){
        If($NewTrig -eq 'N') {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend"})).result}
        Else {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend";"only_true"="extend"})).result}
    }
    ElseIf($dataName -eq "problem.get"){
        If($Ack -eq "Y") {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend";"selectAcknowledges"="$PrbAck"})).result} 
        Else {(Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{"output"="extend"})).result}
    }
    Else{
        (Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData $dataName @{})).result
    }
}

# Function Use Examples:
#$TimeFrom = (Get-Date).AddDays(-2)
#$TimeTill = (Get-Date)
#$HostId = 10692
#$Acknowledged = "Y"

#$ZbxTest = Test-ZbxAPI
#$ZbxHostGroups = Get-ZbxData -dataName "hostgroup.get"
#$ZbxHosts = Get-ZbxData -dataName "host.get"
#$ZbxHostInterfaces = Get-ZbxData -dataName "hostinterface.get" -hostids $HostId
#$ZbxProxyGroups = Get-ZbxData -dataName "proxygroup.get"
#$ZbxProxies = Get-ZbxData -dataName "proxy.get"
#$ZbxServices = Get-ZbxData -dataName "service.get"
#$ZbxUsers = Get-ZbxData -dataName "user.get"
#$ZbxAuditLog = Get-ZbxData -dataName "auditlog.get" -TimeFrom $TimeFrom -TimeTill $TimeTill
#$ZbxProblems = Get-ZbxData -dataName "problem.get" -Ack $Acknowledged
#$ZbxAlerts = Get-ZbxData -dataName "alert.get"
#$ZbxActions = Get-ZbxData -dataName "action.get"
#$ZbxTriggers = Get-ZbxData -dataName "trigger.get"
#$ZbxTrends = Get-ZbxData -dataName "trend.get"
#$ZbxGraphs = Get-ZbxData -dataName "graph.get" -hostids $HostId
#$ZbxDiscHost = Get-ZbxData -dataName "dhost.get"
#$ZbxDiscService = Get-ZbxData -dataName "dservice.get"
#$ZbxTemplates = Get-ZbxData -dataName "template.get"
#$ZbxHistory = Get-ZbxData -dataName "history.get" -hostids $HostId
#$ZbxValueMap = Get-ZbxData -dataName "valuemap.get"

# Test Function Call Results
#$ZbxTest
#$ZbxHostGroups
#$ZbxHosts
#$ZbxHostInterfaces
#$ZbxProxyGroups
#$ZbxProxies
#$ZbxServices
#$ZbxUsers
#$ZbxAuditLog
#$ZbxProblems
#$ZbxAlerts
#$ZbxActions
#$ZbxTriggers
#$ZbxTrends
#$ZbxGraphs
#$ZbxDiscHost
#$ZbxDiscService
#$ZbxTemplates
#$ZbxHistory
#$ZbxValueMap
