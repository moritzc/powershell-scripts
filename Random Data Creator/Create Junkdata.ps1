# Set the root directory for the text files
$rootDirectory = "C:\test"

# Set the number of subdirectories to create
#
$subdirectoryCount = 5

# Set the number of text files to create in each subdirectory
$fileCount = 10

# Generate random data for the files
$randomData = [char[]]([char]'a'..[char]'z' + [char]'A'..[char]'Z' + [char]'0'..[char]'9')

# Function to create subdirectories recursively
function CreateSubDirectories($rootDirectory, $count) {
    if ($count -eq 0) {
        return
    }
    for ($i = 1; $i -le $count; $i++) {
        $subDirectory = New-Item -ItemType Directory -Path ($rootDirectory + "\subdir$i")
        CreateSubDirectories $subDirectory.FullName ($count - 1)
    }
}

# Create the root directory if it doesn't exist
if (-not (Test-Path -Path $rootDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $rootDirectory | Out-Null
}

# Create subdirectories recursively
CreateSubDirectories $rootDirectory $subdirectoryCount

# Loop through the directories and create the files
Get-ChildItem $rootDirectory -Recurse | Where-Object { $_.PSIsContainer -eq $true } | ForEach-Object {
    for ($i = 1; $i -le $fileCount; $i++) {
        $fileName = $_.FullName + "\file$i.txt"
        $fileContent = $randomData | Get-Random -Count 1000 | Out-String
        Set-Content -Path $fileName -Value $fileContent
    }
}

Write-Host "Done"
