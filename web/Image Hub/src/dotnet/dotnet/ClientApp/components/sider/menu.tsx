import React, { useEffect, useMemo, useState } from "react";
import {
  FileImageOutlined, UploadOutlined, UserOutlined,
} from "@ant-design/icons";
import { Col, Menu, MenuProps, Row, Typography } from "antd";
import { useRouter } from "next/router";
import { useRecoilState, useRecoilValue } from "recoil";
import {
  activeImageState,
  activeMenuState,
  themeState,
  totalState,
} from "@/store";

type MenuItem = Required<MenuProps>["items"][number];
function getItem(
  label: React.ReactNode,
  key: React.Key,
  icon?: React.ReactNode,
  children?: MenuItem[],
  type?: "group"
): MenuItem {
  return {
    key,
    icon,
    children,
    label,
    type,
  } as MenuItem;
}

function handleLabel(name: string, desc: number) {
  return (
    <Row justify={"space-between"}>
      <Col flex={1}>{name}</Col>
      <Col>
        <Typography.Text type="secondary">{desc}</Typography.Text>
      </Col>
    </Row>
  );
}

const SiderMenu = () => {
  const [activeMenu, setActiveMenu] = useRecoilState(activeMenuState);
  const [_activeImage, setActiveImage] = useRecoilState(activeImageState);
  const themeMode = useRecoilValue(themeState);
  const total = useRecoilValue(totalState);
  const router = useRouter();

  const [items, setItems] = useState<MenuProps["items"]>();

  useEffect(() => {
    setItems([
      getItem(
          handleLabel("全部图片", total.all),
          "all",
          <FileImageOutlined />
      ),
      getItem(
          "上传图片",
          "uploads",
          <UploadOutlined />
      ),
      getItem(
          "登录",
          "login",
          <UserOutlined />
      ),
    ]);
  }, [total]);

  const selectedKeys = useMemo(
    () => (activeMenu?.key ? [activeMenu.key.toString()] : []),
    [activeMenu]
  );
  useEffect(() => {
    const route = router.route.replace("/", "") || "all";

    if (route != activeMenu?.key && items) {
      const index = items.findIndex(
        (item) => item?.key && route.includes(item?.key?.toString())
      );

      setActiveMenu(items[index]);
    }
  }, [items, router]);

  return (
    <>
      <Menu
        style={{ width: "100%", padding: 10 }}
        mode="inline"
        theme={themeMode}
        items={items}
        selectedKeys={selectedKeys}
        onSelect={(e) => {
          const item = items?.find((item) => item?.key === e.key);
          setActiveMenu(item);
          setActiveImage(undefined);
          router.push("/" + e.key);
        }}
      />
    </>
  );
};

export default SiderMenu;
