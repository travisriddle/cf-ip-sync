### Update the Ansible playbook

`NAME="www" # Name of the DNS record (e.g., vpn)
TYPE="A" # Type of the DNS record (e.g., A, AAAA)
TOKEN="your-token"
DOMAIN=("domain.name")
ZONE_ID=("your-zone-id")
LOG_FILE="location-of-log-file.log"`

### Run the Ansible playbook

`ansible-playbook update_cloudflare_dns.sh`
