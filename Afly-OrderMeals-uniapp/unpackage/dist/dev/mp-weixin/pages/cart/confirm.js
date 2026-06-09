"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_pay_index = require("../../utils/pay/index.js");
const _sfc_main = {
  data() {
    return {
      orderId: 0,
      order: null,
      remark: "",
      loading: false,
      diningMode: 1
    };
  },
  computed: {
    diningModeText() {
      return { 1: "堂食", 3: "外卖配送" }[this.diningMode] || "堂食";
    },
    totalAmount() {
      if (!this.order)
        return "0.00";
      const orderAmount = this.order.amount;
      if (orderAmount !== null && orderAmount !== void 0 && orderAmount !== "") {
        return Number(orderAmount).toFixed(2);
      }
      return this.calcDishesAmount(this.order.dishes);
    }
  },
  onLoad() {
    this.orderId = Number(common_vendor.index.getStorageSync("orderId"));
    this.diningMode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    this.loadDetail();
  },
  methods: {
    calcDishesAmount(dishes) {
      if (!Array.isArray(dishes) || dishes.length === 0)
        return "0.00";
      const total = dishes.reduce((sum, dish) => {
        return sum + Number(dish.amount || 0) * Number(dish.quantity || 1);
      }, 0);
      return total.toFixed(2);
    },
    lineAmount(dish) {
      return (Number(dish.amount || 0) * Number(dish.quantity || 1)).toFixed(2);
    },
    formatAddress(snapshot) {
      try {
        const obj = JSON.parse(snapshot);
        return `${obj.province || ""}${obj.city || ""}${obj.district || ""}${obj.detail || ""}`;
      } catch (e) {
        return snapshot;
      }
    },
    async loadDetail() {
      try {
        this.order = await api_index.orderApi.detail(this.orderId);
      } catch (e) {
        this.order = { dishes: [], amount: "0.00" };
      }
    },
    async handleSubmit() {
      this.loading = true;
      try {
        const addressId = common_vendor.index.getStorageSync("addressId") || null;
        await api_index.orderApi.submit({
          orderId: this.orderId,
          remark: this.remark,
          addressId,
          payChannel: "wxpay",
          payScene: "mp"
        });
        await utils_pay_index.payOrder(this.orderId, "wxpay", "mp");
        common_vendor.index.showToast({ title: "支付成功", icon: "success" });
        setTimeout(() => {
          common_vendor.index.redirectTo({ url: `/pages/order/detail?orderId=${this.orderId}` });
        }, 500);
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      } finally {
        this.loading = false;
      }
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  var _a;
  return common_vendor.e({
    a: $data.order
  }, $data.order ? common_vendor.e({
    b: common_vendor.t($options.diningModeText),
    c: $data.order.contactMobile
  }, $data.order.contactMobile ? {
    d: common_vendor.t($data.order.contactMobile)
  } : {}, {
    e: $data.order.addressSnapshot
  }, $data.order.addressSnapshot ? {
    f: common_vendor.t($options.formatAddress($data.order.addressSnapshot))
  } : {}, {
    g: common_vendor.t(((_a = $data.order.dishes) == null ? void 0 : _a.length) || 0),
    h: common_vendor.f($data.order.dishes, (dish, k0, i0) => {
      return {
        a: common_vendor.t(dish.dishName),
        b: common_vendor.t($options.lineAmount(dish)),
        c: common_vendor.t(dish.quantity),
        d: dish.id
      };
    }),
    i: common_vendor.t($options.totalAmount),
    j: $data.remark,
    k: common_vendor.o(($event) => $data.remark = $event.detail.value, "5a"),
    l: common_vendor.t($options.totalAmount),
    m: common_vendor.t($data.loading ? "提交中..." : "提交并支付"),
    n: common_vendor.o((...args) => $options.handleSubmit && $options.handleSubmit(...args), "3e")
  }) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-aaa7ef6e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/cart/confirm.js.map
