<template>
  <view class="coupon-wallet">
    <view class="coupon-wallet__tabs">
      <view
        v-for="tab in tabs"
        :key="tab.status"
        class="coupon-wallet__tab"
        :class="{ 'coupon-wallet__tab--active': activeTab === tab.status }"
        @tap="switchTab(tab.status)"
      >
        <text>{{ tab.label }}</text>
      </view>
    </view>

    <view v-if="loading" class="coupon-wallet__status">
      <text>加载中...</text>
    </view>

    <view v-else-if="coupons.length === 0" class="coupon-wallet__status">
      <image src="/static/tabbar/优惠券.png" mode="" class="coupon-wallet__empty-icon"></image>
      <text class="coupon-wallet__empty-text">暂无优惠券</text>
      <text class="coupon-wallet__empty-sub">去领券中心看看吧</text>
    </view>

    <scroll-view v-else class="coupon-wallet__list" scroll-y :show-scrollbar="false">
      <view
        v-for="coupon in coupons"
        :key="coupon.id"
        class="coupon-item"
        :class="{ 'coupon-item--used': coupon.status === 2, 'coupon-item--expired': coupon.status === 3 }"
      >
        <view class="coupon-item__body">
          <view class="coupon-item__left">
            <text class="coupon-item__amount">¥{{ coupon.discountAmount }}</text>
            <text class="coupon-item__condition">
              <template v-if="coupon.type === 2 && coupon.minAmount > 0">
                满{{ coupon.minAmount }}元
              </template>
              <template v-else-if="coupon.type === 5">
                夜间券
              </template>
              <template v-else-if="coupon.type === 3 || coupon.type === 4">
                到店核销
              </template>
              <template v-else>
                无门槛
              </template>
            </text>
          </view>
          <view class="coupon-item__info">
            <view class="coupon-item__name-row">
              <text class="coupon-item__name">{{ coupon.templateName }}</text>
              <text class="coupon-item__tag">{{ typeLabel(coupon.type) }}</text>
            </view>
            <text class="coupon-item__period">
              有效期：{{ formatTime(coupon.useStartTime) }} ~ {{ formatTime(coupon.useEndTime) }}
            </text>
            <text v-if="coupon.nightUnavailable" class="coupon-item__night-tip">当前不在夜间可用时段</text>
            <text v-if="coupon.status === 2" class="coupon-item__used-time">
              使用时间：{{ formatTime(coupon.useTime) }}
            </text>
          </view>
        </view>

        <view v-if="coupon.status === 1 && (coupon.type === 3 || coupon.type === 4)" class="coupon-item__verify">
          <text class="coupon-item__verify-btn" @tap="goVerifyCode(coupon)">查看核销码</text>
        </view>

        <view v-if="coupon.status === 2" class="coupon-item__watermark">
          <text>已使用</text>
        </view>
        <view v-if="coupon.status === 3" class="coupon-item__watermark">
          <text>已过期</text>
        </view>
      </view>
    </scroll-view>
    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import { couponApi } from '../../api/index'
import PageLoading from '../../components/page-loading/page-loading.vue'

export default {
  components: { PageLoading },
  data() {
    return {
      tabs: [
        { label: '可使用', status: 1 },
        { label: '已使用', status: 2 },
        { label: '已过期', status: 3 }
      ],
      activeTab: 1,
      loading: false,
      coupons: [],
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  onShow() {
    this.loadCoupons()
  },
  methods: {
    typeLabel(type) {
      const map = { 1: '无门槛', 2: '满减', 3: '兑换券', 4: '套餐券', 5: '夜间券' }
      return map[type] || ''
    },
    formatTime(ts) {
      if (!ts || ts === 0) return '不限'
      const d = new Date(ts * 1000)
      const M = String(d.getMonth() + 1).padStart(2, '0')
      const D = String(d.getDate()).padStart(2, '0')
      return `${M}/${D}`
    },
    switchTab(status) {
      this.activeTab = status
      this.loadCoupons()
    },
    async loadCoupons() {
      this.loading = true
      try {
        this.coupons = await couponApi.myCoupons(this.activeTab) || []
      } catch (e) {
        uni.showToast({ title: e || '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    goVerifyCode(coupon) {
      this.goWithLoading(`/pages/coupon/verify-code?id=${coupon.id}`)
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
.coupon-wallet {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;

  &__tabs {
    display: flex;
    background: #fff;
    border-bottom: 2rpx solid $divider-color;
  }

  &__tab {
    flex: 1;
    text-align: center;
    padding: 24rpx 0;
    font-size: 28rpx;
    color: $text-secondary;
    position: relative;

    &--active {
      color: $brand-primary;
      font-weight: 700;

      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 48rpx;
        height: 4rpx;
        background: $brand-primary;
        border-radius: 2rpx;
      }
    }
  }

  &__status {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 120rpx 32rpx;
  }

  &__empty-icon {
    width: 80rpx;
	height: 80rpx;
  }

  &__empty-text {
    margin-top: 24rpx;
    font-size: 28rpx;
    color: $text-primary;
    font-weight: 600;
  }

  &__empty-sub {
    margin-top: 8rpx;
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__list {
    flex: 1;
    padding: 24rpx;
  }
}

.coupon-item {
  background: #fff;
  border-radius: $radius-card;
  margin-bottom: 20rpx;
  overflow: hidden;
  position: relative;
  box-shadow: $shadow-sm;

  &--used {
    opacity: 0.6;
  }

  &--expired {
    opacity: 0.45;
  }

  &__body {
    display: flex;
    padding: 28rpx 24rpx;
  }

  &__left {
    width: 170rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    border-right: 2rpx dashed rgba($brand-primary, 0.2);
    padding-right: 20rpx;
  }

  &__amount {
    font-size: 44rpx;
    font-weight: 900;
    color: $brand-primary;
  }

  &__condition {
    margin-top: 6rpx;
    font-size: 20rpx;
    color: $text-secondary;
    text-align: center;
  }

  &__info {
    flex: 1;
    padding-left: 20rpx;
    display: flex;
    flex-direction: column;
    gap: 6rpx;
    justify-content: center;
  }

  &__name-row {
    display: flex;
    align-items: center;
    gap: 12rpx;
  }

  &__name {
    font-size: 30rpx;
    font-weight: 700;
    color: $text-primary;
  }

  &__tag {
    padding: 2rpx 12rpx;
    border-radius: 999rpx;
    background: rgba($brand-primary, 0.1);
    font-size: 18rpx;
    color: $brand-primary;
  }

  &__period {
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__night-tip {
    font-size: 20rpx;
    color: $brand-orange-light;
    font-weight: 600;
  }

  &__used-time {
    font-size: 20rpx;
    color: $text-secondary;
  }

  &__verify {
    border-top: 1rpx solid $divider-color;
    padding: 16rpx 24rpx;
    text-align: right;
  }

  &__verify-btn {
    font-size: 24rpx;
    color: $brand-primary;
    font-weight: 600;
  }

  &__watermark {
    position: absolute;
    right: 16rpx;
    bottom: 16rpx;
    transform: rotate(-20deg);

    text {
      font-size: 48rpx;
      font-weight: 900;
      color: rgba($text-secondary, 0.3);
    }
  }
}
</style>
