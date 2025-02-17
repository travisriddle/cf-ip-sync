#!/bin/bash

#################### FILL THESE VARIABLES ####################
NAME="www"  # Name of the DNS record (e.g., vpn)
TYPE="A"    # Type of the DNS record (e.g., A, AAAA)
TOKEN="your-token"
DOMAIN=("domain.name")
ZONE_ID=("your-zone-id")
LOG_FILE="ip.log"
##############################################################

# Function to get the current public IP address
get_current_ip() {
  # Trying multiple services to increase reliability
  for cmd in "dig +short myip.opendns.com @resolver1.opendns.com" \
             "curl -s https://ifconfig.me/ip" \
             "curl -s https://icanhazip.com"; do
    IP=$(eval "$cmd")
    if [[ "$IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then # Basic IP validation
      echo "$IP"
      return 0  # Exit function successfully if IP is found
    fi
  done
  echo "Error: Could not determine public IP." >&2 # Redirect error to stderr
  return 1 # Indicate failure
}

# Function to get Cloudflare record_id
get_record_id() {
    curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$NAME.$DOMAIN&type=$TYPE" -H "Authorization: Bearer $TOKEN" | jq -r '.result[0].content'
}

# Function to update DNS record
update_dns_record() {
    curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $TOKEN" \
        -H "Content-Type: application/json" \
        -d '{"content": "'"$CURRENT_IPV4"'", "name": "'"$NAME"'", "type": "'"$TYPE"'", "ttl": 1, "proxied": false}'
}

# Get your current IP address
CURRENT_IPV4=$(get_current_ip)
if [[ $? -ne 0 ]]; then
  exit 1
fi

# Get existing record content from Cloudflare
CF_IPV4=$(get_record_id)

# Get the record ID (only if the IP has changed or it's the first run)
if [[ "$CURRENT_IPV4" != "$CF_IPV4" || -z "$CF_IPV4" ]]; then
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$NAME.$DOMAIN&type=$TYPE" -H "Authorization: Bearer $TOKEN" | jq -r '.result[0].id')
    if [[ -z "$RECORD_ID" ]]; then
      echo "Error: Could not retrieve record ID." >&2
      exit 1
    fi
fi


# Compare current IP address and update Cloudflare if it has changed
if [[ "$CURRENT_IPV4" != "$CF_IPV4" ]]; then
    echo "IP has changed. Current IP: $CURRENT_IPV4 | Cloudflare IP: $CF_IPV4"
    echo "$(date),$CURRENT_IPV4" >> "$LOG_FILE"  # Quote $LOG_FILE
    update_dns_record
    if [[ $? -eq 0 ]]; then
        echo "DNS record updated successfully."
    else
        echo "Error: Failed to update DNS record." >&2
    fi
elif [[ -z "$CF_IPV4" ]]; then # First run, update
    echo "First run: Setting initial IP to $CURRENT_IPV4"
    update_dns_record
    if [[ $? -eq 0 ]]; then
        echo "DNS record updated successfully."
    else
        echo "Error: Failed to update DNS record." >&2
    fi
else
    echo "IP has not changed ($CURRENT_IPV4)"
fi
