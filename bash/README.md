### Update the information at the top of the script in dns-update.sh

NAME="www"  # Name of the DNS record (e.g., vpn)  
TYPE="A"    # Type of the DNS record (e.g., A, AAAA)  
TOKEN="your-token"  
DOMAIN=("domain.name")  
ZONE_ID=("your-zone-id")  
LOG_FILE="location-of-log-file.log"  

### Run the Script

Make the script executable

`chmod +x update_cloudflare_dns.sh`

Run the script locally:

`./update_cloudflare_dns.sh`

### Schedule the Script

crontab -e

Add the following line (adjust the schedule as needed):

`*/5 * * * * /path/to/your/script/update_cloudflare_dns.sh`

Replace /path/to/your/script/update_cloudflare_dns.sh with the actual path to your script.
