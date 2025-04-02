import { handleImageSrc, imageLoader } from "@/hooks";
import Image from "next/image";
import {
  activeImageState,
  activeMenuState,
  allMenus,
  menusState,
  totalState,
} from "@/store";
import { useRecoilValue } from "recoil";
import { Button, Col, Input, Row } from "antd";
import styles from "./basic.module.css";
import { useMemo } from "react";

const SiderBasic = () => {
  const image: EagleWeb.Image | undefined = useRecoilValue(activeImageState);
  const activeMenu = useRecoilValue(activeMenuState);
  const total = useRecoilValue(totalState);
  const menus = useRecoilValue(menusState);

  const handleTime = (time: number) => {
    const [date, t] = new Date(time * 1000)
      .toLocaleString()
      .replace(/:\d+$/, "")
      .split(" ");

    return (
      date
        .split("/")
        .map((item) => (item.length === 1 ? "0" + item : item))
        .join("/") +
      " " +
      t
    );
  };

  const key = useMemo(
    () =>
      (activeMenu && activeMenu.key
        ? activeMenu.key.toString()
        : "") as allMenus,
    [activeMenu]
  );

  if (!image) {
    return (
      <div style={{ padding: 20 }}>
        <Button block disabled>
          {menus[key]}
        </Button>
        <Row style={{ marginTop: 20 }}>
          <Col>基本信息</Col>
        </Row>
        <div className={styles.baseInfo} style={{ marginTop: 20 }}>
          <Row align="middle">
            <Col span={8}>图片数</Col>
            <Col>{total[key]}</Col>
          </Row>
        </div>
      </div>
    );
  }

  return (
    <div style={{ padding: 20 }}>
      <Image
        width={0}
        height={0}
        style={{
          objectFit: "contain",
          borderRadius: 8,
          margin: "auto",
          width: 200,
          height: image.height / (image.width / 200),
        }}
        src={handleImageSrc(image, true)}
        alt={image.name}
        loader={imageLoader}
      />

      <Row style={{ marginTop: 20 }}>
        <Col flex={1}>
          <Input value={image.name} />
        </Col>
      </Row>
      <Row style={{ marginTop: 10 }}>
        <Col flex={1}>
          <Input value={image.desc} placeholder="暂无注释" />
        </Col>
      </Row>
      <div style={{ marginTop: 20 }} className={styles.baseInfo}>
        <Row>
          <Col>基本信息</Col>
        </Row>

        <Row align="middle" style={{ marginTop: 10 }}>
          <Col span={8}>尺寸</Col>
          <Col>
            {image.width} x {image.height}
          </Col>
        </Row>
        <Row align="middle" style={{ marginTop: 10 }}>
          <Col span={8}>文件大小</Col>
          <Col>{(image.size / 1024).toFixed(2)} KB</Col>
        </Row>
        <Row align="middle" style={{ marginTop: 10 }}>
          <Col span={8}>格式</Col>
          <Col>{(() => {
              const ext = image.name.split('.').pop()
              if (ext == null) {
                  return ''
              } else {
                  return ext.toUpperCase()
              }
          })()}</Col>
        </Row>
        <Row align="middle" style={{ marginTop: 10 }}>
          <Col span={8}>添加日期</Col>
          <Col>{handleTime(image.timeStamp)}</Col>
        </Row>

        <Row style={{ marginTop: 20 }}>
          <Col flex={1}>
            <Button
              block
              type="primary"
              onClick={() => {
                open(handleImageSrc(image));
              }}
            >
              查看原图
            </Button>
          </Col>
        </Row>
      </div>
    </div>
  );
};

export default SiderBasic;
