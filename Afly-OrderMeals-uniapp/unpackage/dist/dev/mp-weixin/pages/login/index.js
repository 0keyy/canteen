"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const utils_auth_index = require("../../utils/auth/index.js");
const utils_config = require("../../utils/config.js");
const _sfc_main = {
  data() {
    return {
      loading: false,
      mockLogin: utils_config.MOCK_LOGIN,
      mobile: utils_config.DEFAULT_MOCK_MOBILE,
      smsCode: "",
      countdown: 0,
      timer: null
    };
  },
  methods: {
    goHome() {
      common_vendor.index.switchTab({ url: "/pages/index/index" });
    },
    async handleMockLogin() {
      if (!/^1\d{10}$/.test(this.mobile)) {
        common_vendor.index.showToast({ title: "请输入正确手机号", icon: "none" });
        return;
      }
      this.loading = true;
      try {
        const result = await api_index.authApi.mockPhoneLogin(this.mobile);
        utils_auth_index.saveLoginResult(result);
        this.goHome();
      } catch (e) {
        common_vendor.index.showToast({ title: e.message || e, icon: "none" });
      } finally {
        this.loading = false;
      }
    },
    async handleWxOneClickLogin(e) {
      if (!e.detail.code) {
        common_vendor.index.showToast({ title: "用户取消授权", icon: "none" });
        return;
      }
      this.loading = true;
      try {
        const loginRes = await new Promise((resolve, reject) => {
          common_vendor.index.login({ provider: "weixin", success: resolve, fail: reject });
        });
        const wxLogin = await api_index.authApi.wxLogin(loginRes.code);
        if (wxLogin.token && !wxLogin.needBindPhone) {
          utils_auth_index.saveLoginResult(wxLogin);
          this.goHome();
          return;
        }
        const result = await api_index.authApi.wxPhone(wxLogin.openid, e.detail.code);
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
    }
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.mockLogin
  }, $data.mockLogin ? {
    b: $data.mobile,
    c: common_vendor.o(($event) => $data.mobile = $event.detail.value, "88"),
    d: $data.loading,
    e: common_vendor.o((...args) => $options.handleMockLogin && $options.handleMockLogin(...args), "62")
  } : {
    f: $data.loading,
    g: common_vendor.o((...args) => $options.handleWxOneClickLogin && $options.handleWxOneClickLogin(...args), "34")
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-d08ef7d4"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/login/index.js.map
