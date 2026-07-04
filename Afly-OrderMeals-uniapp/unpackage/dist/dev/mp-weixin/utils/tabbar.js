"use strict";
const common_vendor = require("../common/vendor.js");
const utils_image = require("./image.js");
function s(path) {
  return `${utils_image.STATIC_IMAGE_PREFIX}${path}`;
}
const TAB_PAGES = [
  "pages/index/index",
  "pages/menu/index",
  "pages/order/list",
  "pages/mine/index"
];
const TAB_NAME_PATH_MAP = {
  "首页": "pages/index/index",
  "点餐": "pages/menu/index",
  "点单": "pages/menu/index",
  "菜单": "pages/menu/index",
  "堂食": "pages/menu/index",
  "订单": "pages/order/list",
  "我的订单": "pages/order/list",
  "我的": "pages/mine/index",
  "个人中心": "pages/mine/index",
  "我的主页": "pages/mine/index"
};
const DEFAULT_TABBAR = {
  style: {
    defaultColor: "#999999",
    selectedColor: "#C41E3A"
  },
  list: [
    { name: "首页", selected: s("/tabbar/首页 1.png"), unselected: s("/tabbar/首页 1.png"), link: { path: "/pages/index/index" } },
    { name: "点餐", selected: s("/tabbar/面条 1.png"), unselected: s("/tabbar/面条 1.png"), link: { path: "/pages/menu/index" } },
    { name: "订单", selected: s("/tabbar/全部订单 1.png"), unselected: s("/tabbar/全部订单 1.png"), link: { path: "/pages/order/list" } },
    { name: "我的", selected: s("/tabbar/头像 1.png"), unselected: s("/tabbar/头像 1.png"), link: { path: "/pages/mine/index" } }
  ]
};
function normalizeTabPath(path) {
  if (!path)
    return "";
  const raw = String(path).trim();
  return raw.startsWith("/") ? raw.slice(1) : raw;
}
function resolveTabPagePath(item) {
  var _a, _b;
  const fromLink = normalizeTabPath(((_a = item == null ? void 0 : item.link) == null ? void 0 : _a.path) || ((_b = item == null ? void 0 : item.link) == null ? void 0 : _b.url) || (item == null ? void 0 : item.pagePath) || "");
  if (fromLink)
    return fromLink;
  return TAB_NAME_PATH_MAP[item == null ? void 0 : item.name] || "";
}
function filterTabbarList(list) {
  if (!Array.isArray(list))
    return DEFAULT_TABBAR.list;
  const mapped = list.map((item) => ({
    ...item,
    pagePath: resolveTabPagePath(item)
  })).filter((item) => TAB_PAGES.includes(item.pagePath));
  if (mapped.length >= 2) {
    TAB_PAGES.forEach((pagePath, index) => {
      if (mapped.some((item) => item.pagePath === pagePath))
        return;
      const fallback = DEFAULT_TABBAR.list.find(
        (item) => normalizeTabPath(item.link.path) === pagePath
      );
      if (fallback) {
        mapped.splice(index, 0, {
          ...fallback,
          pagePath
        });
      }
    });
    return mapped;
  }
  return DEFAULT_TABBAR.list;
}
function getDefaultTabbar() {
  return {
    ...DEFAULT_TABBAR,
    list: filterTabbarList(DEFAULT_TABBAR.list)
  };
}
function hideNativeTabBar() {
  common_vendor.index.hideTabBar({ animation: false, fail: () => {
  } });
}
function normalizeTabbarItem(item) {
  const link = (item == null ? void 0 : item.link) || {};
  const pagePath = resolveTabPagePath(item);
  const selectedImg = (item == null ? void 0 : item.selected) || (item == null ? void 0 : item.selectedIcon) || (item == null ? void 0 : item.selectedIconPath) || (item == null ? void 0 : item.activeIcon) || (item == null ? void 0 : item.iconSelected) || (item == null ? void 0 : item.selectIcon) || (item == null ? void 0 : item.icon) || "";
  const unselectedImg = (item == null ? void 0 : item.unselected) || (item == null ? void 0 : item.unselectedIcon) || (item == null ? void 0 : item.unselectedIconPath) || (item == null ? void 0 : item.inactiveIcon) || (item == null ? void 0 : item.iconUnselected) || (item == null ? void 0 : item.defaultIcon) || (item == null ? void 0 : item.icon) || "";
  return {
    ...item,
    pagePath,
    link: {
      ...link,
      path: link.path || link.url || (pagePath ? `/${pagePath}` : "")
    },
    selected: selectedImg,
    unselected: unselectedImg
  };
}
const TABBAR_CACHE_VERSION = 9;
function readTabbarCache() {
  const cached = common_vendor.index.getStorageSync("tabbarConfig");
  if (!cached || cached.version !== TABBAR_CACHE_VERSION)
    return null;
  return cached;
}
function writeTabbarCache(config) {
  common_vendor.index.setStorageSync("tabbarConfig", {
    version: TABBAR_CACHE_VERSION,
    ...config
  });
}
exports.filterTabbarList = filterTabbarList;
exports.getDefaultTabbar = getDefaultTabbar;
exports.hideNativeTabBar = hideNativeTabBar;
exports.normalizeTabPath = normalizeTabPath;
exports.normalizeTabbarItem = normalizeTabbarItem;
exports.readTabbarCache = readTabbarCache;
exports.writeTabbarCache = writeTabbarCache;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/tabbar.js.map
