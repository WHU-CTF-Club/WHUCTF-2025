import { atom } from "recoil";
import {ItemType} from "antd/es/menu/interface";

// 菜单 menu 相关 >>>
export type allMenus = "all" | "uploads" | "login";
export const menusState = atom({
  key: "menusState",
  default: {
    all: "全部",
    uploads: "上传",
    login: "登录"
  } as { [key in allMenus]: string },
});

// 当前选中的菜单  基础信息中需要显示菜单标题
export const activeMenuState = atom({
  key: "activeMenuState",
  default: undefined as ItemType | undefined,
});
// end >>>

// 当前选中图片
export const activeImageState = atom({
  key: "activeImageState",
  default: undefined as EagleWeb.Image | undefined,
});

// 主题
export const themeState = atom({
  key: "themeState",
  default: "light" as "light" | "dark",
});

export type Total = { [key in allMenus]: number };
// 图片数量
export const totalState = atom({
  key: "totalState",
  default: {
    all: 0,
    uploads: 0,
    login: 0,
  } as Total,
});

// 菜单为单位 排序规则
export const sortState = atom({
  key: "sortState",
  default: "id",
});

// 升序 降序
// asc 升序
// desc 降序
export const orderState = atom({
  key: "orderState",
  default: "desc" as "asc" | "desc",
});

