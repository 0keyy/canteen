"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const common_assets = require("../../common/assets.js");
const _sfc_main = {
  data: function() {
    return {
      navPaddingStyle: {},
      defaultAvatar: "/static/tabbar/avatar-default.png",
      defaultAvatars: [
        "/static/1.png",
        "/static/2.png"
      ],
      form: {
        nickname: "",
        gender: 0,
        birthday: ""
      },
      avatarUrl: "",
      mobile: "",
      saving: false,
      showNicknameModal: false,
      showAvatarModal: false,
      tempNickname: "",
      birthdayPickerVisible: false,
      pickerDate: "2000-01-01"
    };
  },
  computed: {
    maskedPhone: function() {
      if (!this.mobile)
        return "";
      const m = String(this.mobile);
      if (m.length >= 11) {
        return m.substring(0, 3) + "****" + m.substring(7);
      }
      return m;
    },
    genderText: function() {
      if (this.form.gender === 1)
        return "男";
      if (this.form.gender === 2)
        return "女";
      return "请选择";
    }
  },
  onLoad: function() {
    const sysInfo = common_vendor.index.getSystemInfoSync();
    this.navPaddingStyle = { paddingTop: sysInfo.statusBarHeight + "px" };
    this.loadProfile();
  },
  methods: {
    goBack: function() {
      common_vendor.index.navigateBack({
        fail: function() {
          common_vendor.index.switchTab({ url: "/pages/mine/index" });
        }
      });
    },
    loadProfile: function() {
      const self = this;
      api_index.authApi.profile().then(function(res) {
        self.form.nickname = res.nickname || res.userName || "";
        self.form.gender = res.gender || 0;
        self.form.birthday = res.birthday || "";
        self.avatarUrl = res.avatar || res.headImg || "";
        self.mobile = res.mobile || res.phone || "";
        if (self.form.birthday) {
          self.pickerDate = self.form.birthday;
        }
      }).catch(function() {
        self.form.nickname = common_vendor.index.getStorageSync("nickname") || "";
        self.mobile = common_vendor.index.getStorageSync("mobile") || "";
      });
    },
    chooseAvatar: function() {
      this.showAvatarModal = true;
    },
    selectAvatar: function(url) {
      this.avatarUrl = url;
      this.showAvatarModal = false;
    },
    editNickname: function() {
      this.tempNickname = this.form.nickname;
      this.showNicknameModal = true;
    },
    closeNicknameModal: function() {
      this.showNicknameModal = false;
    },
    confirmNickname: function() {
      if (!this.tempNickname.trim()) {
        common_vendor.index.showToast({ title: "昵称不能为空", icon: "none" });
        return;
      }
      this.form.nickname = this.tempNickname.trim();
      this.showNicknameModal = false;
    },
    setGender: function(g) {
      this.form.gender = g;
    },
    onBirthdayChange: function(e) {
      this.form.birthday = e.detail.value;
    },
    saveProfile: function() {
      if (this.saving)
        return;
      this.saving = true;
      const self = this;
      const data = {
        nickname: this.form.nickname,
        gender: this.form.gender,
        birthday: this.form.birthday
      };
      api_index.authApi.updateProfile(data).then(function() {
        common_vendor.index.setStorageSync("nickname", self.form.nickname);
        common_vendor.index.showToast({ title: "保存成功", icon: "success" });
        setTimeout(function() {
          common_vendor.index.navigateBack();
        }, 1500);
      }).catch(function(e) {
        common_vendor.index.showToast({ title: e && e.message || "保存失败", icon: "none" });
      }).finally(function() {
        self.saving = false;
      });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_assets._imports_0$6,
    b: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "c6"),
    c: common_vendor.s(_ctx.navPaddingStyle),
    d: _ctx.avatarUrl || _ctx.defaultAvatar,
    e: common_assets._imports_1$1,
    f: common_vendor.o((...args) => $options.chooseAvatar && $options.chooseAvatar(...args), "3d"),
    g: common_vendor.t(_ctx.form.nickname || "未设置"),
    h: common_vendor.o((...args) => $options.editNickname && $options.editNickname(...args), "fa"),
    i: common_vendor.t($options.maskedPhone || "未绑定"),
    j: _ctx.form.gender === 1
  }, _ctx.form.gender === 1 ? {} : {}, {
    k: common_vendor.n(_ctx.form.gender === 1 ? "profile-page__radio--checked" : ""),
    l: common_vendor.o(($event) => $options.setGender(1), "1d"),
    m: _ctx.form.gender === 2
  }, _ctx.form.gender === 2 ? {} : {}, {
    n: common_vendor.n(_ctx.form.gender === 2 ? "profile-page__radio--checked" : ""),
    o: common_vendor.o(($event) => $options.setGender(2), "46"),
    p: common_vendor.t(_ctx.form.birthday || "请选择"),
    q: _ctx.form.birthday || "2000-01-01",
    r: common_vendor.o((...args) => $options.onBirthdayChange && $options.onBirthdayChange(...args), "a0"),
    s: _ctx.showAvatarModal
  }, _ctx.showAvatarModal ? {
    t: common_vendor.f(_ctx.defaultAvatars, (item, idx, i0) => {
      return common_vendor.e({
        a: item,
        b: _ctx.avatarUrl === item
      }, _ctx.avatarUrl === item ? {
        c: common_assets._imports_2
      } : {}, {
        d: idx,
        e: common_vendor.n(_ctx.avatarUrl === item ? "profile-page__avatar-grid-item--active" : ""),
        f: common_vendor.o(($event) => $options.selectAvatar(item), idx)
      });
    }),
    v: common_vendor.o(($event) => _ctx.showAvatarModal = false, "c6"),
    w: common_vendor.o(() => {
    }, "1b"),
    x: common_vendor.o(($event) => _ctx.showAvatarModal = false, "c3")
  } : {}, {
    y: _ctx.saving,
    z: common_vendor.o((...args) => $options.saveProfile && $options.saveProfile(...args), "9f"),
    A: _ctx.showNicknameModal
  }, _ctx.showNicknameModal ? {
    B: _ctx.tempNickname,
    C: common_vendor.o(($event) => _ctx.tempNickname = $event.detail.value, "d9"),
    D: common_vendor.o((...args) => $options.closeNicknameModal && $options.closeNicknameModal(...args), "ea"),
    E: common_vendor.o((...args) => $options.confirmNickname && $options.confirmNickname(...args), "59"),
    F: common_vendor.o(() => {
    }, "80"),
    G: common_vendor.o((...args) => $options.closeNicknameModal && $options.closeNicknameModal(...args), "b5")
  } : {});
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-935803c6"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/mine/profile.js.map
