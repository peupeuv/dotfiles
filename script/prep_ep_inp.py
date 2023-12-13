import csv
import os
import glob
import cgi
import HTMLParser

def transform_csv(input_file, output_file):
    # Create an instance of HTMLParser
    html_parser = HTMLParser.HTMLParser()
    new_header = ["id_locataire", "code_aadl", "nom", "prenom", "num_facture", "date",
                  "loyer", "ch", "penalte", "total", "nb_ar", "antenne", "code_site",
                  "site", "paye", "prg"]


    with open(input_file, 'rb') as csvfile:
        reader = csv.DictReader(csvfile)
        transformed_data = []

        for row in reader:
            # Calculating new fields
            date = "2023-11-01 00:00:00.000"

            # Format values with two decimal places
            ch = round(float(row["charges"]) + float(row["tva"]), 2)
            loyer = round(float(row["loyer"]), 2)
            penalte = round(float(row["penalte"]), 2)
            total = round(ch + penalte + loyer, 2)
            nb_ar = int(row["np"]) - 1
            prg = int(row["program"]) - 1
            # Decode HTML entities
            nom = html_parser.unescape(row["nom"])
            prenom = html_parser.unescape(row["prenom"])
            site = html_parser.unescape(row["site"])

            if isinstance(nom, unicode):
                nom = nom.encode('utf-8')
            if isinstance(prenom, unicode):
                prenom = prenom.encode('utf-8')
            if isinstance(site, unicode):
                site = site.encode('utf-8')


            # Constructing the new row
            new_row = {
                "id_locataire": row["id_locataire"],
                "code_aadl": row["code_aadl"],
                "nom": nom,
                "prenom": prenom,
                "num_facture": row["num_facture"],
                "date": date,
                "loyer": "{:.2f}".format(loyer),
                "ch": "{:.2f}".format(ch),
                "penalte": "{:.2f}".format(penalte),
                "total": "{:.2f}".format(total),
                "nb_ar": nb_ar,
                "antenne": row["antenne"],
                "code_site": "x",  # Assuming this is a new field with empty value
                "site": site,
                "paye": "\N",       # Assuming this is a new field with empty value
                "prg": prg
            }

            transformed_data.append(new_row)

    # Writing to a new CSV file
    with open(output_file, 'wb') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=new_header)
        writer.writeheader()
        writer.writerows(transformed_data)

def process_all_csv_files():
    # Loop through all CSV files in the current directory
    for file in glob.glob("*.csv"):
        output_file = os.path.splitext(file)[0] + "_clean.csv"
        transform_csv(file, output_file)

if __name__ == "__main__":
    process_all_csv_files()
