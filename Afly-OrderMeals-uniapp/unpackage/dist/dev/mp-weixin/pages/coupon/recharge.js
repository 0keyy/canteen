"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_image = require("../../utils/image.js");
const utils_pay_weixin = require("../../utils/pay/weixin.js");
const _sfc_main = {
  data() {
    return {
      staticImgPrefix: utils_image.STATIC_IMAGE_PREFIX,
      balance: 0,
      selectedAmount: 10,
      amountOptions: [10, 20, 50, 100, 200, 500],
      isCustom: false,
      customAmount: ""
    };
  },
  computed: {
    formatBalance() {
      return Number(this.balance || 0).toFixed(2);
    },
    finalAmount() {
      if (this.isCustom) {
        const n = parseFloat(this.customAmount);
        return !isNaN(n) && n > 0 ? n : 0;
      }
      return this.selectedAmount;
    }
  },
  onLoad() {
    this.loadBalance();
  },
  onShow() {
    this.loadBalance();
  },
  methods: {
    async loadBalance() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile && profile.balance != null) {
          this.balance = profile.balance;
        }
      } catch (e) {
        this.balance = 0;
      }
    },
    selectPreset(amount) {
      this.isCustom = false;
      this.selectedAmount = amount;
    },
    selectCustom() {
      this.isCustom = true;
    },
    onCustomBlur() {
      if (!this.customAmount || parseFloat(this.customAmount) <= 0) {
        this.isCustom = false;
        this.customAmount = "";
      }
    },
    async onRecharge() {
      const amount = this.finalAmount;
      if (!amount || amount <= 0) {
        common_vendor.index.showToast({ title: "请选择或输入充值金额", icon: "none" });
        return;
      }
      try {
        const res = await api_index.walletApi.rechargeCreate(amount);
        if (res && res.outTradeNo) {
          const payInfo = await api_index.payApi.create({
            outTradeNo: res.outTradeNo,
            payChannel: "balance",
            payScene: "mp"
          });
          if (payInfo.completed) {
            common_vendor.index.showToast({ title: "充值成功", icon: "success" });
            this.loadBalance();
            return;
          }
          if (payInfo.mockPay) {
            await api_index.payApi.mockSuccess(payInfo.outTradeNo);
            common_vendor.index.showToast({ title: "充值成功", icon: "success" });
            this.loadBalance();
            return;
          }
          await utils_pay_weixin.wxPay(payInfo);
          common_vendor.index.showToast({ title: "充值成功", icon: "success" });
          this.loadBalance();
        }
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e || "充值失败", icon: "none" });
      }
    },
    goRecord() {
      common_vendor.index.showToast({ title: "明细功能开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.staticImgPrefix + "/tabbar/充值金额 1.png",
    b: common_vendor.t($options.formatBalance),
    c: common_vendor.f($data.amountOptions, (item, index, i0) => {
      return {
        a: common_vendor.t(item),
        b: index,
        c: !$data.isCustom && $data.selectedAmount === item ? 1 : "",
        d: common_vendor.o(($event) => $options.selectPreset(item), index)
      };
    }),
    d: $data.isCustom
  }, $data.isCustom ? {
    e: $data.isCustom,
    f: common_vendor.o((...args) => $options.onCustomBlur && $options.onCustomBlur(...args), "f0"),
    g: $data.customAmount,
    h: common_vendor.o(($event) => $data.customAmount = $event.detail.value, "f6")
  } : {}, {
    i: $data.isCustom ? 1 : "",
    j: common_vendor.o((...args) => $options.selectCustom && $options.selectCustom(...args), "52"),
    k: common_vendor.o((...args) => $options.onRecharge && $options.onRecharge(...args), "96"),
    l: common_vendor.o((...args) => $options.goRecord && $options.goRecord(...args), "f0")
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-c45a7485"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/coupon/recharge.js.map
