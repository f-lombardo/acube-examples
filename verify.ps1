# Set execution policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Define API endpoints and credentials
$authEndpoint = "https://common.api.acubeapi.com"
$dataEndpoint = "https://api.acubeapi.com/verify/company/10442360961"
$email = "your_email"
$password = "your_password"

# Get JWT token from auth endpoint
try {
    $response = Invoke-RestMethod -Uri $authEndpoint -Method Post -Body @{
        email = $email
        password = $password
    } -ContentType "application/json"

    # Extract JWT token using yq
    $jwtToken = & {
        $response | ConvertTo-Json | yq e '.token' -
    }

    Write-Host "JWT Token obtained successfully."
}
catch {
    Write-Error "Failed to get JWT token: $_"
    exit 1
}

# Use JWT token to authenticate to data endpoint
try {
    $headers = @{
        "Authorization" = "Bearer $jwtToken"
    }

    $dataResponse = Invoke-RestMethod -Uri $dataEndpoint -Headers $headers -Method Get

    Write-Host "Data retrieved successfully:"
    $dataResponse | ConvertTo-Json -Depth 10
}
catch {
    Write-Error "Failed to retrieve data: $_"
    exit 1
}

# Clean up
Remove-Variable jwtToken, response, headers, dataResponse
