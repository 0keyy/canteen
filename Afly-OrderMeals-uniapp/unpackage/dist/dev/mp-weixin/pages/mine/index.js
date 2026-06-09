"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const mixins_navPage = require("../../mixins/nav-page.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin, mixins_navPage.navPageMixin],
  data() {
    return {
      nickname: "",
      mobile: ""
    };
  },
  computed: {
    headerPaddingStyle() {
      return {
        paddingTop: `${this.navMetrics.statusBarHeight}px`
      };
    },
    navRowStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` };
    }
  },
  onShow() {
    this.updateNavMetrics();
    this.setupTabbar(2);
    this.nickname = common_vendor.index.getStorageSync("nickname");
    this.mobile = common_vendor.index.getStorageSync("mobile");
  },
  methods: {
    goOrders() {
      common_vendor.index.switchTab({ url: "/pages/order/list" });
    },
    goAddress() {
      common_vendor.index.navigateTo({ url: "/pages/address/list" });
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
    a: common_vendor.s($options.navRowStyle),
    b: common_vendor.t($data.nickname || "未登录用户"),
    c: common_vendor.t($data.mobile || "请登录后查看"),
    d: common_vendor.s($options.headerPaddingStyle),
    e: common_vendor.o((...args) => $options.goOrders && $options.goOrders(...args), "28"),
    f: common_vendor.o((...args) => $options.goAddress && $options.goAddress(...args), "5e"),
    g: common_vendor.o((...args) => $options.logout && $options.logout(...args), "75"),
    h: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
      return common_vendor.e({
        a: item.selected || item.unselected
      }, item.selected || item.unselected ? {
        b: _ctx.tabbarSelected === index ? item.selected : item.unselected
      } : {}, {
        c: common_vendor.t(item.name),
        d: _ctx.tabbarSelected === index ? _ctx.tabbarSelectedColor : _ctx.tabbarDefaultColor,
        e: index,
        f: common_vendor.o(($event) => _ctx.switchTabbar(item, index), index)
      });
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-569e925a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/mine/index.js.map
