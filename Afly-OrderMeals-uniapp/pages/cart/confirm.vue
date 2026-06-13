<template>
  <view class="checkout" v-if="order">
    <scroll-view class="checkout__scroll" scroll-y :show-scrollbar="false">
      <view class="checkout__section">
        <view class="checkout__section-title-row">
          <text class="checkout__section-title">订单信息</text>
        </view>
        <view class="checkout__info-row">
          <text class="checkout__info-label">就餐方式</text>
          <text class="checkout__info-value">{{ diningModeText }}</text>
        </view>
        <view class="checkout__info-row" v-if="order.contactMobile">
          <text class="checkout__info-label">联系电话</text>
          <text class="checkout__info-value">{{ order.contactMobile }}</text>
        </view>
        <view class="checkout__info-row" v-if="order.addressSnapshot">
          <text class="checkout__info-label">配送地址</text>
          <text class="checkout__info-value checkout__addr">{{ formatAddress(order.addressSnapshot) }}</text>
        </view>
      </view>

      <view class="checkout__section">
        <view class="checkout__section-title-row">
          <text class="checkout__section-title">已选菜品</text>
          <text class="checkout__item-count">共{{ order.dishes?.length || 0 }}项</text>
        </view>
        <view class="checkout__items">
          <view v-for="dish in order.dishes" :key="dish.id" class="checkout__item">
            <view class="checkout__item-left">
              <text class="checkout__item-name">{{ dish.dishName }}</text>
            </view>
            <view class="checkout__item-right">
              <text class="checkout__item-price">¥{{ lineAmount(dish) }}</text>
              <text class="checkout__item-qty">x{{ dish.quantity }}</text>
            </view>
          </view>
        </view>
        <view class="checkout__summary-row checkout__summary-row--total">
          <text class="checkout__summary-label-total">合计</text>
          <text class="checkout__summary-total">¥{{ totalAmount }}</text>
        </view>
      </view>

      <view class="checkout__section">
        <pay-method-picker :order-id="orderId" v-model="payChannel" />
      </view>

      <view class="checkout__section">
        <view class="checkout__section-title-row">
          <text class="checkout__section-title">备注信息</text>
        </view>
        <textarea
          v-model="remark"
          class="checkout__remark"
          placeholder="添加备注（选填）"
          placeholder-class="checkout__remark-placeholder"
        />
      </view>

      <view class="checkout__bottom-space"></view>
    </scroll-view>

    <view class="checkout__footer safe-area-bottom">
      <view class="checkout__submit-bar">
        <view class="checkout__submit-info">
          <text class="checkout__submit-label">合计</text>
          <text class="checkout__submit-price">¥{{ totalAmount }}</text>
        </view>
        <view class="checkout__submit-btn" @click="handleSubmit">
          <text class="checkout__submit-btn-text">{{ loading ? '提交中...' : '提交并支付' }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { payOrder, DEFAULT_PAY_CHANNEL } from '../../utils/pay/index'
import PayMethodPicker from '../../components/pay-method-picker/pay-method-picker.vue'

export default {
  components: { PayMethodPicker },
  data() {
    return {
      orderId: 0,
      order: null,
      remark: '',
      loading: false,
      diningMode: 1,
      payChannel: DEFAULT_PAY_CHANNEL
    }
  },
  computed: {
    diningModeText() {
      return { 1: '堂食', 3: '外卖配送' }[this.diningMode] || '堂食'
    },
    totalAmount() {
      if (!this.order) return '0.00'
      const orderAmount = this.order.amount
      if (orderAmount !== null && orderAmount !== undefined && orderAmount !== '') {
        return Number(orderAmount).toFixed(2)
      }
      return this.calcDishesAmount(this.order.dishes)
    }
  },
  onLoad() {
    this.orderId = Number(uni.getStorageSync('orderId'))
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    this.loadDetail()
  },
  methods: {
    calcDishesAmount(dishes) {
      if (!Array.isArray(dishes) || dishes.length === 0) return '0.00'
      const total = dishes.reduce((sum, dish) => {
        return sum + Number(dish.amount || 0) * Number(dish.quantity || 1)
      }, 0)
      return total.toFixed(2)
    },
    lineAmount(dish) {
      return (Number(dish.amount || 0) * Number(dish.quantity || 1)).toFixed(2)
    },
    formatAddress(snapshot) {
      try {
        const obj = JSON.parse(snapshot)
        return `${obj.province || ''}${obj.city || ''}${obj.district || ''}${obj.detail || ''}`
      } catch (e) {
        return snapshot
      }
    },
    async loadDetail() {
      try {
        this.order = await orderApi.detail(this.orderId)
      } catch (e) {
        this.order = { dishes: [], amount: '0.00' }
      }
    },
    async handleSubmit() {
      if (!this.payChannel) {
        uni.showToast({ title: '请选择支付方式', icon: 'none' })
        return
      }
      this.loading = true
      try {
        const addressId = uni.getStorageSync('addressId') || null
        await orderApi.submit({
          orderId: this.orderId,
          remark: this.remark,
          addressId
        })
        await payOrder(this.orderId, this.payChannel, 'mp')
        uni.showToast({ title: '支付成功', icon: 'success' })
        setTimeout(() => {
          uni.redirectTo({ url: `/pages/order/detail?orderId=${this.orderId}` })
        }, 500)
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.checkout {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;

  &__scroll {
    flex: 1;
  }

  &__section {
    background: #FFFFFF;
    margin: 16rpx 24rpx;
    border-radius: $radius-card;
    padding: 28rpx;
    box-shadow: $shadow-sm;
  }

  &__section-title-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16rpx;
  }

  &__section-title {
    font-size: 28rpx;
    font-weight: bold;
    color: #333333;
  }

  &__item-count {
    font-size: 24rpx;
    color: #999999;
  }

  &__info-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding: 12rpx 0;
  }

  &__info-label {
    font-size: 26rpx;
    color: #666666;
    flex-shrink: 0;
  }

  &__info-value {
    font-size: 26rpx;
    color: #333333;
    text-align: right;
    max-width: 420rpx;
  }

  &__addr {
    color: #666666;
    line-height: 1.5;
  }

  &__items {
    margin-top: 8rpx;
  }

  &__item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16rpx 0;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }
  }

  &__item-left {
    flex: 1;
  }

  &__item-name {
    font-size: 26rpx;
    color: #333333;
  }

  &__item-right {
    text-align: right;
    flex-shrink: 0;
    margin-left: 16rpx;
  }

  &__item-price {
    font-size: 26rpx;
    color: #333333;
    font-weight: 500;
    display: block;
  }

  &__item-qty {
    font-size: 22rpx;
    color: #999999;
    display: block;
    margin-top: 4rpx;
  }

  &__summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-top: 16rpx;
    margin-top: 8rpx;
    border-top: 1rpx solid #F0F0F0;

    &--total {
      padding-top: 20rpx;
    }
  }

  &__summary-label-total {
    font-size: 30rpx;
    color: #333333;
    font-weight: bold;
  }

  &__summary-total {
    font-size: 38rpx;
    color: $text-price;
    font-weight: bold;
  }

  &__remark {
    width: 100%;
    min-height: 120rpx;
    font-size: 26rpx;
    color: #333333;
    margin-top: 8rpx;
  }

  &__remark-placeholder {
    color: #CCCCCC;
  }

  &__footer {
    background: $bg-surface;
    padding: 16rpx 24rpx;
    border-top: 1rpx solid $divider-color;
    flex-shrink: 0;
  }

  &__submit-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__submit-info {
    display: flex;
    align-items: baseline;
    gap: 8rpx;
    flex: 1;
    min-width: 0;
    margin-right: 16rpx;
  }

  &__submit-label {
    font-size: 26rpx;
    color: #666666;
  }

  &__submit-price {
    font-size: 40rpx;
    font-weight: bold;
    color: $text-price;
  }

  &__submit-btn {
    background: $brand-primary;
    padding: 24rpx 48rpx;
    border-radius: $radius-btn;

    &:active {
      background: $brand-primary-press;
    }
  }

  &__submit-btn-text {
    color: #FFFFFF;
    font-size: 30rpx;
    font-weight: bold;
    letter-spacing: 2rpx;
  }

  &__bottom-space {
    height: 120rpx;
  }
}
</style>
