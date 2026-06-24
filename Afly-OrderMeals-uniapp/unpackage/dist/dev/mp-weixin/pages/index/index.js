"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_config = require("../../utils/config.js");
const utils_image = require("../../utils/image.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      menuButtonRight: 96,
      shop: null,
      aid: utils_config.DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      shortcuts: [
        { name: "充值中心", icon: "/static/tabbar/充值 1.png" },
        { name: "红包卡券", icon: "/static/tabbar/卡券 1.png" },
        { name: "订单详情", icon: "/static/tabbar/全部订单 1.png" },
        { name: "客服中心", icon: "/static/tabbar/客服 1.png" }
      ]
    };
  },
  computed: {
    nickname() {
      return common_vendor.index.getStorageSync("nickname") || "";
    },
    heroPaddingStyle() {
      const { statusBarHeight } = this.navMetrics;
      return { paddingTop: `${statusBarHeight + 8}px` };
    },
    homeRecommendDishes() {
      return this.recommendDishes.slice(0, 2);
    }
  },
  onLoad() {
    this.updateNavPadding();
  },
  onReady() {
    this.updateNavPadding();
  },
  onShow() {
    this.updateNavPadding();
    this.setupTabbar(0);
    this.loadPageContent();
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = utils_navbar.getNavMetrics();
      this.menuButtonRight = utils_navbar.getMenuButtonMarginRight(96);
    },
    async loadPageContent() {
      await this.loadShop();
      await this.loadDecoration();
      this.loadRecommend();
    },
    async loadShop() {
      try {
        const shop = await api_index.orderApi.shop(this.aid);
        if (shop == null ? void 0 : shop.image)
          shop.image = utils_image.resolveImageUrl(shop.image);
        this.shop = shop;
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      }
    },
    async loadDecoration() {
      var _a, _b;
      try {
        const page = await api_index.decorateApi.page(1);
        const widgets = this.parsePageWidgets(page == null ? void 0 : page.pageData);
        const bannerWidget = widgets.find((item) => item.name === "banner");
        const data = (_a = bannerWidget == null ? void 0 : bannerWidget.content) == null ? void 0 : _a.data;
        if (bannerWidget && this.isWidgetEnabled((_b = bannerWidget.content) == null ? void 0 : _b.enabled) && Array.isArray(data)) {
          this.banners = data.map((item) => this.normalizeBannerItem(item)).filter(Boolean);
        }
      } catch (e) {
        this.banners = [];
      }
    },
    parsePageWidgets(pageData) {
      if (!pageData)
        return [];
      if (Array.isArray(pageData))
        return pageData;
      try {
        const p = JSON.parse(pageData);
        return Array.isArray(p) ? p : [];
      } catch (e) {
        return [];
      }
    },
    isWidgetEnabled(enabled) {
      if (enabled === void 0 || enabled === null)
        return true;
      return enabled !== 0 && enabled !== false && enabled !== "0";
    },
    normalizeBannerItem(item) {
      const rawImage = (item == null ? void 0 : item.image) || (item == null ? void 0 : item.img) || (item == null ? void 0 : item.url) || "";
      const image = utils_image.resolveImageUrl(rawImage);
      return image ? { ...item, image } : null;
    },
    async loadRecommend() {
      this.recommendLoading = true;
      try {
        const list = await api_index.orderApi.menu(this.aid);
        const foods = [];
        (Array.isArray(list) ? list : []).forEach((cate) => {
          ;
          (cate.foods || []).forEach((food) => {
            foods.push({ ...food, image: utils_image.resolveImageUrl(food.image) });
          });
        });
        this.recommendDishes = foods.slice(0, 5);
      } catch (e) {
        this.recommendDishes = [];
      } finally {
        this.recommendLoading = false;
      }
    },
    selectMode(mode) {
      if (mode === 3 && this.shop && this.shop.deliveryEnable !== 1) {
        common_vendor.index.showToast({ title: "暂未开启外卖", icon: "none" });
        return;
      }
      common_vendor.index.setStorageSync("diningMode", mode);
      if (mode === 3) {
        common_vendor.index.navigateTo({ url: "/pages/address/list?select=1" });
        return;
      }
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    },
    goMenu() {
      common_vendor.index.setStorageSync("diningMode", 1);
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    },
    onShortcutTap(item) {
      if ((item == null ? void 0 : item.name) === "红包卡券") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/wallet" });
        return;
      }
      if ((item == null ? void 0 : item.name) === "订单详情") {
        common_vendor.index.switchTab({ url: "/pages/order/list" });
        return;
      }
      common_vendor.index.showToast({ title: "功能开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.t($options.nickname || "用户"),
    b: common_vendor.s($options.heroPaddingStyle),
    c: common_vendor.o(($event) => $options.selectMode(1), "36"),
    d: common_vendor.o(($event) => $options.selectMode(3), "46"),
    e: common_vendor.f($data.shortcuts, (item, k0, i0) => {
      return {
        a: item.icon,
        b: common_vendor.t(item.name),
        c: item.name,
        d: common_vendor.o(($event) => $options.onShortcutTap(item), item.name)
      };
    }),
    f: $options.homeRecommendDishes.length
  }, $options.homeRecommendDishes.length ? {
    g: common_vendor.f($options.homeRecommendDishes, (dish, k0, i0) => {
      return {
        a: dish.image,
        b: common_vendor.t(dish.title),
        c: common_vendor.t(dish.intro || "匠心制作，每日新鲜"),
        d: common_vendor.t(dish.price),
        e: common_vendor.o((...args) => $options.goMenu && $options.goMenu(...args), dish.id),
        f: dish.id,
        g: common_vendor.o((...args) => $options.goMenu && $options.goMenu(...args), dish.id)
      };
    })
  } : {}, {
    h: !$data.recommendLoading && $options.homeRecommendDishes.length === 0
  }, !$data.recommendLoading && $options.homeRecommendDishes.length === 0 ? {} : {}, {
    i: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-1cf27b2a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/index/index.js.map
