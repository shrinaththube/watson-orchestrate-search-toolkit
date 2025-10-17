# Google Search Tool for Watson Orchestrate

This tool enables premium web search capabilities in Watson Orchestrate using Google Custom Search API.

## Quick Setup

### Step 1: Get Your Google Credentials

**You need 2 things from Google:**

1. **API Key**: Go to [Google Cloud Console](https://developers.google.com/custom-search/v1/introduction)
   - Get a Key
   
2. **Search Engine ID**: Go to [Programmable Search Engine](https://programmablesearchengine.google.com)
   - Create search engine → Copy the Search Engine ID

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

# Set credentials for draft environment
orchestrate connections set-credentials \
  --app-id google_search_api_credentials \
  --env draft \
  -e 'GOOGLE_API_KEY=your-api-key' \
  -e 'GOOGLE_SEARCH_ENGINE_ID=your-search-engine-id'

# Set credentials for live environment
orchestrate connections set-credentials \
  --app-id google_search_api_credentials \
  --env live \
  -e 'GOOGLE_API_KEY=your-api-key' \
  -e 'GOOGLE_SEARCH_ENGINE_ID=your-search-engine-id'

# Import the google search tool
orchestrate tools import -k python -f ./google_search_tool.py -r ./requirements.txt --app-id google_search_api_credentials

# Verify it worked
orchestrate tools list
```

### Step 3: Add Your Credentials in WXO Portal

1. Login to Watson Orchestrate at https://dl.watson-orchestrate.ibm.com/
2. Click Menu -> Manage -> Connections
3. Click on Credentials tab and you will see Draft environment credentials.

#### Add Google Search credentials
1. Click on 3 dots on the right side of the google_search_api_credentials and select Edit
2. Click on Add Key value pair
3. Add Key1: GOOGLE_SEARCH_ENGINE_ID and Value1: your-google-search-engine-id
4. Add Key2: GOOGLE_API_KEY and Value2: your-google-api-key
5. Click Update credentials
6. Click Done.
7. Perform Steps 1-6 for live environment.

## Usage

Once imported, the Google Search tool can be used in your skills with the following parameters:

- `query`: The search query to execute
- `num_results`: Number of results to return (1-10, defaults to 10)

Example response format:
```json
[
  {
    "rank": 1,
    "title": "Result title",
    "link": "https://example.com",
    "snippet": "Result description...",
    "displayLink": "example.com"
  }
]
```

## Troubleshooting

- **API Error**: Check if your API key is valid and you haven't exceeded your quota
- **Configuration Error**: Ensure both GOOGLE_API_KEY and GOOGLE_SEARCH_ENGINE_ID are properly set in credentials
- **No Results**: Try a different search query or check if your search engine is configured correctly