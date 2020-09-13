function Test-CommandExists {
    param($command)
    try {
        if (Get-Command $command -errorAction SilentlyContinue) {
            return $true
        }
        else {
            return $false
        }
    }
    catch {
        return $false
    }
}

$exist = Test-CommandExists "flutter"
if (!$exist) {
    Write-Error "flutter command do not exist."
    exit -1
}
# set-proxy for publish 
if (Test-CommandExists "proxy") {
    proxy
}

$PUB_HOSTED_URL = $env:PUB_HOSTED_URL
$env:PUB_HOSTED_URL = ""
Push-Location tools
try {
    flutter pub get
    flutter pub run .\bin\publish.dart
}
finally {
    Pop-Location
    $env:PUB_HOSTED_URL = $PUB_HOSTED_URL
}