"use strict";
const api_index = require("../../api/index.js");
const utils_pay_index = require("../../utils/pay/index.js");
const common_vendor = require("../../common/vendor.js");
const _sfc_main = {
  data() {
    return {
      orderId: 0,
      order: null
    };
  },
  computed: {
    statusText() {
      if (!this.order)
        return "";
      if (this.order.payStatus === 0 || this.order.status === 4)
        return "待支付";
      if (this.order.status === 1)
        return "进行中";
      if (this.order.status === 2)
        return "已完成";
      if (this.order.status === 3)
        return "已取消";
      return "未知";
    }
  },
  onLoad(options) {
    this.orderId = Number(options.orderId);
    this.loadDetail();
  },
  methods: {
    formatAddress(snapshot) {
      try {
        const obj = JSON.parse(snapshot);
        return `${obj.province || ""}${obj.city || ""}${obj.district || ""}${obj.detail || ""}`;
      } catch (e) {
        return snapshot;
      }
    },
    async loadDetail() {
      this.order = await api_index.orderApi.detail(this.orderId);
    },
    async payNow() {
      await utils_pay_index.payOrder(this.orderId, "wxpay", "mp");
      this.loadDetail();
    },
    async cancelOrder() {
      await api_index.orderApi.cancel(this.orderId, "用户取消");
      this.loadDetail();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.order
  }, $data.order ? common_vendor.e({
    b: common_vendor.t($options.statusText),
    c: $data.order.pickupCode
  }, $data.order.pickupCode ? {
    d: common_vendor.t($data.order.pickupCode)
  } : {}, {
    e: common_vendor.t($data.order.number),
    f: $data.order.addressSnapshot
  }, $data.order.addressSnapshot ? {
    g: common_vendor.t($options.formatAddress($data.order.addressSnapshot))
  } : {}, {
    h: common_vendor.f($data.order.dishes, (dish, k0, i0) => {
      return {
        a: common_vendor.t(dish.dishName),
        b: common_vendor.t(dish.quantity),
        c: common_vendor.t(dish.amount),
        d: dish.id
      };
    }),
    i: common_vendor.t($data.order.amount),
    j: $data.order.payStatus === 0 || $data.order.status === 4
  }, $data.order.payStatus === 0 || $data.order.status === 4 ? {
    k: common_vendor.o((...args) => $options.payNow && $options.payNow(...args), "31")
  } : {}, {
    l: $data.order.status === 1
  }, $data.order.status === 1 ? {
    m: common_vendor.o((...args) => $options.cancelOrder && $options.cancelOrder(...args), "9f")
  } : {}) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-6b23c96c"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/detail.js.map
