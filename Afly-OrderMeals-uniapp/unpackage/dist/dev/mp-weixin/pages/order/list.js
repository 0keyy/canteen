"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const mixins_tabbarPage = require("../../mixins/tabbar-page.js");
const mixins_navPage = require("../../mixins/nav-page.js");
const _sfc_main = {
  mixins: [mixins_tabbarPage.tabbarPageMixin, mixins_navPage.navPageMixin],
  data() {
    return {
      list: []
    };
  },
  computed: {
    headerStyle() {
      const { headerHeight, statusBarHeight } = this.navMetrics;
      return {
        height: `${headerHeight}px`,
        paddingTop: `${statusBarHeight}px`,
        boxSizing: "border-box"
      };
    },
    titleBarStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` };
    }
  },
  onShow() {
    this.updateNavMetrics();
    this.setupTabbar(1);
    this.loadList();
  },
  methods: {
    modeText(mode) {
      return { 1: "堂食", 3: "外卖" }[mode] || "订单";
    },
    statusText(item) {
      if (item.payStatus === 0 || item.status === 4)
        return "待支付";
      if (item.status === 1)
        return "进行中";
      if (item.status === 2)
        return "已完成";
      if (item.status === 3)
        return "已取消";
      return "未知";
    },
    async loadList() {
      try {
        this.list = await api_index.orderApi.list();
      } catch (e) {
        this.list = [];
      }
    },
    goDetail(orderId) {
      common_vendor.index.navigateTo({ url: `/pages/order/detail?orderId=${orderId}` });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.s($options.titleBarStyle),
    b: common_vendor.s($options.headerStyle),
    c: $data.list.length > 0
  }, $data.list.length > 0 ? {
    d: common_vendor.f($data.list, (item, k0, i0) => {
      return common_vendor.e({
        a: common_vendor.t($options.modeText(item.diningMode)),
        b: common_vendor.t($options.statusText(item)),
        c: item.payStatus === 1 ? 1 : "",
        d: item.status === 3 ? 1 : "",
        e: common_vendor.t(item.amount || "0.00"),
        f: common_vendor.t(item.createTime),
        g: item.pickupCode
      }, item.pickupCode ? {
        h: common_vendor.t(item.pickupCode)
      } : {}, {
        i: item.id,
        j: common_vendor.o(($event) => $options.goDetail(item.id), item.id)
      });
    })
  } : {}, {
    e: common_vendor.f(_ctx.tabbarList, (item, index, i0) => {
      return common_vendor.e({
        a: item.selected || item.unselected
      }, item.selected || item.unselected ? {
        b: _ctx.tabbarSelected === index ? item.selected : item.unselected
      } : {}, {
        c: common_vendor.t(item.name),
        d: _ctx.tabbarSelected === index ? _ctx.tabbarSelectedColor : _ctx.tabbarDefaultColor,
        e: index,
        f: common_vendor.o(($event) => _ctx.switchTabbar(item, index), index)
      });
    })
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-456ecf67"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/order/list.js.map
