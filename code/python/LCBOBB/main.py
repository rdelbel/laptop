import urllib.request
import json
def get_url(url):
    data=json.loads(urllib.request.urlopen(url).read().decode('utf-8))
    return(data)
    import ipdb; ipdb.set_trace() # BREAKPOINT

