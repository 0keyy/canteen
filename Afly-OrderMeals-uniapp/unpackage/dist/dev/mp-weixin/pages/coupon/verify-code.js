"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const PageLoading = () => "../../components/page-loading/page-loading.js";
const _sfc_main = {
  components: { PageLoading },
  data() {
    return {
      loading: false,
      code: "",
      couponId: null,
      pageLoading: false,
      pageLoadingTip: "加载中..."
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
    },
    goWithLoading(url, type = "navigateTo", tip = "加载中...") {
      this.pageLoadingTip = tip;
      this.pageLoading = true;
      setTimeout(() => {
        if (type === "switchTab") {
          common_vendor.index.switchTab({ url });
        } else if (type === "reLaunch") {
          common_vendor.index.reLaunch({ url });
        } else if (type === "redirectTo") {
          common_vendor.index.redirectTo({ url });
        } else if (type === "navigateBack") {
          common_vendor.index.navigateBack();
        } else {
          common_vendor.index.navigateTo({ url });
        }
        setTimeout(() => {
          this.pageLoading = false;
        }, 500);
      }, 100);
    }
  }
};
if (!Array) {
  const _easycom_page_loading2 = common_vendor.resolveComponent("page-loading");
  _easycom_page_loading2();
}
const _easycom_page_loading = () => "../../components/page-loading/page-loading.js";
if (!Math) {
  _easycom_page_loading();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.loading
  }, $data.loading ? {} : {
    b: common_vendor.t($data.code)
  }, {
    c: common_vendor.p({
      visible: $data.pageLoading,
      tip: $data.pageLoadingTip
    })
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-48a83695"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/verify-code.js.map
