@echo off


echo Cleaning this place up...
echo.

if exist node_modules (
    rmdir /S /Q node_modules
)

call npm install .

echo.
echo Done!
echo.
pause
