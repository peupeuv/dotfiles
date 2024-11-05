import { readFile, writeFile } from "bun";
import { parse } from "csv-parse/sync";
import { stringify } from "csv-stringify/sync";
import fs from "fs";

// Define the directory containing the CSV files
const csvDirectoryPath = ".";

// Get all CSV files in the directory
const csvFiles = fs.readdirSync(csvDirectoryPath).filter(file => file.endsWith(".csv"));

for (const file of csvFiles) {
    console.log(`Processing file: ${file}`);

    // Read and parse the CSV file, skipping the first six lines
    const data = parse(await readFile(`${csvDirectoryPath}/${file}`, "utf8"), {
        columns: true,
        skip_empty_lines: true,
        from_line: 7,
    });

    // Prepare the data with calculations
    const preparedData = data.map(row => {
        const charges = parseFloat(row.charges) + parseFloat(row.tva);
        const montant_facture = charges + parseFloat(row.loyer) + parseFloat(row.penalte);
        const loyer = parseFloat(row.loyer).toFixed(2);
        const penalite = parseFloat(row.penalte).toFixed(2);
        const nbr_arriere = parseInt(row.np) - 1;

        return {
            sysid: row.id_locataire,
            code_benifis: row.code_aadl,
            nom_benefis: row.nom,
            prenom_benefis: row.prenom,
            num_facture: row.num_facture,
            periode_facture: new Date().toISOString().split('T')[0],
            loyer: loyer,
            charges: charges.toFixed(2),
            penalite: penalite,
            montant_facture: montant_facture.toFixed(2),
            nbr_arriere: nbr_arriere,
            code_antenne: row.antenne,
            code_site: row.site,
            designation_site: "\\N",
            facture_paye: "\\N",
            code_bank: "0"
        };
    });

    // Convert prepared data to CSV format
    const csvOutput = stringify(preparedData, { header: true });

    // Write to a new CSV file
    const newFilePath = `${csvDirectoryPath}/processed_V2_${file}`;
    await writeFile(newFilePath, csvOutput);
}
