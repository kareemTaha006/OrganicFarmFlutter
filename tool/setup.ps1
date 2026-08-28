$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error "Flutter is not on PATH. Install it from https://docs.flutter.dev/get-started/install then run this script again."
}

flutter create --org com.orgaincfarm --project-name organic_farm --platforms=android,ios .
flutter pub get
Write-Host "Setup complete. Run: flutter run"
