#!/bin/bash

default_search_path="${1:-/etc}"
sha256_fingerprint="MY_FGP"
pin_sha256="MY_PIN"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "Searching for .crt and .pem files under ${GREEN}$default_search_path${NC}..."

# Find .crt and .pem files under the specified search path
cert_files=$(find "$default_search_path" -type f \( -name "*.crt" -o -name "*.pem" \))

# Flag to track if any matches are found
found_matches=0

# Iterate through each certificate file
for cert_file in $cert_files; do
    echo -e "Certificate file: ${GREEN}$cert_file${NC}"

    # Retrieve fingerprint
    fingerprint=$(openssl x509 -noout -fingerprint -sha256 -in "$cert_file" 2>/dev/null | awk -F= '{print $2}' | sed 's/://g')

    # Compare fingerprints
    if [ -n "$fingerprint" ]; then
        if [ "$fingerprint" = "$sha256_fingerprint" ]; then
            echo -e "${GREEN}SHA256 fingerprint match found!${NC}"
            found_matches=1
        fi

        if [ "$fingerprint" = "$pin_sha256" ]; then
            echo -e "${GREEN}Pin SHA256 match found!${NC}"
            found_matches=1
        fi
    else
        echo -e "${RED}Error: Unable to retrieve fingerprint for $cert_file${NC}"
    fi

    echo "-------------------------"
done

# If no matches found, display "Nothing found" message
if [ $found_matches -eq 0 ]; then
    echo -e "${RED}Nothing found.${NC}"
fi

echo "Done."
