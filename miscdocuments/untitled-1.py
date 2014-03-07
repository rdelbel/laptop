import urllib.request
import json
data = json.loads(urllib.request.urlopen('http://lcboapi.com/stores/511/products').read().decode('utf-8'))
print(data['result'][0]['name'])