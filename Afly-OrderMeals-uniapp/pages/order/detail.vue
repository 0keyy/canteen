<template>
  <view class="detail-page" v-if="order">
    <scroll-view class="detail-page__scroll" scroll-y :show-scrollbar="false">
      <view class="detail-page__status-card">
        <text class="detail-page__status-text">{{ statusText }}</text>
        <text class="detail-page__status-sub" v-if="order.pickupCode">取餐码 {{ order.pickupCode }}</text>
      </view>

      <view class="detail-page__card">
        <view class="detail-page__row">
          <text class="detail-page__label">订单号</text>
          <text class="detail-page__value">{{ order.number }}</text>
        </view>
        <view class="detail-page__row" v-if="order.addressSnapshot">
          <text class="detail-page__label">地址</text>
          <text class="detail-page__value detail-page__addr">{{ formatAddress(order.addressSnapshot) }}</text>
        </view>
      </view>

      <view class="detail-page__card">
        <view class="detail-page__card-title">菜品明细</view>
        <view v-for="dish in order.dishes" :key="dish.id" class="detail-page__dish-row">
          <text class="detail-page__dish-name">{{ dish.dishName }} x{{ dish.quantity }}</text>
          <text class="detail-page__dish-price">¥{{ dish.amount }}</text>
        </view>
        <view class="detail-page__row detail-page__row--total">
          <text class="detail-page__label-total">合计</text>
          <text class="detail-page__total-price">¥{{ order.amount }}</text>
        </view>
      </view>

      <view class="detail-page__bottom-space"></view>
    </scroll-view>

    <view class="detail-page__footer safe-area-bottom">
      <button
        v-if="order.payStatus === 0 || order.status === 4"
        class="detail-page__btn detail-page__btn--primary"
        @click="payNow"
      >去支付</button>
      <button
        v-if="order.status === 1"
        class="detail-page__btn detail-page__btn--secondary"
        @click="cancelOrder"
      >取消订单</button>
    </view>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { payOrder } from '../../utils/pay/index'

export default {
  data() {
    return {
      orderId: 0,
      order: null
    }
  },
  computed: {
    statusText() {
      if (!this.order) return ''
      if (this.order.payStatus === 0 || this.order.status === 4) return '待支付'
      if (this.order.status === 1) return '进行中'
      if (this.order.status === 2) return '已完成'
      if (this.order.status === 3) return '已取消'
      return '未知'
    }
  },
  onLoad(options) {
    this.orderId = Number(options.orderId)
    this.loadDetail()
  },
  methods: {
    formatAddress(snapshot) {
      try {
        const obj = JSON.parse(snapshot)
        return `${obj.province || ''}${obj.city || ''}${obj.district || ''}${obj.detail || ''}`
      } catch (e) {
        return snapshot
      }
    },
    async loadDetail() {
      this.order = await orderApi.detail(this.orderId)
    },
    async payNow() {
      await payOrder(this.orderId, 'wxpay', 'mp')
      this.loadDetail()
    },
    async cancelOrder() {
      await orderApi.cancel(this.orderId, '用户取消')
      this.loadDetail()
    }
  }
}
</script>

<style lang="scss" scoped>
.detail-page {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;

  &__scroll {
    flex: 1;
  }

  &__status-card {
    background: $brand-primary;
    margin: 16rpx 24rpx;
    border-radius: $radius-card;
    padding: 40rpx 32rpx;
  }

  &__status-text {
    display: block;
    font-size: 40rpx;
    font-weight: bold;
    color: #FFFFFF;
  }

  &__status-sub {
    display: block;
    margin-top: 12rpx;
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.85);
  }

  &__card {
    background: $bg-surface;
    border-radius: $radius-card;
    padding: 28rpx;
    margin: 16rpx 24rpx;
    box-shadow: $shadow-sm;
  }

  &__card-title {
    font-size: 28rpx;
    font-weight: bold;
    color: #333333;
    margin-bottom: 16rpx;
  }

  &__row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 16rpx;

    &--total {
      padding-top: 16rpx;
      margin-top: 8rpx;
      margin-bottom: 0;
      border-top: 1rpx solid #F0F0F0;
    }
  }

  &__label {
    font-size: 26rpx;
    color: #666666;
    flex-shrink: 0;
  }

  &__value {
    font-size: 26rpx;
    color: #333333;
    text-align: right;
    max-width: 420rpx;
  }

  &__addr {
    line-height: 1.5;
  }

  &__dish-row {
    display: flex;
    justify-content: space-between;
    padding: 12rpx 0;
    border-bottom: 1rpx solid #F8F8F8;

    &:last-of-type {
      border-bottom: none;
    }
  }

  &__dish-name {
    font-size: 26rpx;
    color: #333333;
  }

  &__dish-price {
    font-size: 26rpx;
    color: #333333;
    font-weight: 500;
  }

  &__label-total {
    font-size: 30rpx;
    font-weight: bold;
    color: #333333;
  }

  &__total-price {
    font-size: 38rpx;
    font-weight: bold;
    color: $text-price;
  }

  &__footer {
    background: $bg-surface;
    padding: 16rpx 24rpx;
    border-top: 1rpx solid $divider-color;
    display: flex;
    gap: 16rpx;
  }

  &__btn {
    flex: 1;
    border-radius: $radius-btn;
    font-size: 30rpx;
    font-weight: bold;

    &--primary {
      background: $brand-primary;
      color: $text-white;

      &:active {
        background: $brand-primary-press;
      }
    }

    &--secondary {
      background: $bg-surface;
      color: $text-secondary;
      border: 1rpx solid $border-light;
    }
  }

  &__bottom-space {
    height: 120rpx;
  }
}
</style>
