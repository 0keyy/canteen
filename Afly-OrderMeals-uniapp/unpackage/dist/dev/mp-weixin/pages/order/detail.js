"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_pay_index = require("../../utils/pay/index.js");
const utils_pay_channels = require("../../utils/pay/channels.js");
const PayMethodPicker = () => "../../components/pay-method-picker/pay-method-picker.js";
const PageLoading = () => "../../components/page-loading/page-loading.js";
const _sfc_main = {
  components: { PayMethodPicker, PageLoading },
  data() {
    return {
      orderId: 0,
      order: null,
      payChannel: utils_pay_channels.DEFAULT_PAY_CHANNEL,
      showPayPicker: false,
      payMethodList: [],
      pageLoading: false,
      pageLoadingTip: "加载中..."
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
    },
    payChannelText() {
      const m = this.payMethodList.find((item) => item.channel === this.payChannel);
      return m ? m.name : "请选择";
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
      this.order = await api_index.orderApi.detail(this.orderId);
    },
    async payNow() {
      try {
        await utils_pay_index.payOrder(this.orderId, this.payChannel, "mp");
        common_vendor.index.showToast({ title: "支付成功", icon: "success" });
        setTimeout(() => {
          this.loadDetail();
        }, 500);
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      }
    },
    async cancelOrder() {
      await api_index.orderApi.cancel(this.orderId, "用户取消");
      this.loadDetail();
    },
    onPayMethodChange(channel) {
      this.payChannel = channel;
      this.showPayPicker = false;
    },
    onPayMethodsLoaded(list) {
      this.payMethodList = list || [];
    },
    goBack() {
      this.goWithLoading("", "navigateBack");
    },
    goWithLoading(url, type = "navigateTo", tip = "加载中...") {
      this.pageLoadingTip = tip;
      this.pageLoading = true;
      setTimeout(() => {
        if (type === "switchTab") {
          common_vendor.index.switchTab({ url });
        } else if (type === "reLaunch") {
          common_vendor.index.reLaunch({ url });
        } else if (type === "redirectTo") {
          common_vendor.index.redirectTo({ url });
        } else if (type === "navigateBack") {
          common_vendor.index.navigateBack();
        } else {
          common_vendor.index.navigateTo({ url });
        }
        setTimeout(() => {
          this.pageLoading = false;
        }, 500);
      }, 100);
    }
  }
};
if (!Array) {
  const _easycom_pay_method_picker2 = common_vendor.resolveComponent("pay-method-picker");
  const _easycom_page_loading2 = common_vendor.resolveComponent("page-loading");
  (_easycom_pay_method_picker2 + _easycom_page_loading2)();
}
const _easycom_pay_method_picker = () => "../../components/pay-method-picker/pay-method-picker.js";
const _easycom_page_loading = () => "../../components/page-loading/page-loading.js";
if (!Math) {
  (_easycom_pay_method_picker + _easycom_page_loading)();
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
    g: $data.order.addressSnapshot
  }, $data.order.addressSnapshot ? {
    h: common_vendor.t($options.formatAddress($data.order.addressSnapshot))
  } : {}, {
    i: common_vendor.t($data.order.createTime),
    j: common_vendor.t($data.order.number),
    k: common_vendor.f($data.order.dishes, (dish, k0, i0) => {
      return {
        a: dish.image || "/static/placeholder.png",
        b: common_vendor.t(dish.dishName),
        c: common_vendor.t(dish.quantity),
        d: common_vendor.t($options.lineAmount(dish)),
        e: dish.id
      };
    }),
    l: common_vendor.t($data.order.amount),
    m: $data.order.payStatus === 0 || $data.order.status === 4
  }, $data.order.payStatus === 0 || $data.order.status === 4 ? {
    n: common_vendor.t($options.payChannelText),
    o: common_vendor.o(($event) => $data.showPayPicker = true, "5f")
  } : {}, {
    p: $data.order.payStatus === 0 || $data.order.status === 4
  }, $data.order.payStatus === 0 || $data.order.status === 4 ? {
    q: common_vendor.t($data.order.amount),
    r: common_vendor.o((...args) => $options.payNow && $options.payNow(...args), "47")
  } : {}, {
    s: $data.order.status === 1
  }, $data.order.status === 1 ? {
    t: common_vendor.o((...args) => $options.cancelOrder && $options.cancelOrder(...args), "ce")
  } : {}, {
    v: $data.showPayPicker
  }, $data.showPayPicker ? {
    w: common_vendor.o($options.onPayMethodChange, "12"),
    x: common_vendor.o($options.onPayMethodsLoaded, "11"),
    y: common_vendor.o(($event) => $data.payChannel = $event, "a9"),
    z: common_vendor.p({
      ["order-id"]: $data.orderId,
      modelValue: $data.payChannel
    }),
    A: common_vendor.o(($event) => $data.showPayPicker = false, "b2"),
    B: common_vendor.o(() => {
    }, "a9"),
    C: common_vendor.o(($event) => $data.showPayPicker = false, "86")
  } : {}, {
    D: common_vendor.p({
      visible: $data.pageLoading,
      tip: $data.pageLoadingTip
    })
  }) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-6b23c96c"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/detail.js.map
