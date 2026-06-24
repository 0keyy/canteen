"use strict";
const common_vendor = require("../common/vendor.js");
const TAB_PAGES = [
  "pages/index/index",
  "pages/menu/index",
  "pages/points/index",
  "pages/mine/index"
];
const TAB_NAME_PATH_MAP = {
  "首页": "pages/index/index",
  "点餐": "pages/menu/index",
  "积分商城": "pages/points/index",
  "我的": "pages/mine/index"
};
const DEFAULT_TABBAR = {
  style: {
    defaultColor: "#999999",
    selectedColor: "#C41E3A"
  },
  list: [
    { name: "首页", selected: "/static/tabbar/首页 1.png", unselected: "/static/tabbar/首页 1.png", link: { path: "/pages/index/index" } },
    { name: "点餐", selected: "/static/tabbar/面条 1.png", unselected: "/static/tabbar/面条 1.png", link: { path: "/pages/menu/index" } },
    { name: "积分商城", selected: "/static/tabbar/商城-幸福餐桌 1.png", unselected: "/static/tabbar/商城-幸福餐桌 1.png", link: { path: "/pages/points/index" } },
    { name: "我的", selected: "/static/tabbar/头像 1.png", unselected: "/static/tabbar/头像 1.png", link: { path: "/pages/mine/index" } }
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
  return {
    ...item,
    pagePath,
    link: {
      ...link,
      path: link.path || link.url || (pagePath ? `/${pagePath}` : "")
    },
    selected: (item == null ? void 0 : item.selected) || (item == null ? void 0 : item.selectedIcon) || "",
    unselected: (item == null ? void 0 : item.unselected) || (item == null ? void 0 : item.unselectedIcon) || ""
  };
}
const TABBAR_CACHE_VERSION = 4;
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
