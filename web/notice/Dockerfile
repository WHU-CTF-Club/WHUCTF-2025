FROM python:3.12-slim-bookworm

# apt更换镜像源，并更新软件包列表信息
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources && \
    sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources
RUN apt-get update && \
    apt install patch gcc wget unzip gosu iptables -y

# 安装必要的python依赖库
RUN python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple \
    setuptools

COPY ./src /app
COPY ./service /

RUN gcc -o readflag readflag.c
RUN chown root:root readflag && chmod u+s readflag

WORKDIR /app
RUN wget https://github.com/falconry/falcon/archive/refs/heads/master.zip && unzip master.zip
RUN cd falcon-master && patch falcon/app.py < ../patch.diff && python setup.py install
RUN chown -R nobody /app

EXPOSE 8000

ENTRYPOINT ["/bin/bash","/docker-entrypoint.sh"]
