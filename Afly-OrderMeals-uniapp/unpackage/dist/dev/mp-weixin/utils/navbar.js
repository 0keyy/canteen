"use strict";
const common_vendor = require("../common/vendor.js");
function getNavMetrics() {
  var _a, _b;
  const fallback = {
    statusBarHeight: 20,
    navBarHeight: 44,
    headerHeight: 64
  };
  try {
    const sys = common_vendor.index.getSystemInfoSync();
    const statusBarHeight = sys.statusBarHeight || 20;
    let menuButton = null;
    if (typeof common_vendor.index.getMenuButtonBoundingClientRect === "function") {
      menuButton = common_vendor.index.getMenuButtonBoundingClientRect();
    }
    if (menuButton && menuButton.height > 0) {
      const navBarHeight = (menuButton.top - statusBarHeight) * 2 + menuButton.height;
      return {
        statusBarHeight,
        navBarHeight,
        headerHeight: statusBarHeight + navBarHeight
      };
    }
    const safeTop = ((_a = sys.safeAreaInsets) == null ? void 0 : _a.top) ?? ((_b = sys.safeArea) == null ? void 0 : _b.top) ?? statusBarHeight;
    const status = Math.max(safeTop, statusBarHeight);
    return {
      statusBarHeight: status,
      navBarHeight: 44,
      headerHeight: status + 44
    };
  } catch (e) {
    return fallback;
  }
}
exports.getNavMetrics = getNavMetrics;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/navbar.js.map
