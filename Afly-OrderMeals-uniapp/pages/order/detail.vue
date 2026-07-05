<template>
  <view class="detail-page" v-if="order">
    <scroll-view class="detail-page__scroll" scroll-y :show-scrollbar="false">
      <!-- 订单状态卡片 -->
      <view class="detail-page__status-card">
        <view class="detail-page__status-main">
          <text class="detail-page__status-text">{{ statusText }}</text>
          <text
            class="detail-page__status-sub"
            :class="{ 'detail-page__status-sub--call': isCalled }"
            v-if="order.pickupCode"
          >取餐码 {{ order.pickupCode }}</text>
          <text class="detail-page__status-hint" v-if="isCalled">餐品已备好，请尽快取餐</text>
        </view>
      </view>

      <!-- 配送信息 -->
      <view class="detail-page__section detail-page__section--address" v-if="order.addressSnapshot">
        <view class="detail-page__address-row">
          <view class="detail-page__address-left">
            <text class="detail-page__address-label">配送地址</text>
            <text class="detail-page__address-detail">{{ formatAddress(order.addressSnapshot) }}</text>
          </view>
        </view>
      </view>

      <!-- 送达时间 -->
      <view class="detail-page__section detail-page__section--delivery">
        <view class="detail-page__info-row">
          <text class="detail-page__info-label">下单时间</text>
          <text class="detail-page__info-value">{{ order.createTime }}</text>
        </view>
        <view class="detail-page__info-row">
          <text class="detail-page__info-label">订单号</text>
          <text class="detail-page__info-value">{{ order.number }}</text>
        </view>
      </view>

      <!-- 餐品详情 -->
      <view class="detail-page__section detail-page__section--dishes">
        <view class="detail-page__section-title-row">
          <text class="detail-page__section-title">餐品详情</text>
        </view>
        <view class="detail-page__items">
          <view v-for="dish in order.dishes" :key="dish.id" class="detail-page__item">
            <view class="detail-page__item-left">
              <image class="detail-page__item-img" :src="dish.image || staticImgPrefix + '/placeholder.png'" mode="aspectFill" />
              <view class="detail-page__item-info">
                <text class="detail-page__item-name">{{ dish.dishName }}</text>
                <text class="detail-page__item-qty">x{{ dish.quantity }}</text>
              </view>
            </view>
            <view class="detail-page__item-right">
              <text class="detail-page__item-price">¥{{ lineAmount(dish) }}</text>
            </view>
          </view>
        </view>

        <!-- 金额明细 -->
        <view class="detail-page__amount-section">
          <view class="detail-page__divider"></view>
          <view class="detail-page__amount-row detail-page__amount-row--total">
            <text class="detail-page__amount-label">合计</text>
            <text class="detail-page__amount-value detail-page__amount-value--total">¥{{ order.amount }}</text>
          </view>
        </view>
      </view>

      <!-- 支付方式 -->
      <view
        class="detail-page__section detail-page__section--pay"
        v-if="order.payStatus === 0 || order.status === 4"
      >
        <view class="detail-page__pay-selector" @tap="showPayPicker = true">
          <text class="detail-page__pay-label">支付方式</text>
          <view class="detail-page__pay-right">
            <text class="detail-page__pay-value">{{ payChannelText }}</text>
            <text class="detail-page__arrow">›</text>
          </view>
        </view>
      </view>

      <view class="detail-page__bottom-space"></view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view class="detail-page__footer safe-area-bottom">
      <view class="detail-page__submit-bar" v-if="isPendingPay">
        <view class="detail-page__submit-info">
          <text class="detail-page__submit-label">合计:</text>
          <text class="detail-page__submit-price">¥{{ order.amount }}</text>
        </view>
        <view class="detail-page__submit-actions">
          <view class="detail-page__cancel-btn detail-page__cancel-btn--inline" @click="cancelOrder">
            <text class="detail-page__cancel-btn-text">取消订单</text>
          </view>
          <view class="detail-page__submit-btn" @click="payNow">
            <text class="detail-page__submit-btn-text">去支付</text>
          </view>
        </view>
      </view>
    </view>

    <!-- 支付方式选择弹窗 -->
    <view class="detail-page__pay-mask" v-if="showPayPicker" @tap="showPayPicker = false">
      <view class="detail-page__pay-picker" @tap.stop>
        <view class="detail-page__pay-picker-title">选择支付方式</view>
        <pay-method-picker
          :order-id="orderId"
          v-model="payChannel"
          @change="onPayMethodChange"
          @loaded="onPayMethodsLoaded"
        />
        <view class="detail-page__pay-picker-close" @tap="showPayPicker = false">取消</view>
      </view>
    </view>

  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { payOrder, DEFAULT_PAY_CHANNEL } from '../../utils/pay/index'
import PayMethodPicker from '../../components/pay-method-picker/pay-method-picker.vue'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

export default {
  components: { PayMethodPicker },
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      orderId: 0,
      order: null,
      payChannel: DEFAULT_PAY_CHANNEL,
      showPayPicker: false,
      payMethodList: []
    }
  },
  computed: {
    isCalled() {
      return this.order && Number(this.order.calledTime) > 0
    },
    isPendingPay() {
      return this.order && (this.order.payStatus === 0 || this.order.status === 4)
    },
    statusText() {
      if (!this.order) return ''
      if (this.order.payStatus === 0 || this.order.status === 4) return '待支付'
      if (this.order.status === 1 && this.isCalled) return '请取餐'
      if (this.order.status === 1) return '制作中'
      if (this.order.status === 2) return '已完成'
      if (this.order.status === 3) return '已取消'
      return '未知'
    },
    payChannelText() {
      const m = this.payMethodList.find((item) => item.channel === this.payChannel)
      return m ? m.name : '请选择'
    }
  },
  onLoad(options) {
    this.orderId = Number(options.orderId)
    this.loadDetail()
  },
  onShow() {
    if (this.orderId) this.loadDetail()
  },
  methods: {
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
      this.order = await orderApi.detail(this.orderId)
    },
    async payNow() {
      try {
        await payOrder(this.orderId, this.payChannel, 'mp')
        uni.showToast({ title: '支付成功', icon: 'success' })
        // 支付成功后延迟刷新，让用户先看到成功提示
        setTimeout(() => {
          this.loadDetail()
        }, 500)
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      }
    },
    async cancelOrder() {
      const { confirm } = await uni.showModal({
        title: '取消订单',
        content: '确定取消该待支付订单吗？已使用的优惠券将退还至您的账户。'
      })
      if (!confirm) return
      try {
        await orderApi.cancel(this.orderId, '用户取消')
        uni.showToast({ title: '订单已取消', icon: 'success' })
        this.loadDetail()
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      }
    },
    onPayMethodChange(channel) {
      this.payChannel = channel
      this.showPayPicker = false
    },
    onPayMethodsLoaded(list) {
      this.payMethodList = list || []
    },
    goBack() {
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss" scoped>
.detail-page {
  min-height: 100vh;
  background: #F0EFF5;
  display: flex;
  flex-direction: column;

  &__scroll {
    flex: 1;
    background: linear-gradient(180deg, #FFF5F5 0%, #FFF5F5 320rpx, #F0EFF5 320rpx, #F0EFF5 100%);
  }

  &__status-card {
    background: linear-gradient(135deg, #c82d24 0%, #A01731 100%);
    margin: 0 24rpx 16rpx;
    border-radius: 16rpx;
    padding: 40rpx 28rpx;
  }

  &__status-main {
    text-align: center;
  }

  &__status-text {
    display: block;
    font-size: 40rpx;
    font-weight: 900;
    color: #FFFFFF;
  }

  &__status-sub {
    display: block;
    margin-top: 12rpx;
    font-size: 28rpx;
    color: rgba(255, 255, 255, 0.85);

    &--call {
      font-size: 40rpx;
      font-weight: 900;
      letter-spacing: 4rpx;
    }
  }

  &__status-hint {
    display: block;
    margin-top: 12rpx;
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.9);
  }

  &__section {
    &--address {
      background: transparent;
      margin: 0;
      padding: 20rpx 32rpx 24rpx;
      border-radius: 0;
    }

    &--delivery {
      background: #FFFFFF;
      margin: 0 24rpx 16rpx;
      border-radius: 16rpx;
      padding: 24rpx 28rpx;
    }

    &--dishes {
      background: #FFFFFF;
      margin: 0 24rpx 16rpx;
      border-radius: 16rpx;
      padding: 28rpx;
    }

    &--pay {
      background: #FFFFFF;
      margin: 0 24rpx 16rpx;
      border-radius: 16rpx;
      padding: 24rpx 28rpx;
    }
  }

  &__address-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin: 20rpx;
  }

  &__address-left {
    flex: 1;
    min-width: 0;
  }

  &__address-label {
    font-size: 34rpx;
    font-weight: 600;
    color: #111111;
    display: block;
  }

  &__address-detail {
    font-size: 24rpx;
    color: #666666;
    margin-top: 8rpx;
    display: block;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12rpx 0;
  }

  &__info-label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__info-value {
    font-size: 26rpx;
    color: #666666;
  }

  &__section-title-row {
    margin-bottom: 30rpx;
  }

  &__section-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #111111;
  }

  &__items {
    margin-bottom: 24rpx;
  }

  &__item {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    padding: 18rpx 0;
    position: relative;
  }

  &__item-left {
    display: flex;
    align-items: center;
    flex: 1;
    min-width: 0;
  }

  &__item-img {
    width: 130rpx;
    height: 130rpx;
    border-radius: 16rpx;
    background: #F5F5F5;
    flex-shrink: 0;
  }

  &__item-info {
    display: flex;
    flex-direction: column;
    margin-left: 20rpx;
    flex: 1;
    min-width: 0;
    justify-content: center;
  }

  &__item-name {
    font-size: 28rpx;
    color: #111111;
    font-weight: 500;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__item-qty {
    font-size: 22rpx;
    color: #999999;
    margin-top: 8rpx;
  }

  &__item-right {
    text-align: right;
    flex-shrink: 0;
    margin-left: 16rpx;
    align-self: flex-end;
    margin-bottom: 4rpx;
  }

  &__item-price {
    font-size: 30rpx;
    color: #D00000;
    font-weight: 600;
  }

  &__amount-section {
    padding-top: 12rpx;
  }

  &__amount-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10rpx 0;

    &--total {
      padding-top: 16rpx;
      justify-content: flex-end;
      gap: 8rpx;
    }
  }

  &__amount-label {
    font-size: 26rpx;
    color: #666666;
  }

  &__amount-value {
    font-size: 26rpx;
    color: #333333;

    &--total {
      font-size: 32rpx;
      font-weight: 700;
      color: #D00000;
    }
  }

  &__divider {
    height: 1rpx;
    background: #F5F5F5;
    margin: 8rpx 0;
  }

  &__footer {
    background: #FFFFFF;
    padding: 18rpx 28rpx;
    box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.06);
    flex-shrink: 0;
  }

  &__submit-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16rpx;
  }

  &__submit-actions {
    display: flex;
    align-items: center;
    gap: 16rpx;
    flex-shrink: 0;
  }

  &__submit-info {
    display: flex;
    align-items: baseline;
    gap: 6rpx;
  }

  &__submit-label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__submit-price {
    font-size: 40rpx;
    font-weight: 700;
    color: #D00000;
  }

  &__submit-btn {
    background: linear-gradient(135deg, #D00000 0%, #B00000 100%);
    padding: 22rpx 56rpx;
    border-radius: 12rpx;
    box-shadow: 0 6rpx 16rpx rgba(208, 0, 0, 0.25);

    &:active {
      transform: scale(0.97);
      opacity: 0.9;
    }
  }

  &__submit-btn-text {
    color: #FFFFFF;
    font-size: 30rpx;
    font-weight: 600;
  }

  &__cancel-bar {
    display: flex;
    justify-content: center;
  }

  &__cancel-btn {
    padding: 22rpx 56rpx;
    border-radius: 12rpx;
    border: 1rpx solid #E8E8E8;
    background: #FFFFFF;

    &--inline {
      padding: 22rpx 32rpx;
    }

    &:active {
      opacity: 0.8;
    }
  }

  &__cancel-btn-text {
    color: #666666;
    font-size: 30rpx;
    font-weight: 600;
  }

  &__bottom-space {
    height: 40rpx;
  }

  &__pay-selector {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  &__pay-label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__pay-right {
    display: flex;
    align-items: center;
  }

  &__pay-value {
    font-size: 26rpx;
    color: #D00000;
    font-weight: 500;
  }

  &__arrow {
    font-size: 32rpx;
    color: #999999;
    line-height: 1;
    margin-left: 12rpx;
    font-weight: 400;
  }

  &__pay-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: flex-end;
    justify-content: center;
    z-index: 1000;
  }

  &__pay-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 24rpx 24rpx 0 0;
    padding: 32rpx 24rpx;
    padding-bottom: calc(32rpx + env(safe-area-inset-bottom));
  }

  &__pay-picker-title {
    font-size: 32rpx;
    font-weight: 600;
    color: #111111;
    text-align: center;
    margin-bottom: 24rpx;
  }

  &__pay-picker-close {
    font-size: 28rpx;
    color: #999999;
    text-align: center;
    padding: 20rpx 0;
  }
}
</style>
