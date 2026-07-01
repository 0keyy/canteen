"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
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
      return map[type] || "未知";
    },
    async loadCoupons() {
      this.loading = true;
      try {
        this.coupons = await api_index.couponApi.center() || [];
        const claimed = common_vendor.index.getStorageSync("claimedCoupons") || {};
        this.coupons.forEach((c) => {
          c.claimed = !!claimed[c.id];
        });
      } catch (e) {
        common_vendor.index.showToast({ title: e || "加载失败", icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    async claimCoupon(coupon) {
      try {
        const result = await api_index.couponApi.claim(coupon.id);
        const claimed = common_vendor.index.getStorageSync("claimedCoupons") || {};
        claimed[coupon.id] = true;
        common_vendor.index.setStorageSync("claimedCoupons", claimed);
        coupon.claimed = true;
        common_vendor.index.showToast({ title: "领取成功！", icon: "success" });
      } catch (e) {
        common_vendor.index.showToast({ title: e || "领取失败", icon: "none" });
      }
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.loading
  }, $data.loading ? {} : $data.coupons.length === 0 ? {} : {
    c: common_vendor.f($data.coupons, (coupon, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t(coupon.discountAmount),
        b: coupon.type === 2 && coupon.minAmount > 0
      }, coupon.type === 2 && coupon.minAmount > 0 ? {
        c: common_vendor.t(coupon.minAmount)
      } : coupon.type === 5 ? {
        e: common_vendor.t(coupon.nightStartTime || "?"),
        f: common_vendor.t(coupon.nightEndTime || "?")
      } : coupon.type === 3 || coupon.type === 4 ? {} : {}, {
        d: coupon.type === 5,
        g: coupon.type === 3 || coupon.type === 4,
        h: common_vendor.t(coupon.name),
        i: common_vendor.t($options.typeLabel(coupon.type)),
        j: coupon.claimStartTime
      }, coupon.claimStartTime ? {
        k: common_vendor.t(coupon.claimStartTime),
        l: common_vendor.t(coupon.claimEndTime)
      } : {}, {
        m: coupon.totalStock > 0
      }, coupon.totalStock > 0 ? {
        n: common_vendor.t(coupon.totalStock - (coupon.claimedCount || 0)),
        o: common_vendor.t(coupon.totalStock)
      } : {}, {
        p: coupon.claimed
      }, coupon.claimed ? {} : {}, {
        q: coupon.id,
        r: coupon.claimed ? 1 : "",
        s: common_vendor.o(($event) => !coupon.claimed && $options.claimCoupon(coupon), coupon.id)
      });
    })
  }, {
    b: $data.coupons.length === 0
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-31f84e9e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/center.js.map
