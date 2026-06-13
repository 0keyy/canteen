"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      tabs: [
        { label: "可使用", status: 1 },
        { label: "已使用", status: 2 },
        { label: "已过期", status: 3 }
      ],
      activeTab: 1,
      loading: false,
      coupons: []
    };
  },
  onShow() {
    this.loadCoupons();
  },
  methods: {
    typeLabel(type) {
      const map = { 1: "无门槛", 2: "满减", 3: "兑换券", 4: "套餐券", 5: "夜间券" };
      return map[type] || "";
    },
    formatTime(ts) {
      if (!ts || ts === 0)
        return "不限";
      const d = new Date(ts * 1e3);
      const M = String(d.getMonth() + 1).padStart(2, "0");
      const D = String(d.getDate()).padStart(2, "0");
      return `${M}/${D}`;
    },
    switchTab(status) {
      this.activeTab = status;
      this.loadCoupons();
    },
    async loadCoupons() {
      this.loading = true;
      try {
        this.coupons = await api_index.couponApi.myCoupons(this.activeTab) || [];
      } catch (e) {
        common_vendor.index.showToast({ title: e || "加载失败", icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    goVerifyCode(coupon) {
      common_vendor.index.navigateTo({ url: `/pages/coupon/verify-code?id=${coupon.id}` });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.f($data.tabs, (tab, k0, i0) => {
      return {
        a: common_vendor.t(tab.label),
        b: tab.status,
        c: $data.activeTab === tab.status ? 1 : "",
        d: common_vendor.o(($event) => $options.switchTab(tab.status), tab.status)
      };
    }),
    b: $data.loading
  }, $data.loading ? {} : $data.coupons.length === 0 ? {} : {
    d: common_vendor.f($data.coupons, (coupon, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t(coupon.discountAmount),
        b: coupon.type === 2 && coupon.minAmount > 0
      }, coupon.type === 2 && coupon.minAmount > 0 ? {
        c: common_vendor.t(coupon.minAmount)
      } : coupon.type === 5 ? {} : coupon.type === 3 || coupon.type === 4 ? {} : {}, {
        d: coupon.type === 5,
        e: coupon.type === 3 || coupon.type === 4,
        f: common_vendor.t(coupon.templateName),
        g: common_vendor.t($options.typeLabel(coupon.type)),
        h: common_vendor.t($options.formatTime(coupon.useStartTime)),
        i: common_vendor.t($options.formatTime(coupon.useEndTime)),
        j: coupon.nightUnavailable
      }, coupon.nightUnavailable ? {} : {}, {
        k: coupon.status === 2
      }, coupon.status === 2 ? {
        l: common_vendor.t($options.formatTime(coupon.useTime))
      } : {}, {
        m: coupon.status === 1 && (coupon.type === 3 || coupon.type === 4)
      }, coupon.status === 1 && (coupon.type === 3 || coupon.type === 4) ? {
        n: common_vendor.o(($event) => $options.goVerifyCode(coupon), coupon.id)
      } : {}, {
        o: coupon.status === 2
      }, coupon.status === 2 ? {} : {}, {
        p: coupon.status === 3
      }, coupon.status === 3 ? {} : {}, {
        q: coupon.id,
        r: coupon.status === 2 ? 1 : "",
        s: coupon.status === 3 ? 1 : ""
      });
    })
  }, {
    c: $data.coupons.length === 0
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-0b2f6175"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/wallet.js.map
