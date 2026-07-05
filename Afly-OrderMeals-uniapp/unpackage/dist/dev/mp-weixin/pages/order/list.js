"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const TABS = [
  { key: "all", name: "全部" },
  { key: "paying", name: "待支付" },
  { key: "shipping", name: "待发货" },
  { key: "delivering", name: "待收货" },
  { key: "refund", name: "退款/售后" }
];
const _sfc_main = {
  data() {
    return {
      tabs: TABS,
      activeTab: 0,
      allList: [],
      navHeight: 0,
      statusBarHeight: 0
    };
  },
  computed: {
    navbarStyle() {
      return `padding-top: ${this.statusBarHeight}px; height: ${44 + this.statusBarHeight}px;`;
    },
    currentList() {
      if (this.activeTab === 0)
        return this.allList;
      const key = TABS[this.activeTab].key;
      return this.allList.filter((o) => o.statusKey === key);
    }
  },
  onLoad(options) {
    const sys = common_vendor.index.getSystemInfoSync();
    this.statusBarHeight = sys.statusBarHeight || 20;
    if (options && options.tab !== void 0) {
      const tabIdx = parseInt(options.tab);
      if (!isNaN(tabIdx) && tabIdx >= 0 && tabIdx < TABS.length) {
        this.activeTab = tabIdx;
      }
    }
    this.loadList();
  },
  onShow() {
    this.loadList();
  },
  methods: {
    async loadList() {
      try {
        const data = await api_index.orderApi.list();
        let list = [];
        if (Array.isArray(data)) {
          list = data;
        } else if (data && Array.isArray(data.list)) {
          list = data.list;
        } else if (data && Array.isArray(data.data)) {
          list = data.data;
        }
        if (list.length > 0) {
          this.allList = list.map((item) => this.normalizeOrder(item));
        } else {
          this.allList = this.getMockList();
        }
      } catch (e) {
        this.allList = this.getMockList();
      }
    },
    normalizeOrder(item) {
      const statusInfo = this.getStatusInfo(item);
      let dishes = [];
      if (Array.isArray(item.dishes)) {
        dishes = item.dishes;
      } else if (item.dish) {
        dishes = [item.dish];
      } else if (Array.isArray(item.goodsList)) {
        dishes = item.goodsList;
      } else if (Array.isArray(item.orderDishes)) {
        dishes = item.orderDishes;
      }
      const dishList = dishes.length > 0 ? dishes.slice(0, 2).map((d) => ({
        id: d.id || d.dishId || d.goodsId,
        name: d.name || d.dishName || d.goodsName || "",
        image: d.image || d.img || d.cover || d.goodsImage || d.dishImage || "",
        price: d.price || d.dishPrice || d.goodsPrice || 0,
        quantity: d.quantity || d.count || d.dishQuantity || d.num || 1
      })) : [];
      if (dishList.length === 0) {
        const modeName = item.diningMode === 3 ? "外卖" : item.diningMode === 1 ? "堂食" : "订单";
        dishList.push({
          id: item.id,
          name: item.dishName || `${modeName}订单`,
          image: item.image || "",
          price: item.amount || 0,
          quantity: 1
        });
      }
      return {
        id: item.id || item.orderId || item.oid,
        createTime: item.createTime || item.time || item.orderTime || "",
        amount: item.amount || item.totalAmount || item.totalPrice || 0,
        statusKey: statusInfo.key,
        statusText: statusInfo.text,
        dishes: dishList
      };
    },
    getStatusInfo(item) {
      if (item.payStatus === 0 || item.status === 4) {
        return { key: "paying", text: "待支付" };
      }
      if (item.status === 1 && item.shippingStatus === 0) {
        return { key: "shipping", text: "待发货" };
      }
      if (item.status === 1 && item.shippingStatus === 1) {
        return { key: "delivering", text: "待收货" };
      }
      if (item.status === 2) {
        return { key: "completed", text: "已完成" };
      }
      if (item.status === 3) {
        return { key: "refund", text: "已退款" };
      }
      if (item.status === 5) {
        return { key: "refund", text: "退款中" };
      }
      return { key: "completed", text: "已完成" };
    },
    getMockList() {
      return [
        {
          id: 1,
          createTime: "2026-06-01 18:11:31",
          amount: 3,
          statusKey: "completed",
          statusText: "已完成",
          dishes: [
            { id: 1, name: "可口可乐", image: "/static/首页广告.png", price: "3", quantity: 1 }
          ]
        },
        {
          id: 2,
          createTime: "2026-06-01 18:11:31",
          amount: 15,
          statusKey: "delivering",
          statusText: "待收货",
          dishes: [
            { id: 2, name: "红烧牛肉面", image: "/static/首页广告.png", price: "15", quantity: 1 }
          ]
        }
      ];
    },
    switchTab(idx) {
      this.activeTab = idx;
    },
    goBack() {
      const pages = getCurrentPages();
      if (pages.length > 1) {
        common_vendor.index.navigateBack();
      } else {
        common_vendor.index.switchTab({ url: "/pages/mine/index" });
      }
    },
    goDetail(orderId) {
      common_vendor.index.navigateTo({ url: `/pages/order/detail?orderId=${orderId}` });
    },
    reorder(order) {
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    },
    confirmReceive(order) {
      common_vendor.index.showToast({ title: "确认收货功能开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "12"),
    b: common_vendor.s($options.navbarStyle),
    c: common_vendor.f($data.tabs, (tab, idx, i0) => {
      return common_vendor.e({
        a: common_vendor.t(tab.name),
        b: $data.activeTab === idx
      }, $data.activeTab === idx ? {} : {}, {
        c: tab.key,
        d: $data.activeTab === idx ? 1 : "",
        e: common_vendor.o(($event) => $options.switchTab(idx), tab.key)
      });
    }),
    d: $options.currentList.length > 0
  }, $options.currentList.length > 0 ? {
    e: common_vendor.f($options.currentList, (order, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.f(order.dishes, (dish, dIdx, i1) => {
          return common_vendor.e({
            a: dish.image,
            b: common_vendor.t(dish.name),
            c: common_vendor.t(dish.quantity),
            d: common_vendor.t(dish.price)
          }, order.statusKey === "completed" ? {
            e: common_vendor.o(($event) => $options.reorder(order), dIdx)
          } : order.statusKey === "shipping" ? {
            f: common_vendor.o(($event) => $options.confirmReceive(order), dIdx)
          } : {}, {
            g: dIdx
          });
        }),
        b: common_vendor.t(order.createTime),
        c: common_vendor.t(order.statusText),
        d: common_vendor.n(`order-item__dish-status--${order.statusKey}`),
        e: order.statusKey === "completed",
        f: order.statusKey === "shipping",
        g: order.dishes.length > 1
      }, order.dishes.length > 1 ? {
        h: common_vendor.o(($event) => $options.goDetail(order.id), order.id)
      } : {}, {
        i: order.id,
        j: common_vendor.o(($event) => $options.goDetail(order.id), order.id)
      });
    })
  } : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-456ecf67"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/list.js.map
