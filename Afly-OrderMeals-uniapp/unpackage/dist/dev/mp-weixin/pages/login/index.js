"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_auth_index = require("../../utils/auth/index.js");
const PageLoading = () => "../../components/page-loading/page-loading.js";
const _sfc_main = {
  components: { PageLoading },
  data() {
    return {
      loading: false,
      pageLoading: false,
      pageLoadingTip: "加载中...",
      mobile: "",
      smsCode: "",
      countdown: 0,
      timer: null
    };
  },
  methods: {
    goHome() {
      this.goWithLoading("/pages/index/index", "switchTab");
    },
    async handleWxLogin() {
      this.loading = true;
      try {
        const loginRes = await new Promise((resolve, reject) => {
          common_vendor.index.login({ provider: "weixin", success: resolve, fail: reject });
        });
        if (!loginRes.code) {
          throw new Error("微信授权失败，请重试");
        }
        const result = await api_index.authApi.wxLogin(loginRes.code);
        if (!result.token) {
          throw new Error("登录失败，请检查小程序 AppID 与后端配置是否一致");
        }
        utils_auth_index.saveLoginResult(result);
        this.goHome();
      } catch (err) {
        common_vendor.index.showToast({ title: err.message || err, icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    async handleAliLogin() {
      this.loading = true;
      try {
        const authCode = await new Promise((resolve, reject) => {
          my.getAuthCode({ scopes: ["auth_user"], success: (res) => resolve(res.authCode), fail: reject });
        });
        let result = await api_index.authApi.aliLogin(authCode);
        if (result.needBindPhone) {
          result = await api_index.authApi.aliPhone(authCode);
        }
        utils_auth_index.saveLoginResult(result);
        this.goHome();
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    async sendSms() {
      if (!/^1\d{10}$/.test(this.mobile)) {
        common_vendor.index.showToast({ title: "请输入正确手机号", icon: "none" });
        return;
      }
      await api_index.authApi.smsSend(this.mobile);
      this.countdown = 60;
      this.timer = setInterval(() => {
        this.countdown -= 1;
        if (this.countdown <= 0) {
          clearInterval(this.timer);
        }
      }, 1e3);
      common_vendor.index.showToast({ title: "验证码已发送", icon: "none" });
    },
    async handleSmsLogin() {
      if (!this.mobile || !this.smsCode) {
        common_vendor.index.showToast({ title: "请填写手机号和验证码", icon: "none" });
        return;
      }
      this.loading = true;
      try {
        const result = await api_index.authApi.smsLogin(this.mobile, this.smsCode);
        utils_auth_index.saveLoginResult(result);
        this.goHome();
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    goWithLoading(url, type = "navigateTo", tip = "加载中...") {
      this.pageLoadingTip = tip;
      this.pageLoading = true;
      setTimeout(() => {
        if (type === "switchTab") {
          common_vendor.index.switchTab({ url });
        } else if (type === "reLaunch") {
          common_vendor.index.reLaunch({ url });
        } else if (type === "redirectTo") {
          common_vendor.index.redirectTo({ url });
        } else if (type === "navigateBack") {
          common_vendor.index.navigateBack();
        } else {
          common_vendor.index.navigateTo({ url });
        }
        setTimeout(() => {
          this.pageLoading = false;
        }, 500);
      }, 100);
    }
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
};
if (!Array) {
  const _easycom_page_loading2 = common_vendor.resolveComponent("page-loading");
  _easycom_page_loading2();
}
const _easycom_page_loading = () => "../../components/page-loading/page-loading.js";
if (!Math) {
  _easycom_page_loading();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: $data.loading,
    b: common_vendor.o((...args) => $options.handleWxLogin && $options.handleWxLogin(...args), "87"),
    c: common_vendor.p({
      visible: $data.pageLoading,
      tip: $data.pageLoadingTip
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-d08ef7d4"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/login/index.js.map
