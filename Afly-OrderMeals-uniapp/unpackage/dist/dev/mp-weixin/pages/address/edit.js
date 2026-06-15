"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      form: {
        id: null,
        contactName: "",
        contactMobile: "",
        province: "",
        city: "",
        district: "",
        detail: "",
        isDefault: 0
      }
    };
  },
  async onLoad(options) {
    if (options.id) {
      const detail = await api_index.addressApi.detail(Number(options.id));
      this.form = { ...detail };
    }
  },
  methods: {
    onDefaultChange(e) {
      this.form.isDefault = e.detail.value ? 1 : 0;
    },
    async save() {
      await api_index.addressApi.save(this.form);
      common_vendor.index.navigateBack();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: $data.form.contactName,
    b: common_vendor.o(($event) => $data.form.contactName = $event.detail.value),
    c: $data.form.contactMobile,
    d: common_vendor.o(($event) => $data.form.contactMobile = $event.detail.value),
    e: $data.form.province,
    f: common_vendor.o(($event) => $data.form.province = $event.detail.value),
    g: $data.form.city,
    h: common_vendor.o(($event) => $data.form.city = $event.detail.value),
    i: $data.form.district,
    j: common_vendor.o(($event) => $data.form.district = $event.detail.value),
    k: $data.form.detail,
    l: common_vendor.o(($event) => $data.form.detail = $event.detail.value),
    m: $data.form.isDefault === 1,
    n: common_vendor.o((...args) => $options.onDefaultChange && $options.onDefaultChange(...args)),
    o: common_vendor.o((...args) => $options.save && $options.save(...args))
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-dcb1f0d8"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/address/edit.js.map
