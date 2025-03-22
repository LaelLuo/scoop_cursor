if (!(Test-Path "$dir\data\extensions") -and (Test-Path "$env:USERPROFILE\.cursor\extensions")) {
  info '[Portable Mode] Copying extensions...'
  Copy-Item "$env:USERPROFILE\.cursor\extensions" "$dir\data" -Recurse
}
if (!(Test-Path "$dir\data\user-data") -and (Test-Path "$env:AppData\Cursor")) {
  info '[Portable Mode] Copying user data...'
  Copy-Item "$env:AppData\Cursor" "$dir\data\user-data" -Recurse
}
$extensions_file = "$dir\data\extensions\extensions.json"
if ((Test-Path "$extensions_file")) {
  info 'Adjusting path in extensions file...'
    (Get-Content "$extensions_file") -replace '(?<=cursor(/|\\\\)).*?(?=(/|\\\\)data(/|\\\\)extensions)', $version | Set-Content "$extensions_file"
}