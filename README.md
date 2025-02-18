# How to update your Cloudflare DNS record automatically when your Public IP address changes

This guide explains how to automatically update your Cloudflare DNS records when your Public IP address changes using the Cloudflare API and an API token. This is particularly useful for those with dynamic IP addresses who need to keep their DNS records up-to-date.

## Prerequisites

* A Cloudflare account with a domain managed through it.
* Internet service with a dynamic IP address.
* Basic knowledge of shell scripting and cron jobs.

## Steps

### 1. Create a Cloudflare API Token

1. Log in to your Cloudflare account.
2. Go to your profile icon in the top right corner and select "My Profile."
3. Navigate to the "API Tokens" tab.
4. Click "Create Token."
5. Give your token a descriptive name (e.g., "DNS Update").
6. **Crucially**, under "Zone.DNS," select at least the "DNS:Edit" permission.  "DNS:Read" is also useful.
7. Click "Create Token."
8. **Copy the token immediately!** You won't be able to see it again. Store it securely (e.g., in an environment variable).

### 2. Get your Cloudflare Zone ID

1. Log in to your Cloudflare account.
2. Select the domain you want to manage.
3. The Zone ID is displayed on the "Overview" page for your domain.

### 3. Identify your DNS Record Name and Type

1. Go to the "DNS" page for your domain in the Cloudflare dashboard.
2. Locate the DNS record you want to update.
3. Note the *name* (e.g., `www`) and *type* (e.g., `A`, `AAAA`) of the record.  The full record name is usually `name.yourdomain.com`.

