<template>
  <view class="checkout" v-if="order">
    <!-- 自定义导航栏 -->
    <view class="checkout__header">
      <view class="checkout__nav">
        <view class="checkout__back-btn" @tap="goBack">
          <text class="checkout__back-icon">‹</text>
        </view>
        <image class="checkout__logo" src="/static/logo.png" mode="aspectFit" />
        <view class="checkout__nav-empty"></view>
      </view>
    </view>

    <scroll-view class="checkout__scroll" scroll-y :show-scrollbar="false">
      <!-- 配送信息 -->
      <view class="checkout__section checkout__section--address" @tap="goAddress">
        <view class="checkout__address-row">
          <view class="checkout__address-left">
            <text class="checkout__address-label">请选择配送位置</text>
            <text v-if="addressInfo" class="checkout__address-detail">{{ addressInfo }}</text>
          </view>
          <text class="checkout__arrow">›</text>
        </view>
      </view>

      <!-- 送达时间 -->
      <view class="checkout__section checkout__section--delivery">
        <view class="checkout__info-row checkout__info-row--clickable">
          <text class="checkout__info-label">送达时间</text>
          <view class="checkout__info-right">
            <text class="checkout__info-value checkout__info-value--primary">立即出发</text>
            <text class="checkout__arrow">›</text>
          </view>
        </view>
      </view>

      <!-- 餐品详情 -->
      <view class="checkout__section checkout__section--dishes">
        <view class="checkout__section-title-row">
          <text class="checkout__section-title">餐品详情</text>
        </view>
        <view class="checkout__items">
          <view v-for="dish in order.dishes" :key="dish.id" class="checkout__item">
            <view class="checkout__item-left">
              <image class="checkout__item-img" :src="dish.image || '/static/placeholder.png'" mode="aspectFill" />
              <view class="checkout__item-info">
                <text class="checkout__item-name">{{ dish.dishName }}</text>
                <text class="checkout__item-qty">1份</text>
              </view>
            </view>
            <view class="checkout__item-right">
              <text class="checkout__item-price">¥{{ lineAmount(dish) }}</text>
            </view>
          </view>
        </view>

        <!-- 金额明细 -->
        <view class="checkout__amount-section">
          <view class="checkout__amount-row">
            <text class="checkout__amount-label">商品金额</text>
            <text class="checkout__amount-value">¥{{ totalAmount }}</text>
          </view>
          <view class="checkout__amount-row" v-if="couponDiscount > 0">
            <text class="checkout__amount-label">优惠券</text>
            <text class="checkout__amount-value checkout__amount-value--discount">-¥{{ couponDiscount.toFixed(2) }}</text>
          </view>
          <view class="checkout__divider"></view>
          <view class="checkout__amount-row checkout__amount-row--total">
            <text class="checkout__amount-label">合计</text>
            <text class="checkout__amount-value checkout__amount-value--total">¥{{ finalAmount }}</text>
          </view>
        </view>
      </view>

      <!-- 支付方式 -->
      <view class="checkout__section checkout__section--pay">
        <view class="checkout__info-row checkout__info-row--clickable" @tap="showPayPicker = true">
          <text class="checkout__info-label">支付方式</text>
          <view class="checkout__info-right">
            <text class="checkout__info-value">{{ payChannelText }}</text>
            <text class="checkout__arrow">›</text>
          </view>
        </view>
      </view>

      <!-- 备注 -->
      <view class="checkout__section checkout__section--remark">
        <view class="checkout__info-row">
          <text class="checkout__info-label">备注</text>
          <view class="checkout__info-right">
            <input
              v-model="remark"
              class="checkout__remark-input"
              placeholder="请输入"
              placeholder-class="checkout__remark-placeholder"
            />
          </view>
        </view>
      </view>

      <view class="checkout__bottom-space"></view>
    </scroll-view>

    <!-- 底部支付栏 -->
    <view class="checkout__footer safe-area-bottom">
      <view class="checkout__submit-bar">
        <view class="checkout__submit-info">
          <text class="checkout__submit-label">合计:</text>
          <text class="checkout__submit-price">¥{{ finalAmount }}</text>
        </view>
        <view class="checkout__submit-btn" @click="handleSubmit">
          <text class="checkout__submit-btn-text">{{ loading ? '提交中...' : '去支付' }}</text>
        </view>
      </view>
    </view>

    <!-- 支付方式选择弹窗 -->
    <view class="checkout__pay-picker-mask" v-if="showPayPicker" @tap="showPayPicker = false">
      <view class="checkout__pay-picker" @tap.stop>
        <pay-method-picker
          :order-id="orderId"
          v-model="payChannel"
          @change="onPayMethodChange"
          @loaded="onPayMethodsLoaded"
        />
        <view class="checkout__pay-picker-close" @tap="showPayPicker = false">取消</view>
      </view>
    </view>

    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import { orderApi, couponApi } from '../../api/index'
import { payOrder, DEFAULT_PAY_CHANNEL } from '../../utils/pay/index'
import PayMethodPicker from '../../components/pay-method-picker/pay-method-picker.vue'
import PageLoading from '../../components/page-loading/page-loading.vue'

export default {
  components: { PayMethodPicker, PageLoading },
  data() {
    return {
      orderId: 0,
      order: null,
      remark: '',
      loading: false,
      diningMode: 1,
      payChannel: DEFAULT_PAY_CHANNEL,
      couponInfo: null,
      selectedCouponId: 0,
      couponDiscount: 0,
      showPayPicker: false,
      payMethodList: [],
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  computed: {
    diningModeText() {
      return { 1: '堂食', 3: '外卖配送' }[this.diningMode] || '堂食'
    },
    payChannelText() {
      const m = this.payMethodList.find((item) => item.channel === this.payChannel)
      return m ? m.name : '请选择'
    },
    finalAmount() {
      const raw = Number(this.totalAmount)
      return Math.max(0, raw - this.couponDiscount).toFixed(2)
    },
    totalAmount() {
      if (!this.order) return '0.00'
      const orderAmount = this.order.amount
      if (orderAmount !== null && orderAmount !== undefined && orderAmount !== '') {
        return Number(orderAmount).toFixed(2)
      }
      return this.calcDishesAmount(this.order.dishes)
    },
    addressInfo() {
      if (this.order?.addressSnapshot) {
        return this.formatAddress(this.order.addressSnapshot)
      }
      return null
    }
  },
  onLoad() {
    this.orderId = Number(uni.getStorageSync('orderId'))
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    this.loadDetail()
    this.loadBestCoupon()
  },
  methods: {
    goBack() {
      this.goWithLoading('', 'navigateBack')
    },
    goAddress() {
      this.goWithLoading('/pages/address/list?select=1', 'navigateTo')
    },
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
    async loadBestCoupon() {
      try {
        const result = await couponApi.bestForOrder(this.orderId)
        if (result && result.hasCoupon) {
          this.couponInfo = result
          this.selectedCouponId = result.userCouponId
          this.couponDiscount = Number(result.discountAmount || 0)
        }
      } catch (e) {
        this.couponInfo = null
        this.selectedCouponId = 0
        this.couponDiscount = 0
      }
    },
    onPayMethodChange(channel) {
      this.payChannel = channel
      this.showPayPicker = false
    },
    onPayMethodsLoaded(list) {
      this.payMethodList = list || []
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
          addressId,
          couponId: this.selectedCouponId || null
        })
        await payOrder(this.orderId, this.payChannel, 'mp')
        uni.showToast({ title: '支付成功', icon: 'success' })
        setTimeout(() => {
          this.goWithLoading(`/pages/order/detail?orderId=${this.orderId}`, 'redirectTo')
        }, 500)
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    goWithLoading(url, type = 'navigateTo', tip = '加载中...') {
      this.pageLoadingTip = tip
      this.pageLoading = true
      setTimeout(() => {
        if (type === 'switchTab') { uni.switchTab({ url }) }
        else if (type === 'reLaunch') { uni.reLaunch({ url }) }
        else if (type === 'redirectTo') { uni.redirectTo({ url }) }
        else if (type === 'navigateBack') { uni.navigateBack() }
        else { uni.navigateTo({ url }) }
        setTimeout(() => { this.pageLoading = false }, 500)
      }, 100)
    }
  }
}
</script>

<style lang="scss" scoped>
.checkout {
  min-height: 100vh;
  background: #F0EFF5;
  display: flex;
  flex-direction: column;

  &__header {
    background: linear-gradient(180deg, #FFECEC 0%, #FFF5F5 100%);
    flex-shrink: 0;
	
    padding-top: calc(var(--status-bar-height, 88rpx) + 30rpx);
  }

  &__nav {
    display: flex;
    align-items: center;
    // justify-content: space-between;
    height: 88rpx;
    padding: 0 24rpx;
  }

  &__back-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 72rpx;
    color: #333333;
    font-weight: 400;
    line-height: 1;
  }

  &__logo {
    height: 300rpx;
    width: 300rpx;
  }

  &__nav-empty {
    width: 64rpx;
  }

  &__scroll {
    flex: 1;
    background: linear-gradient(180deg, #FFF5F5 0%, #FFF5F5 320rpx, #F0EFF5 320rpx, #F0EFF5 100%);
  }

  &__section {
    &--address {
      background: transparent;
      margin: 0;
      padding: 20rpx 32rpx 24rpx;
      border-radius: 0;
    }

    &--delivery {
      background: transparent;
      margin: 0;
      padding: 0 32rpx 24rpx;
      border-radius: 0;
    }

    &--dishes {
      background: #FFFFFF;
      margin: 16rpx 24rpx;
      border-radius: 16rpx;
      padding: 28rpx;
    }

    &--pay,
    &--remark {
      background: #FFFFFF;
      margin: 16rpx 24rpx;
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

  &__arrow {
    font-size: 32rpx;
    color: #999999;
    line-height: 1;
    margin-left: 12rpx;
    font-weight: 400;
  }

  &__section-title-row {
    margin-bottom: 30rpx;
  }

  &__section-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #111111;
  }

  &__info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 4rpx 0;

    &--clickable {
      padding: 4rpx 0;
    }
  }

  &__info-label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__info-right {
    display: flex;
    align-items: center;
  }

  &__info-value {
    font-size: 26rpx;
    color: #999999;

    &--primary {
      color: #D00000;
      font-weight: 500;
    }
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
    position: absolute;
    top: 20rpx;
    right: 0;
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
    border-top: 1rpx solid #F5F5F5;
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

    &--discount {
      color: #D00000;
    }

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

  &__remark-input {
    text-align: right;
    font-size: 26rpx;
    color: #333333;
    flex: 1;
  }

  &__remark-placeholder {
    color: #CCCCCC;
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

  &__bottom-space {
    height: 40rpx;
  }

  &__pay-picker-mask {
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

  &__pay-options {
    margin-bottom: 32rpx;
  }

  &__pay-option {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 0;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }
  }

  &__pay-option-name {
    font-size: 28rpx;
    color: #111111;
    font-weight: 500;
  }

  &__pay-option-check {
    width: 40rpx;
    height: 40rpx;
    background: #D00000;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__pay-option-check-icon {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: bold;
  }

  &__pay-picker-close {
    font-size: 28rpx;
    color: #999999;
    text-align: center;
    padding: 20rpx 0;
  }
}
</style>
