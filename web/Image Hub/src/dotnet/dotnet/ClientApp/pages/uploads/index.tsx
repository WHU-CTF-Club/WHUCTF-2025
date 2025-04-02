import {Row, Upload, UploadProps, message } from "antd";
import {InboxOutlined} from "@ant-design/icons";
import {useEffect,useState} from "react";
import {useRouter} from "next/router";
const { Dragger } = Upload;

const props: UploadProps = {
    name: 'file',
    multiple: true,
    accept: '.jpg',
    action: '/api/uploads',
    data: {'desc': 'some description'},
    beforeUpload: (file) => {
        const token = sessionStorage.getItem("token");
        const isPNG = file.type === 'image/jpeg';
        if (!isPNG) {
            message.error(`${file.name} is not a png file`);
        }
        return isPNG || Upload.LIST_IGNORE;
    },
    onChange(info) {
        const { status } = info.file;
        if (status === 'done') {
            message.success(`${info.file.name} file uploaded successfully.`);
        } else if (status === 'error') {
            message.error(`${info.file.name} file upload failed.`);
        }
    },

};

const Page = () => {
    const router = useRouter();
    const [headers, setHeaders] = useState<Record<string, string>>({});
    const [messageApi, contextHolder] = message.useMessage();

    useEffect(() => {
        if (sessionStorage.getItem("token") == null) {
            messageApi.open({
                type: 'error',
                content: `请先登录`,
            });
            setTimeout(() => {
                router.push("/login");
            }, 1500);
        }
        setHeaders({ Authorization: `Bearer ${sessionStorage.getItem('token') || ''}` });
    }, []);
    return (
        <>
            {contextHolder}
            <Row justify="center" align="middle" style={{minHeight:'100vh'}}>
                <Dragger {...props} style={{padding: '50px'}} headers={headers} >
                    <p className="ant-upload-drag-icon">
                        <InboxOutlined style={{ fontSize: '60px'}} />
                    </p>
                    <p className="ant-upload-text" style={{marginTop: '30px'}}>点击此处或拖拽图片至此以上传</p>
                </Dragger>
            </Row>
        </>
)
}

export default Page;
