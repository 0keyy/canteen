"use strict";
const common_vendor = require("../../common/vendor.js");
const utils_deptTree = require("../../utils/dept-tree.js");
const _sfc_main = {
  name: "DeptTreePicker",
  props: {
    modelValue: {
      type: [Number, String],
      default: null
    },
    deptList: {
      type: Array,
      default: () => []
    },
    placeholder: {
      type: String,
      default: "请选择部门"
    }
  },
  emits: ["update:modelValue", "change"],
  data() {
    return {
      visible: false,
      expandedIds: {},
      innerValue: null
    };
  },
  computed: {
    currentValue() {
      return this.innerValue != null ? this.innerValue : this.modelValue;
    },
    tree() {
      return utils_deptTree.buildDeptTree(this.deptList);
    },
    visibleList() {
      return utils_deptTree.flattenDeptTree(this.tree, this.expandedIds);
    },
    displayName() {
      const dept = utils_deptTree.findDeptById(this.deptList, this.currentValue);
      return dept ? dept.deptName : "";
    }
  },
  watch: {
    modelValue(val) {
      this.innerValue = val;
    },
    deptList: {
      immediate: true,
      handler(list) {
        if (Array.isArray(list) && list.length > 0) {
          this.expandedIds = utils_deptTree.collectAllExpanded(utils_deptTree.buildDeptTree(list));
        }
      }
    }
  },
  methods: {
    isSelected(deptId) {
      return Number(this.currentValue) === Number(deptId);
    },
    rowPadding(level) {
      return `${24 + level * 32}rpx`;
    },
    isExpanded(deptId) {
      return !!this.expandedIds[String(deptId)];
    },
    toggleExpand(deptId) {
      const key = String(deptId);
      const next = { ...this.expandedIds };
      if (next[key]) {
        delete next[key];
      } else {
        next[key] = true;
      }
      this.expandedIds = next;
    },
    openPopup() {
      if (!this.deptList.length) {
        common_vendor.index.showToast({ title: "暂无部门数据", icon: "none" });
        return;
      }
      this.expandedIds = utils_deptTree.collectAllExpanded(this.tree);
      this.visible = true;
    },
    closePopup() {
      this.visible = false;
    },
    onSelect(item) {
      if (!item || item.deptId == null)
        return;
      this.innerValue = item.deptId;
      this.$emit("update:modelValue", item.deptId);
      this.$emit("change", item);
      this.closePopup();
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return common_vendor.e({
    a: common_vendor.t($options.displayName || $props.placeholder),
    b: !$options.displayName ? 1 : "",
    c: common_vendor.o((...args) => $options.openPopup && $options.openPopup(...args)),
    d: $data.visible
  }, $data.visible ? common_vendor.e({
    e: common_vendor.o((...args) => $options.closePopup && $options.closePopup(...args)),
    f: common_vendor.o((...args) => $options.closePopup && $options.closePopup(...args)),
    g: common_vendor.f($options.visibleList, (item, k0, i0) => {
      return common_vendor.e({
        a: item.hasChildren
      }, item.hasChildren ? {
        b: common_vendor.n({
          "dept-picker__expand-icon--open": $options.isExpanded(item.deptId)
        }),
        c: common_vendor.o(($event) => $options.toggleExpand(item.deptId), item.deptId)
      } : {}, {
        d: common_vendor.t(item.deptName),
        e: $options.isSelected(item.deptId)
      }, $options.isSelected(item.deptId) ? {} : {}, {
        f: item.deptId,
        g: common_vendor.n({
          "dept-picker__row--active": $options.isSelected(item.deptId)
        }),
        h: $options.rowPadding(item.level),
        i: common_vendor.o(($event) => $options.onSelect(item), item.deptId)
      });
    }),
    h: $options.visibleList.length === 0
  }, $options.visibleList.length === 0 ? {} : {}) : {});
}
const Component = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-a752faee"]]);
wx.createComponent(Component);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/components/dept-tree-picker/dept-tree-picker.js.map
