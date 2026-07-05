"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_config = require("../../utils/config.js");
const utils_image = require("../../utils/image.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const PageLoading = () => "../../components/page-loading/page-loading.js";
const MenuCategorySidebar = () => "../../components/menu-category-sidebar/menu-category-sidebar.js";
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  components: { PageLoading, MenuCategorySidebar },
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics(),
      menuButtonRight: 96,
      aid: utils_config.DEFAULT_SHOP_ID,
      shop: null,
      diningMode: 1,
      orderId: 0,
      menu: [],
      activeIndex: 0,
      cartMap: {},
      loading: true,
      pageLoading: false,
      pageLoadingTip: "",
      cartReady: false,
      cartBusy: false,
      cartInitPromise: null,
      banners: []
    };
  },
  computed: {
    headerPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
    },
    searchRowStyle() {
      return { paddingRight: `${this.menuButtonRight}px` };
    },
    shopName() {
      var _a;
      return ((_a = this.shop) == null ? void 0 : _a.name) || "粮兴坊";
    },
    distanceText() {
      var _a;
      if ((_a = this.shop) == null ? void 0 : _a.distance)
        return `距离您${this.shop.distance}km`;
      return "欢迎到店用餐";
    },
    currentFoods() {
      var _a;
      return ((_a = this.menu[this.activeIndex]) == null ? void 0 : _a.foods) || [];
    },
    currentCategoryName() {
      var _a;
      return ((_a = this.menu[this.activeIndex]) == null ? void 0 : _a.name) || "推荐";
    },
    displayBanners() {
      if (this.banners.length)
        return this.banners;
      return [{ image: "/static/首页广告.png" }];
    },
    totalPrice() {
      let total = 0;
      Object.values(this.cartMap).forEach((item) => {
        total += Number(item.price) * item.count;
      });
      return total.toFixed(2);
    },
    cartItemCount() {
      return Object.values(this.cartMap).reduce((sum, item) => sum + item.count, 0);
    },
    cartSummary() {
      if (!this.cartReady)
        return "¥0.00";
      if (this.cartItemCount === 0)
        return "¥0.00";
      return `¥ ${this.totalPrice}`;
    }
  },
  onLoad() {
    this.diningMode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    this.updateNavPadding();
    this.loadShop();
    this.loadBanners();
    this.bootstrap();
  },
  onShow() {
    this.updateNavPadding();
    this.setupTabbar(1);
    const mode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    if (mode !== this.diningMode) {
      this.diningMode = mode;
      this.bootstrap();
      return;
    }
    if (!this.loading && !this.cartBusy) {
      this.refreshCartState();
    }
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = utils_navbar.getNavMetrics();
      this.menuButtonRight = utils_navbar.getMenuButtonMarginRight(96);
    },
    selectCategory(index) {
      this.activeIndex = index;
    },
    goSearch() {
      common_vendor.index.showToast({ title: "搜索功能开发中", icon: "none" });
    },
    toggleMode() {
      const next = this.diningMode === 3 ? 1 : 3;
      this.switchMode(next);
    },
    async switchMode(mode) {
      if (mode === this.diningMode)
        return;
      if (mode === 3 && this.shop && this.shop.deliveryEnable !== 1) {
        common_vendor.index.showToast({ title: "暂未开启外卖", icon: "none" });
        return;
      }
      common_vendor.index.setStorageSync("diningMode", mode);
      this.diningMode = mode;
      if (mode === 3) {
        common_vendor.index.navigateTo({ url: "/pages/address/list?select=1" });
        return;
      }
      await this.bootstrap();
    },
    async loadShop() {
      try {
        this.shop = await api_index.orderApi.shop(this.aid);
      } catch (e) {
        this.shop = null;
      }
    },
    async loadBanners() {
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
    foodTag(index) {
      const tags = ["热销", "新品", "特价"];
      return index < 3 ? tags[index] : "";
    },
    dishKey(dishId) {
      return String(dishId);
    },
    getCount(dishId) {
      var _a;
      return ((_a = this.cartMap[this.dishKey(dishId)]) == null ? void 0 : _a.count) || 0;
    },
    findFood(dishId) {
      const targetId = Number(dishId);
      for (const cate of this.menu) {
        const food = cate.foods.find((f) => Number(f.id) === targetId);
        if (food)
          return food;
      }
      return null;
    },
    setCartMap(map) {
      this.cartMap = { ...map };
    },
    parseCartHasId(has) {
      if (!has)
        return null;
      const id = has.oid ? Number(has.oid) : has.id ? Number(has.id) : null;
      return id || null;
    },
    isCartHasSubmitted(has) {
      if (!has)
        return false;
      return !!(has.submitTime || has.status !== void 0 && Number(has.status) > 0);
    },
    parseCartHasItems(has) {
      if (!has)
        return [];
      return has.dish || has.dishes || [];
    },
    async bootstrap() {
      this.pageLoading = true;
      this.pageLoadingTip = "加载中...";
      this.loading = true;
      this.cartReady = false;
      try {
        await this.loadMenu();
        await this.initCart();
      } catch (e) {
        this.cartReady = false;
        common_vendor.index.__f__("error", "at pages/menu/index.vue:361", "菜单页加载失败:", e);
        common_vendor.index.showToast({ title: e.message || e || "页面加载失败", icon: "none", duration: 3e3 });
      } finally {
        this.loading = false;
        this.pageLoading = false;
      }
    },
    async loadMenu() {
      const list = await api_index.orderApi.menu(this.aid);
      this.menu = (Array.isArray(list) ? list : []).map((cate) => ({
        ...cate,
        foods: (cate.foods || []).map((food) => ({
          ...food,
          image: utils_image.resolveImageUrl(food.image)
        }))
      }));
      this.activeIndex = 0;
    },
    async initOrder() {
      const has = await api_index.orderApi.cartHas(this.aid);
      const existingId = this.parseCartHasId(has);
      const existingMode = (has == null ? void 0 : has.diningMode) !== void 0 ? Number(has.diningMode) : null;
      const isSubmitted = this.isCartHasSubmitted(has);
      if (existingId && existingMode === this.diningMode && !isSubmitted) {
        this.orderId = existingId;
        return;
      }
      const orderId = await api_index.orderApi.cartCreate({
        aid: this.aid,
        diningMode: this.diningMode,
        deskId: this.diningMode === 1 ? 1 : 0,
        userNum: 1,
        source: 2
      });
      this.orderId = Number(orderId);
      if (!this.orderId) {
        throw new Error("购物车创建失败");
      }
    },
    async initCart() {
      if (this.cartInitPromise) {
        await this.cartInitPromise;
        return;
      }
      this.cartInitPromise = (async () => {
        await this.initOrder();
        await this.syncCart();
        this.cartReady = !!this.orderId;
      })();
      try {
        await this.cartInitPromise;
      } finally {
        this.cartInitPromise = null;
      }
    },
    async refreshCartState() {
      if (this.cartInitPromise) {
        await this.cartInitPromise;
        return;
      }
      try {
        const has = await api_index.orderApi.cartHas(this.aid);
        const activeCartId = this.parseCartHasId(has);
        const isSubmitted = this.isCartHasSubmitted(has);
        const validCartId = activeCartId && !isSubmitted ? activeCartId : null;
        if (!validCartId) {
          if (this.orderId) {
            this.orderId = 0;
            this.setCartMap({});
          }
          await this.initCart();
          return;
        }
        if (this.orderId !== validCartId) {
          this.orderId = validCartId;
        }
        await this.syncCart();
        this.cartReady = true;
      } catch (e) {
        common_vendor.index.__f__("error", "at pages/menu/index.vue:442", "购物车刷新失败:", e);
      }
    },
    async ensureCart() {
      if (this.cartInitPromise) {
        await this.cartInitPromise;
      }
      if (!this.cartReady || !this.orderId) {
        await this.initCart();
      }
      if (!this.orderId) {
        throw new Error("购物车未就绪");
      }
      return this.orderId;
    },
    async syncCart() {
      if (!this.orderId) {
        this.setCartMap({});
        return;
      }
      const has = await api_index.orderApi.cartHas(this.aid);
      const hasId = this.parseCartHasId(has);
      if (!hasId || hasId !== this.orderId || this.isCartHasSubmitted(has)) {
        this.setCartMap({});
        return;
      }
      const items = this.parseCartHasItems(has);
      const map = {};
      items.forEach((item) => {
        const dishId = Number(item.dishId);
        const food = this.findFood(dishId);
        const key = this.dishKey(dishId);
        const count = Number(item.count || item.quantity) || 0;
        const existing = map[key];
        if (existing) {
          existing.count += count;
          return;
        }
        map[key] = {
          odid: Number(item.id),
          dishId,
          count,
          price: (food == null ? void 0 : food.price) || 0
        };
      });
      this.setCartMap(map);
    },
    async addFood(food, _isRetry = false) {
      if (this.cartBusy || !this.cartReady)
        return;
      this.cartBusy = true;
      try {
        await this.ensureCart();
        const dishId = Number(food.id);
        const key = this.dishKey(dishId);
        const current = this.cartMap[key];
        if (!current) {
          await api_index.orderApi.dishAdd(this.orderId, dishId);
        } else {
          await api_index.orderApi.dishInc(current.odid);
        }
        await this.syncCart();
      } catch (e) {
        const errMsg = e.message || String(e) || "";
        if (!_isRetry && (errMsg.includes("不可用") || errMsg.includes("购物车"))) {
          this.orderId = 0;
          this.cartReady = false;
          this.cartBusy = false;
          return this.addFood(food, true);
        }
        if (errMsg === "成功" || errMsg.includes("操作成功")) {
          await this.syncCart();
          return;
        }
        common_vendor.index.showToast({ title: errMsg || "加购失败", icon: "none" });
        await this.syncCart();
      } finally {
        this.cartBusy = false;
      }
    },
    async decFood(food, _isRetry = false) {
      if (this.cartBusy || !this.cartReady)
        return;
      const dishId = Number(food.id);
      const key = this.dishKey(dishId);
      const current = this.cartMap[key];
      if (!current)
        return;
      this.cartBusy = true;
      try {
        await this.ensureCart();
        if (current.count <= 1) {
          await api_index.orderApi.dishDel(current.odid);
        } else {
          await api_index.orderApi.dishDec(current.odid);
        }
        await this.syncCart();
      } catch (e) {
        const errMsg = e.message || String(e) || "";
        if (!_isRetry && (errMsg.includes("不可用") || errMsg.includes("购物车"))) {
          this.orderId = 0;
          this.cartReady = false;
          this.cartBusy = false;
          return this.decFood(food, true);
        }
        if (errMsg === "成功" || errMsg.includes("操作成功")) {
          await this.syncCart();
          return;
        }
        common_vendor.index.showToast({ title: errMsg || "操作失败", icon: "none" });
        await this.syncCart();
      } finally {
        this.cartBusy = false;
      }
    },
    async goConfirm() {
      if (this.cartItemCount === 0) {
        common_vendor.index.showToast({ title: "请先选择菜品", icon: "none" });
        return;
      }
      try {
        await this.ensureCart();
        await this.syncCart();
        if (this.cartItemCount === 0) {
          common_vendor.index.showToast({ title: "请先选择菜品", icon: "none" });
          return;
        }
        common_vendor.index.setStorageSync("orderId", this.orderId);
        common_vendor.index.navigateTo({ url: "/pages/cart/confirm" });
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e || "购物车未就绪", icon: "none" });
      }
    }
  }
};
if (!Array) {
  const _easycom_page_loading2 = common_vendor.resolveComponent("page-loading");
  const _easycom_menu_category_sidebar2 = common_vendor.resolveComponent("menu-category-sidebar");
  (_easycom_page_loading2 + _easycom_menu_category_sidebar2)();
}
const _easycom_page_loading = () => "../../components/page-loading/page-loading.js";
const _easycom_menu_category_sidebar = () => "../../components/menu-category-sidebar/menu-category-sidebar.js";
if (!Math) {
  (_easycom_page_loading + _easycom_menu_category_sidebar)();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $options.displayBanners.length
  }, $options.displayBanners.length ? {
    b: common_vendor.f($options.displayBanners, (banner, idx, i0) => {
      return {
        a: banner.image,
        b: idx
      };
    }),
    c: $options.displayBanners.length > 1,
    d: $options.displayBanners.length > 1
  } : {}, {
    e: common_vendor.t($options.shopName),
    f: common_vendor.t($data.diningMode === 3 ? "外卖" : "堂食"),
    g: common_vendor.o((...args) => $options.toggleMode && $options.toggleMode(...args), "e2"),
    h: common_vendor.s($options.headerPaddingStyle),
    i: common_vendor.p({
      visible: $data.pageLoading,
      tip: $data.pageLoadingTip
    }),
    j: $data.loading
  }, $data.loading ? {} : $data.menu.length === 0 ? {} : common_vendor.e({
    l: common_vendor.o($options.selectCategory, "5c"),
    m: common_vendor.p({
      menu: $data.menu,
      ["active-index"]: $data.activeIndex,
      ["cart-map"]: $data.cartMap
    }),
    n: common_vendor.t($options.currentCategoryName),
    o: common_vendor.f($options.currentFoods, (food, idx, i0) => {
      return common_vendor.e({
        a: food.image,
        b: $options.foodTag(idx)
      }, $options.foodTag(idx) ? {
        c: common_vendor.t($options.foodTag(idx))
      } : {}, {
        d: common_vendor.t(food.title),
        e: food.intro
      }, food.intro ? {
        f: common_vendor.t(food.intro)
      } : {}, {
        g: common_vendor.t(food.price),
        h: $options.getCount(food.id) > 0
      }, $options.getCount(food.id) > 0 ? {
        i: $data.cartBusy || !$data.cartReady ? 1 : "",
        j: common_vendor.o(($event) => $options.decFood(food), food.id)
      } : {}, {
        k: $options.getCount(food.id) > 0
      }, $options.getCount(food.id) > 0 ? {
        l: common_vendor.t($options.getCount(food.id))
      } : {}, {
        m: common_vendor.o(($event) => $options.addFood(food), food.id),
        n: food.id
      });
    }),
    p: $data.cartBusy || !$data.cartReady ? 1 : "",
    q: $options.currentFoods.length === 0
  }, $options.currentFoods.length === 0 ? {} : {}), {
    k: $data.menu.length === 0,
    r: $options.cartItemCount > 0
  }, $options.cartItemCount > 0 ? {
    s: common_vendor.t($options.cartItemCount)
  } : {}, {
    t: common_vendor.t($options.cartSummary),
    v: !$data.cartReady || $options.cartItemCount === 0 ? 1 : "",
    w: !$data.cartReady || $options.cartItemCount === 0 ? 1 : "",
    x: common_vendor.o((...args) => $options.goConfirm && $options.goConfirm(...args), "0a"),
    y: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-1f245baa"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/menu/index.js.map
