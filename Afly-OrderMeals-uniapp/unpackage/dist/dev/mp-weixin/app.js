"use strict";
Object.defineProperty(exports, Symbol.toStringTag, { value: "Module" });
const common_vendor = require("./common/vendor.js");
const api_index = require("./api/index.js");
const utils_tabbar = require("./utils/tabbar.js");
if (!Math) {
  "./pages/login/index.js";
  "./pages/index/index.js";
  "./pages/menu/index.js";
  "./pages/cart/confirm.js";
  "./pages/address/list.js";
  "./pages/address/edit.js";
  "./pages/order/list.js";
  "./pages/order/detail.js";
  "./pages/mine/index.js";
  "./pages/mine/company-auth.js";
}
async function preloadTabbar() {
  try {
    const data = await api_index.decorateApi.tabbar();
    const list = utils_tabbar.filterTabbarList((data == null ? void 0 : data.list) || []);
    if (list.length >= 2) {
      utils_tabbar.writeTabbarCache({
        style: (data == null ? void 0 : data.style) || utils_tabbar.getDefaultTabbar().style,
        list
      });
    }
  } catch (e) {
  }
}
const _sfc_main = {
  onLaunch() {
    const token = common_vendor.index.getStorageSync("token");
    if (!token) {
      common_vendor.index.reLaunch({ url: "/pages/login/index" });
      return;
    }
    preloadTabbar();
  }
};
function createApp() {
  const app = common_vendor.createSSRApp(_sfc_main);
  return { app };
}
createApp().app.mount("#app");
exports.createApp = createApp;
//# sourceMappingURL=../.sourcemap/mp-weixin/app.js.map
