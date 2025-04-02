import {message, Button, Card, Col, Input, Row} from "antd";
import {LockOutlined, UserOutlined} from "@ant-design/icons";
import {useState} from "react";
import {useRouter} from "next/router";

const Page = () => {
    const router = useRouter();
    const [messageApi, contextHolder] = message.useMessage();

    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");

    const handleLogin = () => {
        fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, password })
        })
            .then(response => {
                if (response.status ==  200) {
                    return response.json();
                } else if (response.status == 401) {
                    messageApi.open({
                        type: 'error',
                        content: `账户名或密码错误`,
                    });
                } else {
                    throw new Error();
                }
            })
            .then(data => {
                if (!(data.token == null)) {
                    messageApi.open({
                        type: 'success',
                        content: `登录成功`,
                    });
                    sessionStorage.setItem('token', data.token);
                    router.push('/all');
                } else {
                    throw new Error();
                }
            })
            .catch(() => {
                messageApi.open({
                    type: 'error',
                    content: `登录失败`,
                });
            });
    };

    return (
        <>
            {contextHolder}
            <Row justify="center" align="middle" style={{minHeight:'100vh'}}>
                <Col>
                    <Card hoverable style={{width: 620}} styles={{ body: { padding: 0, overflow: 'hidden', margin:'20px'}}}>
                        <Row justify="center" style={{marginTop:'10px'}}>
                            <h1>Login</h1>
                        </Row>
                        <Row justify="center" style={{marginTop:'30px'}}>
                            <Input size="large" placeholder="用户名" prefix={<UserOutlined />} style={{width: '70%'}}
                                   value={username}
                                   onChange={(e) => setUsername(e.target.value)}/>
                        </Row>
                        <Row justify="center" style={{marginTop:'20px'}}>
                            <Input.Password size="large" placeholder="密码" prefix={<LockOutlined />} style={{width: '70%'}}
                                            value={password}
                                            onChange={(e) => setPassword(e.target.value)}/>
                        </Row>

                        <Row justify="center" style={{marginTop:'30px', marginBottom:'10px'}}>
                            <Button type={"primary"} size={"large"} shape={"round"} style={{width: '150px'}}
                                    onClick={handleLogin}>登录</Button>
                        </Row>

                    </Card>
                </Col>
            </Row>
        </>
    )
}

export default Page;
