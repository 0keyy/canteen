"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      nickname: "",
      mobile: "",
      companyVerified: false,
      balance: 0,
      couponCount: 0
    };
  },
  computed: {
    headerPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
    }
  },
  onShow() {
    this.navMetrics = utils_navbar.getNavMetrics();
    this.setupTabbar(3);
    this.nickname = common_vendor.index.getStorageSync("nickname");
    this.mobile = common_vendor.index.getStorageSync("mobile");
    this.loadProfile();
  },
  methods: {
    goProfile() {
      common_vendor.index.navigateTo({ url: "/pages/mine/profile" });
    },
    async loadProfile() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile) {
          this.nickname = profile.nickname || this.nickname;
          this.mobile = profile.mobile || this.mobile;
          this.companyVerified = !!profile.companyVerified;
          this.balance = profile.balance != null ? profile.balance : 0;
          common_vendor.index.setStorageSync("companyVerified", this.companyVerified);
        }
      } catch (e) {
        this.companyVerified = !!common_vendor.index.getStorageSync("companyVerified");
      }
      try {
        const myCoupons = await api_index.couponApi.myCoupons(1) || [];
        this.couponCount = myCoupons.length;
      } catch (e) {
        this.couponCount = 0;
      }
    },
    onViewAllOrders() {
      common_vendor.index.switchTab({ url: "/pages/order/list" });
    },
    onOrderTap(status) {
      common_vendor.index.switchTab({ url: "/pages/order/list" });
    },
    onStatTap(type) {
      if (type === "coupon") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/wallet" });
      }
    },
    onFeatureItemTap(name) {
      if (name === "我的订单") {
        common_vendor.index.switchTab({ url: "/pages/order/list" });
        return;
      }
      if (name === "地址管理") {
        common_vendor.index.navigateTo({ url: "/pages/address/list" });
        return;
      }
      if (name === "红包卡券") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/wallet" });
        return;
      }
      if (name === "安全退出") {
        this.logout();
        return;
      }
      common_vendor.index.showToast({ title: "功能开发中", icon: "none" });
    },
    async logout() {
      try {
        await api_index.authApi.logout();
      } catch (e) {
      }
      common_vendor.index.clearStorageSync();
      common_vendor.index.reLaunch({ url: "/pages/login/index" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.t($data.nickname || "未登录用户"),
    b: common_vendor.o((...args) => $options.goProfile && $options.goProfile(...args), "50"),
    c: common_vendor.s($options.headerPaddingStyle),
    d: common_vendor.t($data.balance),
    e: common_vendor.o(($event) => $options.onStatTap("balance"), "49"),
    f: common_vendor.o(($event) => $options.onStatTap("points"), "73"),
    g: common_vendor.t($data.couponCount),
    h: common_vendor.o(($event) => $options.onStatTap("coupon"), "c5"),
    i: common_vendor.o((...args) => $options.onViewAllOrders && $options.onViewAllOrders(...args), "c7"),
    j: common_vendor.o(($event) => $options.onOrderTap("待支付"), "18"),
    k: common_vendor.o(($event) => $options.onOrderTap("待发货"), "b4"),
    l: common_vendor.o(($event) => $options.onOrderTap("待收货"), "ff"),
    m: common_vendor.o(($event) => $options.onOrderTap("退款售后"), "4c"),
    n: common_vendor.o(($event) => $options.onFeatureItemTap("我的订单"), "4a"),
    o: common_vendor.o(($event) => $options.onFeatureItemTap("地址管理"), "c5"),
    p: common_vendor.o(($event) => $options.onFeatureItemTap("客服中心"), "74"),
    q: common_vendor.o(($event) => $options.onFeatureItemTap("充值中心"), "d2"),
    r: common_vendor.o(($event) => $options.onFeatureItemTap("红包卡券"), "c2"),
    s: common_vendor.o(($event) => $options.onFeatureItemTap("签到中心"), "28"),
    t: common_vendor.o(($event) => $options.onFeatureItemTap("积分抽奖"), "ec"),
    v: common_vendor.o(($event) => $options.onFeatureItemTap("安全退出"), "37"),
    w: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
      return {
        a: _ctx.tabbarSelected !== index ? 1 : "",
        b: _ctx.tabbarSelected === index ? item.selected : item.unselected,
        c: common_vendor.t(item.name),
        d: _ctx.tabbarSelected === index ? _ctx.tabbarSelectedColor : _ctx.tabbarDefaultColor,
        e: index,
        f: _ctx.tabbarSelected === index ? 1 : "",
        g: common_vendor.o(($event) => _ctx.switchTabbar(item, index), index)
      };
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-569e925a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/mine/index.js.map
