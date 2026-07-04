"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const utils_image = require("../../utils/image.js");
const PRIMARY_ACTIONS = [
  { title: "待支付", icon: "orders" },
  { title: "待发货", icon: "address" },
  { title: "待收货", icon: "service" },
  { title: "退款售后", icon: "code" }
];
const SECONDARY_ACTIONS = [
  { title: "我的订单", icon: "check", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/公司认证.png" },
  { title: "地址管理", icon: "wallet", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/充值 1.png" },
  { title: "客服中心", icon: "coins", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/积分商城.png" },
  { title: "充值中心", icon: "ticket", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/卡券 1.png" },
  { title: "红包卡券", icon: "crown", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/名词 1.png" },
  { title: "签到中心", icon: "logout", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/退出 1.png" },
  { title: "积分抽奖", icon: "logout", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/退出 1.png" },
  { title: "安全退出", icon: "logout", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/退出 1.png" }
];
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      staticImgPrefix: utils_image.STATIC_IMAGE_PREFIX,
      navMetrics: utils_navbar.getNavMetrics(),
      nickname: "",
      mobile: "",
      companyVerified: false,
      companyDeptName: "",
      balance: 0,
      couponCount: 0,
      pointCount: 0,
      primaryActions: PRIMARY_ACTIONS,
      secondaryActions: SECONDARY_ACTIONS,
      avatarKey: "",
      showAvatarPicker: false,
      showServicePicker: false,
      servicePhones: [{ phone: "400-800-1234", name: "客服热线" }]
    };
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
    },
    avatarSrc() {
      if (this.avatarKey)
        return utils_image.STATIC_IMAGE_PREFIX + `/${this.avatarKey}.png`;
      return utils_image.STATIC_IMAGE_PREFIX + "/1.png";
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
          common_vendor.index.setStorageSync("balance", this.balance);
          common_vendor.index.setStorageSync("companyVerified", this.companyVerified);
          common_vendor.index.setStorageSync("companyDeptName", this.companyDeptName);
        }
      } catch (e) {
        this.balance = common_vendor.index.getStorageSync("balance") || 0;
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
      if (item.title === "联系客服") {
        this.callService();
        return;
      }
      if (item.title === "会员码") {
        common_vendor.index.navigateTo({ url: "/pages/mine/memberCode/index" });
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
      if (item.title === "充值中心") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/recharge" });
        return;
      }
      if (item.title === "积分商城") {
        common_vendor.index.navigateTo({ url: "/pages/integralShop/index" });
        return;
      }
      if (item.title === "会员日") {
        common_vendor.index.navigateTo({ url: "/pages/mine/memberDay/index" });
        return;
      }
      if (item.title === "退出登录") {
        this.logout();
        return;
      }
      this.onFeatureTap(item.title);
    },
    goOrderList() {
      common_vendor.index.navigateTo({ url: "/pages/order/list" });
    },
    goMemberCode() {
      common_vendor.index.navigateTo({ url: "/pages/mine/memberCode/index" });
    },
    onFeatureTap(title) {
      common_vendor.index.showToast({ title: `${title}功能开发中`, icon: "none" });
    },
    goProfile() {
      common_vendor.index.navigateTo({ url: "/pages/mine/profile" });
    },
    async callService() {
      try {
        const data = await api_index.serviceApi.hotline();
        if (data && Array.isArray(data.list) && data.list.length) {
          this.servicePhones = data.list;
        } else if (data && data.phone) {
          this.servicePhones = [{ phone: data.phone, name: data.name || "客服热线" }];
        }
      } catch (e) {
      }
      this.showServicePicker = true;
    },
    makeCall(phone) {
      if (!phone)
        return;
      this.showServicePicker = false;
      setTimeout(() => {
        common_vendor.index.makePhoneCall({
          phoneNumber: phone,
          fail: (err) => {
            if (err.errMsg && err.errMsg.includes("cancel"))
              return;
            common_vendor.index.showToast({ title: "拨打失败", icon: "none" });
          }
        });
      }, 200);
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
    a: $data.staticImgPrefix + "/白logo.png",
    b: $options.avatarSrc,
    c: common_vendor.o(($event) => $data.showAvatarPicker = true, "65"),
    d: common_vendor.t($data.nickname || "未登录用户"),
    e: $data.companyVerified
  }, $data.companyVerified ? {} : {}, {
    f: common_vendor.o((...args) => $options.goProfile && $options.goProfile(...args), "0c"),
    g: common_vendor.t($data.mobile || "请登录后查看"),
    h: $data.companyVerified && $data.companyDeptName
  }, $data.companyVerified && $data.companyDeptName ? {
    i: common_vendor.t($data.companyDeptName)
  } : {}, {
    j: common_vendor.o((...args) => $options.goMemberCode && $options.goMemberCode(...args), "70"),
    k: common_vendor.t($data.balance),
    l: common_vendor.t($data.pointCount),
    m: common_vendor.t($data.couponCount),
    n: common_vendor.s($options.heroPaddingStyle),
    o: common_vendor.o((...args) => $options.goOrderList && $options.goOrderList(...args), "a4"),
    p: common_vendor.f($data.primaryActions, (item, k0, i0) => {
      return {
        a: common_vendor.n(`profile-page__action-icon--${item.icon}`),
        b: common_vendor.t(item.title),
        c: item.title,
        d: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      };
    }),
    q: common_vendor.f($data.secondaryActions, (item, k0, i0) => {
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
    r: $data.showAvatarPicker
  }, $data.showAvatarPicker ? {
    s: $data.staticImgPrefix + "/1.png",
    t: $data.avatarKey === "1" ? 1 : "",
    v: common_vendor.o(($event) => $options.selectAvatar("1"), "58"),
    w: $data.staticImgPrefix + "/2.png",
    x: $data.avatarKey === "2" ? 1 : "",
    y: common_vendor.o(($event) => $options.selectAvatar("2"), "5f"),
    z: common_vendor.o(($event) => $data.showAvatarPicker = false, "85"),
    A: common_vendor.o(() => {
    }, "d0"),
    B: common_vendor.o(($event) => $data.showAvatarPicker = false, "62")
  } : {}, {
    C: $data.showServicePicker
  }, $data.showServicePicker ? {
    D: common_vendor.f($data.servicePhones, (item, index, i0) => {
      return {
        a: common_vendor.t(item.name || "客服热线"),
        b: common_vendor.t(item.phone),
        c: index,
        d: common_vendor.o(($event) => $options.makeCall(item.phone), index)
      };
    }),
    E: common_vendor.o(($event) => $data.showServicePicker = false, "7f"),
    F: common_vendor.o(() => {
    }, "ed"),
    G: common_vendor.o(($event) => $data.showServicePicker = false, "a5")
  } : {}, {
    H: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
