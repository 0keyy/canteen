"use strict";
const common_vendor = require("../common/vendor.js");
function readWindowInfo() {
  if (typeof common_vendor.index.getWindowInfo === "function") {
    return common_vendor.index.getWindowInfo();
  }
  if (typeof common_vendor.wx$1 !== "undefined" && typeof common_vendor.wx$1.getWindowInfo === "function") {
    return common_vendor.wx$1.getWindowInfo();
  }
  return null;
}
function readDeviceInfo() {
  if (typeof common_vendor.index.getDeviceInfo === "function") {
    return common_vendor.index.getDeviceInfo();
  }
  if (typeof common_vendor.wx$1 !== "undefined" && typeof common_vendor.wx$1.getDeviceInfo === "function") {
    return common_vendor.wx$1.getDeviceInfo();
  }
  return null;
}
function readLegacySystemInfo() {
  try {
    return common_vendor.index.getSystemInfoSync();
  } catch (e) {
    return null;
  }
}
function getNavMetrics() {
  var _a, _b;
  const fallback = {
    statusBarHeight: 20,
    navBarHeight: 44,
    headerHeight: 64
  };
  try {
    const windowInfo = readWindowInfo() || readLegacySystemInfo() || {};
    const deviceInfo = readDeviceInfo() || {};
    const statusBarHeight = Number(windowInfo.statusBarHeight || deviceInfo.statusBarHeight) || 20;
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
    const safeTop = ((_a = windowInfo.safeAreaInsets) == null ? void 0 : _a.top) ?? ((_b = windowInfo.safeArea) == null ? void 0 : _b.top) ?? statusBarHeight;
    const status = Math.max(Number(safeTop) || 0, statusBarHeight);
    return {
      statusBarHeight: status,
      navBarHeight: 44,
      headerHeight: status + 44
    };
  } catch (e) {
    return fallback;
  }
}
function getMenuButtonMarginRight(fallback = 96) {
  try {
    const windowInfo = readWindowInfo() || readLegacySystemInfo() || {};
    const windowWidth = Number(windowInfo.windowWidth);
    if (!Number.isFinite(windowWidth) || windowWidth <= 0) {
      return fallback;
    }
    if (typeof common_vendor.index.getMenuButtonBoundingClientRect === "function") {
      const menuButton = common_vendor.index.getMenuButtonBoundingClientRect();
      const left = Number(menuButton == null ? void 0 : menuButton.left);
      if (Number.isFinite(left) && left > 0) {
        const margin = windowWidth - left + 8;
        return Number.isFinite(margin) && margin > 0 ? margin : fallback;
      }
    }
    return fallback;
  } catch (e) {
    return fallback;
  }
}
exports.getMenuButtonMarginRight = getMenuButtonMarginRight;
exports.getNavMetrics = getNavMetrics;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/navbar.js.map
