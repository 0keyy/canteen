"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const utils_tabbar = require("../../utils/tabbar.js");
const utils_image = require("../../utils/image.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      staticImgPrefix: utils_image.STATIC_IMAGE_PREFIX,
      pointsBalance: 0,
      activeTab: 1,
      activeCategory: 0,
      navTabs: ["积分规则", "积分明细", "兑换记录"],
      categories: ["全部", "积分秒杀", "堂食专享", "外卖专享"],
      products: [
        {
          id: 1,
          image: utils_image.STATIC_IMAGE_PREFIX + "/static/1.png",
          label: "可口可乐",
          title: "【堂食专享】可口可乐",
          points: 10,
          redeemed: 47
        },
        {
          id: 2,
          image: utils_image.STATIC_IMAGE_PREFIX + "/static/2.png",
          label: "薯条",
          title: "【堂食专享】香脆薯条",
          points: 20,
          redeemed: 32
        },
        {
          id: 3,
          image: utils_image.STATIC_IMAGE_PREFIX + "/static/3.png",
          label: "奶茶",
          title: "【外卖专享】珍珠奶茶",
          points: 30,
          redeemed: 58
        },
        {
          id: 4,
          image: utils_image.STATIC_IMAGE_PREFIX + "/static/4.png",
          label: "鸡翅",
          title: "【积分秒杀】香辣鸡翅",
          points: 50,
          redeemed: 19
        }
      ]
    };
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
    }
  },
  onShow() {
    this.navMetrics = utils_navbar.getNavMetrics();
    this.setupTabbar(2);
    this.loadPoints();
  },
  methods: {
    async loadPoints() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile && profile.points != null) {
          this.pointsBalance = profile.points;
        }
      } catch (e) {
      }
    },
    selectCategory(index) {
      this.activeCategory = index;
    },
    selectTab(index) {
      this.activeTab = index;
    },
    onScan() {
      common_vendor.index.showToast({ title: "扫码功能开发中", icon: "none" });
    },
    switchTabbar(item, index) {
      var _a, _b;
      const path = utils_tabbar.normalizeTabPath(((_a = item == null ? void 0 : item.link) == null ? void 0 : _a.path) || ((_b = item == null ? void 0 : item.link) == null ? void 0 : _b.url) || (item == null ? void 0 : item.pagePath));
      if (!path)
        return;
      if (this.tabbarSelected === index)
        return;
      common_vendor.index.switchTab({
        url: `/${path}`,
        fail: () => {
          common_vendor.index.reLaunch({ url: `/${path}` });
        }
      });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.t($data.pointsBalance),
    b: $data.staticImgPrefix + "/static/看书.png",
    c: common_vendor.o((...args) => $options.onScan && $options.onScan(...args)),
    d: common_vendor.s($options.heroPaddingStyle),
    e: common_vendor.f($data.navTabs, (tab, index, i0) => {
      return {
        a: common_vendor.t(tab),
        b: index,
        c: $data.activeTab === index ? 1 : "",
        d: common_vendor.o(($event) => $options.selectTab(index), index)
      };
    }),
    f: common_vendor.f($data.categories, (cat, index, i0) => {
      return {
        a: common_vendor.t(cat),
        b: index,
        c: $data.activeCategory === index ? 1 : "",
        d: common_vendor.o(($event) => $options.selectCategory(index), index)
      };
    }),
    g: common_vendor.f($data.products, (product, k0, i0) => {
      return {
        a: product.image,
        b: common_vendor.t(product.title),
        c: common_vendor.t(product.points),
        d: common_vendor.t(product.redeemed),
        e: product.id
      };
    }),
    h: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
      return {
        a: _ctx.tabbarSelected !== index ? 1 : "",
        b: _ctx.tabbarSelected === index ? item.selected : item.unselected,
        c: common_vendor.t(item.name),
        d: _ctx.tabbarSelected === index ? _ctx.tabbarSelectedColor : _ctx.tabbarDefaultColor,
        e: index,
        f: _ctx.tabbarSelected === index ? 1 : "",
        g: common_vendor.o(($event) => $options.switchTabbar(item, index), index)
      };
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-dd6e20da"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/points/index.js.map
