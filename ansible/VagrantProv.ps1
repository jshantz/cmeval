param
(
  $proxyAddr = '10.100.112.93:8080'
)

$userName = "$($env:USERDOMAIN)\\$($env:USERNAME)"
if ((get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds' -Name "ConsolePrompting" -ea SilentlyContinue).ConsolePrompting -ne $true)
{
  Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds' ConsolePrompting $true
  $revertPrompting = $true
}

$cred = get-credential $userName -Message 'Enter your credentials.'
$password = $cred.GetNetworkCredential().Password
if ($revertPrompting)
{
  Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds' ConsolePrompting $false
}

$env:cmeval_proxy = "http://$($userName):$($password)@$($proxyAddr)"
vagrant provision
$env:cmeval_proxy = ''