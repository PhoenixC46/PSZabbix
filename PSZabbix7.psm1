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

Test-ZbxAPI
Get-ZbxHosts
Get-ZbxHostGroup
Get-ZbxAction