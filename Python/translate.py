import requests

from urllib.parse import urlencode

##TIMEOUT = 30
TIMEOUT = 3
MAGICHEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.104 Safari/537.36'
}

class ResponseError(Exception):
    pass

def get_translation_url(sentance, tolanguage, fromlanguage='auto'):
    """Return the url you should visit to get sentance translated to language tolanguage."""
    query = {'client': 'gtx',
             'dt'    : 't',
             'sl'    : fromlanguage,
             'tl'    : tolanguage,
             'q'     : sentance}
    url = 'https://translate.googleapis.com/translate_a/single?'+urlencode(query)
    return url

def translate(sentance, tolang, fromlang='auto'):
    """Use the power of sneeky tricks to do translation."""
    # Get url from function, which uses urllib to generate proper query
    url = get_translation_url(sentance, tolang, fromlang)
    try:
        # Make a get request to translate url with magic headers
        # that make it work right cause google is smart and looks at that.
        # Also, make request result be json so we can look at it easily
        request_result = requests.get(url, headers=MAGICHEADERS).json()
    except Exception as ex:
        # If it broke somehow, try again
        # NOTE: could cause indefinite recursion
        return translate(sentance, tolang, fromlang)
    # After we get the result, get the right field of the response and return that.
    # If result field not in request result
    def get_parts(lst):
        usefull = []
        for i in lst:
            if isinstance(i, list):
                usefull += get_parts(i)
            elif i:
                usefull.append(i)
        return usefull
    return get_parts(request_result)[0]