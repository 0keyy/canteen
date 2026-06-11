"use strict";
const api_index = require("../../api/index.js");
const utils_pay_channels = require("./channels.js");
const utils_pay_weixin = require("./weixin.js");
async function payOrder(orderId, payChannel, payScene = "mp") {
  const payInfo = await api_index.payApi.create({ orderId, payChannel, payScene });
  if (payInfo.completed) {
    return payInfo;
  }
  if (payChannel === utils_pay_channels.PAY_CHANNEL.AGGREGATE) {
    throw new Error("聚合支付暂未开通，请使用余额支付");
  }
  if (payInfo.mockPay) {
    await api_index.payApi.mockSuccess(payInfo.outTradeNo);
    return payInfo;
  }
  await utils_pay_weixin.wxPay(payInfo);
  return payInfo;
}
exports.payOrder = payOrder;
//# sourceMappingURL=../../../.sourcemap/mp-weixin/utils/pay/index.js.map
