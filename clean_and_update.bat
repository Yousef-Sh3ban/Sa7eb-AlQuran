@echo off
cd /d "d:\My Flutter\sa7eb_alquran"
echo Cleaning Flutter project...
flutter clean
echo.
echo Getting packages...
flutter pub get
echo.
echo Upgrading packages...
flutter pub upgrade
echo.
echo Done! Now you can run: flutter run
pause
