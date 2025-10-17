import requests
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
from ibm_watsonx_orchestrate.run import connections
from ibm_watsonx_orchestrate.agent_builder.connections import ConnectionType
from typing import List, Dict, Any


@tool(
    name='google_search',
    description='Premium web search using Google Custom Search. Uses secure credential management.',
    permission=ToolPermission.READ_ONLY,
    expected_credentials=[{
        "app_id": "google_search_api", 
        "type": ConnectionType.KEY_VALUE
    }]
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
    try:
        # Access credentials from secure connection
        conn = connections.key_value("google_search_api")
        GOOGLE_API_KEY = conn["GOOGLE_API_KEY"]
        GOOGLE_SEARCH_ENGINE_ID = conn["GOOGLE_SEARCH_ENGINE_ID"]
        
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
            
            return formatted_results if formatted_results else [
                {'title': 'No results found', 'link': '', 'snippet': f'No search results found for: {query}'}
            ]
        
        elif response.status_code == 403:
            return [{'title': 'API Error', 'link': '', 'snippet': 'Invalid API key or quota exceeded. Check credentials.'}]
        
        else:
            return [{'title': 'Search Error', 'link': '', 'snippet': f'Google API error: {response.status_code}'}]
    
    except KeyError as e:
        return [{'title': 'Configuration Error', 'link': '', 'snippet': f'Missing credential: {str(e)}. Check connection setup in UI.'}]
    
    except Exception as e:
        return [{'title': 'Search Failed', 'link': '', 'snippet': f'Search error: {str(e)}'}]
