# Get the number of cores and logical processors
$CoreCount = (Get-CimInstance -ClassName 'Win32_Processor' | Measure-Object -Property 'NumberOfCores' -Sum).Sum
$LogicalProcessors = (Get-CimInstance -ClassName 'Win32_Processor' | Measure-Object -Property 'NumberOfLogicalProcessors' -Sum).Sum

# Get registry path
$c = (reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" 2>&1) | Where-Object { $_ -like "HKEY_*" } | Select-Object -First 1

# Ensure registry path was found
if (-not $c) {
    Write-Output 'Registry path not found' | Out-File -FilePath C:\TT\CoreInfo\RegistryPathError.txt
    exit 1
}

# Handle core count
if ($CoreCount -eq 2) {
    Write-Output 'Only 2 cores' | Out-File -FilePath C:\TT\CoreInfo\INCompatibleCoreCount.txt
} else {
    Write-Output 'Seems to match the necessary' | Out-File -FilePath C:\TT\CoreInfo\CompatibleCoreCount.txt
}

# Backup and apply registry settings
try {
    reg export "$c" "C:\TT\TTRevert\ognic.reg" /y 2>$null
    reg add "$c" /v "MIMOPowerSaveMode" /t REG_SZ /d "3" /f 2>$null
    reg add "$c" /v "PowerSavingMode" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*EEE" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*IPSecOffloadV1IPv4" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*IPSecOffloadV2IPv4" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*IPSecOffloadV2" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*RscIPv4" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*RscIPv6" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*PMNSOffload" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*PMARPOffload" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*JumboPacket" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "EnableConnectedPowerGating" /t REG_DWORD /d "0" /f 2>$null
    reg add "$c" /v "EnableDynamicPowerGating" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "EnableSavePowerNow" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*FlowControl" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*NicAutoPowerSaver" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "ULPMode" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "EnablePME" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "AlternateSemaphoreDelay" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "AutoPowerSaveModeEnabled" /t REG_SZ /d "0" /f 2>$null
    reg add "$c" /v "*NumRssQueues" /t REG_SZ /d "2" /f 2>$null
} catch {
    Write-Output "Failed to apply registry settings: $_" | Out-File -FilePath C:\TT\CoreInfo\RegistryError.txt
}

# Handle additional configurations based on core count
if ($CoreCount -gt 4) {
    $i = (wmic path Win32_VideoController get PNPDeviceID | Where-Object { $_ -like "PCI*" } | Select-Object -First 1).Trim()
    reg add "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f 2>$null
    reg delete "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f 2>$null
    $i = (wmic path Win32_NetworkAdapter get PNPDeviceID | Where-Object { $_ -like "PCI*" } | Select-Object -First 1).Trim()
    reg add "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "3" /f 2>$null
    reg delete "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f 2>$null
} else {
    Write-Output 'Não tem os Requesitos, não são 4 núcleos' | Out-File -FilePath C:\TT\CoreInfo\NotEqualTo4.txt
}

if ($CoreCount -ge 4) {
    $c = (reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" 2>&1) | Where-Object { $_ -like "HKEY_*" } | Select-Object -First 1
    reg add "$c" /v "*RssBaseProcNumber" /t REG_SZ /d "2" /f 2>$null
    reg add "$c" /v "*RssMaxProcNumber" /t REG_SZ /d "3" /f 2>$null
} else {
    reg delete "$c" /v "*RssBaseProcNumber" /f 2>$null
    reg delete "$c" /v "*RssMaxProcNumber" /f 2>$null
    Write-Output 'Não tem os Requesitos, menos que 4 núcleos' | Out-File -FilePath C:\TT\CoreInfo\LessThan4.txt
}

if ($CoreCount -ge 6) {
    $c = (reg query "HKLM\System\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" 2>&1) | Where-Object { $_ -like "HKEY_*" } | Select-Object -First 1
    reg add "$c" /v "*RssBaseProcNumber" /t REG_SZ /d "4" /f 2>$null
    reg add "$c" /v "*RssMaxProcNumber" /t REG_SZ /d "5" /f 2>$null
} else {
    Write-Output 'Não tem os Requesitos, menos que 6 núcleos' | Out-File -FilePath C:\TT\CoreInfo\LessThan6.txt
}

if ($LogicalProcessors -gt $CoreCount) {
    # HyperThreading is Enabled
    $i = (wmic path Win32_USBController get PNPDeviceID | Where-Object { $_ -like "PCI*" } | Select-Object -First 1).Trim()
    reg add "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePolicy" /t REG_DWORD /d "4" /f 2>$null
    reg delete "HKLM\System\CurrentControlSet\Enum\$i\Device Parameters\Interrupt Management\Affinity Policy" /v "AssignmentSetOverride" /f 2>$null
    Write-Output 'HyperThreading enabled - Infelizmente não se pode garantir que o BIOS esteja atualizado' | Out-File -FilePath C:\TT\CoreInfo\HyperThreadingError.txt
} else {
    Write-Output 'HyperThreading disabled' | Out-File -FilePath C:\TT\CoreInfo\HyperThreadingInfo.txt
}

# Handle system RAM settings
try {
    $sysRAM = (Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory
    Write-Output "System RAM: $($sysRAM / 1GB) GB" | Out-File -FilePath C:\TT\CoreInfo\SystemRAM.txt
} catch {
    Write-Output "Failed to retrieve system RAM: $_" | Out-File -FilePath C:\TT\CoreInfo\RAMError.txt
}

# Clean up and end script
Write-Output "Script execution completed." | Out-File -FilePath C:\TT\CoreInfo\ScriptCompletion.txt