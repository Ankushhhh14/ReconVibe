#!/bin/bash

# Function to handle Windows line endings in Linux/WSL
handle_line_endings() {
    if [[ "$(uname -s)" == "Linux" ]]; then
        if file "$0" | grep -q "CRLF"; then
            echo -e "${YELLOW}[!] Windows line endings detected. Converting to Unix line endings...${NC}"
            dos2unix "$0"
        fi
    fi
}

# Call the function to handle line endings
handle_line_endings

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Banner
echo -e "${GREEN}"
echo "╔══════════════════════════════════╗"
echo "║     Automated Recon Script       ║"
echo "╚══════════════════════════════════╝"
echo -e "${NC}"

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <domain.com OR domains.txt>${NC}"
    exit 1
fi

input="$1"

# Ask the user for a custom folder name
echo -e "${YELLOW}[+] Please enter a name for the output folder (e.g., recon-hackerone-2025-04-26):${NC}"
read -p "Folder name: " folder_name

# Create main output directory and subfolders
mkdir -p "$folder_name/all_urls"
mkdir -p "$folder_name/gf_patterns"
cd "$folder_name" || exit

# Subdomain enumeration
echo -e "${GREEN}[+] Running Subfinder...${NC}"

if [[ -f "../$input" ]]; then
    subfinder -dL "../$input" | tee subfinder.txt
else
    subfinder -d "$input" | tee subfinder.txt
fi

# Decide what to run based on subfinder output
if [ ! -s subfinder.txt ]; then
    echo -e "${YELLOW}[!] No subdomains found. Using original domain(s)...${NC}"
    if [[ -f "../$input" ]]; then
        cp "../$input" live.txt
    else
        echo "$input" > live.txt
    fi
else
    echo -e "${GREEN}[+] Running httpx-toolkit on subdomains...${NC}"
    httpx-toolkit -l subfinder.txt -silent | tee live.txt

    if [ ! -s live.txt ]; then
        echo -e "${YELLOW}[!] No live domains found from subfinder. Falling back to original domain(s)...${NC}"
        if [[ -f "../$input" ]]; then
            cp "../$input" live.txt
        else
            echo "$input" > live.txt
        fi
    fi
fi

# Subdomain takeover check
echo -e "${GREEN}[+] Running Subdominator...${NC}"
Subdominator -l live.txt -o subdominator.txt

# Ask if user wants to run Waymore
echo -e "${YELLOW}[?] Do you want to run Waymore? (y/n) [default: n]${NC}"
read -r use_waymore
use_waymore=${use_waymore:-n}

# URL Gathering
echo -e "${GREEN}[+] Gathering URLs from Waybackurls, Waymore (optional), GAU, Katana...${NC}"

# Empty URL files inside "all_urls" folder
> all_urls/gau.txt
> all_urls/waybackurls.txt
> all_urls/waymore.txt
> all_urls/katana.txt

cat live.txt | gau --o all_urls/gau.txt &
cat live.txt | waybackurls > all_urls/waybackurls.txt &

# Conditionally run Waymore
if [[ "$use_waymore" == "y" || "$use_waymore" == "Y" ]]; then
    echo -e "${GREEN}[+] Running Waymore with timeout of 5 minutes...${NC}"
    timeout 5m waymore -oU all_urls/waymore.txt -l live.txt --depth 1 --threads 50 &
else
    echo -e "${YELLOW}[!] Skipping Waymore as per user choice.${NC}"
fi

katana -list live.txt -o all_urls/katana.txt &

# Wait for all background jobs to finish
wait

# Merge all URLs into urls.txt
echo -e "${GREEN}[+] Merging and deduplicating URLs...${NC}"
cat all_urls/*.txt | sort -u > urls.txt

# GF-Patterns
echo -e "${GREEN}[+] Running GF-Patterns...${NC}"

patterns=("xss" "sqli" "ssti" "idor" "lfi" "rce" "ssrf" "redirect" "s3" "debug_logic" "interestingEXT" "interestingparams" "php_errors" "server-errors" "cors")

for pattern in "${patterns[@]}"; do
    if gf "$pattern" < urls.txt > "gf_patterns/${pattern}_urls.txt" 2>/dev/null; then
        echo -e "${GREEN}[+] Found pattern: $pattern${NC}"
    else
        echo -e "${YELLOW}[!] Pattern not found or error: $pattern${NC}"
    fi
done

# Final Summary
echo -e "${GREEN}[+] Recon complete! All data saved in '$folder_name' folder.${NC}"
echo -e "${GREEN}Targets scanned: $(wc -l < live.txt)${NC}"
echo -e "${GREEN}Total URLs collected: $(wc -l < urls.txt)${NC}"
echo -e "${GREEN}GF patterns extracted: $(ls gf_patterns/*.txt 2>/dev/null | wc -l)${NC}"
