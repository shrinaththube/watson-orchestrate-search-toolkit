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

### Step 3: Add Your Credentials
**Edit `google_search_tool.py`** - Replace these lines:
```python
GOOGLE_API_KEY = "your-api-key-here"        # ← Put your API key here
SEARCH_ENGINE_ID = "your-search-engine-id"  # ← Put your Search Engine ID here
```

### Step 4: Import to Watson Orchestrate

Install watsonx orchestrate ADK and connect to your instance -> https://developer.watson-orchestrate.ibm.com/getting_started/installing

```bash
# Install ADK (if you haven't already)
pip install ibm-watsonx-orchestrate

# Connect to Watson Orchestrate
orchestrate env activate your-environment-name

# Import the tool
orchestrate tools import -k python -f google_search_tool.py -r requirements.txt

# Verify it worked
orchestrate tools list
```
