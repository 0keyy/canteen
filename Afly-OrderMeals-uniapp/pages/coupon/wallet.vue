<template>
  <view class="wallet-page">
    <view class="wallet-page__header">
      <view class="wallet-page__back-btn" @tap="goBack">
        <text class="wallet-page__back-icon">‹</text>
      </view>
      <text class="wallet-page__title">我的卡券</text>
      <view class="wallet-page__header-right"></view>
    </view>

    <view class="wallet-page__tabs">
      <view
        v-for="tab in tabs"
        :key="tab.value"
        class="wallet-page__tab"
        :class="{ 'wallet-page__tab--active': activeTab === tab.value }"
        @tap="switchTab(tab.value)"
      >
        <text>{{ tab.label }}</text>
      </view>
    </view>

    <scroll-view class="wallet-page__content" scroll-y :show-scrollbar="false">
      <view v-if="loading" class="wallet-page__empty">
        <text class="wallet-page__empty-text">加载中...</text>
      </view>

      <view v-else-if="coupons.length === 0" class="wallet-page__empty">
        <image :src="staticImgPrefix + '/tabbar/优惠券.png'" mode="aspectFit" class="wallet-page__empty-icon"></image>
        <text class="wallet-page__empty-text">暂无优惠券</text>
        <text class="wallet-page__empty-sub">去领券中心看看吧</text>
      </view>

      <view v-else class="wallet-page__list">
        <view
          v-for="coupon in coupons"
          :key="coupon.id"
          class="coupon-card"
          :class="{ 'coupon-card--used': coupon.status === 2, 'coupon-card--expired': coupon.status === 3 }"
        >
          <view class="coupon-card__left">
            <text class="coupon-card__amount">¥{{ coupon.discountAmount }}</text>
            <text class="coupon-card__condition">
              <template v-if="coupon.type === 2 && coupon.minAmount > 0">
                满{{ coupon.minAmount }}元
              </template>
              <template v-else>
                无门槛
              </template>
            </text>
          </view>
          <view class="coupon-card__right">
            <text class="coupon-card__name">{{ coupon.templateName }}</text>
            <text class="coupon-card__period">
              {{ formatTime(coupon.useStartTime) }}~{{ formatTime(coupon.useEndTime) }}
            </text>
            <view class="coupon-card__bottom">
              <text class="coupon-card__tip">{{ coupon.tip || '限堂食到店使用' }}</text>
              <view v-if="coupon.status === 1" class="coupon-card__use-btn" @tap="useCoupon(coupon)">
                <text class="coupon-card__use-text">去使用</text>
              </view>
            </view>
          </view>

          <view v-if="coupon.status === 2" class="coupon-card__watermark">
            <text>已使用</text>
          </view>
          <view v-if="coupon.status === 3" class="coupon-card__watermark">
            <text>已过期</text>
          </view>
        </view>
      </view>

      <view class="wallet-page__bottom-space"></view>
    </scroll-view>

    <view class="wallet-page__footer safe-area-bottom">
      <view class="wallet-page__exchange-btn" @tap="goExchange">
        <text class="wallet-page__exchange-text">兑换优惠券</text>
      </view>
    </view>
  </view>
</template>

<script>
import { couponApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

export default {
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      tabs: [
        { label: '到店堂食', value: 'instore' },
        { label: '外卖配送', value: 'delivery' }
      ],
      activeTab: 'instore',
      loading: false,
      coupons: []
    }
  },
  onShow() {
    this.loadCoupons()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    formatTime(ts) {
      if (!ts || ts === 0) return '不限'
      const d = new Date(ts * 1000)
      const y = d.getFullYear()
      const M = String(d.getMonth() + 1).padStart(2, '0')
      const D = String(d.getDate()).padStart(2, '0')
      return `${y}.${M}.${D}`
    },
    switchTab(value) {
      this.activeTab = value
      this.loadCoupons()
    },
    async loadCoupons() {
      this.loading = true
      try {
        const list = await couponApi.myCoupons(1) || []
        this.coupons = list
      } catch (e) {
        this.coupons = []
      } finally {
        this.loading = false
      }
    },
    getMockCoupons() {
      return []
    },
    useCoupon(coupon) {
      if (coupon.type === 3 || coupon.type === 4) {
        uni.navigateTo({ url: `/pages/coupon/verify-code?id=${coupon.id}` })
      } else {
        uni.switchTab({ url: '/pages/menu/index' })
      }
    },
    goExchange() {
      uni.navigateTo({ url: '/pages/coupon/center' })
    }
  }
}
</script>

<style lang="scss" scoped>
.wallet-page {
  min-height: 100vh;
  background: #F5F5F5;
  display: flex;
  flex-direction: column;

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 60rpx 32rpx 24rpx;
    background: #FFFFFF;
	margin-top: 38rpx;
  }

  &__back-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 80rpx;
    color: #333333;
    font-weight: 300;
    line-height: 1;
  }

  &__title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333333;
  }

  &__header-right {
    width: 64rpx;
  }

  &__tabs {
    display: flex;
    background: #FFFFFF;
  }

  &__tab {
    flex: 1;
    text-align: center;
    padding: 28rpx 0;
    font-size: 30rpx;
    color: #666666;
    position: relative;
	font-weight: 600;

    &--active {
      color: #2e2e2e;


      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 48rpx;
        height: 4rpx;
        background: #be0000;
        border-radius: 2rpx;
      }
    }
  }

  &__content {
    flex: 1;
    padding: 24rpx;
	background: #e0e0e0;
  }

  &__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 160rpx 32rpx;
  }

  &__empty-icon {
    width: 120rpx;
    height: 120rpx;
    opacity: 0.5;
  }

  &__empty-text {
    margin-top: 24rpx;
    font-size: 28rpx;
    color: #999999;
  }

  &__empty-sub {
    margin-top: 8rpx;
    font-size: 24rpx;
    color: #CCCCCC;
  }

  &__list {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  &__bottom-space {
    height: 40rpx;
  }

  &__footer {
    padding: 24rpx 32rpx;
    background: #FFFFFF;
    flex-shrink: 0;
  }

  &__exchange-btn {
    background: #be0000;
    border-radius: 8rpx;
    padding: 28rpx;
    text-align: center;
	margin-bottom: 16rpx;

    &:active {
      opacity: 0.9;
    }
  }

  &__exchange-text {
    color: #FFFFFF;
    font-size: 32rpx;
    font-weight: 600;
  }
}

.coupon-card {
  background: #FFFFFF;
  border-radius: 12rpx;
  display: flex;
  overflow: hidden;
  position: relative;

  &--used,
  &--expired {
    opacity: 0.5;
  }

  &__left {
    width: 180rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 24rpx 16rpx;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      right: 0;
      top: 0;
      bottom: 0;
      width: 2rpx;
      background: repeating-linear-gradient(
        to bottom,
        #E8E8E8,
        #E8E8E8 4rpx,
        transparent 4rpx,
        transparent 10rpx
      );
    }
  }

  &__amount {
    font-size: 48rpx;
    font-weight: 700;
    color: #be0000;
  }

  &__condition {
    margin-top: 4rpx;
    font-size: 22rpx;
    color: #be0000;
  }

  &__right {
    flex: 1;
    padding: 20rpx 24rpx;
    display: flex;
    flex-direction: column;
  }

  &__name {
    font-size: 28rpx;
    font-weight: 600;
    color: #333333;
    line-height: 1.4;
  }

  &__period {
    font-size: 24rpx;
    color: #999999;
    margin-top: 8rpx;
  }

  &__bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: auto;
    padding-top: 12rpx;
  }

  &__tip {
    font-size: 20rpx;
    color: #CCCCCC;
  }

  &__use-btn {
    background: #be0000;
    border-radius: 999rpx;
    padding: 8rpx 24rpx;
    flex-shrink: 0;

    &:active {
      opacity: 0.8;
    }
  }

  &__use-text {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: 500;
  }

  &__watermark {
    position: absolute;
    right: 20rpx;
    bottom: 20rpx;
    transform: rotate(-15deg);

    text {
      font-size: 36rpx;
      font-weight: 700;
      color: rgba(153, 153, 153, 0.4);
    }
  }
}
</style>
