<template>
  <view class="checkout" v-if="order">
    <view class="checkout__header">
      <view class="checkout__nav">
        <view class="checkout__back-btn" @tap="goBack">
          <text class="checkout__back-icon">‹</text>
        </view>
        <image class="checkout__logo" :src="staticImgPrefix + '/logo.png'" mode="aspectFit" />
        <view class="checkout__nav-empty"></view>
      </view>
      <text class="checkout__header-title">请确认用餐方式</text>
    </view>

    <scroll-view class="checkout__scroll" scroll-y :show-scrollbar="false">
      <view class="checkout__section checkout__section--dining-mode">
        <view 
          class="checkout__mode-card" 
          :class="{ 'checkout__mode-card--active': diningMode === 1 }"
          @tap="selectDiningMode(1)"
        >
          <view class="checkout__mode-icon">
            <image :src="staticImgPrefix + '/tabbar/商城-幸福餐桌 1.png'" mode="aspectFit" />
          </view>
          <text class="checkout__mode-name">堂食</text>
          <text class="checkout__mode-desc">店内用餐</text>
          <view v-if="diningMode === 1" class="checkout__mode-check">✓</view>
        </view>
        <view 
          class="checkout__mode-card" 
          :class="{ 'checkout__mode-card--active': diningMode === 2 }"
          @tap="selectDiningMode(2)"
        >
          <view class="checkout__mode-icon">
            <image :src="staticImgPrefix + '/tabbar/打包 1.png'" mode="aspectFit" />
          </view>
          <text class="checkout__mode-name">打包</text>
          <text class="checkout__mode-desc">打包带走</text>
          <view v-if="diningMode === 2" class="checkout__mode-check">✓</view>
        </view>
      </view>

      <view class="checkout__section checkout__section--time" @tap="showTimePicker = true">
        <text class="checkout__section-label">取餐时间</text>
        <view class="checkout__section-right">
          <text class="checkout__section-value checkout__section-value--primary">{{ pickupTimeText }}</text>
          <text class="checkout__arrow">›</text>
        </view>
      </view>

      <view class="checkout__section checkout__section--dishes">
        <view class="checkout__section-title-row">
          <text class="checkout__section-title">餐品详情</text>
        </view>
        <view class="checkout__items">
          <view v-for="dish in order.dishes" :key="dish.id" class="checkout__item">
            <image
              class="checkout__item-img"
              :src="dish.dishImage ? dish.dishImage.replace(/^http:/, 'https:') : staticImgPrefix + '/placeholder.png'"
              mode="aspectFill"
            />
            <view class="checkout__item-info">
              <text class="checkout__item-name">{{ dish.dishName }}</text>
            </view>
            <view class="checkout__item-right">
              <text class="checkout__item-qty">{{ dish.quantity }}份</text>
              <text class="checkout__item-price">¥{{ lineAmount(dish) }}</text>
            </view>
          </view>
        </view>

        <view class="checkout__amount-section">
          <view class="checkout__amount-row">
            <text class="checkout__amount-label">商品金额</text>
            <text class="checkout__amount-value">¥{{ totalAmount }}</text>
          </view>
          <view class="checkout__amount-row" v-if="selectedCoupon">
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

      <view class="checkout__section checkout__section--coupon" @tap="showCouponPicker = true">
        <view class="checkout__coupon-left">
          <text class="checkout__coupon-icon">券</text>
          <text class="checkout__section-label">可用优惠券</text>
        </view>
        <view class="checkout__section-right">
          <text class="checkout__section-value" :class="{ 'checkout__section-value--primary': selectedCoupon }">
            {{ selectedCoupon ? `-${couponDiscount.toFixed(2)}元` : `${availableCoupons.length}个可用` }}
          </text>
          <text class="checkout__arrow">›</text>
        </view>
      </view>

      <view class="checkout__section checkout__section--pay" @tap="showPayPicker = true">
        <text class="checkout__section-label">支付方式</text>
        <view class="checkout__section-right">
          <text class="checkout__section-value">{{ payChannelText }}</text>
          <text class="checkout__arrow">›</text>
        </view>
      </view>

      <view class="checkout__section checkout__section--remark">
        <text class="checkout__section-label">备注</text>
        <input
          v-model="remark"
          class="checkout__remark-input"
          placeholder="请输入"
          placeholder-class="checkout__remark-placeholder"
        />
      </view>

      <view class="checkout__bottom-space"></view>
    </scroll-view>

    <view class="checkout__footer safe-area-bottom">
      <view class="checkout__submit-bar">
        <view class="checkout__submit-info">
          <text class="checkout__submit-label">合计:</text>
          <text class="checkout__submit-price">¥{{ finalAmount }}</text>
        </view>
        <view class="checkout__submit-btn" @click="handleSubmit" :class="{ 'checkout__submit-btn--disabled': loading }">
          <text class="checkout__submit-btn-text">{{ loading ? '提交中...' : '去支付' }}</text>
        </view>
      </view>
    </view>

    <view class="checkout__mask" v-if="showTimePicker" @tap="showTimePicker = false">
      <view class="checkout__time-picker" @tap.stop>
        <view class="checkout__picker-header">
          <text class="checkout__picker-title">请选择时间</text>
        </view>
        <view class="checkout__time-content">
          <scroll-view scroll-y class="checkout__time-days">
            <view 
              v-for="(day, idx) in timeDays" 
              :key="idx"
              class="checkout__time-day"
              :class="{ 'checkout__time-day--active': selectedTimeDay === idx }"
              @tap="selectedTimeDay = idx"
            >
              <text>{{ day.label }}</text>
            </view>
          </scroll-view>
          <scroll-view scroll-y class="checkout__time-slots">
            <view 
              v-for="(slot, idx) in currentTimeSlots" 
              :key="idx"
              class="checkout__time-slot"
              :class="{ 'checkout__time-slot--active': selectedTimeSlot === idx }"
              @tap="selectedTimeSlot = idx"
            >
              <text>{{ slot }}</text>
              <view v-if="selectedTimeSlot === idx" class="checkout__slot-check">✓</view>
            </view>
          </scroll-view>
        </view>
        <view class="checkout__picker-confirm" @tap="confirmTime">确认</view>
      </view>
    </view>

    <view class="checkout__mask" v-if="showCouponPicker" @tap="showCouponPicker = false">
      <view class="checkout__coupon-picker" @tap.stop>
        <view class="checkout__picker-header">
          <text class="checkout__picker-title">选择优惠券</text>
          <text class="checkout__picker-close" @tap="showCouponPicker = false">关闭</text>
        </view>
        <scroll-view scroll-y class="checkout__coupon-list">
          <view 
            class="checkout__coupon-item"
            :class="{ 'checkout__coupon-item--selected': !selectedCouponId }"
            @tap="selectCoupon(0)"
          >
            <view class="checkout__coupon-empty">不使用优惠券</view>
            <view v-if="!selectedCouponId" class="checkout__coupon-check">✓</view>
          </view>
          <view 
            v-for="coupon in availableCoupons" 
            :key="coupon.id"
            class="checkout__coupon-item"
            :class="{ 'checkout__coupon-item--selected': selectedCouponId === coupon.id }"
            @tap="selectCoupon(coupon.id)"
          >
            <view class="checkout__coupon-left">
              <text class="checkout__coupon-amount">¥{{ coupon.discountAmount }}</text>
              <text class="checkout__coupon-condition">满{{ coupon.minAmount }}元可用</text>
            </view>
            <view class="checkout__coupon-center">
              <text class="checkout__coupon-name">{{ coupon.name }}</text>
              <text class="checkout__coupon-expire">{{ coupon.endTime ? formatTime(coupon.endTime) + '到期' : '' }}</text>
            </view>
            <view class="checkout__coupon-right">
              <view v-if="selectedCouponId === coupon.id" class="checkout__coupon-check-wrap">
                <view class="checkout__coupon-check-inner">✓</view>
              </view>
            </view>
          </view>
        </scroll-view>
      </view>
    </view>

    <view class="checkout__mask" v-if="showPayPicker" @tap="showPayPicker = false">
      <view class="checkout__pay-picker" @tap.stop>
        <view class="checkout__picker-header">
          <text class="checkout__picker-title">支付方式</text>
        </view>
        <scroll-view scroll-y class="checkout__pay-list">
          <view 
          v-for="method in payMethodList" 
          :key="method.channel"
          class="checkout__pay-item"
          :class="{ 'checkout__pay-item--disabled': !method.enabled }"
          @tap="selectPayMethod(method)"
        >
            <view class="checkout__pay-info">
              <text class="checkout__pay-name">{{ method.name }}</text>
              <text class="checkout__pay-desc">{{ getPayMethodDesc(method) }}</text>
            </view>
            <view class="checkout__pay-right">
              <text v-if="method.tips" class="checkout__pay-tips">{{ method.tips }}</text>
              <view 
                v-if="payChannel === method.channel" 
                class="checkout__pay-check"
              >✓</view>
            </view>
          </view>
        </scroll-view>
        <view class="checkout__picker-cancel" @tap="showPayPicker = false">取消</view>
      </view>
    </view>

    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import { orderApi, couponApi, payApi } from '../../api/index'
import { payOrder, DEFAULT_PAY_CHANNEL } from '../../utils/pay/index'
import PageLoading from '../../components/page-loading/page-loading.vue'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

export default {
  components: { PageLoading },
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      orderId: 0,
      order: null,
      remark: '',
      loading: false,
      pageLoading: false,
      pageLoadingTip: '',
      diningMode: 1,
      payChannel: DEFAULT_PAY_CHANNEL,
      couponDiscount: 0,
      selectedCouponId: 0,
      showPayPicker: false,
      showTimePicker: false,
      showCouponPicker: false,
      payMethodList: [],
      availableCoupons: [],
      selectedCoupon: null,
      selectedTimeDay: 0,
      selectedTimeSlot: 0,
      pickupTime: '立即取餐'
    }
  },
  computed: {
    diningModeText() {
      return { 1: '堂食', 2: '打包' }[this.diningMode] || '堂食'
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
    pickupTimeText() {
      return this.pickupTime
    },
    timeDays() {
      const today = new Date()
      const tomorrow = new Date(today)
      tomorrow.setDate(tomorrow.getDate() + 1)
      const weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六']
      return [
        { label: `今天（${weekdays[today.getDay()]}）` },
        { label: `明天（${weekdays[tomorrow.getDay()]}）` }
      ]
    },
    currentTimeSlots() {
      const slots = ['立即取餐']
      const now = new Date()
      const startHour = now.getHours() + 1
      for (let i = 0; i < 8; i++) {
        const hour = startHour + i
        if (hour >= 24) break
        slots.push(`${hour.toString().padStart(2, '0')}:20-${hour.toString().padStart(2, '0')}:40取餐`)
      }
      return slots
    }
  },
  async onLoad() {
    this.orderId = Number(uni.getStorageSync('orderId'))
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    await this.loadDetail()
    await this.loadCoupons()
    this.loadBestCoupon()
    this.loadPayMethods()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    selectDiningMode(mode) {
      this.diningMode = mode
      uni.setStorageSync('diningMode', mode)
    },
    confirmTime() {
      if (this.currentTimeSlots.length > 0) {
        this.pickupTime = this.currentTimeSlots[this.selectedTimeSlot]
      }
      this.showTimePicker = false
    },
    async loadCoupons() {
      try {
        const list = await couponApi.myCoupons(0)
        this.availableCoupons = (list || []).filter(c => {
          const minAmount = Number(c.minAmount || 0)
          return minAmount <= Number(this.totalAmount)
        })
      } catch (e) {
        this.availableCoupons = []
      }
    },
    selectCoupon(couponId) {
      this.selectedCouponId = couponId
      if (couponId === 0) {
        this.selectedCoupon = null
        this.couponDiscount = 0
      } else {
        const coupon = this.availableCoupons.find(c => c.id === couponId)
        this.selectedCoupon = coupon
        this.couponDiscount = Number(coupon?.discountAmount || 0)
      }
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
    async loadDetail() {
      try {
        this.order = await orderApi.detail(this.orderId)
      } catch (e) {
        this.order = { dishes: [], amount: '0.00' }
      }
    },
    async loadPayMethods() {
      try {
        const list = await payApi.methods(this.orderId)
        this.payMethodList = Array.isArray(list) ? list : []
        const enabled = this.payMethodList.find((m) => m.channel === this.payChannel && m.enabled)
        if (!enabled) {
          const fallback = this.payMethodList.find((m) => m.enabled)
          if (fallback) {
            this.payChannel = fallback.channel
          }
        }
      } catch (e) {
        this.payMethodList = []
      }
    },
    async loadBestCoupon() {
      try {
        const result = await couponApi.bestForOrder(this.orderId)
        if (result && result.hasCoupon) {
          this.selectedCouponId = result.userCouponId
          const coupon = this.availableCoupons.find(c => c.id === result.userCouponId)
          this.selectedCoupon = coupon
          this.couponDiscount = Number(result.discountAmount || 0)
        }
      } catch (e) {
        if (this.availableCoupons.length > 0) {
          const best = this.availableCoupons.reduce((max, c) => 
            Number(c.discountAmount || 0) > Number(max.discountAmount || 0) ? c : max
          )
          this.selectedCouponId = best.id
          this.selectedCoupon = best
          this.couponDiscount = Number(best.discountAmount || 0)
        }
      }
    },
    getPayMethodDesc(item) {
      if (item.channel === 'balance' && item.balance !== undefined) {
        return `可用余额 ${item.balance}，本次需 ${item.requiredBalance || 0}`
      }
      if (item.channel === 'credit') {
        const limit = item.creditLimit ?? 0
        const used = item.creditUsed ?? 0
        const remain = item.creditRemain ?? 0
        return `挂账支付，已用 ${used}，剩余 ${remain}`
      }
      if (item.channel === 'online') {
        return '微信/支付宝等（聚合支付）'
      }
      if (item.channel === 'wechat') {
        return '直连微信支付'
      }
      return item.desc || ''
    },
    formatTime(time) {
      if (!time) return ''
      const date = new Date(time)
      const year = date.getFullYear()
      const month = (date.getMonth() + 1).toString().padStart(2, '0')
      const day = date.getDate().toString().padStart(2, '0')
      const hour = date.getHours().toString().padStart(2, '0')
      const minute = date.getMinutes().toString().padStart(2, '0')
      return `${year}.${month}.${day} ${hour}:${minute}`
    },
    selectPayMethod(method) {
      if (!method.enabled) {
        uni.showToast({ title: method.disabledReason || '该支付方式不可用', icon: 'none' })
        return
      }
      this.payChannel = method.channel
      this.showPayPicker = false
    },
    async handleSubmit() {
      if (this.loading) return
      this.loading = true
      this.pageLoading = true
      this.pageLoadingTip = '提交中...'
      try {
        await orderApi.submit({
          orderId: this.orderId,
          remark: this.remark,
          couponId: this.selectedCouponId || null
        })
        await payOrder(this.orderId, this.payChannel, 'mp')
        uni.removeStorageSync('orderId')
        uni.showToast({ title: '支付成功', icon: 'success' })
        setTimeout(() => {
          uni.redirectTo({ url: `/pages/order/detail?orderId=${this.orderId}` })
        }, 500)
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      } finally {
        this.loading = false
        this.pageLoading = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.checkout {
  min-height: 100vh;
  background: #FFF5F5;
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
    margin: 0 auto;
  }

  &__nav-empty {
    width: 64rpx;
  }

  &__header-title {
    display: block;
    text-align: center;
    font-size: 28rpx;
    color: #666666;
    padding-bottom: 20rpx;
  }

  &__scroll {
    flex: 1;
    background: #FFF5F5;
  }

  &__section {
    background: #FFFFFF;
    margin: 16rpx 24rpx;
    border-radius: 16rpx;
    padding: 28rpx;
    display: flex;
    align-items: center;
    justify-content: space-between;

    &--dining-mode {
      display: flex;
      justify-content: space-between;
      gap: 24rpx;
    }

    &--dishes {
      display: block;
    }

    &--coupon {
      padding: 24rpx 28rpx;
    }

    &--pay,
    &--remark {
      padding: 24rpx 28rpx;
    }
  }

  &__mode-card {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 32rpx 20rpx;
    border-radius: 16rpx;
    border: 2rpx solid #E8E8E8;
    position: relative;
    background: #FFFFFF;

    &--active {
      border-color: #E33A30;
      background: #FFF5F5;
    }
  }

  &__mode-icon {
    width: 80rpx;
    height: 80rpx;
    margin-bottom: 16rpx;
  }

  &__mode-name {
    font-size: 32rpx;
    font-weight: 600;
    color: #333333;
    margin-bottom: 8rpx;
  }

  &__mode-desc {
    font-size: 24rpx;
    color: #999999;
  }

  &__mode-check {
    position: absolute;
    top: 16rpx;
    right: 16rpx;
    width: 40rpx;
    height: 40rpx;
    background: #E33A30;
    border-radius: 50%;
    color: #FFFFFF;
    font-size: 24rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__section-label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__section-right {
    display: flex;
    align-items: center;
  }

  &__section-value {
    font-size: 26rpx;
    color: #999999;

    &--primary {
      color: #E33A30;
      font-weight: 600;
    }
  }

  &__arrow {
    font-size: 32rpx;
    color: #999999;
    line-height: 1;
    margin-left: 12rpx;
    font-weight: 400;
  }

  &__section-title-row {
    margin-bottom: 24rpx;
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
    align-items: center;
    padding: 20rpx 0;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }
  }

  &__item-img {
    width: 120rpx;
    height: 120rpx;
    border-radius: 12rpx;
    background: #F5F5F5;
    flex-shrink: 0;
  }

  &__item-info {
    flex: 1;
    margin-left: 20rpx;
    min-width: 0;
  }

  &__item-name {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: block;
  }

  &__item-right {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 8rpx;
    flex-shrink: 0;
  }

  &__item-qty {
    font-size: 24rpx;
    color: #999999;
  }

  &__item-price {
    font-size: 30rpx;
    color: #E33A30;
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
    padding: 12rpx 0;

    &--total {
      padding-top: 16rpx;
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
      color: #E33A30;
    }

    &--total {
      font-size: 32rpx;
      font-weight: 700;
      color: #E33A30;
    }
  }

  &__divider {
    height: 1rpx;
    background: #F5F5F5;
    margin: 8rpx 0;
  }

  &__coupon-left {
    display: flex;
    align-items: center;
    gap: 8rpx;
  }

  &__coupon-icon {
    width: 40rpx;
    height: 40rpx;
    background: #E33A30;
    color: #FFFFFF;
    font-size: 24rpx;
    border-radius: 8rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__coupon-empty {
    font-size: 28rpx;
    color: #999999;
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
    color: #E33A30;
  }

  &__submit-btn {
    background: #B80000;
    padding: 22rpx 56rpx;
    border-radius: 44rpx;

    &:active {
      opacity: 0.9;
    }

    &--disabled {
      background: #CCCCCC;
      pointer-events: none;
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

  &__mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    align-items: flex-end;
  }

  &__picker-header {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 32rpx 0;
    border-bottom: 1rpx solid #F0F0F0;
  }

  &__picker-title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333333;
  }

  &__picker-close {
    position: absolute;
    right: 32rpx;
    font-size: 28rpx;
    color: #999999;
  }

  &__time-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 24rpx 24rpx 0 0;
    padding-bottom: env(safe-area-inset-bottom);
  }

  &__time-content {
    display: flex;
    height: 500rpx;
  }

  &__time-days {
    width: 200rpx;
    background: #F5F5F5;
  }

  &__time-day {
    height: 100rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 26rpx;
    color: #666666;

    &--active {
      background: #FFFFFF;
      color: #333333;
      font-weight: 600;
    }
  }

  &__time-slots {
    flex: 1;
    padding: 0 20rpx;
  }

  &__time-slot {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 100rpx;
    font-size: 26rpx;
    color: #333333;
    border-bottom: 1rpx solid #F5F5F5;

    &--active {
      color: #E33A30;
      font-weight: 600;
    }
  }

  &__slot-check {
    color: #E33A30;
    font-size: 32rpx;
  }

  &__picker-confirm {
    background: #B80000;
    color: #FFFFFF;
    font-size: 32rpx;
    font-weight: 600;
    text-align: center;
    padding: 32rpx 0;
  }

  &__coupon-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 24rpx 24rpx 0 0;
    padding-bottom: env(safe-area-inset-bottom);
    position: relative;
  }

  &__coupon-list {
    max-height: 600rpx;
  }

  &__coupon-item {
    display: flex;
    align-items: center;
    padding: 28rpx 32rpx;
    border-bottom: 1rpx solid #F5F5F5;

    &--selected {
      background: #FFF5F5;
    }
  }

  &__coupon-left {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    margin-right: 24rpx;
  }

  &__coupon-amount {
    font-size: 48rpx;
    font-weight: 700;
    color: #E33A30;
    line-height: 1;
  }

  &__coupon-condition {
    font-size: 24rpx;
    color: #999999;
    margin-top: 8rpx;
  }

  &__coupon-center {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 8rpx;
  }

  &__coupon-name {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__coupon-expire {
    font-size: 24rpx;
    color: #999999;
  }

  &__coupon-right {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 16rpx;
  }

  &__coupon-check-wrap {
    width: 48rpx;
    height: 48rpx;
    background: #FF9500;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__coupon-check-inner {
    color: #FFFFFF;
    font-size: 28rpx;
    font-weight: bold;
  }

  &__coupon-check {
    color: #E33A30;
    font-size: 32rpx;
    font-weight: bold;
  }

  &__pay-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 24rpx 24rpx 0 0;
    padding-bottom: env(safe-area-inset-bottom);
  }

  &__pay-list {
    max-height: 600rpx;
  }

  &__pay-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 32rpx;
    border-bottom: 1rpx solid #F5F5F5;

    &--disabled {
      opacity: 0.5;
    }
  }

  &__pay-info {
    display: flex;
    flex-direction: column;
    gap: 8rpx;
  }

  &__pay-name {
    font-size: 30rpx;
    color: #333333;
    font-weight: 500;
  }

  &__pay-desc {
    font-size: 24rpx;
    color: #999999;
  }

  &__pay-right {
    display: flex;
    align-items: center;
    gap: 16rpx;
  }

  &__pay-tips {
    font-size: 24rpx;
    color: #E33A30;
  }

  &__pay-check {
    color: #E33A30;
    font-size: 32rpx;
    font-weight: bold;
  }

  &__picker-cancel {
    text-align: center;
    padding: 28rpx 0;
    font-size: 28rpx;
    color: #999999;
    border-top: 1rpx solid #F0F0F0;
  }
}
</style>