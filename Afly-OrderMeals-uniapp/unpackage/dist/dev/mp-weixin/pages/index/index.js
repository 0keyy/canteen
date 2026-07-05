"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_config = require("../../utils/config.js");
const utils_image = require("../../utils/image.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const common_assets = require("../../common/assets.js");
const PageLoading = () => "../../components/page-loading/page-loading.js";
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  components: { PageLoading },
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      menuButtonRight: 96,
      shop: null,
      aid: utils_config.DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      pageLoading: false,
      pageLoadingTip: "",
      nickname: "",
      pointCount: 0,
      couponCount: 0,
      shortcuts: [
        { name: "充值中心", desc: "", iconPath: "/static/充值中心.png" },
        { name: "红包卡券", desc: "", iconPath: "/static/红包卡券.png" },
        { name: "订单详情", desc: "", iconPath: "/static/订单详情.png" },
        { name: "客服中心", desc: "", iconPath: "/static/客服中心.png" }
      ]
    };
  },
  computed: {
    heroPaddingStyle() {
      const { statusBarHeight } = this.navMetrics;
      return {
        paddingTop: `${statusBarHeight - 55}px`
      };
    },
    searchRowStyle() {
      return { paddingRight: `${this.menuButtonRight}px` };
    },
    displayBanners() {
      if (this.banners.length)
        return this.banners;
      return [{ image: "" }];
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
      this.pageLoading = true;
      this.pageLoadingTip = "加载中...";
      try {
        await this.loadShop();
        await this.loadDecoration();
        await this.loadRecommend();
        await this.loadUserInfo();
      } finally {
        this.pageLoading = false;
      }
    },
    async loadUserInfo() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile) {
          this.nickname = profile.nickname || common_vendor.index.getStorageSync("nickname") || "";
          this.pointCount = profile.point ?? 0;
          common_vendor.index.setStorageSync("nickname", this.nickname);
        } else {
          this.nickname = common_vendor.index.getStorageSync("nickname") || "";
          this.pointCount = parseInt(common_vendor.index.getStorageSync("pointCount")) || 0;
        }
      } catch (e) {
        this.nickname = common_vendor.index.getStorageSync("nickname") || "";
        this.pointCount = parseInt(common_vendor.index.getStorageSync("pointCount")) || 0;
      }
      try {
        const myCoupons = await api_index.couponApi.myCoupons(1) || [];
        this.couponCount = myCoupons.length;
      } catch (e) {
        this.couponCount = 0;
      }
    },
    parsePageWidgets(pageData) {
      if (!pageData)
        return [];
      if (Array.isArray(pageData))
        return pageData;
      try {
        const parsed = JSON.parse(pageData);
        return Array.isArray(parsed) ? parsed : [];
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
    async loadShop() {
      try {
        const shop = await api_index.orderApi.shop(this.aid);
        if (shop == null ? void 0 : shop.image) {
          shop.image = utils_image.resolveImageUrl(shop.image);
        }
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
        } else {
          this.banners = [];
        }
      } catch (e) {
        this.banners = [];
      }
    },
    async loadRecommend() {
      this.recommendLoading = true;
      try {
        const list = await api_index.orderApi.menu(this.aid);
        const foods = [];
        (Array.isArray(list) ? list : []).forEach((cate) => {
          ;
          (cate.foods || []).forEach((food) => {
            foods.push({
              ...food,
              image: utils_image.resolveImageUrl(food.image)
            });
          });
        });
        this.recommendDishes = foods.slice(0, 5).map((food, index) => ({
          ...food,
          badge: index === 0 ? "招牌" : index === 1 ? "热卖" : ""
        }));
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
    selectSpec() {
      this.goMenu();
    },
    goSearch() {
      common_vendor.index.showToast({ title: "搜索功能开发中", icon: "none" });
    },
    onShortcutTap(item) {
      if ((item == null ? void 0 : item.name) === "充值中心") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/recharge" });
        return;
      }
      if ((item == null ? void 0 : item.name) === "红包卡券") {
        common_vendor.index.navigateTo({ url: "/pages/coupon/center" });
        return;
      }
      if ((item == null ? void 0 : item.name) === "订单详情") {
        common_vendor.index.navigateTo({ url: "/pages/order/list" });
        return;
      }
      if ((item == null ? void 0 : item.name) === "客服中心") {
        common_vendor.index.showToast({ title: "客服中心开发中", icon: "none" });
        return;
      }
      common_vendor.index.showToast({ title: "功能开发中", icon: "none" });
    },
    goCouponCenter() {
      common_vendor.index.navigateTo({ url: "/pages/coupon/center" });
    },
    goMine() {
      common_vendor.index.switchTab({ url: "/pages/mine/index" });
    },
    goIntegralShop() {
      common_vendor.index.switchTab({ url: "/pages/points/index" });
    },
    goCouponWallet() {
      common_vendor.index.navigateTo({ url: "/pages/coupon/wallet" });
    }
  }
};
if (!Array) {
  const _easycom_page_loading2 = common_vendor.resolveComponent("page-loading");
  _easycom_page_loading2();
}
const _easycom_page_loading = () => "../../components/page-loading/page-loading.js";
if (!Math) {
  _easycom_page_loading();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.t($data.nickname || "用户123"),
    b: common_vendor.o((...args) => $options.goMine && $options.goMine(...args), "3f"),
    c: common_vendor.t($data.pointCount),
    d: common_vendor.o((...args) => $options.goIntegralShop && $options.goIntegralShop(...args), "56"),
    e: common_vendor.t($data.couponCount),
    f: common_vendor.o((...args) => $options.goCouponWallet && $options.goCouponWallet(...args), "7b"),
    g: common_vendor.f($options.displayBanners, (item, index, i0) => {
      return common_vendor.e({
        a: item.image
      }, item.image ? {
        b: item.image
      } : {}, {
        c: index
      });
    }),
    h: $options.displayBanners.length > 1,
    i: $options.displayBanners.length > 0,
    j: common_vendor.s($options.heroPaddingStyle),
    k: common_assets._imports_0,
    l: common_vendor.o(($event) => $options.selectMode(1), "29"),
    m: common_assets._imports_1,
    n: $data.shop && $data.shop.deliveryEnable !== 1 ? 1 : "",
    o: common_vendor.o(($event) => $options.selectMode(3), "35"),
    p: common_vendor.f($data.shortcuts, (item, k0, i0) => {
      return {
        a: item.iconPath,
        b: common_vendor.t(item.name),
        c: item.name,
        d: common_vendor.o(($event) => $options.onShortcutTap(item), item.name)
      };
    }),
    q: common_vendor.o((...args) => $options.goMenu && $options.goMenu(...args), "80"),
    r: $options.homeRecommendDishes.length
  }, $options.homeRecommendDishes.length ? {
    s: common_vendor.f($options.homeRecommendDishes, (dish, k0, i0) => {
      return common_vendor.e({
        a: dish.image,
        b: dish.badge
      }, dish.badge ? {
        c: common_vendor.t(dish.badge)
      } : {}, {
        d: common_vendor.t(dish.title),
        e: common_vendor.t(dish.intro || "匠心制作，每日新鲜"),
        f: common_vendor.t(dish.price),
        g: common_vendor.o(($event) => $options.selectSpec(dish), dish.id),
        h: dish.id,
        i: common_vendor.o(($event) => $options.selectSpec(dish), dish.id)
      });
    })
  } : {}, {
    t: !$data.recommendLoading && $options.homeRecommendDishes.length === 0
  }, !$data.recommendLoading && $options.homeRecommendDishes.length === 0 ? {} : {}, {
    v: common_vendor.p({
      visible: $data.pageLoading,
      tip: $data.pageLoadingTip
    }),
    w: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-1cf27b2a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/index/index.js.map
