# Test Docker Hub login
Write-Host "Testing Docker Hub credentials..." -ForegroundColor Yellow

# Replace TOKEN_HERE with your actual access token
$token = Read-Host "Enter your Docker Hub access token" -AsSecureString
$tokenPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

# Test login
echo $tokenPlain | docker login -u gordov1su4 --password-stdin

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Docker Hub login successful!" -ForegroundColor Green
    Write-Host "Your credentials are working correctly." -ForegroundColor Green
} else {
    Write-Host "❌ Docker Hub login failed!" -ForegroundColor Red
    Write-Host "Please check your username and access token." -ForegroundColor Red
}

# Logout for security
docker logout
