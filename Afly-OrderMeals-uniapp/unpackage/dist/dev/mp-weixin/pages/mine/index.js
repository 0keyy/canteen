"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const PRIMARY_ACTIONS = [
  { title: "我的订单", icon: "orders" },
  { title: "地址管理", icon: "address" },
  { title: "联系客服", icon: "service" },
  { title: "会员码", icon: "code" }
];
const SECONDARY_ACTIONS = [
  { title: "公司认证", icon: "check" },
  { title: "充值中心", icon: "wallet" },
  { title: "积分商城", icon: "coins" },
  { title: "集点有礼", icon: "star" },
  { title: "优惠券包", icon: "ticket" },
  { title: "会员日", icon: "crown" },
  { title: "退出登录", icon: "logout" }
];
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      nickname: "",
      mobile: "",
      companyVerified: false,
      companyDeptName: "",
      primaryActions: PRIMARY_ACTIONS,
      secondaryActions: SECONDARY_ACTIONS
    };
  },
  computed: {
    heroPaddingStyle() {
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
    async loadProfile() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile) {
          this.nickname = profile.nickname || this.nickname;
          this.mobile = profile.mobile || this.mobile;
          this.companyVerified = !!profile.companyVerified;
          this.companyDeptName = profile.companyDeptName || "";
          common_vendor.index.setStorageSync("companyVerified", this.companyVerified);
          common_vendor.index.setStorageSync("companyDeptName", this.companyDeptName);
        }
      } catch (e) {
        this.companyVerified = !!common_vendor.index.getStorageSync("companyVerified");
        this.companyDeptName = common_vendor.index.getStorageSync("companyDeptName") || "";
      }
    },
    onActionTap(item) {
      if (item.title === "我的订单") {
        common_vendor.index.switchTab({ url: "/pages/order/list" });
        return;
      }
      if (item.title === "地址管理") {
        common_vendor.index.navigateTo({ url: "/pages/address/list" });
        return;
      }
      if (item.title === "公司认证") {
        common_vendor.index.navigateTo({ url: "/pages/mine/company-auth" });
        return;
      }
      if (item.title === "退出登录") {
        this.logout();
        return;
      }
      this.onFeatureTap(item.title);
    },
    onFeatureTap(title) {
      common_vendor.index.showToast({ title: `${title}功能开发中`, icon: "none" });
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
  return common_vendor.e({
    a: common_vendor.t($data.nickname || "未登录用户"),
    b: $data.companyVerified
  }, $data.companyVerified ? {} : {}, {
    c: common_vendor.t($data.mobile || "请登录后查看"),
    d: $data.companyVerified && $data.companyDeptName
  }, $data.companyVerified && $data.companyDeptName ? {
    e: common_vendor.t($data.companyDeptName)
  } : {}, {
    f: common_vendor.o(($event) => $options.onFeatureTap("会员码"), "e1"),
    g: common_vendor.s($options.heroPaddingStyle),
    h: common_vendor.f($data.primaryActions, (item, k0, i0) => {
      return {
        a: common_vendor.n(`profile-page__action-icon--${item.icon}`),
        b: common_vendor.t(item.title),
        c: item.title,
        d: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      };
    }),
    i: common_vendor.f($data.secondaryActions, (item, k0, i0) => {
      return {
        a: common_vendor.n(`profile-page__action-icon--${item.icon}`),
        b: common_vendor.t(item.title),
        c: item.title,
        d: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      };
    }),
    j: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
      return {
        a: _ctx.tabbarSelected === index ? item.selected : item.unselected,
        b: common_vendor.t(item.name),
        c: _ctx.tabbarSelected === index ? _ctx.tabbarSelectedColor : _ctx.tabbarDefaultColor,
        d: index,
        e: _ctx.tabbarSelected === index ? 1 : "",
        f: common_vendor.o(($event) => _ctx.switchTabbar(item, index), index)
      };
    })
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-569e925a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/mine/index.js.map
