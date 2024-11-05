import pandas as pd
from datetime import datetime, timedelta
import glob

# Define the directory containing the CSV files
csv_directory_path = "."

# Process each CSV file in the directory
for file_path in glob.glob(f"{csv_directory_path}/*.csv"):
    print(f"Processing file: {file_path}")

    # Read the CSV, skip non-meaningful lines, and load data
    data = pd.read_csv(file_path, skip_blank_lines=True, skiprows=6)

    # Prepare the data with calculations
    data['charges'] = data['charges'].astype(float) + data['tva'].astype(float)
    data['montant_facture'] = data['charges'] + data['loyer'].astype(float) + data['penalte'].astype(float)
    data['loyer'] = data['loyer'].round(2)
    data['penalte'] = data['penalte'].round(2)
    data['nbr_arriere'] = data['np'].astype(int) - 1

    # Add additional fields
    data = data.assign(
        sysid=data['id_locataire'],
        code_benifis=data['code_aadl'],
        nom_benefis=data['nom'],
        prenom_benefis=data['prenom'],
        num_facture=data['num_facture'],
        periode_facture=(datetime.now().replace(day=1) - timedelta(days=1)).strftime('%Y-%m-%d'),
        code_antenne=data['antenne'],
        code_site=data['site'],
        designation_site='\\N',
        facture_paye='\\N',
        code_bank='0'
    )

    # Select relevant columns for the output
    prepared_data = data[[
        'sysid', 'code_benifis', 'nom_benefis', 'prenom_benefis', 'num_facture',
        'periode_facture', 'loyer', 'charges', 'penalite', 'montant_facture',
        'nbr_arriere', 'code_antenne', 'code_site', 'designation_site', 'facture_paye', 'code_bank'
    ]]

    # Save to a new CSV file
    new_file_path = f"{csv_directory_path}/processed_V2_{file_path.split('/')[-1]}"
    prepared_data.to_csv(new_file_path, index=False, encoding='utf-8')
