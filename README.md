# Watson Orchestrate Tools Collection

This repository contains a collection of tools for IBM Watson Orchestrate that enhance its capabilities with external services.

## Available Tools

### [Google Search Tool](./google-search-tool/README.md)

The Google Search Tool enables premium web search capabilities in Watson Orchestrate using Google Custom Search API.

- Perform web searches directly from Watson Orchestrate
- Get structured search results with titles, links, and snippets
- Uses secure credential management

[Setup and Usage Instructions](./google-search-tool/README.md)

### [Gmail Send Tool](./gmail-send-tool/README.md)

The Gmail Send Tool allows sending emails via Gmail in Watson Orchestrate using secure credential management.

- Send emails directly from Watson Orchestrate
- Supports subject, body, and recipient customization
- Uses secure credential management

[Setup and Usage Instructions](./gmail-send-tool/README.md)

## Quick Start

Each tool has its own setup requirements and credentials. Please refer to the tool-specific README files for detailed instructions:

1. [Google Search Tool Setup](./google-search-tool/README.md)
2. [Gmail Send Tool Setup](./gmail-send-tool/README.md)

## General Requirements

- IBM Watson Orchestrate instance
- Watson Orchestrate ADK installed (`pip install ibm-watsonx-orchestrate`)
- Tool-specific credentials (see individual tool READMEs)

## License

This project is licensed under the terms specified in the [LICENSE](./LICENSE) file.