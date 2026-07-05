"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const _sfc_main = {
  data() {
    return {
      list: [],
      selectMode: false
    };
  },
  onLoad(options) {
    this.selectMode = options.select === "1";
  },
  onShow() {
    this.loadList();
  },
  methods: {
    async loadList() {
      this.list = await api_index.addressApi.list();
    },
    choose(item) {
      if (!this.selectMode)
        return;
      common_vendor.index.setStorageSync("diningMode", 3);
      common_vendor.index.setStorageSync("addressId", item.id);
      common_vendor.index.switchTab({ url: "/pages/menu/index" });
    },
    edit(item) {
      const id = (item == null ? void 0 : item.id) || "";
      common_vendor.index.navigateTo({ url: `/pages/address/edit?id=${id}` });
    },
    async remove(id) {
      await api_index.addressApi.delete(id);
      this.loadList();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.f($data.list, (item, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t(item.contactName),
        b: common_vendor.t(item.contactMobile),
        c: item.isDefault === 1
      }, item.isDefault === 1 ? {} : {}, {
        d: common_vendor.t(item.fullAddress),
        e: common_vendor.o(($event) => $options.edit(item), item.id),
        f: common_vendor.o(($event) => $options.remove(item.id), item.id),
        g: item.id,
        h: common_vendor.o(($event) => $options.choose(item), item.id)
      });
    }),
    b: $data.list.length === 0
  }, $data.list.length === 0 ? {
    c: _ctx.STATIC_IMAGE_PREFIX + "/开心呢.png"
  } : {}, {
    d: common_vendor.o(($event) => $options.edit(), "02")
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-90a3874e"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/address/list.js.map
