@echo off
setlocal enabledelayedexpansion

:: Define API endpoints and credentials
set authEndpoint=https://common.api.acubeapi.com
set dataEndpoint=https://api.acubeapi.com/verify/company/10442360961
set email=your_email
set password=your_password

:: Get JWT token from auth endpoint
echo Getting JWT token...
curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"%email%\",\"password\":\"%password%\"}" "%authEndpoint%" > token_response.txt

:: Check if the request was successful
set /p tokenResponse=<token_response.txt
del token_response.txt

for /f "tokens=*" %%a in ('jq -r ".token" <(echo %tokenResponse%)') do set "jwtToken=%%~a"

if "%jwtToken%"=="" (
    echo Failed to get JWT token
    goto :eof
)

echo JWT Token obtained successfully: %jwtToken%

:: Use JWT token to authenticate to data endpoint
echo Retrieving data...
curl -H "Authorization: Bearer %jwtToken%" -H "Accept: application/json" "%dataEndpoint%" 
