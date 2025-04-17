$ZbxHostname = "sumotwo.managed.co.uk"
$ZbxURI = "https://" + $ZbxHostname + "/api_jsonrpc.php"
$AuthKey = "47cd61fb599ff6efea143169287ff90734a35e8ed104ac7986aab6a2da5480d7"
$AuthHead = "Bearer " + $AuthKey
$ZbxMethod = "POST"
$ZbxHeader = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$ZbxHeader.Add("Content-Type", "application/json")

function Test-ZbxAPI($ZbxBody)
{
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
function Get-ZbxHosts($ZbxBody)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"host.get",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}

function Get-ZbxHostGroup($ZbxBody)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"hostgroup.get",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}
function Get-ZbxAction($ZbxBody)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"action.get",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}

function Get-ZbxUsers($ZbxBody)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"user.get",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}
function Get-ZbxProxies($ZbxBody)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"proxy.get",
        `"params`": [],
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody
$response | ConvertTo-Json
}
function Get-ZbxGraph($ZbxBody, $hostids)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    $ZbxBody = @"
    {
        `"jsonrpc`": `"2.0`",
        `"method`": `"graph.get",
        `"params`": [],
        hostids = $hostids,
        `"output`": `"extend`",
        `"sortfield`": `"name`",
        `"id`": 1
    }
"@
$response = Invoke-RestMethod $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body $ZbxBody -hostids 10688
$response | ConvertTo-Json
}

# Rebuilt Functions
function Get-ZbxGetData($ZbxQuery, $ZbxParam)
{
    If(($ZbxHeader.Authorization | Measure-Object).Count -ne 1) {$ZbxHeader.Add("Authorization", $AuthHead)}
    If ($params.output -eq $null -and $method -like "*.get")
    {$params["output"] = "extend"}
    return ConvertTo-Json @{
        jsonrpc = "2.0"
	    method = $ZbxQuery
	    params = $ZbxParam
	    id = 1
    } -Depth 20
}
function Get-ZbxHosts {
    (Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData "host.get" @{})).result
}

function Get-ZbxHostGroup {
    (Invoke-RestMethod -Uri $ZbxURI -Method $ZbxMethod -Headers $ZbxHeader -Body (Get-ZbxGetData "hostgroup.get" @{})).result
}

Test-ZbxAPI
Get-ZbxHosts
Get-ZbxHostGroup
Get-ZbxAction
Get-ZbxUsers
Get-ZbxProxies
Get-ZbxGraph