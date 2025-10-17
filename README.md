# Watson Orchestrate Search Tool - Quick Start

##  Quick Setup

### Step 1: Clone Repository
```bash
git clone https://github.com/yourusername/watson-orchestrate-search-tool
cd watson-orchestrate-search-tool/google-search-tool/
```

### Step 2: Get Your Credentials
**You need 2 things from Google:**

1. **API Key**: Go to [Google Cloud Console](https://developers.google.com/custom-search/v1/introduction)
   - Get a Key
   
2. **Search Engine ID**: Go to [Programmable Search Engine](https://programmablesearchengine.google.com)
   - Create search engine → Copy the Search Engine ID


### Step 3: Import to Watson Orchestrate

Install watsonx orchestrate ADK and connect to your instance -> https://developer.watson-orchestrate.ibm.com/getting_started/installing

```bash
# Install ADK (if you haven't already)
pip install ibm-watsonx-orchestrate

# Add your credentials to Watson Orchestrate (if you haven't already)
orchestrate env add -n <environment-name> -u <service-instance-url> --
activate

# Connect to Watson Orchestrate
orchestrate env activate your-environment-name

# Add the connection
orchestrate connections add --app-id google_search_api_credentials

# Configure for draft environment
orchestrate connections configure \
  --app-id google_search_api_credentials \
  --env draft \
  --kind key_value \
  --type team

# Configure for live environment
orchestrate connections configure \
  --app-id google_search_api_credentials \
  --env live \
  --kind key_value \
  --type team

orchestrate connections set-credentials \
  --app-id google_search_api_credentials \
  --env draft \
  -e 'GOOGLE_API_KEY=your-api-key' \
  -e 'GOOGLE_SEARCH_ENGINE_ID=your-search-engine-id'

orchestrate connections set-credentials \
  --app-id google_search_api_credentials \
  --env live \
  -e 'GOOGLE_API_KEY=your-api-key' \
  -e 'GOOGLE_SEARCH_ENGINE_ID=your-search-engine-id'

# Import the google search tool
orchestrate tools import -k python -f ./google-search-tool/google_search_tool.py -r ./google-search-tool/requirements.txt --app-id google_search_api_credentials


# add the connections
orchestrate connections add --app-id gmail_credentials

# configure the connections draft & live
orchestrate connections configure \
  --app-id gmail_credentials \
  --env draft \
  --kind key_value \
  --type team

orchestrate connections configure \
  --app-id gmail_credentials \
  --env live \
  --kind key_value \
  --type team


# Set-credentials for send gmail tool for draft & live
orchestrate connections set-credentials \
  --app-id gmail_credentials \
  --env draft \
  -e 'GMAIL_USER=your-email@gmail.com' \
  -e 'GMAIL_APP_PASSWORD=your-app-password'

orchestrate connections set-credentials \
  --app-id gmail_credentials \
  --env live \
  -e 'GMAIL_USER=your-email@gmail.com' \
  -e 'GMAIL_APP_PASSWORD=your-app-password'


# Import the send gmail tool
orchestrate tools import -k python -f ./gmail-send-tool/send_email_2.py --app-id gmail_credentials


# Verify it worked
orchestrate tools list
```

### Step 4: Add Your Credentials in wxo portal -> https://dl.watson-orchestrate.ibm.com/manage/connectors/credentials
1. Login to Watson Orchestrate
2. Click Menu -> Manage -> Connections
3. Click on Credentials tab and you will see Draft environment credentials.
#### Add gmail credentials
4. Click on 3 dots on the right side of the gmail_credentials and select Edit
5. CLick on Add Key value pair
6. Add Key1: GMAIL_USER and Value1: your-email@gmail.com
7. Add Key2: GMAIL_APP_PASSWORD and Value2: your-app-password
8. Click Update credentials
9. Click Done.
10.Perform Step 4 to 9 for live environment.
#### Add Google Search credentials
4. Click on 3 dots on the right side of the gmail_credentials and select Edit
5. CLick on Add Key value pair
6. Add Key1: GOOGLE_SEARCH_ENGINE_ID and Value1: your-google-search-engine-id
7. Add Key2: GOOGLE_API_KEY and Value2: your-google-api-key
8. Click Update credentials
9. Click Done.
10.Perform Step 4 to 9 for live environment.