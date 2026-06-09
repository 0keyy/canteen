"use strict";
const common_vendor = require("../../common/vendor.js");
function wxPay(payInfo) {
  return new Promise((resolve, reject) => {
    common_vendor.index.requestPayment({
      provider: "wxpay",
      timeStamp: payInfo.timeStamp,
      nonceStr: payInfo.nonceStr,
      package: payInfo.packageValue,
      signType: payInfo.signType,
      paySign: payInfo.paySign,
      success: resolve,
      fail: reject
    });
  });
}
exports.wxPay = wxPay;
//# sourceMappingURL=../../../.sourcemap/mp-weixin/utils/pay/weixin.js.map
