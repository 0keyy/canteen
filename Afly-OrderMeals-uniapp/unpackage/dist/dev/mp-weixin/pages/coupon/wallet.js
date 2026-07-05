"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      tabs: [
        { label: "到店堂食", value: "instore" },
        { label: "外卖配送", value: "delivery" }
      ],
      activeTab: "instore",
      loading: false,
      coupons: []
    };
  },
  onShow() {
    this.loadCoupons();
  },
  methods: {
    goBack() {
      common_vendor.index.navigateBack();
    },
    formatTime(ts) {
      if (!ts || ts === 0)
        return "不限";
      const d = new Date(ts * 1e3);
      const y = d.getFullYear();
      const M = String(d.getMonth() + 1).padStart(2, "0");
      const D = String(d.getDate()).padStart(2, "0");
      return `${y}.${M}.${D}`;
    },
    switchTab(value) {
      this.activeTab = value;
      this.loadCoupons();
    },
    async loadCoupons() {
      this.loading = true;
      try {
        const list = await api_index.couponApi.myCoupons(this.activeTab) || [];
        this.coupons = list;
      } catch (e) {
        this.coupons = [];
      } finally {
        this.loading = false;
      }
    },
    getMockCoupons() {
      return [];
    },
    useCoupon(coupon) {
      if (coupon.type === 3 || coupon.type === 4) {
        common_vendor.index.navigateTo({ url: `/pages/coupon/verify-code?id=${coupon.id}` });
      } else {
        common_vendor.index.switchTab({ url: "/pages/menu/index" });
      }
    },
    goExchange() {
      common_vendor.index.navigateTo({ url: "/pages/coupon/center" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "2a"),
    b: common_vendor.f($data.tabs, (tab, k0, i0) => {
      return {
        a: common_vendor.t(tab.label),
        b: tab.value,
        c: $data.activeTab === tab.value ? 1 : "",
        d: common_vendor.o(($event) => $options.switchTab(tab.value), tab.value)
      };
    }),
    c: $data.loading
  }, $data.loading ? {} : $data.coupons.length === 0 ? {} : {
    e: common_vendor.f($data.coupons, (coupon, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t(coupon.discountAmount),
        b: coupon.type === 2 && coupon.minAmount > 0
      }, coupon.type === 2 && coupon.minAmount > 0 ? {
        c: common_vendor.t(coupon.minAmount)
      } : {}, {
        d: common_vendor.t(coupon.templateName),
        e: common_vendor.t($options.formatTime(coupon.useStartTime)),
        f: common_vendor.t($options.formatTime(coupon.useEndTime)),
        g: common_vendor.t(coupon.tip || "限堂食到店使用"),
        h: coupon.status === 1
      }, coupon.status === 1 ? {
        i: common_vendor.o(($event) => $options.useCoupon(coupon), coupon.id)
      } : {}, {
        j: coupon.status === 2
      }, coupon.status === 2 ? {} : {}, {
        k: coupon.status === 3
      }, coupon.status === 3 ? {} : {}, {
        l: coupon.id,
        m: coupon.status === 2 ? 1 : "",
        n: coupon.status === 3 ? 1 : ""
      });
    })
  }, {
    d: $data.coupons.length === 0,
    f: common_vendor.o((...args) => $options.goExchange && $options.goExchange(...args), "fc")
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-0b2f6175"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/wallet.js.map
