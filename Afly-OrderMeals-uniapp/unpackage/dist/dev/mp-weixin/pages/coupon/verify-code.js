"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      loading: false,
      code: "",
      couponId: null
    };
  },
  onLoad(options) {
    this.couponId = options.id;
    this.loadCode();
  },
  methods: {
    async loadCode() {
      this.loading = true;
      try {
        this.code = await api_index.couponApi.verifyCode(this.couponId) || "";
      } catch (e) {
        common_vendor.index.showToast({ title: e || "获取核销码失败", icon: "none" });
      } finally {
        this.loading = false;
      }
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.loading
  }, $data.loading ? {} : {
    b: common_vendor.t($data.code)
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-48a83695"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/verify-code.js.map
