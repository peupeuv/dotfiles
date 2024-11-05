# Specify the directory containing the CSV files
$csvDirectoryPath = "."

# Get all CSV files in the directory
$csvFiles = Get-ChildItem -Path $csvDirectoryPath -Filter *.csv

foreach ($file in $csvFiles) {
	 # Echo the current file name
    Write-Host "Processing file: $($file.Name)"
    # Read the CSV file, skip the first six lines, then convert to CSV objects
    $data = Get-Content -Path $file.FullName |
        Where-Object { $_ -match '\S' } |  # Skip all empty or whitespace-only lines
        ConvertFrom-Csv

    # Prepare the data for the locataire table
    $preparedData = $data | ForEach-Object {
        # Calculate charges (charges + tva)
        $charges = [Math]::Round([decimal]::Parse($_.charges) + [decimal]::Parse($_.tva), 2)
		# Calculate montant_facture (charges + loyer + penalite)
		$montant_facture = [Math]::Round([decimal]::Parse($_.charges) + [decimal]::Parse($_.tva) + [decimal]::Parse($_.loyer) + [decimal]::Parse($_.penalte), 2)
		$loyer = [Math]::Round($_.loyer,2)
		$penalite = [Math]::Round($_.penalte,2)

		# Calculate nombre arriere
		$nbr_arriere =  [int]::Parse($_.np) - 1

        # Create a custom object for each row to structure it for the locataire table
        [PSCustomObject]@{
            sysid = $_.id_locataire  # Adjust as necessary
            code_benifis = $_.code_aadl
            nom_benefis = $_.nom
            prenom_benefis = $_.prenom
            num_facture = $_.num_facture
            periode_facture = (Get-Date).AddMonths(-1).ToString("yyyy-MM-01") # Adjust as necessary
            loyer = $loyer
            charges = $charges
            penalite = $penalite
            montant_facture = $montant_facture
            nbr_arriere = $nbr_arriere  # Adjust as necessary
            code_antenne = $_.antenne
            code_site = $_.site
            designation_site = '\N'  # Adjust as necessary
            facture_paye = '\N'  # Adjust as necessary
            code_bank = '0'  # Adjust as necessary
        }
    }

    # Define a new path for the prepared data CSV file
    # Using the original file name with a prefix/suffix to indicate it's processed
    $newFilePath = Join-Path -Path $csvDirectoryPath -ChildPath ("processed_V2_" + $file.Name)

    # Export the prepared data to a new CSV file
    $preparedData | Export-Csv -Path $newFilePath -NoTypeInformation -Encoding UTF8
}
