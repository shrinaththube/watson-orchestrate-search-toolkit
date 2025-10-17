#!/bin/bash

# Watson Orchestrate Tools Setup Script
# This script automates the setup of Google Search and Gmail Send tools for Watson Orchestrate

# Text formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Function to display section headers
section() {
    echo -e "\n${BOLD}${BLUE}$1${NC}\n"
}

# Function to display success messages
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to display error messages and exit
error() {
    echo -e "${RED}✗ $1${NC}"
    exit 1
}

# Function to display info messages
info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Function to prompt for input with a default value
prompt() {
    local prompt_text="$1"
    local default_value="$2"
    local var_name="$3"
    
    if [ -n "$default_value" ]; then
        read -p "$prompt_text [$default_value]: " input
        eval $var_name="${input:-$default_value}"
    else
        read -p "$prompt_text: " input
        eval $var_name="$input"
    fi
}

# Check if orchestrate CLI is installed
check_orchestrate_cli() {
    section "Checking Watson Orchestrate CLI"
    
    if ! command -v orchestrate &> /dev/null; then
        error "Watson Orchestrate CLI not found. Please install it with: pip install ibm-watsonx-orchestrate"
    else
        success "Watson Orchestrate CLI is installed"
    fi
}

# Setup environment
setup_environment() {
    section "Setting up Watson Orchestrate Environment"
    
    # List existing environments
    echo "Existing environments:"
    orchestrate env list
    
    # Prompt for environment details
    prompt "Enter environment name" "default" ENV_NAME
    prompt "Enter service instance URL (leave empty to skip environment creation)" "" SERVICE_URL
    
    # Create environment if URL is provided
    if [ -n "$SERVICE_URL" ]; then
        info "Creating environment '$ENV_NAME'..."
        orchestrate env add -n "$ENV_NAME" -u "$SERVICE_URL" --activate || error "Failed to create environment"
        success "Environment '$ENV_NAME' created and activated"
    else
        # Activate existing environment
        info "Activating environment '$ENV_NAME'..."
        orchestrate env activate "$ENV_NAME" || error "Failed to activate environment '$ENV_NAME'"
        success "Environment '$ENV_NAME' activated"
    fi
}

# Setup Google Search tool
setup_google_search() {
    section "Setting up Google Search Tool"
    
    # Prompt for Google Search credentials
    prompt "Enter your Google API Key" "" GOOGLE_API_KEY
    prompt "Enter your Google Search Engine ID" "" GOOGLE_SEARCH_ENGINE_ID
    
    # Add connection
    info "Adding Google Search API connection..."
    orchestrate connections add --app-id google_search_api_credentials || error "Failed to add Google Search API connection"
    
    # Configure for draft environment
    info "Configuring Google Search API connection for draft environment..."
    orchestrate connections configure \
      --app-id google_search_api_credentials \
      --env draft \
      --kind key_value \
      --type team || error "Failed to configure Google Search API connection for draft environment"
    
    # Configure for live environment
    info "Configuring Google Search API connection for live environment..."
    orchestrate connections configure \
      --app-id google_search_api_credentials \
      --env live \
      --kind key_value \
      --type team || error "Failed to configure Google Search API connection for live environment"
    
    # Set credentials for draft environment
    info "Setting Google Search API credentials for draft environment..."
    orchestrate connections set-credentials \
      --app-id google_search_api_credentials \
      --env draft \
      -e "GOOGLE_API_KEY=$GOOGLE_API_KEY" \
      -e "GOOGLE_SEARCH_ENGINE_ID=$GOOGLE_SEARCH_ENGINE_ID" || error "Failed to set Google Search API credentials for draft environment"
    
    # Set credentials for live environment
    info "Setting Google Search API credentials for live environment..."
    orchestrate connections set-credentials \
      --app-id google_search_api_credentials \
      --env live \
      -e "GOOGLE_API_KEY=$GOOGLE_API_KEY" \
      -e "GOOGLE_SEARCH_ENGINE_ID=$GOOGLE_SEARCH_ENGINE_ID" || error "Failed to set Google Search API credentials for live environment"
    
    # Import the tool
    info "Importing Google Search tool..."
    orchestrate tools import -k python -f ./google-search-tool/google_search_tool.py -r ./google-search-tool/requirements.txt --app-id google_search_api_credentials || error "Failed to import Google Search tool"
    
    success "Google Search tool setup completed"
}

# Setup Gmail Send tool
setup_gmail_send() {
    section "Setting up Gmail Send Tool"
    
    # Prompt for Gmail credentials
    prompt "Enter your Gmail email address" "" GMAIL_USER
    prompt "Enter your Gmail app password" "" GMAIL_APP_PASSWORD
    
    # Add connection
    info "Adding Gmail connection..."
    orchestrate connections add --app-id gmail_credentials || error "Failed to add Gmail connection"
    
    # Configure for draft environment
    info "Configuring Gmail connection for draft environment..."
    orchestrate connections configure \
      --app-id gmail_credentials \
      --env draft \
      --kind key_value \
      --type team || error "Failed to configure Gmail connection for draft environment"
    
    # Configure for live environment
    info "Configuring Gmail connection for live environment..."
    orchestrate connections configure \
      --app-id gmail_credentials \
      --env live \
      --kind key_value \
      --type team || error "Failed to configure Gmail connection for live environment"
    
    # Set credentials for draft environment
    info "Setting Gmail credentials for draft environment..."
    orchestrate connections set-credentials \
      --app-id gmail_credentials \
      --env draft \
      -e "GMAIL_USER=$GMAIL_USER" \
      -e "GMAIL_APP_PASSWORD=$GMAIL_APP_PASSWORD" || error "Failed to set Gmail credentials for draft environment"
    
    # Set credentials for live environment
    info "Setting Gmail credentials for live environment..."
    orchestrate connections set-credentials \
      --app-id gmail_credentials \
      --env live \
      -e "GMAIL_USER=$GMAIL_USER" \
      -e "GMAIL_APP_PASSWORD=$GMAIL_APP_PASSWORD" || error "Failed to set Gmail credentials for live environment"
    
    # Import the tool
    info "Importing Gmail Send tool..."
    orchestrate tools import -k python -f ./gmail-send-tool/send_email_2.py --app-id gmail_credentials || error "Failed to import Gmail Send tool"
    
    success "Gmail Send tool setup completed"
}

# Verify setup
verify_setup() {
    section "Verifying Setup"
    
    info "Listing installed tools..."
    orchestrate tools list
    
    success "Setup verification completed"
}

# Main script execution
main() {
    section "Watson Orchestrate Tools Setup"
    
    echo -e "This script will set up the following tools for Watson Orchestrate:"
    echo -e "  1. Google Search Tool"
    echo -e "  2. Gmail Send Tool"
    echo -e "\nMake sure you have the following information ready:"
    echo -e "  - Watson Orchestrate environment details"
    echo -e "  - Google API Key and Search Engine ID"
    echo -e "  - Gmail email address and app password"
    
    prompt "Do you want to continue? (y/n)" "y" CONTINUE
    
    if [[ $CONTINUE != "y" && $CONTINUE != "Y" ]]; then
        info "Setup cancelled"
        exit 0
    fi
    
    check_orchestrate_cli
    setup_environment
    
    # Ask which tools to set up
    prompt "Set up Google Search Tool? (y/n)" "y" SETUP_GOOGLE
    if [[ $SETUP_GOOGLE == "y" || $SETUP_GOOGLE == "Y" ]]; then
        setup_google_search
    fi
    
    prompt "Set up Gmail Send Tool? (y/n)" "y" SETUP_GMAIL
    if [[ $SETUP_GMAIL == "y" || $SETUP_GMAIL == "Y" ]]; then
        setup_gmail_send
    fi
    
    verify_setup
    
    section "Setup Complete"
    echo -e "You can now use the Google Search and Gmail Send tools in Watson Orchestrate."
    echo -e "For more information, refer to the README files in each tool's directory."
}

# Run the main function
main
