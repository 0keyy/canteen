"use strict";
const utils_navbar = require("../utils/navbar.js");
const navPageMixin = {
  data() {
    return {
      navMetrics: utils_navbar.getNavMetrics()
    };
  },
  methods: {
    updateNavMetrics() {
      this.navMetrics = utils_navbar.getNavMetrics();
    }
  },
  onLoad() {
    this.updateNavMetrics();
  },
  onReady() {
    this.updateNavMetrics();
  }
};
exports.navPageMixin = navPageMixin;
//# sourceMappingURL=../../.sourcemap/mp-weixin/mixins/nav-page.js.map
