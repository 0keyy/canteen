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
      aid: utils_config.DEFAULT_SHOP_ID,
      shop: null,
      diningMode: 1,
      orderId: 0,
      menu: [],
      activeIndex: 0,
      cartMap: {},
      loading: true,
      cartReady: false,
      cartBusy: false,
      cartInitPromise: null
    };
  },
  computed: {
    headerPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` };
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
      return `¥${this.totalPrice}`;
    }
  },
  onLoad() {
    this.diningMode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    this.updateNavPadding();
    this.loadShop();
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
    if (!this.loading && this.cartReady) {
      this.syncCart();
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
    patchCartItem(dishId, item) {
      const key = this.dishKey(dishId);
      const next = { ...this.cartMap };
      if (item) {
        next[key] = item;
      } else {
        delete next[key];
      }
      this.cartMap = next;
    },
    async bootstrap() {
      this.loading = true;
      this.cartReady = false;
      try {
        await this.loadMenu();
        await this.initOrder();
        await this.syncCart();
        this.cartReady = !!this.orderId;
      } catch (e) {
        this.cartReady = false;
        common_vendor.index.showToast({ title: e.message || e || "页面加载失败", icon: "none" });
      } finally {
        this.loading = false;
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
      if ((has == null ? void 0 : has.oid) && Number(has.diningMode) === this.diningMode) {
        this.orderId = Number(has.oid);
        return;
      }
      if (has == null ? void 0 : has.oid) {
        await api_index.orderApi.toEmpty(has.oid);
        this.setCartMap({});
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
    async ensureCart() {
      if (this.orderId) {
        return this.orderId;
      }
      if (this.cartInitPromise) {
        await this.cartInitPromise;
        return this.orderId;
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
      if (!(has == null ? void 0 : has.oid) || Number(has.oid) !== this.orderId) {
        this.setCartMap({});
        return;
      }
      const map = {};
      (has.dish || []).forEach((item) => {
        const dishId = Number(item.dishId);
        const food = this.findFood(dishId);
        const key = this.dishKey(dishId);
        const existing = map[key];
        if (existing) {
          existing.count += Number(item.count) || 0;
          return;
        }
        map[key] = {
          odid: Number(item.id),
          dishId,
          count: Number(item.count) || 0,
          price: (food == null ? void 0 : food.price) || 0
        };
      });
      this.setCartMap(map);
    },
    async addFood(food) {
      if (this.cartBusy)
        return;
      this.cartBusy = true;
      try {
        await this.ensureCart();
        const dishId = Number(food.id);
        const key = this.dishKey(dishId);
        const current = this.cartMap[key];
        if (!current) {
          const odid = Number(await api_index.orderApi.dishAdd(this.orderId, dishId));
          if (!odid) {
            throw new Error("加购失败");
          }
          this.patchCartItem(dishId, {
            odid,
            dishId,
            count: 1,
            price: food.price
          });
        } else {
          await api_index.orderApi.dishInc(current.odid);
          this.patchCartItem(dishId, {
            ...current,
            count: current.count + 1
          });
        }
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e || "加购失败", icon: "none" });
        await this.syncCart();
      } finally {
        this.cartBusy = false;
      }
    },
    async decFood(food) {
      if (this.cartBusy)
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
          this.patchCartItem(dishId, null);
        } else {
          await api_index.orderApi.dishDec(current.odid);
          this.patchCartItem(dishId, {
            ...current,
            count: current.count - 1
          });
        }
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e || "操作失败", icon: "none" });
        await this.syncCart();
      } finally {
        this.cartBusy = false;
      }
    },
    async goConfirm() {
      if (!this.cartReady) {
        common_vendor.index.showToast({ title: "购物车准备中，请稍候", icon: "none" });
        return;
      }
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
  const _easycom_menu_category_sidebar2 = common_vendor.resolveComponent("menu-category-sidebar");
  _easycom_menu_category_sidebar2();
}
const _easycom_menu_category_sidebar = () => "../../components/menu-category-sidebar/menu-category-sidebar.js";
if (!Math) {
  _easycom_menu_category_sidebar();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.n($data.diningMode === 1 ? "order-page__mode-tab--active" : ""),
    b: common_vendor.o(($event) => $options.switchMode(1), "52"),
    c: common_vendor.n($data.diningMode === 3 ? "order-page__mode-tab--active" : ""),
    d: common_vendor.n($data.shop && $data.shop.deliveryEnable !== 1 ? "order-page__mode-tab--disabled" : ""),
    e: common_vendor.o(($event) => $options.switchMode(3), "4d"),
    f: common_vendor.s($options.headerPaddingStyle),
    g: $data.loading
  }, $data.loading ? {} : $data.menu.length === 0 ? {} : common_vendor.e({
    i: common_vendor.o($options.selectCategory, "ca"),
    j: common_vendor.p({
      menu: $data.menu,
      ["active-index"]: $data.activeIndex,
      ["cart-map"]: $data.cartMap
    }),
    k: common_vendor.t($options.currentCategoryName),
    l: common_vendor.f($options.currentFoods, (food, idx, i0) => {
      return common_vendor.e({
        a: food.image,
        b: common_vendor.t(food.title),
        c: $options.foodTag(idx)
      }, $options.foodTag(idx) ? {
        d: common_vendor.t($options.foodTag(idx))
      } : {}, {
        e: common_vendor.t(food.sales || 13),
        f: common_vendor.t(food.price),
        g: $options.getCount(food.id) > 0
      }, $options.getCount(food.id) > 0 ? {
        h: common_vendor.o(($event) => $options.decFood(food), food.id),
        i: common_vendor.t($options.getCount(food.id))
      } : {}, {
        j: common_vendor.o(($event) => $options.addFood(food), food.id),
        k: food.id
      });
    }),
    m: $data.cartBusy ? 1 : "",
    n: $options.currentFoods.length === 0
  }, $options.currentFoods.length === 0 ? {} : {}), {
    h: $data.menu.length === 0,
    o: $options.cartItemCount > 0
  }, $options.cartItemCount > 0 ? {
    p: common_vendor.t($options.cartItemCount)
  } : {}, {
    q: common_vendor.t($options.cartSummary),
    r: !$data.cartReady || $options.cartItemCount === 0 ? 1 : "",
    s: !$data.cartReady || $options.cartItemCount === 0 ? 1 : "",
    t: common_vendor.o((...args) => $options.goConfirm && $options.goConfirm(...args), "f1"),
    v: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-1f245baa"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/menu/index.js.map
