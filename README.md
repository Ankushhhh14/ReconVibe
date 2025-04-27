# ReconVibe
Automated recon script for bug bounty hunters – subdomains, URLs, live hosts, and gf patterns in one run.

**ReconVibe** is an automated reconnaissance script designed for bug bounty hunters and security researchers. It streamlines subdomain discovery, live domain checking, URL gathering, and vulnerability pattern matching using popular tools.

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

Install all dependencies via `go install` or your preferred method.

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

## 📌 Example

```bash
./reconvibe.sh hackerone.com
```

Output folder name? `recon-hackerone-2025-04-26`  
Everything gets saved and sorted under this folder.

---

## 📢 Disclaimer

This tool is meant for **educational and authorized testing purposes only**. Always get proper permission before scanning any domains.

---

## 👤 Author

ReconVibe by Ankushhhh14 
Pull requests and suggestions are welcome!
