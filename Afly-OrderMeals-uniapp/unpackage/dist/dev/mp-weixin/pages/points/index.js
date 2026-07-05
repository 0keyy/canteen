"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const utils_navbar = require("../../utils/navbar.js");
const utils_image = require("../../utils/image.js");
const DEFAULT_CATEGORIES = [
  { id: 0, name: "全部" },
  { id: 1, name: "积分秒杀" },
  { id: 2, name: "堂食专享" },
  { id: 3, name: "外卖专享" }
];
const DEFAULT_PRODUCTS = [
  {
    id: 1,
    image: utils_image.STATIC_IMAGE_PREFIX + "/1.png",
    title: "【堂食专享】可口可乐",
    points: 10,
    redeemed: 47
  },
  {
    id: 2,
    image: utils_image.STATIC_IMAGE_PREFIX + "/2.png",
    title: "【堂食专享】香脆薯条",
    points: 20,
    redeemed: 32
  },
  {
    id: 3,
    image: utils_image.STATIC_IMAGE_PREFIX + "/3.png",
    title: "【外卖专享】珍珠奶茶",
    points: 30,
    redeemed: 58
  },
  {
    id: 4,
    image: utils_image.STATIC_IMAGE_PREFIX + "/4.png",
    title: "【积分秒杀】香辣鸡翅",
    points: 50,
    redeemed: 19
  }
];
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
      categories: DEFAULT_CATEGORIES,
      products: DEFAULT_PRODUCTS,
      goodsLoading: false
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
    this.loadCategories();
    this.loadGoods();
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
    async loadCategories() {
      try {
        const list = await api_index.integralApi.categoryList();
        if (Array.isArray(list) && list.length) {
          this.categories = [{ id: 0, name: "全部" }, ...list.map((item) => ({
            id: item.id ?? item.categoryId ?? item.key,
            name: item.name ?? item.categoryName ?? item.title
          }))];
        }
      } catch (e) {
      }
    },
    normalizeGoodsItem(item) {
      return {
        id: item.id ?? item.goodsId,
        image: utils_image.resolveImageUrl(item.image ?? item.cover ?? item.img),
        title: item.title ?? item.name ?? item.goodsName,
        points: item.points ?? item.integral ?? item.point,
        redeemed: item.redeemed ?? item.exchangeCount ?? item.sales ?? 0
      };
    },
    async loadGoods() {
      var _a;
      const categoryId = (_a = this.categories[this.activeCategory]) == null ? void 0 : _a.id;
      if (categoryId == null)
        return;
      this.goodsLoading = true;
      try {
        const data = await api_index.integralApi.goodsList(categoryId || null);
        const list = (data == null ? void 0 : data.list) || data || [];
        if (Array.isArray(list) && list.length) {
          this.products = list.map((item) => this.normalizeGoodsItem(item));
        } else {
          this.products = [];
        }
      } catch (e) {
        this.products = categoryId === 0 ? DEFAULT_PRODUCTS : [];
      } finally {
        this.goodsLoading = false;
      }
    },
    selectCategory(index) {
      if (this.activeCategory === index)
        return;
      this.activeCategory = index;
      this.loadGoods();
    },
    selectTab(index) {
      this.activeTab = index;
    },
    onScan() {
      common_vendor.index.showToast({ title: "扫码功能开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.t($data.pointsBalance),
    b: $data.staticImgPrefix + "/看书.png",
    c: common_vendor.s($options.heroPaddingStyle),
    d: common_vendor.f($data.navTabs, (tab, index, i0) => {
      return {
        a: common_vendor.t(tab),
        b: index,
        c: $data.activeTab === index ? 1 : "",
        d: common_vendor.o(($event) => $options.selectTab(index), index)
      };
    }),
    e: $data.staticImgPrefix + "/白logo.png",
    f: $data.staticImgPrefix + "/白logo.png",
    g: common_vendor.f($data.categories, (cat, index, i0) => {
      return {
        a: common_vendor.t(cat.name),
        b: cat.id,
        c: $data.activeCategory === index ? 1 : "",
        d: common_vendor.o(($event) => $options.selectCategory(index), cat.id)
      };
    }),
    h: common_vendor.f($data.products, (product, k0, i0) => {
      return {
        a: product.image,
        b: common_vendor.t(product.title),
        c: common_vendor.t(product.points),
        d: common_vendor.t(product.redeemed),
        e: product.id
      };
    }),
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
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-dd6e20da"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/points/index.js.map
