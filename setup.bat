@echo off
echo ================================
echo Cleaning Flutter project...
echo ================================
call flutter clean

echo ================================
echo Getting Flutter packages...
echo ================================
call flutter pub get

echo ================================
echo Creating Flutter native splash...
echo ================================
call flutter pub run flutter_native_splash:create

echo ================================
echo Done! You can now run your app.
echo ================================
pause