# Specify the path to the folder
$folderPath = "C:\path\to\folder"

# Get the current date in the desired format (e.g., YYYYMMDD)
$currentDate = (Get-Date -Format "yyyyMMdd")

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Process each file
foreach ($file in $files) {
    # Remove numbers, special characters, and whitespace, then convert to uppercase
    $cleanedBaseName = ($file.BaseName -replace '[^a-zA-Z]', '').Trim().ToUpper()
    
    # Construct the new filename with the date
    $newFileName = $cleanedBaseName + "_" + $currentDate + $file.Extension

    # Construct the new file path
    $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName

    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilePath
}
