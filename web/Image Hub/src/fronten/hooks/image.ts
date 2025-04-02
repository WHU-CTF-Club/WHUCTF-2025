import getConfig from "next/config";
import { ImageLoaderProps } from "next/image";

const { env }: { env: EagleWeb.Env } = getConfig().publicRuntimeConfig;

export const handleImageSrc = (
  data: EagleWeb.Image,
  thumbnail: boolean = false
) => {
  // let host = `${env.images_protocol}://${env.images_hostname}`;
  //
  // if (env.images_port) {
  //   host += ":" + env.images_port;
  // }
  //
  // const prefix = `${host}/api/image/${data.id}`;

  const prefix = `/api/image/${data.id}`;

  // 有些图片没有缩略图，具体规则未知
  if (thumbnail) {
    return `${prefix}?thumbnail=1`;
  }
  return `${prefix}`;
};

export const imageLoader = ({ src }: ImageLoaderProps) => {
  return `${src}`;
};
