<template>
  <view class="sidebar">
    <view
      v-for="(cate, index) in menu"
      :key="cate.id || cate.name || index"
      :class="['sidebar__item', activeIndex === index ? 'sidebar__item--active' : '']"
      @tap="$emit('select', index)"
    >
      <view v-if="activeIndex === index" class="sidebar__indicator"></view>
      <view class="sidebar__name-wrap">
        <image
          v-if="index === 0"
          class="sidebar__heart-icon"
          src="/static/tabbar/爱心 _实心 1.png"
          mode="aspectFit"
        />
        <text :class="['sidebar__name', activeIndex === index ? 'sidebar__name--active' : '']">
          {{ index === 0 ? '猜你喜欢' : cate.name }}
        </text>
      </view>
      <text v-if="badgeCount(index) > 0" class="sidebar__badge">{{ badgeCount(index) }}</text>
    </view>
  </view>
</template>

<script>
export default {
  props: {
    menu: {
      type: Array,
      default: () => []
    },
    activeIndex: {
      type: Number,
      default: 0
    },
    cartMap: {
      type: Object,
      default: () => ({})
    }
  },
  emits: ['select'],
  methods: {
    badgeCount(index) {
      const foods = this.menu[index]?.foods || []
      return foods.reduce((sum, food) => sum + (this.cartMap[String(food.id)]?.count || 0), 0)
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar {
  width: 172rpx;
  background: rgba(245, 240, 234, 0.7);

  &__item {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 112rpx;
    padding: 16rpx 12rpx;
  }

  &__item--active {
    background: $bg-surface;
  }

  &__indicator {
    position: absolute;
    left: 0;
    top: 50%;
    transform: translateY(-50%);
    width: 8rpx;
    height: 48rpx;
    background: $brand-primary;
    border-radius: 0 8rpx 8rpx 0;
  }

  &__name-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4rpx;
  }

  &__heart-icon {
    width: 32rpx;
    height: 32rpx;
  }

  &__name {
    font-size: 28rpx;
    font-weight: 600;
    color: $text-secondary;
    text-align: center;
    line-height: 1.4;
  }

  &__name--active {
    color: $brand-primary;
  }

  &__badge {
    position: absolute;
    top: 10rpx;
    right: 10rpx;
    min-width: 28rpx;
    height: 28rpx;
    line-height: 28rpx;
    padding: 0 6rpx;
    border-radius: 14rpx;
    background: $brand-red;
    color: $text-white;
    font-size: 18rpx;
    text-align: center;
  }
}
</style>


