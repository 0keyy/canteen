"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const common_assets = require("../../common/assets.js");
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
        const coupons = await api_index.couponApi.center() || [];
        const myCoupons1 = await api_index.couponApi.myCoupons(1) || [];
        const myCoupons2 = await api_index.couponApi.myCoupons(2) || [];
        const myCoupons3 = await api_index.couponApi.myCoupons(3) || [];
        const allMyCoupons = [...myCoupons1, ...myCoupons2, ...myCoupons3];
        this.coupons = coupons;
        common_vendor.index.__f__("log", "at pages/coupon/center.vue:96", "=== 领券中心数据 ===", JSON.stringify(coupons));
        common_vendor.index.__f__("log", "at pages/coupon/center.vue:97", "=== 用户已领券数据 ===", JSON.stringify(allMyCoupons));
        const myCouponTemplateIds = /* @__PURE__ */ new Set();
        allMyCoupons.forEach((c) => {
          if (c.templateId)
            myCouponTemplateIds.add(String(c.templateId));
          if (c.couponTemplateId)
            myCouponTemplateIds.add(String(c.couponTemplateId));
        });
        const claimed = common_vendor.index.getStorageSync("claimedCoupons") || {};
        common_vendor.index.__f__("log", "at pages/coupon/center.vue:106", "=== 本地已领记录 ===", JSON.stringify(claimed));
        this.coupons.forEach((c) => {
          const centerCouponId = String(c.id);
          const centerTemplateId = String(c.templateId || c.id);
          const isClaimed = c.claimed || c.status === 1 || !!claimed[centerCouponId] || !!claimed[centerTemplateId] || myCouponTemplateIds.has(centerCouponId) || myCouponTemplateIds.has(centerTemplateId);
          c.claimed = isClaimed;
          common_vendor.index.__f__("log", "at pages/coupon/center.vue:119", `=== 券 ${c.name}: id=${c.id}, templateId=${c.templateId}, claimed=${isClaimed}, status=${c.status} ===`);
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
        if (coupon.templateId) {
          claimed[coupon.templateId] = true;
        }
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
    a: common_assets._imports_0$7,
    b: $data.loading
  }, $data.loading ? {} : $data.coupons.length === 0 ? {} : {
    d: common_vendor.f($data.coupons, (coupon, k0, i0) => {
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
    c: $data.coupons.length === 0
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-31f84e9e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/center.js.map
