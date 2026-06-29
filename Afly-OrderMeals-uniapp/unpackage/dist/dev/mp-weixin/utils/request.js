"use strict";
const common_vendor = require("../common/vendor.js");
const utils_config = require("./config.js");
function buildUrl(url, params) {
  if (!params || Object.keys(params).length === 0) {
    return url;
  }
  const query = Object.keys(params).filter((key) => params[key] !== void 0 && params[key] !== null).map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`).join("&");
  return `${url}?${query}`;
}
function request(options) {
  const token = common_vendor.index.getStorageSync("token");
  const finalUrl = options.params ? buildUrl(options.url, options.params) : options.url;
  return new Promise((resolve, reject) => {
    common_vendor.index.request({
      url: utils_config.BASE_URL + finalUrl,
      method: options.method || "GET",
      data: options.data || {},
      header: {
        "Content-Type": "application/json",
        "like-uniapp": token || ""
      },
      success(res) {
        const body = res.data || {};
        if (body.code === 200) {
          resolve(body.data);
        } else if (body.code === 401 || body.code === 310 || body.code === 332 || body.code === 333) {
          common_vendor.index.removeStorageSync("token");
          common_vendor.index.reLaunch({ url: "/pages/login/index" });
          reject(body.msg || "请先登录");
        } else {
          reject(body.msg || "请求失败");
        }
      },
      fail(err) {
        reject(err.errMsg || "网络错误");
      }
    });
  });
}
function get(url, params) {
  return request({ url, method: "GET", params });
}
function post(url, data, params) {
  return request({ url, method: "POST", data, params });
}
exports.get = get;
exports.post = post;
exports.request = request;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/request.js.map
