# Cloud Recon
This script is used to search for cloud certificate entities such as Amazon, Azure, and others that have been extracted by the kaeferjaeger.gay provider. It is useful for subdomain enumeration and finding additional apex domains during your reconnaissance processes.
## Installation
```bash
git clone https://github.com/0xSpidey/cloudrecon.git
cd cloudrecon
chmod +x main.sh
```
## Usage
    -u: Update local cloud data files.
    -s <Search Term>: Search for a domain or subdomain containing the specified term in cloud data files.
    -h: Display usage information.
    -q: Run the script in silent mode, suppressing all output.
### Example 
```bash
./cloud_data_search.sh -u -s Company_Name
```
