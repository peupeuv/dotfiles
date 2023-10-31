param (
    [int]$ChunkSize = 300
)

# Get the current location where the script is executed
$currentLocation = Get-Location

# Use the current location as the input folder
$inputFolder = $currentLocation

# Create the output folder in the current location
$outputFolder = Join-Path -Path $currentLocation -ChildPath "output"
New-Item -Path $outputFolder -ItemType Directory -Force

# Get all CSV files in the input folder
$csvFiles = Get-ChildItem -Path $inputFolder -Filter *.csv

# Process each CSV file
foreach ($csvFile in $csvFiles) {
    # Read the CSV file as text
    $data = Get-Content -Path $csvFile.FullName

    # Split the data into chunks of $ChunkSize rows
    $chunks = [System.Collections.ArrayList]@()
    $chunk = [System.Collections.ArrayList]@()
    foreach ($row in $data) {
        $chunk.Add($row)
        if ($chunk.Count -eq $ChunkSize) {
            $chunks.Add($chunk.Clone())
            $chunk.Clear()
        }
    }
    if ($chunk.Count -gt 0) {
        $chunks.Add($chunk.Clone())
    }

    # Export each chunk to a new CSV file
    for ($i = 0; $i -lt $chunks.Count; $i++) {
        $fileName = $csvFile.BaseName + "_part_" + ($i + 1) + ".csv"
        $filePath = Join-Path -Path $outputFolder -ChildPath $fileName
        $chunks[$i] | Set-Content -Path $filePath
    }
}
