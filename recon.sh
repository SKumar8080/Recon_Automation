#!/bin/bash

# Target domain
TARGET="example.com"

# Output directories and files
OUTPUT_DIR="./Recon_hunt"
SUBS_FILE="$OUTPUT_DIR/subdomains.txt"
LIVE_SUBS_FILE="$OUTPUT_DIR/live_subdomains.txt"
NUCLEI_OUTPUT="$OUTPUT_DIR/nuclei_results.txt"

# Create output directory if not exists
mkdir -p $OUTPUT_DIR

echo "[*] Starting Bug Hunting for $TARGET"

# Step 1: Subdomain Enumeration with subfinder
echo "[*] Running subfinder to enumerate subdomains..."
subfinder -d $TARGET -o $SUBS_FILE
echo "[+] Subdomains saved to $SUBS_FILE"

# Step 2: Check live subdomains with httprobe instead of httpx
echo "[*] Checking live subdomains with httprobe..."
cat $SUBS_FILE | httprobe > $LIVE_SUBS_FILE
echo "[+] Live subdomains saved to $LIVE_SUBS_FILE"

# Step 3: Vulnerability scanning with nuclei on live subdomains
echo "[*] Running nuclei vulnerability scan on live subdomains..."
nuclei -l $LIVE_SUBS_FILE -o $NUCLEI_OUTPUT
echo "[+] Nuclei scan results saved to $NUCLEI_OUTPUT"

echo "[*] Bug hunting automation complete!"
echo "Results stored in: $OUTPUT_DIR"
