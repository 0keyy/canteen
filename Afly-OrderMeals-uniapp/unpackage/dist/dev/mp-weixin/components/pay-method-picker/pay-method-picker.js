"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_pay_channels = require("../../utils/pay/channels.js");
const _sfc_main = {
  name: "PayMethodPicker",
  props: {
    orderId: {
      type: Number,
      required: true
    },
    value: {
      type: String,
      default: utils_pay_channels.DEFAULT_PAY_CHANNEL
    }
  },
  data() {
    return {
      methods: [],
      selected: this.value || utils_pay_channels.DEFAULT_PAY_CHANNEL
    };
  },
  watch: {
    orderId: {
      immediate: true,
      handler(val) {
        if (val)
          this.loadMethods();
      }
    },
    value(val) {
      this.selected = val;
    }
  },
  methods: {
    itemDesc(item) {
      if (item.channel === "balance" && item.balance !== void 0) {
        return `可用余额 ${item.balance}，本次需 ${item.requiredBalance || 0}`;
      }
      return item.desc || "";
    },
    async loadMethods() {
      if (!this.orderId)
        return;
      try {
        const list = await api_index.payApi.methods(this.orderId);
        this.methods = Array.isArray(list) ? list : [];
        const enabled = this.methods.find((m) => m.channel === this.selected && m.enabled);
        if (!enabled) {
          const fallback = this.methods.find((m) => m.enabled);
          if (fallback) {
            this.selectChannel(fallback.channel);
          }
        }
        this.$emit("loaded", this.methods);
      } catch (e) {
        this.methods = [];
      }
    },
    onSelect(item) {
      if (!item.enabled) {
        common_vendor.index.showToast({ title: item.disabledReason || "该支付方式不可用", icon: "none" });
        return;
      }
      this.selectChannel(item.channel);
    },
    selectChannel(channel) {
      this.selected = channel;
      this.$emit("input", channel);
      this.$emit("change", channel);
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.f($data.methods, (item, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t(item.name),
        b: common_vendor.t($options.itemDesc(item)),
        c: item.channel === $data.selected && item.enabled
      }, item.channel === $data.selected && item.enabled ? {} : !item.enabled ? {
        e: common_vendor.t(item.disabledReason || "不可用")
      } : {}, {
        d: !item.enabled,
        f: item.channel,
        g: common_vendor.n({
          "pay-picker__item--disabled": !item.enabled,
          "pay-picker__item--active": item.channel === $data.selected
        }),
        h: common_vendor.o(($event) => $options.onSelect(item), item.channel)
      });
    })
  };
}
const Component = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-cde544f7"]]);
wx.createComponent(Component);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/components/pay-method-picker/pay-method-picker.js.map
