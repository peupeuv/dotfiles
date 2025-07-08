
# Define a hashtable of HTML entities and their replacements
$htmlEntities = @{
    "&#039;" = "'"
    "&quot;" = '"'
    "&eacute;" = "é"
    }

# Get all CSV files in the current directory
$csvFiles = Get-ChildItem -Path . -Filter *.csv

foreach ($file in $csvFiles) {
    $inputFile = $file.FullName
    $cleanedFile = "cleaned_" + $file.Name

    # Read the CSV content
    $content = Get-Content -Path $inputFile
	
	# Remove the first line
    $content = $content | Select-Object -Skip 1

    # Replace HTML entities
    foreach ($key in $htmlEntities.Keys) {
        $content = $content -replace $key, $htmlEntities[$key]
		
    # Remove double quotes from the content
    $content = $content -replace '"', ''
    }

    # Save the cleaned content to a new CSV file
    Set-Content -Path $cleanedFile -Value $content
}
