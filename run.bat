@echo off

node --version > NUL 2>&1 && (
    node bin/run
    echo Done!
) || (
    echo Please install nodejs from www.nodejs.org.
    echo It is required to run songdown.
    echo.
)

echo.
pause
