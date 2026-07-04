"use strict";
const utils_image = require("../../utils/image.js");
const common_vendor = require("../../common/vendor.js");
const _sfc_main = {
  props: {
    menu: {
      type: Array,
      default: () => []
    },
    activeIndex: {
      type: Number,
      default: 0
    },
    cartMap: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      staticImgPrefix: utils_image.STATIC_IMAGE_PREFIX
    };
  },
  emits: ["select"],
  methods: {
    badgeCount(index) {
      var _a;
      const foods = ((_a = this.menu[index]) == null ? void 0 : _a.foods) || [];
      return foods.reduce((sum, food) => {
        var _a2;
        return sum + (((_a2 = this.cartMap[String(food.id)]) == null ? void 0 : _a2.count) || 0);
      }, 0);
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.f($props.menu, (cate, index, i0) => {
      return common_vendor.e({
        a: $props.activeIndex === index
      }, $props.activeIndex === index ? {} : {}, {
        b: index === 0
      }, index === 0 ? {
        c: $data.staticImgPrefix + "/tabbar/爱心 _实心 1.png"
      } : {}, {
        d: common_vendor.t(index === 0 ? "猜你喜欢" : cate.name),
        e: common_vendor.n($props.activeIndex === index ? "sidebar__name--active" : ""),
        f: $options.badgeCount(index) > 0
      }, $options.badgeCount(index) > 0 ? {
        g: common_vendor.t($options.badgeCount(index))
      } : {}, {
        h: cate.id || cate.name || index,
        i: common_vendor.n($props.activeIndex === index ? "sidebar__item--active" : ""),
        j: common_vendor.o(($event) => _ctx.$emit("select", index), cate.id || cate.name || index)
      });
    })
  };
}
const Component = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-75257acb"]]);
wx.createComponent(Component);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/components/menu-category-sidebar/menu-category-sidebar.js.map
