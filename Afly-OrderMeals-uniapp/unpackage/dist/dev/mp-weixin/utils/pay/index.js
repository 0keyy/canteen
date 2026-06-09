"use strict";
const api_index = require("../../api/index.js");
const utils_pay_weixin = require("./weixin.js");
async function payOrder(orderId, payChannel, payScene) {
  const payInfo = await api_index.payApi.create({ orderId, payChannel, payScene });
  if (payInfo.mockPay) {
    await api_index.payApi.mockSuccess(payInfo.outTradeNo);
    return payInfo;
  }
  await utils_pay_weixin.wxPay(payInfo);
  return payInfo;
}
exports.payOrder = payOrder;
//# sourceMappingURL=../../../.sourcemap/mp-weixin/utils/pay/index.js.map
