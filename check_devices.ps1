# Check connected Flutter devices
Set-Location "d:\My Flutter\sa7eb_alquran"
Write-Host "Checking connected devices..." -ForegroundColor Green
flutter devices
Write-Host ""
Write-Host "To run the app on a device, use:" -ForegroundColor Yellow
Write-Host "flutter run -d <device-id>" -ForegroundColor Cyan
