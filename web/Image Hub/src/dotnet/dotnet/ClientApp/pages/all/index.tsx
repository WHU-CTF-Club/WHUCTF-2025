import { useEffect, useState } from "react";
import justifyLayout from "justified-layout";
import { selectImages } from "@/hooks";
import { Empty, Layout, message } from "antd";
import { useRecoilState, useRecoilValue } from "recoil";
import { orderState, sortState, totalState } from "@/store";
import LayoutHeader from "@/components/layout-header";
import LayoutContent from "@/components/layout-content";
import {useRouter} from "next/router";

const Page = () => {
  const router = useRouter();
  const [total, setTotal] = useRecoilState(totalState);
  const [loading, setLoading] = useState(false);
  const [layoutPos, setLayoutPos] = useState<any>();
  const [page, setPage] = useState(1);
  const [data, setData] = useState<EagleWeb.Image[]>([]);
  const sort = useRecoilValue(sortState);
  const order = useRecoilValue(orderState);
  const [keywords, setKeywords] = useState("");
  const [searchCount, setSearchCount] = useState(0);
  const [messageApi, contextHolder] = message.useMessage();

  useEffect(()=>{
      if (sessionStorage.getItem("token") == null) {
          messageApi.open({
              type: 'error',
              content: `请先登录`,
          });
          setTimeout(() => {
              router.push("/login");
          }, 1500);
      }
  },[]);
  // 请求第一页数据，设置图片总数
  useEffect(() => {
    find(1, "", (all) => {
      setTotal({
        ...total,
        all,
      });
    });
  }, [sort, order]);

  // 查询
  const find = (page: number, rules?: string, fn?: (all: number) => void) => {
    setLoading(true);
    if (page === 1) {
      setLayoutPos(undefined);
    }

    selectImages({ page, sort: sort, order: order, rules })
      .then((res) => res.json())
      .then((v) => {
          const totalCount = Number(v.totalCount);
          // setSearchCount(totalCount);
          fn && fn(totalCount);
        setData(page === 1 ? v.images : (d) => d.concat(v));
        setPage(page);
        setLoading(false);
      })
        .catch((err) => {
            messageApi.open({
                type: 'error',
                content: `图片获取失败`,
            });
        });
  };

  // 通过data获取图片位置
  useEffect(() => {
    if (!data.length) return;
    setLayoutPos(
      justifyLayout([...data], {
        containerWidth: document.body.clientWidth - 480,
        targetRowHeight: 260,
        boxSpacing: {
          horizontal: 10,
          vertical: 20,
        },
      })
    );
  }, [data]);

  return (
    <Layout style={{ height: "100%" }}>
      {contextHolder}
      <LayoutHeader
        onSearch={(e) => {
          const key = e ? `${e}` : "";
          find(1, key);
          setKeywords(key);
        }}
        searchCount={searchCount}
      />
      {data.length > 0 ? (
        <LayoutContent
          layoutPos={layoutPos}
          data={data}
          onLoadmore={() => find(page + 1, keywords)}
          loading={loading}
        />
      ) : (
        <div
          style={{
            height: "100%",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
          }}
        >
          <Empty />
        </div>
      )}
    </Layout>
  );
};

export default Page;
