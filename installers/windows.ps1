# Requires running as Administrator

param(
    [string]$InstallPath = "C:\Program Files\filio"
)

# Variables
$repoURL = "https://github.com/replit-user/filio"  # Replace with your actual repo URL
$tempDir = "$env:TEMP\filio_install_temp"
$includeDir = Join-Path $InstallPath "include"
$dllTargetPath = Join-Path $InstallPath "filio-win.dll"
$gitInstalledBefore = $false

function Is-GitInstalled {
    $gitCommand = Get-Command git.exe -ErrorAction SilentlyContinue
if ($null -ne $gitCommand) {
    $gitPath = $gitCommand.Source
} else {
    $gitPath = $null
}

    return -not [string]::IsNullOrEmpty($gitPath)
}

function Add-ToUserPath($folderPath) {
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if (-not ($currentPath.Split(';') -contains $folderPath)) {
        $newPath = $currentPath + ";" + $folderPath
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Output "Added $folderPath to user PATH environment variable."
    }
    else {
        Write-Output "$folderPath is already in user PATH."
    }
}

# Check Admin rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole] "Administrator")) {
    Write-Warning "You need to run this script as Administrator!"
    exit 1
}

# Install Git if needed
if (-not (Is-GitInstalled)) {
    Write-Output "Git not found, installing Git..."
    $gitInstalledBefore = $false
    winget install --id Git.Git -e --source winget
    if (-not (Is-GitInstalled)) {
        Write-Error "Git installation failed or Git still not found. Aborting."
        exit 1
    }
}
else {
    $gitInstalledBefore = $true
    Write-Output "Git is already installed."
}

# Clone repo
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
git clone $repoURL $tempDir

# Verify DLL exists
$dllSource = Join-Path -Path $tempDir -ChildPath "build\filio-win.dll"
if (-not (Test-Path $dllSource)) {
    Write-Error "DLL not found at $dllSource. Aborting."
    Remove-Item -Recurse -Force $tempDir
    exit 1
}

# Create install directories
if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
}
if (-not (Test-Path $includeDir)) {
    New-Item -ItemType Directory -Path $includeDir -Force | Out-Null
}

# Copy DLL
Copy-Item -Path $dllSource -Destination $dllTargetPath -Force
Write-Output "Copied DLL to $dllTargetPath"

# Copy headers
$headerSource = Join-Path -Path $tempDir -ChildPath "include"
if (-not (Test-Path $headerSource)) {
    Write-Error "Header folder not found at $headerSource. Aborting."
    Remove-Item -Recurse -Force $tempDir
    exit 1
}
Copy-Item -Path (Join-Path $headerSource '*') -Destination $includeDir -Recurse -Force
Write-Output "Copied headers to $includeDir"

# Cleanup
Remove-Item -Recurse -Force $tempDir

# Add install path to user PATH environment variable
Add-ToUserPath $InstallPath

# Uninstall Git if installed by this script
if (-not $gitInstalledBefore) {
    Write-Output "Uninstalling Git as it was installed by this script..."
    winget uninstall --id Git.Git
}

Write-Output "Installation complete! You can now include headers like <filio.hpp> and the DLL is in your user PATH."
