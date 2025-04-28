
# ReconVibe
Automated recon script for bug bounty hunters – subdomains, urls, live hosts, js file analysis, and gf patterns in one run.

**ReconVibe** is an automated reconnaissance script designed for bug bounty hunters and security researchers. It streamlines subdomain discovery, live domain checking, URL gathering, JavaScript file extraction and analysis, and vulnerability pattern matching using popular tools.

---

## 🛠 Features

- 🔍 Subdomain Enumeration using **Subfinder**
- 🌐 Live Domain Detection with **httpx-toolkit**
- ⚠️ Subdomain Takeover check via **Subdominator**
- 📜 URL Harvesting from:
  - **gau**
  - **waybackurls**
  - **katana**
  - **waymore** (optional)
- 🎯 Vulnerability Pattern Detection using **gf**
- 📄 JavaScript File Extraction and Analysis using **Mantra**
- 📁 Organized outputs by folder name

---

## 🚀 Tools Required

Make sure the following tools are installed and available in your `$PATH`:

- [`subfinder`](https://github.com/projectdiscovery/subfinder)
- [`httpx-toolkit`](https://github.com/projectdiscovery/httpx)
- [`Subdominator`](https://github.com/ProjectAnte/Subdominator)
- [`gau`](https://github.com/lc/gau)
- [`waybackurls`](https://github.com/tomnomnom/waybackurls)
- [`waymore`](https://github.com/xnl-h4ck3r/waymore)
- [`katana`](https://github.com/projectdiscovery/katana)
- [`gf`](https://github.com/tomnomnom/gf)
- [`mantra`](https://github.com/Significant-Gravitas/Mantra)

Install all dependencies via `go install`, `git clone`, or your preferred method.

---

## 🧪 Usage

```bash
chmod +x reconvibe.sh
./reconvibe.sh <domain.com OR domains.txt>
```

You'll be prompted to enter a name for the output folder. The script then automatically performs recon and saves all output in that folder.

---

## 📂 Output Structure

- `subfinder.txt` – All discovered subdomains
- `live.txt` – Filtered live hosts
- `subdominator.txt` – Subdomain takeover findings
- `gau.txt`, `waybackurls.txt`, `katana.txt`, `waymore.txt` – Raw URL output from various tools
- `urls.txt` – Deduplicated final URL list
- `*_urls.txt` – URLs matching specific **gf** patterns
- `jsfiles.txt` – Extracted JavaScript files
- `mantra_output.txt` – Vulnerability findings from JavaScript files using **Mantra**

---

## ⚡ GF Patterns Included

- `xss`
- `sqli`
- `ssti`
- `idor`
- `lfi`
- `rce`
- `ssrf`
- `redirect`
- `s3`
- `debug_logic`
- `interestingEXT`
- `interestingparams`
- `php_errors`
- `server-errors`
- `cors`

---

## 📜 JavaScript File Analysis

At the final stage, ReconVibe extracts all JavaScript (`.js`) files from collected URLs and analyzes them using **Mantra**.  
Findings are saved in `mantra_output.txt` for easy review.

Command used internally:

```bash
cat jsfiles.txt | mantra | tee mantra_output.txt
```

This allows you to spot exposed secrets, API endpoints, and vulnerabilities hidden inside JavaScript files.

---

## 📌 Example

```bash
./reconvibe.sh hackerone.com
```

Output folder name? `recon-hackerone-2025-04-26`  
Everything gets saved and sorted under this folder.

---

## 🛠 Common Issues & Fixes

### ❗ Problem: Line Endings Error

#### Error Output:

```bash
┌──(kali㉿kali)-[~/ReconVibe]
└─$ bash reconvibe.sh
reconvibe.sh: line 2: $'
': command not found
reconvibe.sh: line 4: syntax error near unexpected token $'{
''
'econvibe.sh: line 4: handle_line_endings() {
┌──(kali㉿kali)-[~/ReconVibe]
└─$
```

---

#### Cause:

This issue occurs when the script uses **Windows-style line endings (CRLF)**, which are incompatible with Unix-based systems (Linux/macOS/WSL).  
The presence of the carriage return (`\r`) character causes the script to fail during execution.

---

#### Solution:

Here’s how you can fix it:

1. **Convert to Unix line endings (recommended):**

   If you have the `dos2unix` utility installed, run:

   ```bash
   dos2unix reconvibe.sh
   ```

2. **Or manually remove carriage returns:**

   If `dos2unix` is not available, you can use `sed`:

   ```bash
   sed -i 's/\r//g' reconvibe.sh
   ```

3. **Ensure the script is executable:**

   After fixing the line endings, grant execute permissions:

   ```bash
   chmod +x reconvibe.sh
   ```

4. **Run the script again:**

   ```bash
   ./reconvibe.sh <domain.com>
   ```

✅ _Tip: Always use a Unix-compatible text editor (like VSCode with LF line endings) when editing shell scripts to avoid this issue._

---

## 📢 Disclaimer

This tool is meant for **educational and authorized testing purposes only**. Always get proper permission before scanning any domains.

---

## 👤 Author

ReconVibe by Ankushhhh14  
Pull requests and suggestions are welcome!

---
