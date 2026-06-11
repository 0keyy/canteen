"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_pay_index = require("../../utils/pay/index.js");
const utils_pay_channels = require("../../utils/pay/channels.js");
const PayMethodPicker = () => "../../components/pay-method-picker/pay-method-picker.js";
const _sfc_main = {
  components: { PayMethodPicker },
  data() {
    return {
      orderId: 0,
      order: null,
      payChannel: utils_pay_channels.DEFAULT_PAY_CHANNEL
    };
  },
  computed: {
    isCalled() {
      return this.order && Number(this.order.calledTime) > 0;
    },
    statusText() {
      if (!this.order)
        return "";
      if (this.order.payStatus === 0 || this.order.status === 4)
        return "待支付";
      if (this.order.status === 1 && this.isCalled)
        return "请取餐";
      if (this.order.status === 1)
        return "制作中";
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
  onShow() {
    if (this.orderId)
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
      try {
        await utils_pay_index.payOrder(this.orderId, this.payChannel, "mp");
        common_vendor.index.showToast({ title: "支付成功", icon: "success" });
        this.loadDetail();
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      }
    },
    async cancelOrder() {
      await api_index.orderApi.cancel(this.orderId, "用户取消");
      this.loadDetail();
    }
  }
};
if (!Array) {
  const _easycom_pay_method_picker2 = common_vendor.resolveComponent("pay-method-picker");
  _easycom_pay_method_picker2();
}
const _easycom_pay_method_picker = () => "../../components/pay-method-picker/pay-method-picker.js";
if (!Math) {
  _easycom_pay_method_picker();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.order
  }, $data.order ? common_vendor.e({
    b: common_vendor.t($options.statusText),
    c: $data.order.pickupCode
  }, $data.order.pickupCode ? {
    d: common_vendor.t($data.order.pickupCode),
    e: $options.isCalled ? 1 : ""
  } : {}, {
    f: $options.isCalled
  }, $options.isCalled ? {} : {}, {
    g: common_vendor.t($data.order.number),
    h: $data.order.addressSnapshot
  }, $data.order.addressSnapshot ? {
    i: common_vendor.t($options.formatAddress($data.order.addressSnapshot))
  } : {}, {
    j: $data.order.payStatus === 0 || $data.order.status === 4
  }, $data.order.payStatus === 0 || $data.order.status === 4 ? {
    k: common_vendor.o(($event) => $data.payChannel = $event, "59"),
    l: common_vendor.p({
      ["order-id"]: $data.orderId,
      modelValue: $data.payChannel
    })
  } : {}, {
    m: common_vendor.f($data.order.dishes, (dish, k0, i0) => {
      return {
        a: common_vendor.t(dish.dishName),
        b: common_vendor.t(dish.quantity),
        c: common_vendor.t(dish.amount),
        d: dish.id
      };
    }),
    n: common_vendor.t($data.order.amount),
    o: $data.order.payStatus === 0 || $data.order.status === 4
  }, $data.order.payStatus === 0 || $data.order.status === 4 ? {
    p: common_vendor.o((...args) => $options.payNow && $options.payNow(...args), "9e")
  } : {}, {
    q: $data.order.status === 1
  }, $data.order.status === 1 ? {
    r: common_vendor.o((...args) => $options.cancelOrder && $options.cancelOrder(...args), "fc")
  } : {}) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-6b23c96c"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/detail.js.map
