"use strict";
const utils_request = require("../utils/request.js");
function getIntegralGoodsList() {
  return utils_request.request({
    url: "/api/integral/goods/list",
    method: "GET"
  });
}
function getDrawPrizeList() {
  return utils_request.request({
    url: "/api/integral/draw/prizeList",
    method: "GET"
  });
}
function startDrawApi() {
  return utils_request.request({
    url: "/api/integral/draw/start",
    method: "POST"
  });
}
exports.getDrawPrizeList = getDrawPrizeList;
exports.getIntegralGoodsList = getIntegralGoodsList;
exports.startDrawApi = startDrawApi;
//# sourceMappingURL=../../.sourcemap/mp-weixin/api/integral.js.map
