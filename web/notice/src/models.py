from middleware import JSONTranslator
from falcon import App


class Notice:
    def __init__(self, title: str, number: str, content: str):
        self.title = title
        self.number = number
        self.content = content


class User:
    def __init__(self, name: str, secret: str):
        self.name = name
        self.secret = secret
        

class Token:
    def __init__(self, token: str, username: str):
        self.token = token
        self.username = username
      
        
app = App(
        middleware=[
            JSONTranslator(),
        ],
    )
