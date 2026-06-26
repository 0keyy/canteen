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
    a: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "ad"),
    b: $data.form.contactName,
    c: common_vendor.o(($event) => $data.form.contactName = $event.detail.value, "ba"),
    d: $data.gender === "先生" ? 1 : "",
    e: common_vendor.o(($event) => $options.selectGender("先生"), "fb"),
    f: $data.gender === "女士" ? 1 : "",
    g: common_vendor.o(($event) => $options.selectGender("女士"), "68"),
    h: $data.form.contactMobile,
    i: common_vendor.o(($event) => $data.form.contactMobile = $event.detail.value, "25"),
    j: $data.form.province,
    k: common_vendor.o(($event) => $data.form.province = $event.detail.value, "bc"),
    l: $data.form.city,
    m: common_vendor.o(($event) => $data.form.city = $event.detail.value, "e7"),
    n: $data.form.district,
    o: common_vendor.o(($event) => $data.form.district = $event.detail.value, "1a"),
    p: $data.form.detail,
    q: common_vendor.o(($event) => $data.form.detail = $event.detail.value, "e0"),
    r: $data.form.isDefault === 1,
    s: common_vendor.o((...args) => $options.onDefaultChange && $options.onDefaultChange(...args), "0f"),
    t: common_vendor.o((...args) => $options.save && $options.save(...args), "1a")
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-dcb1f0d8"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/address/edit.js.map
