"use strict";
const utils_request = require("../utils/request.js");
const authApi = {
  wxLogin: (code) => utils_request.post("/front/auth/wx/login", { code }),
  wxPhone: (openid, phoneCode) => utils_request.post("/front/auth/wx/phone", { openid, phoneCode }),
  aliLogin: (authCode) => utils_request.post("/front/auth/ali/login", { authCode }),
  aliPhone: (authCode) => utils_request.post("/front/auth/ali/phone", { authCode }),
  smsSend: (mobile) => utils_request.post("/front/auth/app/sms/send", { mobile }),
  smsLogin: (mobile, code) => utils_request.post("/front/auth/app/sms/login", { mobile, code }),
  mockPhoneLogin: (mobile) => utils_request.post("/front/auth/mock/phone", { mobile }),
  profile: () => utils_request.get("/front/auth/profile"),
  logout: () => utils_request.post("/front/auth/logout")
};
const orderApi = {
  shop: (aid) => utils_request.get("/front/order/shop", { aid }),
  menu: (aid) => utils_request.get("/front/order/menu", { aid }),
  cartCreate: (data) => utils_request.post("/front/order/cart/create", data),
  cartHas: (aid) => utils_request.get("/front/order/cart/has", { aid }),
  dishAdd: (orderId, dishId) => utils_request.post("/front/order/cart/dishAdd", { orderId, dishId }),
  dishInc: (id) => utils_request.post("/front/order/cart/dishInc", null, { id }),
  dishDec: (id) => utils_request.post("/front/order/cart/dishDec", null, { id }),
  dishDel: (id) => utils_request.post("/front/order/cart/dishDel", null, { id }),
  toEmpty: (orderId) => utils_request.post("/front/order/cart/toEmpty", null, { orderId }),
  submit: (data) => utils_request.post("/front/order/submit", data),
  list: () => utils_request.get("/front/order/list"),
  detail: (orderId) => utils_request.get("/front/order/detail", { orderId }),
  cancel: (orderId, reason) => utils_request.post("/front/order/cancel", null, { orderId, reason })
};
const addressApi = {
  list: () => utils_request.get("/front/address/list"),
  detail: (id) => utils_request.get("/front/address/detail", { id }),
  save: (data) => utils_request.post("/front/address/save", data),
  delete: (id) => utils_request.post("/front/address/delete", null, { id }),
  setDefault: (id) => utils_request.post("/front/address/setDefault", null, { id })
};
const decorateApi = {
  tabbar: () => utils_request.get("/front/decorate/tabbar"),
  page: (id = 1) => utils_request.get("/front/decorate/page", { id })
};
const payApi = {
  create: (data) => utils_request.post("/front/pay/create", data),
  mockSuccess: (outTradeNo) => utils_request.post("/front/pay/mock/success", null, { outTradeNo }),
  status: (outTradeNo) => utils_request.get("/front/pay/status", { outTradeNo })
};
exports.addressApi = addressApi;
exports.authApi = authApi;
exports.decorateApi = decorateApi;
exports.orderApi = orderApi;
exports.payApi = payApi;
//# sourceMappingURL=../../.sourcemap/mp-weixin/api/index.js.map
