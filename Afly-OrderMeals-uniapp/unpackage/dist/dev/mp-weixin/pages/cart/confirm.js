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
      remark: "",
      loading: false,
      diningMode: 1,
      payChannel: utils_pay_channels.DEFAULT_PAY_CHANNEL,
      couponInfo: null,
      selectedCouponId: 0,
      couponDiscount: 0,
      showPayPicker: false,
      payMethodList: []
    };
  },
  computed: {
    diningModeText() {
      return { 1: "堂食", 3: "外卖配送" }[this.diningMode] || "堂食";
    },
    payChannelText() {
      const m = this.payMethodList.find((item) => item.channel === this.payChannel);
      return m ? m.name : "请选择";
    },
    finalAmount() {
      const raw = Number(this.totalAmount);
      return Math.max(0, raw - this.couponDiscount).toFixed(2);
    },
    totalAmount() {
      if (!this.order)
        return "0.00";
      const orderAmount = this.order.amount;
      if (orderAmount !== null && orderAmount !== void 0 && orderAmount !== "") {
        return Number(orderAmount).toFixed(2);
      }
      return this.calcDishesAmount(this.order.dishes);
    },
    addressInfo() {
      var _a;
      if ((_a = this.order) == null ? void 0 : _a.addressSnapshot) {
        return this.formatAddress(this.order.addressSnapshot);
      }
      return null;
    }
  },
  onLoad() {
    this.orderId = Number(common_vendor.index.getStorageSync("orderId"));
    this.diningMode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    this.loadDetail();
    this.loadBestCoupon();
  },
  methods: {
    goBack() {
      common_vendor.index.navigateBack();
    },
    goAddress() {
      common_vendor.index.navigateTo({ url: "/pages/address/list?select=1" });
    },
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
    async loadBestCoupon() {
      try {
        const result = await api_index.couponApi.bestForOrder(this.orderId);
        if (result && result.hasCoupon) {
          this.couponInfo = result;
          this.selectedCouponId = result.userCouponId;
          this.couponDiscount = Number(result.discountAmount || 0);
        }
      } catch (e) {
        this.couponInfo = null;
        this.selectedCouponId = 0;
        this.couponDiscount = 0;
      }
    },
    onPayMethodChange(channel) {
      this.payChannel = channel;
      this.showPayPicker = false;
    },
    onPayMethodsLoaded(list) {
      this.payMethodList = list || [];
    },
    async handleSubmit() {
      if (!this.payChannel) {
        common_vendor.index.showToast({ title: "请选择支付方式", icon: "none" });
        return;
      }
      this.loading = true;
      try {
        const addressId = common_vendor.index.getStorageSync("addressId") || null;
        await api_index.orderApi.submit({
          orderId: this.orderId,
          remark: this.remark,
          addressId,
          couponId: this.selectedCouponId || null
        });
        await utils_pay_index.payOrder(this.orderId, this.payChannel, "mp");
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
    b: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "fb"),
    c: $options.addressInfo
  }, $options.addressInfo ? {
    d: common_vendor.t($options.addressInfo)
  } : {}, {
    e: common_vendor.o((...args) => $options.goAddress && $options.goAddress(...args), "40"),
    f: common_vendor.f($data.order.dishes, (dish, k0, i0) => {
      return {
        a: dish.image || "/static/placeholder.png",
        b: common_vendor.t(dish.dishName),
        c: common_vendor.t($options.lineAmount(dish)),
        d: dish.id
      };
    }),
    g: common_vendor.t($options.totalAmount),
    h: $data.couponDiscount > 0
  }, $data.couponDiscount > 0 ? {
    i: common_vendor.t($data.couponDiscount.toFixed(2))
  } : {}, {
    j: common_vendor.t($options.finalAmount),
    k: common_vendor.t($options.payChannelText),
    l: common_vendor.o(($event) => $data.showPayPicker = true, "f1"),
    m: $data.remark,
    n: common_vendor.o(($event) => $data.remark = $event.detail.value, "76"),
    o: common_vendor.t($options.finalAmount),
    p: common_vendor.t($data.loading ? "提交中..." : "去支付"),
    q: common_vendor.o((...args) => $options.handleSubmit && $options.handleSubmit(...args), "4b"),
    r: $data.showPayPicker
  }, $data.showPayPicker ? {
    s: common_vendor.o($options.onPayMethodChange, "d1"),
    t: common_vendor.o($options.onPayMethodsLoaded, "d8"),
    v: common_vendor.o(($event) => $data.payChannel = $event, "f6"),
    w: common_vendor.p({
      ["order-id"]: $data.orderId,
      modelValue: $data.payChannel
    }),
    x: common_vendor.o(($event) => $data.showPayPicker = false, "51"),
    y: common_vendor.o(() => {
    }, "a3"),
    z: common_vendor.o(($event) => $data.showPayPicker = false, "56")
  } : {}) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-aaa7ef6e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/cart/confirm.js.map
