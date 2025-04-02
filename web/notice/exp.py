import requests

url = "http://125.220.147.47:49229"
def login():
    res = requests.post(url=url+ "api/register",data={"username":"Admin","password":"123456"})
    res = requests.post(url=url+ "api/login",data={"username":"admin","password":"123456"})
    return(res.json['token'])

def evil(token):
    pass

def shell(token):
    pass

if __name__ == '__main__':
    token = login()
    evil(token)
    shell(token)

