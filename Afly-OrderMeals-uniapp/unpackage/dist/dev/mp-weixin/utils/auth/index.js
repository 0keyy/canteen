"use strict";
const common_vendor = require("../../common/vendor.js");
function saveLoginResult(result) {
  if (result.token) {
    common_vendor.index.setStorageSync("token", result.token);
  }
  if (result.userId) {
    common_vendor.index.setStorageSync("userId", result.userId);
  }
  if (result.mobile) {
    common_vendor.index.setStorageSync("mobile", result.mobile);
  }
  if (result.nickname) {
    common_vendor.index.setStorageSync("nickname", result.nickname);
  }
}
exports.saveLoginResult = saveLoginResult;
//# sourceMappingURL=../../../.sourcemap/mp-weixin/utils/auth/index.js.map
