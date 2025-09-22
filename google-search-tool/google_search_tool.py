import requests
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
from typing import List, Dict, Any

@tool(
    name='google_search',
    description='Premium web search using Google Custom Search. Ready to use with pre-configured credentials.',
    permission=ToolPermission.READ_ONLY
)
def google_search(query: str, num_results: int = 10) -> List[Dict[str, Any]]:
    """Searches the web using Google Custom Search API.
    
    Args:
        query (str): The search query to execute
        num_results (int, optional): Number of results to return (1-10). Defaults to 10.
        
    Returns:
        List[Dict[str, Any]]: List of search results with title, link, and snippet
        
    Example:
        >>> google_search("SJSU computer science", 5)
        [{'rank': 1, 'title': '...', 'link': '...', 'snippet': '...'}]
    """
    # Hardcoded credentials (replace with your actual values)
    GOOGLE_API_KEY = "Add-Your-Google-API-Key>"
    GOOGLE_SEARCH_ENGINE_ID = "Add-Search-Engine-ID"
    
    try:
        # Google Custom Search API endpoint
        endpoint = "https://www.googleapis.com/customsearch/v1"
        
        # Parameters
        params = {
            'key': GOOGLE_API_KEY,
            'cx': GOOGLE_SEARCH_ENGINE_ID,
            'q': query,
            'num': min(num_results, 10),
            'safe': 'medium',
            'gl': 'us',
            'hl': 'en'
        }
        
        # Make API request
        response = requests.get(endpoint, params=params, timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            items = data.get('items', [])
            
            # Format results
            formatted_results = []
            for i, item in enumerate(items, 1):
                formatted_results.append({
                    'rank': i,
                    'title': item.get('title', 'No Title'),
                    'link': item.get('link', 'No URL'),
                    'snippet': item.get('snippet', 'No description available'),
                    'displayLink': item.get('displayLink', 'Unknown domain')
                })
            
            return formatted_results if formatted_results else [{'title': 'No results found', 'link': '', 'snippet': f'No search results found for: {query}'}]
        
        else:
            return [{'title': 'Search Error', 'link': '', 'snippet': f'Google API error: {response.status_code}'}]
            
    except Exception as e:
        return [{'title': 'Search Failed', 'link': '', 'snippet': f'Search error: {str(e)}'}]
