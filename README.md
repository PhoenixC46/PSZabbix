# What is PSZabbix7:
A powershell module for automating Zabbix administration, modified for Zabbix 7.2+

The objects which can be queried are only the basic objects: hosts, host groups, users, user groups, templates and a few others. The module does not expose the full Zabbix API. Administrators are expected to use the Zabbix UI to do complex operations like adding monitored items to hosts or templates.

Thanks to https://github.com/marcanpilami/PSZabbix, this module has been built from scratch using the ideas/methods from their original code.

Details of what each field contains (and its type) can be found in the Zabbix API documentation: https://www.zabbix.com/documentation/current/en/manual/api

# Usage:
1) Open the `InstanceData.txt` file and add the full DNS name for your Zabbix server on the first line, do not include https:// or any slashes on the end.
2) Add your Authentication Token from Zabbix on the 2nd line.

You should end up with something like this:
```
Hostname=zabbix.mydomain.com
AuthKey=RF78W47RFGFHGIWFHIR8FGHO8IHIHF49W384JGF8W3HFG87
```
Save the file somewhere safe, but in a place where this script can still access it, for example: `C:\Secure\PSZabbix`

Copy the file `PSZabbix7_Functions.ps1` into the same folder.


# Test the API Connection:
Open PowerShell and import the functions, simply type the full path and filename for the file and hit Enter. For example: `C:\Secure\PSZabbix\PSZabbix7_Functions.ps1`

Then type this command and hit Enter: `Test-ZbxApi`

The script should return the Zabbix Server version:
```
{
    "jsonrpc":  "2.0",
    "result":  "7.2.4",
    "id":  1
}
```

If the script returns an error it means the authentication token was incorrect, the server was not accessible on the URL, or is running a version older than 7.2.

Any problems relating to the PowerShell or OS would need to be investigated separately. This module has no dependencies on other scripts or modules. The only requirement is PowerShell 5.0 or later.

# How to make a call:
All of the queries will start with the main function which is named: `Get-ZbxData`

This is followed by the fixed parameter of `-dataName` followed by the data to query.

An example for retrieving the list of Host Groups is below, note that the first line will return the type of data being retrieved:
```
> Get-ZbxData -dataName "hostgroup.get"
Is Type: hostgroup.get

groupid name                                       flags uuid                            
------- ----                                       ----- ----                            
2       Linux servers                              0     dc429cd7a1a34222933f24f52a68bcd8
4       Zabbix servers                             0     6f6789aa69e832b4b3918f779f2abf08
5       Discovered hosts                           0     f2481141f99448eea617b7b1d4255566
6       Virtual machines                           0     137f19e6e1db4219b33553b812626bc2
```

# Simple Sample Script:
Now you're ready to build a script and grab some data!

Create a new file in a different folder such as: `C:\Scripts\PSZabbix\GetHosts.ps1`

Open the new file in your preferred PowerShell editor, copy+paste the code below:
```
$ZbxFunctions = 'C:\Secure\PSZabbix\PSZabbix7_Functions.ps1'    # Path to where your secure files are stored, not where you run your scripts from!
. $ZbxFunctions                                                 # This loads the file and executes the contents
$ZbxHosts = Get-ZbxData -dataName "host.get"                    # Get a list of all Hosts
$ZbxHosts                                                       # Show the results
```
Run the code and you should see a long list of hosts and their details displayed on the screen.

# Parameters:
Some of the datasets have additional parameters or the ability to query a single host. These are still a work in progress so please consult the list below of which functions and parameters are available.

An example of this would be the Host Interfaces, on this you specify a single hostId on the same line or from a variable:
```
$HostIds = 12121
Get-ZbxData -dataName "hostinterface.get" -hostids $HostId
Is Type: hostinterface.get

interfaceid hostid main type useip ip            dns port available error
----------- ------ ---- ---- ----- --            --- ---- --------- -----
81          12121  1    2    1     192.168.15.10     161  0              
```

# Time Filters:
Some of the calls can return only results that sit between two datetime values.

The datetime needs to be provided in the format: `yyyy-MM-ddTHH:mm:ss.fffZ`

This will result in a value that looks like: `2025-04-25T09:36:43.316Z`

Create two variables named TimeFrom and TimeTill, these will be where you set the time range to be queried.

In the example below the TimeFrom is set to the current time minus 5 days, and TimeTill is set to the current time minus 1 second:
```
$TimeFrom = (((Get-Date).AddDays(-5)).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
$TimeTill = (((Get-Date).AddSeconds(-1)).ToUniversalTime()).ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
```
Then run the command with the two additional parameters:
```
Get-ZbxData -dataName "auditlog.get" -TimeFrom $TimeFrom -TimeTill $TimeTill
```
If you do not specify a range where one is required, the default range of 1 day will be used. (Current date/time - 24 hours)


# Commands Tested and working:
```
$ZbxTest = Test-ZbxAPI
$ZbxHostGroups = Get-ZbxData -dataName "hostgroup.get"
$ZbxHosts = Get-ZbxData -dataName "host.get"
$ZbxHostInterfaces = Get-ZbxData -dataName "hostinterface.get" -hostids $HostId
$ZbxProxyGroups = Get-ZbxData -dataName "proxygroup.get"
$ZbxProxies = Get-ZbxData -dataName "proxy.get"
$ZbxServices = Get-ZbxData -dataName "service.get"
$ZbxUsers = Get-ZbxData -dataName "user.get"
$ZbxAuditLog = Get-ZbxData -dataName "auditlog.get" -TimeFrom $TimeFrom -TimeTill $TimeTill
$ZbxProblems = Get-ZbxData -dataName "problem.get" -Ack $Acknowledged   # Requires a Y or N response. Default = N
$ZbxAlerts = Get-ZbxData -dataName "alert.get"
$ZbxActions = Get-ZbxData -dataName "action.get"
$ZbxTriggers = Get-ZbxData -dataName "trigger.get" -NewTrig $RecentTriggers    # Requires a Y or N response. Default = Y. Using N will result in all triggers being retrieved.
$ZbxTrends = Get-ZbxData -dataName "trend.get"
$ZbxGraphs = Get-ZbxData -dataName "graph.get" -hostids $HostId
$ZbxDiscHost = Get-ZbxData -dataName "dhost.get"
$ZbxDiscService = Get-ZbxData -dataName "dservice.get"
$ZbxTemplates = Get-ZbxData -dataName "template.get"
$ZbxHistory = Get-ZbxData -dataName "history.get" -hostids $HostId
$ZbxValueMap = Get-ZbxData -dataName "valuemap.get"
```

# Notes:
This script has been built due to there being so many different examples on the internet but all for old versions which no longer work after Zabbix 7.2.x

I tried almost 20 different methods before giving up and deciding to write this script, which is essentially just a handful of functions and a generic method to call a dataset.
Authentication is simply a token combined with the correct headers.

For reference, the headers should simply be the following:
```
Key           Value                                                                  
---           -----                                                                  
Content-Type  application/json                                                       
Authorization Bearer YourAuthTokenHere
```

The `InstanceData.txt` file is not secure in the current format, you should keep this in a secure place (not publicly accessible) or consider using Secure Strings when capturing the information for use.

It has been intentionally left unsecure to keep the code simple and easier to understand for anyone taking their first steps into the API world.

> YOU are responsible for the security of YOUR scripts and where you keep YOUR auth tokens.
