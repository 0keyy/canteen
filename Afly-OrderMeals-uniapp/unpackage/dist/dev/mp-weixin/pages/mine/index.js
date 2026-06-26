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
  { title: "公司认证", icon: "check", iconImg: "/static/tabbar/公司认证.png" },
  { title: "充值中心", icon: "wallet", iconImg: "/static/tabbar/充值 1.png" },
  { title: "积分商城", icon: "coins", iconImg: "/static/tabbar/积分商城.png" },
  { title: "集点有礼", icon: "star", iconImg: "/static/tabbar/签到 1.png" },
  { title: "优惠券包", icon: "ticket", iconImg: "/static/tabbar/卡券 1.png" },
  { title: "会员日", icon: "crown", iconImg: "/static/tabbar/名词 1.png" },
  { title: "退出登录", icon: "logout", iconImg: "/static/tabbar/退出 1.png" }
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
      balance: 0,
      couponCount: 0,
      pointCount: 0,
      // 新增积分变量
      primaryActions: PRIMARY_ACTIONS,
      secondaryActions: SECONDARY_ACTIONS,
      avatarKey: "",
      showAvatarPicker: false
    };
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
    },
    avatarSrc() {
      if (this.avatarKey)
        return `/static/${this.avatarKey}.png`;
      return "/static/1.png";
    }
  },
  onShow() {
    this.navMetrics = utils_navbar.getNavMetrics();
    this.setupTabbar(3);
    this.nickname = common_vendor.index.getStorageSync("nickname");
    this.mobile = common_vendor.index.getStorageSync("mobile");
    this.avatarKey = common_vendor.index.getStorageSync("avatarKey") || "1";
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
          this.balance = profile.balance != null ? profile.balance : 0;
          this.pointCount = profile.point ?? 0;
          common_vendor.index.setStorageSync("companyVerified", this.companyVerified);
          common_vendor.index.setStorageSync("companyDeptName", this.companyDeptName);
        }
      } catch (e) {
        this.companyVerified = !!common_vendor.index.getStorageSync("companyVerified");
        this.companyDeptName = common_vendor.index.getStorageSync("companyDeptName") || "";
      }
      try {
        const myCoupons = await api_index.couponApi.myCoupons(1) || [];
        this.couponCount = myCoupons.length;
      } catch (e) {
        this.couponCount = 0;
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
      if (item.title === "优惠券包") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/wallet" });
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
    selectAvatar(key) {
      this.avatarKey = key;
      common_vendor.index.setStorageSync("avatarKey", key);
      this.showAvatarPicker = false;
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
    a: $options.avatarSrc,
    b: common_vendor.o(($event) => $data.showAvatarPicker = true, "da"),
    c: common_vendor.t($data.nickname || "未登录用户"),
    d: $data.companyVerified
  }, $data.companyVerified ? {} : {}, {
    e: common_vendor.t($data.mobile || "请登录后查看"),
    f: $data.companyVerified && $data.companyDeptName
  }, $data.companyVerified && $data.companyDeptName ? {
    g: common_vendor.t($data.companyDeptName)
  } : {}, {
    h: common_vendor.o(($event) => $options.onFeatureTap("会员码"), "5f"),
    i: common_vendor.t($data.balance),
    j: common_vendor.t($data.pointCount),
    k: common_vendor.t($data.couponCount),
    l: common_vendor.s($options.heroPaddingStyle),
    m: common_vendor.f($data.primaryActions, (item, k0, i0) => {
      return {
        a: common_vendor.n(`profile-page__action-icon--${item.icon}`),
        b: common_vendor.t(item.title),
        c: item.title,
        d: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      };
    }),
    n: common_vendor.f($data.secondaryActions, (item, k0, i0) => {
      return common_vendor.e({
        a: item.iconImg
      }, item.iconImg ? {
        b: item.iconImg
      } : {
        c: common_vendor.n(`profile-page__action-icon--${item.icon}`)
      }, {
        d: common_vendor.t(item.title),
        e: item.title,
        f: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      });
    }),
    o: $data.showAvatarPicker
  }, $data.showAvatarPicker ? {
    p: $data.avatarKey === "1" ? 1 : "",
    q: common_vendor.o(($event) => $options.selectAvatar("1"), "f8"),
    r: $data.avatarKey === "2" ? 1 : "",
    s: common_vendor.o(($event) => $options.selectAvatar("2"), "b5"),
    t: common_vendor.o(($event) => $data.showAvatarPicker = false, "88"),
    v: common_vendor.o(() => {
    }, "92"),
    w: common_vendor.o(($event) => $data.showAvatarPicker = false, "aa")
  } : {}, {
    x: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
