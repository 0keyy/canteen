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
      couponDiscount: 0
    };
  },
  computed: {
    diningModeText() {
      return { 1: "堂食", 3: "外卖配送" }[this.diningMode] || "堂食";
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
    }
  },
  onLoad() {
    this.orderId = Number(common_vendor.index.getStorageSync("orderId"));
    this.diningMode = Number(common_vendor.index.getStorageSync("diningMode") || 1);
    this.loadDetail();
    this.loadBestCoupon();
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
    goCouponCenter() {
      common_vendor.index.navigateTo({ url: "/pages/coupon/center" });
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
    j: common_vendor.o((...args) => $options.goCouponCenter && $options.goCouponCenter(...args)),
    k: $data.couponInfo
  }, $data.couponInfo ? {
    l: common_vendor.t($data.couponInfo.templateName),
    m: common_vendor.t($data.couponInfo.discountAmount)
  } : {}, {
    n: common_vendor.o(($event) => $data.payChannel = $event),
    o: common_vendor.p({
      ["order-id"]: $data.orderId,
      modelValue: $data.payChannel
    }),
    p: $data.remark,
    q: common_vendor.o(($event) => $data.remark = $event.detail.value),
    r: common_vendor.t($options.finalAmount),
    s: $data.couponDiscount > 0
  }, $data.couponDiscount > 0 ? {
    t: common_vendor.t($data.couponDiscount.toFixed(2))
  } : {}, {
    v: common_vendor.t($data.loading ? "提交中..." : "提交并支付"),
    w: common_vendor.o((...args) => $options.handleSubmit && $options.handleSubmit(...args))
  }) : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-aaa7ef6e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/cart/confirm.js.map
