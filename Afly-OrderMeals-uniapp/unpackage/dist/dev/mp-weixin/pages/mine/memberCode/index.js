"use strict";
const common_vendor = require("../../../common/vendor.js");
const api_index = require("../../../api/index.js");
const _sfc_main = {
  data() {
    return {
      memberId: "",
      nickname: "",
      level: "",
      balance: "",
      avatarKey: "1",
      qrCodeContent: "",
      timer: null
    };
  },
  computed: {
    avatarSrc() {
      return `/static/${this.avatarKey || "1"}.png`;
    }
  },
  onLoad() {
    this.avatarKey = common_vendor.index.getStorageSync("avatarKey") || "1";
    this.loadMemberCode();
    this.timer = setInterval(() => {
      this.refreshQrCode();
    }, 3e4);
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    async loadMemberCode() {
      try {
        const profile = await api_index.authApi.profile();
        if (profile) {
          this.nickname = profile.nickname || profile.name || "会员";
          this.balance = profile.balance != null ? profile.balance : "0.00";
          this.memberId = profile.memberId || profile.id || profile.userId || "";
          this.level = profile.level || "普通会员";
        }
      } catch (e) {
        common_vendor.index.__f__("log", "at pages/mine/memberCode/index.vue:97", "获取用户信息失败", e);
      }
      try {
        const res = await api_index.memberApi.code();
        if (res && res.code === 200 && res.data) {
          const data = res.data;
          if (data.memberId)
            this.memberId = data.memberId;
          if (data.nickname)
            this.nickname = data.nickname;
          if (data.level)
            this.level = data.level;
          if (data.balance != null)
            this.balance = data.balance;
        }
      } catch (e) {
        common_vendor.index.__f__("log", "at pages/mine/memberCode/index.vue:110", "会员码接口暂未开发", e);
      }
      this.refreshQrCode();
    },
    refreshQrCode() {
      if (!this.memberId)
        return;
      const timeStamp = Date.now();
      this.qrCodeContent = `https://你的后端核销接口.com/verify?uid=${this.memberId}&ts=${timeStamp}`;
    },
    goBack() {
      common_vendor.index.navigateBack();
    }
  }
};
if (!Array) {
  const _component_u_qrcode = common_vendor.resolveComponent("u-qrcode");
  _component_u_qrcode();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $options.avatarSrc,
    b: common_vendor.t($data.nickname || "加载中..."),
    c: common_vendor.t($data.level || "会员"),
    d: common_vendor.t($data.memberId || "--"),
    e: $data.qrCodeContent
  }, $data.qrCodeContent ? {
    f: common_vendor.p({
      value: $data.qrCodeContent,
      size: "320"
    })
  } : {}, {
    g: common_vendor.t($data.balance || "0.00")
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-d2b1f0dc"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../../.sourcemap/mp-weixin/pages/mine/memberCode/index.js.map
