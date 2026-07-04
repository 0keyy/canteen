"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const DeptTreePicker = () => "../../components/dept-tree-picker/dept-tree-picker.js";
const _sfc_main = {
  components: { DeptTreePicker },
  data() {
    return {
      verified: false,
      authInfo: {},
      deptList: [],
      form: {
        deptId: null,
        username: "",
        password: ""
      },
      submitting: false
    };
  },
  async onLoad() {
    await this.loadData();
  },
  methods: {
    async loadData() {
      try {
        common_vendor.index.showLoading({ title: "加载中", mask: true });
        const status = await api_index.companyApi.status();
        this.authInfo = status || {};
        this.verified = !!(status == null ? void 0 : status.verified);
        if (!this.verified) {
          this.deptList = await api_index.companyApi.deptList() || [];
        }
      } catch (e) {
        const message = typeof e === "string" ? e : (e == null ? void 0 : e.msg) || (e == null ? void 0 : e.message) || "加载失败";
        common_vendor.index.showToast({ title: message, icon: "none" });
      } finally {
        common_vendor.index.hideLoading();
      }
    },
    onDeptSelect(dept) {
      this.form.deptId = dept ? dept.deptId : null;
    },
    async submit() {
      if (this.verified) {
        common_vendor.index.showToast({ title: "您已完成公司认证", icon: "none" });
        return;
      }
      if (this.form.deptId == null) {
        common_vendor.index.showToast({ title: "请选择部门", icon: "none" });
        return;
      }
      if (!this.form.username.trim()) {
        common_vendor.index.showToast({ title: "请输入用户名", icon: "none" });
        return;
      }
      if (!this.form.password) {
        common_vendor.index.showToast({ title: "请输入密码", icon: "none" });
        return;
      }
      if (this.submitting)
        return;
      this.submitting = true;
      try {
        const result = await api_index.companyApi.auth({
          deptId: this.form.deptId,
          username: this.form.username.trim(),
          password: this.form.password
        });
        this.authInfo = result || {};
        this.verified = true;
        this.form.password = "";
        common_vendor.index.setStorageSync("companyVerified", true);
        common_vendor.index.setStorageSync("companyDeptName", (result == null ? void 0 : result.deptName) || "");
        const granted = (result == null ? void 0 : result.balanceGranted) || 0;
        common_vendor.index.showToast({
          title: granted > 0 ? `认证成功，余额+${granted}` : "认证成功",
          icon: "success"
        });
      } catch (e) {
        const message = typeof e === "string" ? e : (e == null ? void 0 : e.msg) || (e == null ? void 0 : e.message) || "认证失败";
        common_vendor.index.showModal({
          title: "认证失败",
          content: message,
          showCancel: false
        });
      } finally {
        this.submitting = false;
      }
    }
  }
};
if (!Array) {
  const _easycom_dept_tree_picker2 = common_vendor.resolveComponent("dept-tree-picker");
  _easycom_dept_tree_picker2();
}
const _easycom_dept_tree_picker = () => "../../components/dept-tree-picker/dept-tree-picker.js";
if (!Math) {
  _easycom_dept_tree_picker();
}
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: $data.verified
  }, $data.verified ? {
    b: common_vendor.t($data.authInfo.deptName || "-"),
    c: common_vendor.t($data.authInfo.userName || "-"),
    d: common_vendor.t($data.authInfo.nickName || "-")
  } : {
    e: common_vendor.o($options.onDeptSelect, "16"),
    f: common_vendor.o(($event) => $data.form.deptId = $event, "9b"),
    g: common_vendor.p({
      ["dept-list"]: $data.deptList,
      placeholder: "请选择部门",
      modelValue: $data.form.deptId
    }),
    h: $data.form.username,
    i: common_vendor.o(($event) => $data.form.username = $event.detail.value, "1a"),
    j: $data.form.password,
    k: common_vendor.o(($event) => $data.form.password = $event.detail.value, "b0")
  }, {
    l: !$data.verified
  }, !$data.verified ? {
    m: $data.submitting,
    n: common_vendor.o((...args) => $options.submit && $options.submit(...args), "73")
  } : {}, {
    o: $data.verified ? 1 : ""
  });
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-431fd8fd"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/mine/company-auth.js.map
