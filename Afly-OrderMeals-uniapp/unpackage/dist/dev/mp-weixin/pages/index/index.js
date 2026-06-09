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
      shop: null,
      aid: utils_config.DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      shortcuts: [
        { name: "积分商城", desc: "神秘好物等你来", icon: "🛍️" },
        { name: "储值优惠", desc: "查看&绑定", icon: "🎁" },
        { name: "优惠券包", desc: "享多重优惠", icon: "🎫" }
      ]
    };
  },
  computed: {
    headerStyle() {
      const { headerHeight, statusBarHeight } = this.navMetrics;
      return {
        height: `${headerHeight}px`,
        paddingTop: `${statusBarHeight}px`,
        boxSizing: "border-box"
      };
    },
    storeBarStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` };
    },
    storeName() {
      var _a;
      return ((_a = this.shop) == null ? void 0 : _a.name) || "粮兴坊";
    },
    bannerList() {
      var _a;
      if (this.banners.length)
        return this.banners;
      if ((_a = this.shop) == null ? void 0 : _a.image)
        return [{ image: this.shop.image }];
      return [];
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
    this.loadShop();
    this.loadDecoration();
    this.loadRecommend();
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = utils_navbar.getNavMetrics();
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
      var _a;
      try {
        const page = await api_index.decorateApi.page(1);
        const widgets = JSON.parse((page == null ? void 0 : page.pageData) || "[]");
        const bannerWidget = widgets.find((item) => item.name === "banner");
        if (((_a = bannerWidget == null ? void 0 : bannerWidget.content) == null ? void 0 : _a.enabled) === 1 && Array.isArray(bannerWidget.content.data)) {
          this.banners = bannerWidget.content.data.filter((item) => item.image).map((item) => ({
            ...item,
            image: utils_image.resolveImageUrl(item.image)
          }));
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
      common_vendor.index.navigateTo({ url: "/pages/menu/index" });
    },
    goMenu() {
      common_vendor.index.setStorageSync("diningMode", 1);
      common_vendor.index.navigateTo({ url: "/pages/menu/index" });
    },
    selectSpec() {
      this.goMenu();
    },
    onShortcutTap() {
      common_vendor.index.showToast({ title: "功能开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.t($options.storeName),
    b: common_vendor.s($options.storeBarStyle),
    c: common_vendor.s($options.headerStyle),
    d: $options.bannerList.length
  }, $options.bannerList.length ? {
    e: common_vendor.f($options.bannerList, (item, index, i0) => {
      return {
        a: item.image,
        b: index
      };
    })
  } : {}, {
    f: common_vendor.o(($event) => $options.selectMode(1), "2c"),
    g: $data.shop && $data.shop.deliveryEnable !== 1 ? 1 : "",
    h: common_vendor.o(($event) => $options.selectMode(3), "bb"),
    i: common_vendor.f($data.shortcuts, (item, k0, i0) => {
      return {
        a: common_vendor.t(item.icon),
        b: common_vendor.t(item.name),
        c: common_vendor.t(item.desc),
        d: item.name,
        e: common_vendor.o(($event) => $options.onShortcutTap(item), item.name)
      };
    }),
    j: common_vendor.o((...args) => $options.goMenu && $options.goMenu(...args), "ad"),
    k: common_vendor.f($data.recommendDishes, (dish, k0, i0) => {
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
    }),
    l: !$data.recommendLoading && $data.recommendDishes.length === 0
  }, !$data.recommendLoading && $data.recommendDishes.length === 0 ? {} : {}, {
    m: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-1cf27b2a"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/index/index.js.map
