"use strict";
const utils_config = require("./config.js");
const API_ORIGIN = utils_config.BASE_URL.replace(/\/api\/?$/, "");
const STATIC_IMAGE_PREFIX = "/static";
function resolveImageUrl(url) {
  if (!url)
    return "";
  let value = String(url).trim();
  const nested = value.match(/^(https?:\/\/[^/]+(?:\/api\/uploads)?\/)(https?:\/\/.+)$/i);
  if (nested) {
    value = nested[2];
  }
  if (/^https?:\/\//i.test(value)) {
    return value;
  }
  if (value.startsWith("//")) {
    return `https:${value}`;
  }
  const path = value.startsWith("/") ? value : `/${value}`;
  if (path.startsWith("/api/")) {
    return `${API_ORIGIN}${path}`;
  }
  return `${API_ORIGIN}/api/uploads${path}`;
}
exports.STATIC_IMAGE_PREFIX = STATIC_IMAGE_PREFIX;
exports.resolveImageUrl = resolveImageUrl;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/image.js.map
