"use strict";
const common_vendor = require("../common/vendor.js");
const TAB_PAGES = [
  "pages/index/index",
  "pages/order/list",
  "pages/mine/index"
];
const DEFAULT_TABBAR = {
  style: {
    defaultColor: "#999999",
    selectedColor: "#FF6B35"
  },
  list: [
    { name: "首页", selected: "", unselected: "", link: { path: "/pages/index/index" } },
    { name: "订单", selected: "", unselected: "", link: { path: "/pages/order/list" } },
    { name: "我的", selected: "", unselected: "", link: { path: "/pages/mine/index" } }
  ]
};
function normalizeTabPath(path) {
  if (!path)
    return "";
  const raw = String(path).trim();
  return raw.startsWith("/") ? raw.slice(1) : raw;
}
function filterTabbarList(list) {
  if (!Array.isArray(list))
    return DEFAULT_TABBAR.list;
  const filtered = list.map((item) => {
    var _a, _b;
    return {
      ...item,
      pagePath: normalizeTabPath(((_a = item == null ? void 0 : item.link) == null ? void 0 : _a.path) || ((_b = item == null ? void 0 : item.link) == null ? void 0 : _b.url) || "")
    };
  }).filter((item) => TAB_PAGES.includes(item.pagePath));
  return filtered.length >= 2 ? filtered : DEFAULT_TABBAR.list;
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
exports.filterTabbarList = filterTabbarList;
exports.getDefaultTabbar = getDefaultTabbar;
exports.hideNativeTabBar = hideNativeTabBar;
exports.normalizeTabPath = normalizeTabPath;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/tabbar.js.map
