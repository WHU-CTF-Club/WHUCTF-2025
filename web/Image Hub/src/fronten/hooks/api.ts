import getConfig from "next/config";

interface SelectImagesParam {
  page?: number;
  limit?: number;
  rules?: string;
  order?: string;
  sort?: string;
}

const { env }: { env: EagleWeb.Env } = getConfig().publicRuntimeConfig;

// 查询images
export const selectImages = (props: SelectImagesParam) => {
  props.limit = props.limit === undefined ? env.limit : props.limit;

  return fetch('/api/list', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(props),
  })
};
