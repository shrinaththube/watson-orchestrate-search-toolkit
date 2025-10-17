# Gmail Send Tool for Watson Orchestrate

This tool enables sending emails via Gmail in Watson Orchestrate using secure credential management.

## Quick Setup

### Step 1: Get Your Gmail Credentials

To use this tool, you'll need:

1. **Gmail Account**: Your Gmail email address
2. **App Password**: A special password for less secure apps
   - Go to your [Google Account](https://myaccount.google.com/)
   - Select Security
   - Under "Signing in to Google," select 2-Step Verification and turn it on
   - Go to [AppPasswords](https://myaccount.google.com/apppasswords)
   - Enter a name for the app password (e.g., "Watson Orchestrate")
   - Click Create and copy the generated password

### Step 2: Import to Watson Orchestrate

Install watsonx orchestrate ADK and connect to your instance -> https://developer.watson-orchestrate.ibm.com/getting_started/installing

```bash
# Install ADK (if you haven't already)
pip install ibm-watsonx-orchestrate

# Add your credentials to Watson Orchestrate (if you haven't already)
orchestrate env add -n <environment-name> -u <service-instance-url> --activate

# Connect to Watson Orchestrate
orchestrate env activate your-environment-name

# Add the connection
orchestrate connections add --app-id gmail_credentials

# Configure for draft environment
orchestrate connections configure \
  --app-id gmail_credentials \
  --env draft \
  --kind key_value \
  --type team

# Configure for live environment
orchestrate connections configure \
  --app-id gmail_credentials \
  --env live \
  --kind key_value \
  --type team

# Set credentials for draft environment
orchestrate connections set-credentials \
  --app-id gmail_credentials \
  --env draft \
  -e 'GMAIL_USER=your-email@gmail.com' \
  -e 'GMAIL_APP_PASSWORD=your-app-password'

# Set credentials for live environment
orchestrate connections set-credentials \
  --app-id gmail_credentials \
  --env live \
  -e 'GMAIL_USER=your-email@gmail.com' \
  -e 'GMAIL_APP_PASSWORD=your-app-password'

# Import the Gmail send tool
orchestrate tools import -k python -f ./send_email_2.py --app-id gmail_credentials

# Verify it worked
orchestrate tools list
```

### Step 3: Add Your Credentials in WXO Portal

1. Login to Watson Orchestrate at https://dl.watson-orchestrate.ibm.com/
2. Click Menu -> Manage -> Connections
3. Click on Credentials tab and you will see Draft environment credentials.

#### Add Gmail credentials
1. Click on 3 dots on the right side of the gmail_credentials and select Edit
2. Click on Add Key value pair
3. Add Key1: GMAIL_USER and Value1: your-email@gmail.com
4. Add Key2: GMAIL_APP_PASSWORD and Value2: your-app-password
5. Click Update credentials
6. Click Done.
7. Perform Steps 1-6 for live environment.

## Usage

Once imported, the Gmail Send tool can be used in your skills with the following parameters:

- `recipient_email`: The recipient's email address
- `subject`: Email subject line
- `body`: Email body content

Example response:
```
✅ Email sent successfully!
```

## Troubleshooting

- **Authentication Error**: Verify your Gmail username and app password are correct
- **Connection Error**: Check your internet connection
- **Permission Error**: Ensure the tool has ADMIN permission level
- **Credential Error**: Make sure both GMAIL_USER and GMAIL_APP_PASSWORD are properly set in credentials