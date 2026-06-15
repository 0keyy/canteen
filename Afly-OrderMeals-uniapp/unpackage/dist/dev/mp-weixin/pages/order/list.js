"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_config = require("../../utils/config.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin],
  data() {
    return {
      list: [],
      shopName: "粮兴坊",
      pendingTotal: 0
    };
  },
  onShow() {
    this.setupTabbar(2);
    this.loadShop();
    this.loadList();
    this.loadPendingCart();
  },
  methods: {
    async loadShop() {
      try {
        const shop = await api_index.orderApi.shop(utils_config.DEFAULT_SHOP_ID);
        if (shop == null ? void 0 : shop.name)
          this.shopName = shop.name;
      } catch (e) {
      }
    },
    async loadPendingCart() {
      try {
        const has = await api_index.orderApi.cartHas(utils_config.DEFAULT_SHOP_ID);
        if (!(has == null ? void 0 : has.oid) || !Array.isArray(has.dish) || has.dish.length === 0) {
          this.pendingTotal = 0;
          return;
        }
        let total = 0;
        has.dish.forEach((item) => {
          total += Number(item.price || 0) * (Number(item.count) || 0);
        });
        this.pendingTotal = total;
      } catch (e) {
        this.pendingTotal = 0;
      }
    },
    modeText(mode) {
      return { 1: "堂食", 3: "外卖" }[mode] || "订单";
    },
    statusText(item) {
      if (item.payStatus === 0 || item.status === 4)
        return "待支付";
      if (item.status === 1 && Number(item.calledTime) > 0)
        return "请取餐";
      if (item.status === 1)
        return "制作中";
      if (item.status === 2)
        return "已完成";
      if (item.status === 3)
        return "已取消";
      return "未知";
    },
    orderTitle(item) {
      return `${this.modeText(item.diningMode)}订单`;
    },
    async loadList() {
      try {
        this.list = await api_index.orderApi.list();
      } catch (e) {
        this.list = [];
      }
    },
    goDetail(orderId) {
      common_vendor.index.navigateTo({ url: `/pages/order/detail?orderId=${orderId}` });
    },
    goMenu() {
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    },
    reorder() {
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.t($data.shopName),
    b: $data.pendingTotal > 0
  }, $data.pendingTotal > 0 ? {
    c: common_vendor.t($data.pendingTotal.toFixed(2)),
    d: common_vendor.o((...args) => $options.goMenu && $options.goMenu(...args), "3a")
  } : {}, {
    e: $data.list.length > 0
  }, $data.list.length > 0 ? {
    f: common_vendor.f($data.list, (item, k0, i0) => {
      return {
        a: common_vendor.t($options.orderTitle(item)),
        b: common_vendor.t($options.statusText(item)),
        c: item.payStatus === 1 ? 1 : "",
        d: item.status === 3 ? 1 : "",
        e: common_vendor.t(item.createTime),
        f: common_vendor.t(item.id),
        g: common_vendor.t(item.amount || "0.00"),
        h: common_vendor.o(($event) => $options.reorder(item), item.id),
        i: item.id,
        j: common_vendor.o(($event) => $options.goDetail(item.id), item.id)
      };
    })
  } : {}, {
    g: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
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
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-456ecf67"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/list.js.map
