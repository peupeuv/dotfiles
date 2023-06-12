# Specify the path to the folder
$folderPath = "C:\path\to\folder"

# Get all files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Process each file
foreach ($file in $files) {
    # Get the new filename with uppercase letters and no whitespace
    $newFileName = ($file.BaseName -replace '\s', '').ToUpper() + $file.Extension

    # Construct the new file path
    $newFilePath = Join-Path -Path $folderPath -ChildPath $newFileName

    # Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilePath
}
