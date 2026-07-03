"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const utils_image = require("../../utils/image.js");
const PRIMARY_ACTIONS = [
  { title: "我的订单", icon: "orders" },
  { title: "地址管理", icon: "address" },
  { title: "联系客服", icon: "service" },
  { title: "会员码", icon: "code" }
];
const SECONDARY_ACTIONS = [
  { title: "公司认证", icon: "check", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/公司认证.png" },
  { title: "充值中心", icon: "wallet", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/充值 1.png" },
  { title: "积分商城", icon: "coins", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/积分商城.png" },
  { title: "优惠券包", icon: "ticket", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/卡券 1.png" },
  { title: "会员日", icon: "crown", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/名词 1.png" },
  { title: "退出登录", icon: "logout", iconImg: utils_image.STATIC_IMAGE_PREFIX + "/tabbar/退出 1.png" }
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
    onFeatureTap(title) {
      if (title === "会员码") {
        common_vendor.index.navigateTo({ url: "/pages/mine/memberCode/index" });
        return;
      }
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
    a: $options.avatarSrc,
    b: common_vendor.o(($event) => $data.showAvatarPicker = true, "da"),
    c: common_vendor.t($data.nickname || "未登录用户"),
    d: $data.companyVerified
  }, $data.companyVerified ? {} : {}, {
    e: common_vendor.o((...args) => $options.goProfile && $options.goProfile(...args), "2b"),
    f: common_vendor.t($data.mobile || "请登录后查看"),
    g: $data.companyVerified && $data.companyDeptName
  }, $data.companyVerified && $data.companyDeptName ? {
    h: common_vendor.t($data.companyDeptName)
  } : {}, {
    i: $data.staticImgPrefix + "/tabbar/二维码图标.png",
    j: common_vendor.o(($event) => $options.onFeatureTap("会员码"), "01"),
    k: common_vendor.t($data.balance),
    l: common_vendor.t($data.pointCount),
    m: common_vendor.t($data.couponCount),
    n: common_vendor.s($options.heroPaddingStyle),
    o: common_vendor.f($data.primaryActions, (item, k0, i0) => {
      return {
        a: common_vendor.n(`profile-page__action-icon--${item.icon}`),
        b: common_vendor.t(item.title),
        c: item.title,
        d: common_vendor.o(($event) => $options.onActionTap(item), item.title)
      };
    }),
    p: common_vendor.f($data.secondaryActions, (item, k0, i0) => {
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
    q: $data.showAvatarPicker
  }, $data.showAvatarPicker ? {
    r: $data.staticImgPrefix + "/1.png",
    s: $data.avatarKey === "1" ? 1 : "",
    t: common_vendor.o(($event) => $options.selectAvatar("1"), "2f"),
    v: $data.staticImgPrefix + "/2.png",
    w: $data.avatarKey === "2" ? 1 : "",
    x: common_vendor.o(($event) => $options.selectAvatar("2"), "4a"),
    y: common_vendor.o(($event) => $data.showAvatarPicker = false, "07"),
    z: common_vendor.o(() => {
    }, "2f"),
    A: common_vendor.o(($event) => $data.showAvatarPicker = false, "c1")
  } : {}, {
    B: $data.showServicePicker
  }, $data.showServicePicker ? {
    C: common_vendor.f($data.servicePhones, (item, index, i0) => {
      return {
        a: common_vendor.t(item.name || "客服热线"),
        b: common_vendor.t(item.phone),
        c: index,
        d: common_vendor.o(($event) => $options.makeCall(item.phone), index)
      };
    }),
    D: common_vendor.o(($event) => $data.showServicePicker = false, "1c"),
    E: common_vendor.o(() => {
    }, "bc"),
    F: common_vendor.o(($event) => $data.showServicePicker = false, "03")
  } : {}, {
    G: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
