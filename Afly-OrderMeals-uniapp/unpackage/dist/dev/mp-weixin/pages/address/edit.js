"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      form: {
        id: null,
        companyName: "",
        address: "",
        province: "",
        city: "",
        district: "",
        detail: "",
        contactName: "",
        contactMobile: "",
        isDefault: 0
      },
      gender: ""
    };
  },
  async onLoad(options) {
    if (options.id) {
      const detail = await api_index.addressApi.detail(Number(options.id));
      this.form = { ...detail };
      this.extractGender();
    }
  },
  methods: {
    goBack() {
      common_vendor.index.navigateBack();
    },
    extractGender() {
      if (this.form.contactName) {
        if (this.form.contactName.endsWith("先生")) {
          this.gender = "先生";
          this.form.contactName = this.form.contactName.replace("先生", "");
        } else if (this.form.contactName.endsWith("女士")) {
          this.gender = "女士";
          this.form.contactName = this.form.contactName.replace("女士", "");
        }
      }
    },
    selectGender(gender) {
      this.gender = gender;
    },
    onDefaultChange(e) {
      this.form.isDefault = e.detail.value ? 1 : 0;
    },
    selectAddress() {
      common_vendor.index.showToast({ title: "地址选择功能开发中", icon: "none" });
    },
    buildContactName() {
      if (this.form.contactName && this.gender) {
        return this.form.contactName + this.gender;
      }
      return this.form.contactName;
    },
    async save() {
      const originalName = this.form.contactName;
      this.form.contactName = this.buildContactName();
      await api_index.addressApi.save(this.form);
      this.form.contactName = originalName;
      common_vendor.index.navigateBack();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "d0"),
    b: common_vendor.t($data.form.companyName || "请选择地址"),
    c: common_vendor.t($data.form.address || "请选择详细地址"),
    d: common_vendor.o((...args) => $options.selectAddress && $options.selectAddress(...args), "f5"),
    e: $data.form.detail,
    f: common_vendor.o(($event) => $data.form.detail = $event.detail.value, "b4"),
    g: $data.form.contactName,
    h: common_vendor.o(($event) => $data.form.contactName = $event.detail.value, "ff"),
    i: $data.gender === "先生" ? 1 : "",
    j: common_vendor.o(($event) => $options.selectGender("先生"), "bc"),
    k: $data.gender === "女士" ? 1 : "",
    l: common_vendor.o(($event) => $options.selectGender("女士"), "c0"),
    m: $data.form.contactMobile,
    n: common_vendor.o(($event) => $data.form.contactMobile = $event.detail.value, "d7"),
    o: $data.form.isDefault === 1,
    p: common_vendor.o((...args) => $options.onDefaultChange && $options.onDefaultChange(...args), "b2"),
    q: common_vendor.o((...args) => $options.save && $options.save(...args), "8c")
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-dcb1f0d8"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/address/edit.js.map
