<template>
  <view class="app-tab-bar">
    <view
      v-for="(item, index) in list"
      :key="item.pagePath || index"
      class="app-tab-item"
      :class="{ 'app-tab-item--active': selected === index }"
      @tap.stop="onTap(item, index)"
    >
      <view class="app-tab-icon-wrap">
        <image
          v-if="iconSrc(item, index)"
          class="app-tab-icon"
          :src="iconSrc(item, index)"
          mode="aspectFit"
        />
      </view>
      <text
        class="app-tab-text"
        :style="{ color: selected === index ? selectedColor : defaultColor }"
      >
        {{ item.name }}
      </text>
    </view>
  </view>
</template>

<script setup>
defineOptions({ name: 'AppTabBar' })

const props = defineProps({
  list: {
    type: Array,
    default: () => []
  },
  selected: {
    type: Number,
    default: 0
  },
  defaultColor: {
    type: String,
    default: '#999999'
  },
  selectedColor: {
    type: String,
    default: '#B10A0F'
  }
})

const emit = defineEmits(['switch'])

function iconSrc(item, index) {
  const url = props.selected === index ? item.selected : item.unselected
  return url || (props.selected === index ? item.unselected : item.selected) || ''
}

function onTap(item, index) {
  emit('switch', item, index)
}
</script>

<style lang="scss" scoped>
.app-tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  width: 100%;
  height: calc(108rpx + env(safe-area-inset-bottom));
  padding: 8rpx 16rpx env(safe-area-inset-bottom);
  display: flex;
  background: rgba(255, 252, 248, 0.98);
  border-top: 1rpx solid $border-light;
  box-sizing: border-box;
  backdrop-filter: blur(8px);
}

.app-tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4rpx;
  min-height: 88rpx;
  border-radius: 32rpx;
}

.app-tab-icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56rpx;
  height: 56rpx;
}

.app-tab-icon {
  width: 44rpx;
  height: 44rpx;
  display: block;
}

.app-tab-text {
  font-size: 22rpx;
  font-weight: 600;
  line-height: 1.2;
}
</style>
