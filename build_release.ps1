# 空想森林攻略Demo — 打 release APK（国内镜像，纯文字版无需同步游戏图片）
$ErrorActionPreference = 'Stop'
$env:PUB_HOSTED_URL = 'https://pub.flutter-io.cn'
$env:FLUTTER_STORAGE_BASE_URL = 'https://storage.flutter-io.cn'

$ProjectRoot = $PSScriptRoot
Set-Location $ProjectRoot

Write-Host '==> strip wiki_data.json...'
python (Join-Path $ProjectRoot 'scripts\strip_wiki_data.py')
if ($LASTEXITCODE -ne 0) { throw 'strip_wiki_data.py failed' }

Write-Host '==> flutter pub get...'
& flutter pub get
if ($LASTEXITCODE -ne 0) { throw 'flutter pub get failed' }

Write-Host '==> flutter build apk --release...'
& flutter build apk --release
if ($LASTEXITCODE -ne 0) { throw 'flutter build failed' }

$apk = Join-Path $ProjectRoot 'build\app\outputs\flutter-apk\app-release.apk'
if (Test-Path $apk) {
    $full = (Resolve-Path $apk).Path
    $size = [math]::Round((Get-Item $full).Length / 1MB, 1)
    Write-Host "OK: $full ($size MB)"
} else {
    throw "APK not found: $apk"
}
