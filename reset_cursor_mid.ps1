# 设置配置文件路径
$STORAGE_FILE = "$env:SCOOP\persist\cursor\data\user-data\User\globalStorage\storage.json"

Write-Host "Starting script..."
Write-Host "Target file path: $STORAGE_FILE"

# 生成随机ID，格式正确

# 生成 machineId (40字符的十六进制)
$bytes1 = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($bytes1)
$NEW_MACHINE_ID = ($bytes1 | ForEach-Object { $_.ToString("x2") }) -join ""

# 生成 macMachineId (40字符的十六进制)
$bytes2 = New-Object Byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($bytes2)
$NEW_MAC_MACHINE_ID = ($bytes2 | ForEach-Object { $_.ToString("x2") }) -join ""

# 生成 sqmId (带大括号的UUID)
$NEW_SQM_ID = '{' + ([guid]::NewGuid().ToString().ToUpper()) + '}'

# 生成 devDeviceId (标准UUID)
$NEW_DEV_DEVICE_ID = [guid]::NewGuid().ToString()

# 创建备份
if (Test-Path $STORAGE_FILE) {
    Copy-Item $STORAGE_FILE "$STORAGE_FILE.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
}

try {
    $json = Get-Content $STORAGE_FILE -Raw

    $json = $json -replace '"telemetry\.machineId"\s*:\s*"[^"]*"', ('"telemetry.machineId": "' + $NEW_MACHINE_ID + '"')
    $json = $json -replace '"telemetry\.macMachineId"\s*:\s*"[^"]*"', ('"telemetry.macMachineId": "' + $NEW_MAC_MACHINE_ID + '"')
    $json = $json -replace '"telemetry\.sqmId"\s*:\s*"[^"]*"', ('"telemetry.sqmId": "' + $NEW_SQM_ID + '"')
    $json = $json -replace '"telemetry\.devDeviceId"\s*:\s*"[^"]*"', ('"telemetry.devDeviceId": "' + $NEW_DEV_DEVICE_ID + '"')

    $json | Set-Content $STORAGE_FILE -NoNewline

    Write-Host "Operation completed successfully!"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    Write-Host "Script execution error!"
    Write-Host "Please make sure Cursor editor is closed and you have sufficient file access permissions."
}

pause
