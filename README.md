# What is PSZabbix7
A powershell module for automating Zabbix administration, modified for Zabbix 7.2+

The objects which can be managed are only the basic objects: hosts, host groups, users, user groups, templates and a few others. The module does not expose the full Zabbix API. Administrators are expected to use the Zabbix UI to do complex operations like adding monitored items to hosts or templates.

# Usage
$ConnectZbx = New-ZbxApiSession "http://myserver/zabbix/api_jsonrpc.php" (Get-Credential MyAdminLogin)

# Then call any cmdlet
PS> Get-ZbxHost
hostid host                    name                                        status
------ ----                    ----                                        ------
 10084 Zabbix server           Zabbix server                               Enabled
 10105 Agent Mongo 1           Agent Mongo 1                               Enabled
...

# List of cmdlets (the Zbx prefix can be changed on import if needed):
PS> Get-Command -Module PSZabbix
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Add-ZbxHostGroupMembership                         1.0.0      PSZabbix
Function        Add-ZbxUserGroupMembership                         1.0.0      PSZabbix
Function        Add-ZbxUserGroupPermission                         1.0.0      PSZabbix
Function        Add-ZbxUserMail                                    1.0.0      PSZabbix
Function        Disable-ZbxHost                                    1.0.0      PSZabbix
Function        Disable-ZbxUserGroup                               1.0.0      PSZabbix
Function        Enable-ZbxHost                                     1.0.0      PSZabbix
Function        Enable-ZbxUserGroup                                1.0.0      PSZabbix
Function        Get-ZbxAction                                      1.0.0      PSZabbix
Function        Get-ZbxHost                                        1.0.0      PSZabbix
Function        Get-ZbxHostGroup                                   1.0.0      PSZabbix
Function        Get-ZbxMedia                                       1.0.0      PSZabbix
Function        Get-ZbxMediaType                                   1.0.0      PSZabbix
Function        Get-ZbxProxy                                       1.0.0      PSZabbix
Function        Get-ZbxTemplate                                    1.0.0      PSZabbix
Function        Get-ZbxUser                                        1.0.0      PSZabbix
Function        Get-ZbxUserGroup                                   1.0.0      PSZabbix
Function        New-ZbxApiSession                                  1.0.0      PSZabbix
Function        New-ZbxHost                                        1.0.0      PSZabbix
Function        New-ZbxHostGroup                                   1.0.0      PSZabbix
Function        New-ZbxUser                                        1.0.0      PSZabbix
Function        New-ZbxUserGroup                                   1.0.0      PSZabbix
Function        Remove-ZbxHost                                     1.0.0      PSZabbix
Function        Remove-ZbxHostGroup                                1.0.0      PSZabbix
Function        Remove-ZbxHostGroupMembership                      1.0.0      PSZabbix
Function        Remove-ZbxMedia                                    1.0.0      PSZabbix
Function        Remove-ZbxTemplate                                 1.0.0      PSZabbix
Function        Remove-ZbxUser                                     1.0.0      PSZabbix
Function        Remove-ZbxUserGroup                                1.0.0      PSZabbix
Function        Remove-ZbxUserGroupMembership                      1.0.0      PSZabbix
```

# Misc

The module is tested with Pester. If you want to run the tests you will have to modify the login chain inside the test file
and have a working Zabbix server to test against.