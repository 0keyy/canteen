"use strict";
const common_vendor = require("../../common/vendor.js");
const common_assets = require("../../common/assets.js");
const MIN_DURATION = 300;
const _sfc_main = {
  name: "PageLoading",
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    tip: {
      type: String,
      default: ""
    }
  },
  data() {
    return {
      showContent: false,
      progress: 0,
      startTime: 0,
      progressTimer: null,
      localTip: ""
    };
  },
  watch: {
    visible(val) {
      if (val) {
        this.doShow();
      } else {
        this.doHide();
      }
    },
    tip(val) {
      this.localTip = val;
    }
  },
  mounted() {
    this.localTip = this.tip;
    common_vendor.index.$on("__global_loading_show__", this.onGlobalShow);
    common_vendor.index.$on("__global_loading_hide__", this.onGlobalHide);
  },
  beforeUnmount() {
    common_vendor.index.$off("__global_loading_show__", this.onGlobalShow);
    common_vendor.index.$off("__global_loading_hide__", this.onGlobalHide);
    this.clearTimers();
  },
  methods: {
    doShow() {
      this.showContent = true;
      this.progress = 0;
      this.startTime = Date.now();
      this.startProgress();
    },
    doHide() {
      const elapsed = Date.now() - this.startTime;
      const remaining = MIN_DURATION - elapsed;
      if (remaining > 0) {
        setTimeout(() => {
          this.finishProgress();
        }, remaining);
      } else {
        this.finishProgress();
      }
    },
    startProgress() {
      this.clearTimers();
      let p = 0;
      this.progressTimer = setInterval(() => {
        p += Math.random() * 15 + 5;
        if (p >= 90) {
          p = 90;
          clearInterval(this.progressTimer);
          this.progressTimer = null;
        }
        this.progress = Math.min(p, 90);
      }, 200);
    },
    finishProgress() {
      this.clearTimers();
      this.progress = 100;
      setTimeout(() => {
        this.showContent = false;
        this.progress = 0;
      }, 150);
    },
    clearTimers() {
      if (this.progressTimer) {
        clearInterval(this.progressTimer);
        this.progressTimer = null;
      }
    },
    onGlobalShow(tip) {
      if (tip)
        this.localTip = tip;
      this.doShow();
    },
    onGlobalHide() {
      this.doHide();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.showContent
  }, $data.showContent ? common_vendor.e({
    b: common_assets._imports_0$1,
    c: $data.progress + "%",
    d: $data.localTip
  }, $data.localTip ? {
    e: common_vendor.t($data.localTip)
  } : {}, {
    f: common_vendor.o(() => {
    }, "5e")
  }) : {});
}
const Component = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-e598955a"]]);
wx.createComponent(Component);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/components/page-loading/page-loading.js.map
