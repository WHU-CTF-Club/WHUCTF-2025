import {
  activeMenuState,
  allMenus,
  themeState,
} from "@/store";
import { Layout, ConfigProvider } from "antd";
import zhCN from "antd/locale/zh_CN";
import Head from "next/head";
import { useEffect, useMemo } from "react";
import { useRecoilState, useRecoilValue } from "recoil";
import SiderBasic from "./sider/basic";
import SiderMenu from "./sider/menu";

const { Sider, Content } = Layout;

export default function App({ children }: { children: JSX.Element }) {
  const themeMode = useRecoilValue(themeState);
  const activeMenu = useRecoilValue(activeMenuState);

  const key = useMemo(
    () =>
      (activeMenu && activeMenu.key
        ? activeMenu.key.toString()
        : "") as allMenus,
    [activeMenu]
  );

  return (
    <>
      <Head>
        <title>ImgHub</title>
        <meta property="og:title" content="rao.pics" key="title" />
      </Head>

      <ConfigProvider locale={zhCN}>
        <Layout
          style={{
            width: "100%",
            height: "100%",
          }}
          hasSider
        >
          <Sider width={240} theme={themeMode} className="sider-menu">
            <SiderMenu />
          </Sider>
          <Content
            className="scroll-bar main"
            style={{
              position: "relative",
              overflowY: "auto",
              overflowX: "hidden",
            }}
          >
            {children}
          </Content>
          <Sider
            className="sider-basic"
            collapsedWidth={0}
            width={240}
            theme={themeMode}
          >
            <SiderBasic />
          </Sider>
        </Layout>
      </ConfigProvider>
    </>
  );
}
