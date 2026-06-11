<template>
  <view class="pay-picker">
    <view class="pay-picker__title-row">
      <text class="pay-picker__title">支付方式</text>
    </view>
    <view
      v-for="item in methods"
      :key="item.channel"
      :class="['pay-picker__item', { 'pay-picker__item--disabled': !item.enabled, 'pay-picker__item--active': item.channel === selected }]"
      @click="onSelect(item)"
    >
      <view class="pay-picker__item-left">
        <text class="pay-picker__item-name">{{ item.name }}</text>
        <text class="pay-picker__item-desc">{{ itemDesc(item) }}</text>
      </view>
      <view class="pay-picker__item-right">
        <view v-if="item.channel === selected && item.enabled" class="pay-picker__check"></view>
        <text v-else-if="!item.enabled" class="pay-picker__disabled-tag">{{ item.disabledReason || '不可用' }}</text>
      </view>
    </view>
  </view>
</template>

<script>
import { payApi } from '../../api/index'
import { DEFAULT_PAY_CHANNEL } from '../../utils/pay/channels'

export default {
  name: 'PayMethodPicker',
  props: {
    orderId: {
      type: Number,
      required: true
    },
    value: {
      type: String,
      default: DEFAULT_PAY_CHANNEL
    }
  },
  data() {
    return {
      methods: [],
      selected: this.value || DEFAULT_PAY_CHANNEL
    }
  },
  watch: {
    orderId: {
      immediate: true,
      handler(val) {
        if (val) this.loadMethods()
      }
    },
    value(val) {
      this.selected = val
    }
  },
  methods: {
    itemDesc(item) {
      if (item.channel === 'balance' && item.balance !== undefined) {
        return `可用余额 ${item.balance}，本次需 ${item.requiredBalance || 0}`
      }
      return item.desc || ''
    },
    async loadMethods() {
      if (!this.orderId) return
      try {
        const list = await payApi.methods(this.orderId)
        this.methods = Array.isArray(list) ? list : []
        const enabled = this.methods.find((m) => m.channel === this.selected && m.enabled)
        if (!enabled) {
          const fallback = this.methods.find((m) => m.enabled)
          if (fallback) {
            this.selectChannel(fallback.channel)
          }
        }
        this.$emit('loaded', this.methods)
      } catch (e) {
        this.methods = []
      }
    },
    onSelect(item) {
      if (!item.enabled) {
        uni.showToast({ title: item.disabledReason || '该支付方式不可用', icon: 'none' })
        return
      }
      this.selectChannel(item.channel)
    },
    selectChannel(channel) {
      this.selected = channel
      this.$emit('input', channel)
      this.$emit('change', channel)
    }
  }
}
</script>

<style lang="scss" scoped>
.pay-picker {
  &__title-row {
    margin-bottom: 8rpx;
  }

  &__title {
    font-size: 28rpx;
    font-weight: bold;
    color: #333333;
  }

  &__item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 0;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }

    &--disabled {
      opacity: 0.55;
    }

    &--active .pay-picker__item-name {
      color: $brand-primary;
    }
  }

  &__item-left {
    flex: 1;
    min-width: 0;
  }

  &__item-name {
    display: block;
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__item-desc {
    display: block;
    margin-top: 6rpx;
    font-size: 22rpx;
    color: #999999;
  }

  &__item-right {
    flex-shrink: 0;
    margin-left: 16rpx;
  }

  &__check {
    width: 36rpx;
    height: 36rpx;
    border-radius: 50%;
    background: $brand-primary;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      left: 12rpx;
      top: 8rpx;
      width: 10rpx;
      height: 16rpx;
      border-right: 3rpx solid #FFFFFF;
      border-bottom: 3rpx solid #FFFFFF;
      transform: rotate(45deg);
    }
  }

  &__disabled-tag {
    font-size: 22rpx;
    color: #CCCCCC;
  }
}
</style>
