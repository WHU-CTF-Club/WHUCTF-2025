import {
  activeMenuState,
  allMenus,
  menusState,
  orderState,
  sortState,
} from "@/store";
import { RightOutlined, SearchOutlined, SwapOutlined } from "@ant-design/icons";
import {
  Breadcrumb,
  Button,
  Col,
  Input,
  Layout,
  Popover,
  Radio,
  Row,
  Select,
  Slider,
  theme,
  Typography,
} from "antd";
import { useMemo } from "react";
import { useRecoilState, useRecoilValue } from "recoil";

interface Props {
  onSearch?: (value: string) => void;
  searchCount?: number;
}

const LayoutHeader = (props: Props) => {
  const { token } = theme.useToken();
  const activeMenu = useRecoilValue(activeMenuState);
  const [order, setOrder] = useRecoilState(orderState);
  const [sort, setSort] = useRecoilState(sortState);
  const menus = useRecoilValue(menusState);

  const key = useMemo(
    () =>
      (activeMenu && activeMenu.key
        ? activeMenu.key.toString()
        : "") as allMenus,
    [activeMenu]
  );

  return (
    <Layout.Header
      style={{
        position: "sticky",
        top: 0,
        backgroundColor: token.colorBgContainer,
        zIndex: 999,
        height: 36,
        padding: "0 20px",
        lineHeight: "36px",
      }}
    >
      <Row justify="space-between" align="middle" style={{ height: 32 }}>
        <Col>
          <Breadcrumb separator={<RightOutlined />}>
            <Breadcrumb.Item>
              <Typography.Text strong>{menus[key]}</Typography.Text>
            </Breadcrumb.Item>
            {props.searchCount ? (
              <Breadcrumb.Item>
                <Typography.Text strong>
                  搜索结果（{props.searchCount}）
                </Typography.Text>
              </Breadcrumb.Item>
            ) : null}
          </Breadcrumb>
        </Col>

        {/*<Col>*/}
        {/*  <Slider max={12} min={1} style={{ width: 120 }} disabled />*/}
        {/*</Col>*/}

        <Col>
          <Row gutter={[10, 0]}>
            <Col>
              <Popover
                trigger="click"
                content={
                  <Row style={{ width: 100 }} gutter={[0, 10]}>
                    <Col flex={1} style={{ textAlign: "center" }}>
                      <Radio.Group
                        optionType="button"
                        size="small"
                        value={order}
                        onChange={(e) => setOrder(e.target.value)}
                        buttonStyle="solid"
                        options={[
                          { label: "升序", value: "asc" },
                          { label: "降序", value: "desc" },
                        ]}
                      />
                    </Col>

                    <Col flex={1}>
                      <Select
                        size="small"
                        style={{ width: 100 }}
                        value={sort}
                        onChange={setSort}
                        placeholder="排序方式"
                        options={[
                          {
                            value: "Id",
                            label: "编号",
                          },
                          {
                            value: "timeStamp",
                            label: "创建日期",
                          },
                          {
                            value: "size",
                            label: "文件大小",
                          },
                        ]}
                      />
                    </Col>
                  </Row>
                }
              >
                <Button
                  icon={<SwapOutlined rotate={90} />}
                  type="text"
                  size="small"
                />
              </Popover>
            </Col>
            <Col>
              <Input
                placeholder="回车开始搜索"
                size="small"
                prefix={<SearchOutlined />}
                onPressEnter={(e) =>
                  props?.onSearch &&
                  props.onSearch((e.target as HTMLInputElement).value)
                }
              />
            </Col>
          </Row>
        </Col>
      </Row>

    {/*  <Row*/}
    {/*    style={{ height: 32, width: "100%" }}*/}
    {/*    align="middle"*/}
    {/*    justify="space-between"*/}
    {/*  >*/}
    {/*    <Col flex={1}>*/}
    {/*      <Typography.Text type="warning" strong>*/}
    {/*        该版本为一个实验版本，主要验证想法的可行性、技术选型、UI样式统一问题。*/}
    {/*      </Typography.Text>*/}
    {/*    </Col>*/}

    {/*    <Col>*/}
    {/*      <Typography.Text type="secondary">*/}
    {/*        json-server*/}
    {/*        联合/多条件查询实现过于复杂，等后面改为sqlite在接入更多搜索*/}
    {/*      </Typography.Text>*/}
    {/*    </Col>*/}
    {/*  </Row>*/}
    </Layout.Header>
  );
};

export default LayoutHeader;
