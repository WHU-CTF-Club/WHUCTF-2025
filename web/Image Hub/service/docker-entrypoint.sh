#!/bin/sh

# Get the user
user=$(ls /home)
KEY="w1ll_siesta_b3come_a_j0ker?"

RANDOM_STRING=$(cat /dev/random | tr -dc 'A-Za-z0-9' | head -c 7)
echo $RANDOM_STRING
MD5_HASH=$(echo -n "$RANDOM_STRING$KEY" | md5sum | awk '{print toupper($1)}')

sqlite3 /app/db.sqlite "INSERT INTO Users (Name, Password) VALUES ('admin', '$MD5_HASH');"

JWT_RANDOM_STRING=$(cat /dev/random | tr -dc 'A-Za-z0-9' | head -c 32)
sed -i "s/<JwtKeySed>/$JWT_RANDOM_STRING/g" /app/appsettings.json

# Check the environment variables for the flag and assign to INSERT_FLAG
if [ "$DASFLAG" ]; then
    INSERT_FLAG="$DASFLAG"
    export DASFLAG=no_FLAG
    DASFLAG=no_FLAG
elif [ "$FLAG" ]; then
    INSERT_FLAG="$FLAG"
    export FLAG=no_FLAG
    FLAG=no_FLAG
elif [ "$GZCTF_FLAG" ]; then
    INSERT_FLAG="$GZCTF_FLAG"
    export GZCTF_FLAG=no_FLAG
    GZCTF_FLAG=no_FLAG
else
    INSERT_FLAG="flag{TEST_Dynamic_FLAG}"
fi

# 将FLAG写入文件 请根据需要修改
echo $INSERT_FLAG | tee /flag.txt

# 控制flag和项目源码的权限
chown root:root /flag.txt && chmod 400 /flag.txt

su-exec app "dotnet" "dotnet.dll"
