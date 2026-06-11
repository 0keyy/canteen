<template>
  <view class="dept-picker">
    <view class="dept-picker__trigger" @tap="openPopup">
      <text :class="{ 'dept-picker__placeholder': !displayName }">
        {{ displayName || placeholder }}
      </text>
      <text class="dept-picker__arrow">›</text>
    </view>

    <!-- 弹层置于组件根节点，避免被父级裁剪 -->
    <view v-if="visible" class="dept-picker__popup">
      <view class="dept-picker__mask" @tap="closePopup"></view>
      <view class="dept-picker__panel safe-area-bottom">
        <view class="dept-picker__header">
          <text class="dept-picker__title">选择部门</text>
          <text class="dept-picker__close" @tap="closePopup">×</text>
        </view>

        <scroll-view scroll-y class="dept-picker__scroll" :show-scrollbar="false">
          <view
            v-for="item in visibleList"
            :key="item.deptId"
            :class="['dept-picker__row', { 'dept-picker__row--active': isSelected(item.deptId) }]"
            :style="{ paddingLeft: rowPadding(item.level) }"
            @tap="onSelect(item)"
          >
            <view
              v-if="item.hasChildren"
              class="dept-picker__expand"
              @tap.stop="toggleExpand(item.deptId)"
            >
              <text :class="['dept-picker__expand-icon', { 'dept-picker__expand-icon--open': isExpanded(item.deptId) }]">›</text>
            </view>
            <view v-else class="dept-picker__expand dept-picker__expand--placeholder"></view>
            <text class="dept-picker__name">{{ item.deptName }}</text>
            <text v-if="isSelected(item.deptId)" class="dept-picker__check">✓</text>
          </view>
          <view v-if="visibleList.length === 0" class="dept-picker__empty">暂无部门数据</view>
        </scroll-view>
      </view>
    </view>
  </view>
</template>

<script>
import {
  buildDeptTree,
  collectAllExpanded,
  findDeptById,
  flattenDeptTree
} from '../../utils/dept-tree'

export default {
  name: 'DeptTreePicker',
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
      default: '请选择部门'
    }
  },
  emits: ['update:modelValue', 'change'],
  data() {
    return {
      visible: false,
      expandedIds: {},
      innerValue: null
    }
  },
  computed: {
    currentValue() {
      return this.innerValue != null ? this.innerValue : this.modelValue
    },
    tree() {
      return buildDeptTree(this.deptList)
    },
    visibleList() {
      return flattenDeptTree(this.tree, this.expandedIds)
    },
    displayName() {
      const dept = findDeptById(this.deptList, this.currentValue)
      return dept ? dept.deptName : ''
    }
  },
  watch: {
    modelValue(val) {
      this.innerValue = val
    },
    deptList: {
      immediate: true,
      handler(list) {
        if (Array.isArray(list) && list.length > 0) {
          this.expandedIds = collectAllExpanded(buildDeptTree(list))
        }
      }
    }
  },
  methods: {
    isSelected(deptId) {
      return Number(this.currentValue) === Number(deptId)
    },
    rowPadding(level) {
      return `${24 + level * 32}rpx`
    },
    isExpanded(deptId) {
      return !!this.expandedIds[String(deptId)]
    },
    toggleExpand(deptId) {
      const key = String(deptId)
      const next = { ...this.expandedIds }
      if (next[key]) {
        delete next[key]
      } else {
        next[key] = true
      }
      this.expandedIds = next
    },
    openPopup() {
      if (!this.deptList.length) {
        uni.showToast({ title: '暂无部门数据', icon: 'none' })
        return
      }
      this.expandedIds = collectAllExpanded(this.tree)
      this.visible = true
    },
    closePopup() {
      this.visible = false
    },
    onSelect(item) {
      if (!item || item.deptId == null) return
      this.innerValue = item.deptId
      this.$emit('update:modelValue', item.deptId)
      this.$emit('change', item)
      this.closePopup()
    }
  }
}
</script>

<style lang="scss" scoped>
.dept-picker {
  &__trigger {
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 88rpx;
    padding: 0 24rpx;
    border-radius: $radius-card;
    background: $bg-gray;
    font-size: 28rpx;
    color: $text-primary;
  }

  &__placeholder {
    color: $text-secondary;
  }

  &__arrow {
    font-size: 36rpx;
    color: $text-secondary;
    line-height: 1;
  }

  &__popup {
    position: fixed;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
    z-index: 9999;
  }

  &__mask {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.45);
  }

  &__panel {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    background: $bg-surface;
    border-radius: 24rpx 24rpx 0 0;
    display: flex;
    flex-direction: column;
  }

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 32rpx 16rpx;
    border-bottom: 1rpx solid #F0F0F0;
    flex-shrink: 0;
  }

  &__title {
    font-size: 32rpx;
    font-weight: bold;
    color: $text-primary;
  }

  &__close {
    font-size: 44rpx;
    line-height: 1;
    color: $text-secondary;
    padding: 0 8rpx;
  }

  /* 微信小程序 scroll-view 必须指定高度 */
  &__scroll {
    height: 55vh;
    max-height: 800rpx;
  }

  &__row {
    display: flex;
    align-items: center;
    min-height: 88rpx;
    padding-right: 32rpx;
    border-bottom: 1rpx solid #F8F8F8;

    &--active {
      background: rgba(177, 10, 15, 0.06);

      .dept-picker__name {
        color: $brand-primary;
        font-weight: 600;
      }
    }
  }

  &__expand {
    width: 48rpx;
    height: 48rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;

    &--placeholder {
      opacity: 0;
    }
  }

  &__expand-icon {
    font-size: 32rpx;
    color: $text-secondary;
    transform: rotate(0deg);
    transition: transform 0.2s;

    &--open {
      transform: rotate(90deg);
    }
  }

  &__name {
    flex: 1;
    font-size: 28rpx;
    color: $text-primary;
    line-height: 1.4;
  }

  &__check {
    font-size: 28rpx;
    color: $brand-primary;
    font-weight: bold;
    margin-left: 12rpx;
  }

  &__empty {
    padding: 80rpx 0;
    text-align: center;
    font-size: 26rpx;
    color: $text-secondary;
  }
}
</style>
