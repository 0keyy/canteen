"use strict";
const common_vendor = require("../common/vendor.js");
const api_index = require("../api/index.js");
const utils_image = require("../utils/image.js");
const utils_tabbar = require("../utils/tabbar.js");
const tabbarPageMixin = {
  data() {
    return {
      tabbarSelected: 0,
      tabbarDefaultColor: "#999999",
      tabbarSelectedColor: "#FF6B35",
      tabbarList: utils_tabbar.getDefaultTabbar().list
    };
  },
  methods: {
    setupTabbar(selectedIndex) {
      utils_tabbar.hideNativeTabBar();
      this.tabbarSelected = selectedIndex;
      this.loadTabbar();
    },
    async loadTabbar() {
      var _a, _b;
      const cached = common_vendor.index.getStorageSync("tabbarConfig");
      if ((_a = cached == null ? void 0 : cached.list) == null ? void 0 : _a.length) {
        this.applyTabbarConfig(cached);
      }
      try {
        const data = await api_index.decorateApi.tabbar();
        const list = utils_tabbar.filterTabbarList((data == null ? void 0 : data.list) || []);
        if (list.length >= 2) {
          const config = {
            style: (data == null ? void 0 : data.style) || {},
            list
          };
          common_vendor.index.setStorageSync("tabbarConfig", config);
          this.applyTabbarConfig(config);
        }
      } catch (e) {
        if (!((_b = cached == null ? void 0 : cached.list) == null ? void 0 : _b.length)) {
          this.applyTabbarConfig(utils_tabbar.getDefaultTabbar());
        }
      }
    },
    applyTabbarConfig(config) {
      const style = (config == null ? void 0 : config.style) || {};
      this.tabbarDefaultColor = style.defaultColor || "#999999";
      this.tabbarSelectedColor = style.selectedColor || "#FF6B35";
      const list = config.list || utils_tabbar.getDefaultTabbar().list;
      this.tabbarList = list.map((item) => {
        var _a, _b;
        return {
          ...item,
          pagePath: utils_tabbar.normalizeTabPath(((_a = item == null ? void 0 : item.link) == null ? void 0 : _a.path) || ((_b = item == null ? void 0 : item.link) == null ? void 0 : _b.url) || (item == null ? void 0 : item.pagePath) || ""),
          selected: utils_image.resolveImageUrl(item.selected),
          unselected: utils_image.resolveImageUrl(item.unselected)
        };
      });
    },
    switchTabbar(item, index) {
      var _a, _b;
      const path = utils_tabbar.normalizeTabPath(((_a = item == null ? void 0 : item.link) == null ? void 0 : _a.path) || ((_b = item == null ? void 0 : item.link) == null ? void 0 : _b.url) || (item == null ? void 0 : item.pagePath));
      if (!path)
        return;
      if (this.tabbarSelected === index)
        return;
      common_vendor.index.switchTab({
        url: `/${path}`,
        fail: () => {
          common_vendor.index.reLaunch({ url: `/${path}` });
        }
      });
    }
  }
};
exports.tabbarPageMixin = tabbarPageMixin;
//# sourceMappingURL=../../.sourcemap/mp-weixin/mixins/tabbar-page.js.map
