<template>
  <view class="coupon-center">
    <view class="coupon-center__header">
		<view class="coupon-center__header-left">
			<text class="coupon-center__title">领券中心</text>
			<text class="coupon-center__sub">领取优惠券，下单更优惠</text>
		</view>
		<view class="coupon-center__header-right">
			<image :src="staticImgPrefix + '/拱手.png'" mode="" class="coupon-center__header-image"></image>
		</view>
    </view>

    <view v-if="loading" class="coupon-center__status">
      <text class="coupon-center__status-text">加载中...</text>
    </view>

    <view v-else-if="coupons.length === 0" class="coupon-center__status">
      <text class="coupon-center__status-text">暂无可领取的优惠券</text>
    </view>

    <view v-else class="coupon-center__list">
      <view
        v-for="coupon in coupons"
        :key="coupon.id"
        class="coupon-card"
        :class="{ 'coupon-card--claimed': coupon.claimed }"
        @tap="!coupon.claimed && claimCoupon(coupon)"
      >
        <view class="coupon-card__left">
          <text class="coupon-card__amount">¥{{ coupon.discountAmount }}</text>
          <text class="coupon-card__condition">
            <template v-if="coupon.type === 2 && coupon.minAmount > 0">
              满{{ coupon.minAmount }}元可用
            </template>
            <template v-else-if="coupon.type === 5">
              夜间券 · {{ coupon.nightStartTime || '?' }}-{{ coupon.nightEndTime || '?' }}
            </template>
            <template v-else-if="coupon.type === 3 || coupon.type === 4">
              到店核销
            </template>
            <template v-else>
              无门槛
            </template>
          </text>
        </view>
        <view class="coupon-card__right">
          <text class="coupon-card__name">{{ coupon.name }}</text>
          <text class="coupon-card__type-tag">{{ typeLabel(coupon.type) }}</text>
          <text class="coupon-card__time" v-if="coupon.claimStartTime">
            {{ coupon.claimStartTime }} ~ {{ coupon.claimEndTime }}
          </text>
          <text class="coupon-card__stock" v-if="coupon.totalStock > 0">
            剩余 {{ coupon.totalStock - (coupon.claimedCount || 0) }} / {{ coupon.totalStock }}
          </text>

          <view v-if="coupon.claimed" class="coupon-card__btn coupon-card__btn--done">
            <text>已领取</text>
          </view>
          <view v-else class="coupon-card__btn">
            <text>立即领取</text>
          </view>
        </view>
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
      loading: false,
      coupons: []
    }
  },
  onShow() {
    this.loadCoupons()
  },
  methods: {
    typeLabel(type) {
      const map = { 1: '无门槛', 2: '满减', 3: '兑换券', 4: '套餐券', 5: '夜间券' }
      return map[type] || '未知'
    },
    async loadCoupons() {
      this.loading = true
      try {
        this.coupons = await couponApi.center() || []
        // 标记已领取的券
        const claimed = uni.getStorageSync('claimedCoupons') || {}
        this.coupons.forEach(c => {
          c.claimed = !!claimed[c.id]
        })
      } catch (e) {
        uni.showToast({ title: e || '加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    async claimCoupon(coupon) {
      try {
        const result = await couponApi.claim(coupon.id)
        // 记录已领取
        const claimed = uni.getStorageSync('claimedCoupons') || {}
        claimed[coupon.id] = true
        uni.setStorageSync('claimedCoupons', claimed)
        coupon.claimed = true
        uni.showToast({ title: '领取成功！', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: e || '领取失败', icon: 'none' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.coupon-center {
  min-height: 100vh;
  background: $bg-page;
  padding-bottom: 32rpx;

  &__header {
    padding: 40rpx 32rpx 24rpx;
    background: linear-gradient(170deg, #c41e3a 0%, #fffcf8 100%);
	display: flex;
	justify-content: space-between;
  }
  &__header-left{
	  line-height: 70rpx;
  }
  &__header-image{
	width: 90rpx;
	height:145rpx;
	margin-right: 100rpx;
  }
	
  &__title {
    display: block;
    font-size: 40rpx;
    font-weight: 900;
    color: #fff;
  }

  &__sub {
    display: block;
    margin-top: 8rpx;
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.8);
  }

  &__status {
    padding: 120rpx 32rpx;
    text-align: center;
  }

  &__status-text {
    font-size: 28rpx;
    color: $text-secondary;
  }

  &__list {
    padding: 24rpx;
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }
}

.coupon-card {
  display: flex;
  background: #fff;
  border-radius: $radius-card;
  overflow: hidden;
  box-shadow: $shadow-sm;

  &--claimed {
    opacity: 0.55;
  }

  &__left {
    width: 200rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 32rpx 16rpx;
    background: rgba($brand-primary, 0.06);
    border-right: 2rpx dashed rgba($brand-primary, 0.2);
  }

  &__amount {
    font-size: 48rpx;
    font-weight: 900;
    color: $brand-primary;
  }

  &__condition {
    margin-top: 8rpx;
    font-size: 20rpx;
    color: $text-secondary;
    text-align: center;
  }

  &__right {
    flex: 1;
    padding: 28rpx 24rpx;
    display: flex;
    flex-direction: column;
    gap: 8rpx;
  }

  &__name {
    font-size: 30rpx;
    font-weight: 700;
    color: $text-primary;
  }

  &__type-tag {
    display: inline-block;
    padding: 4rpx 16rpx;
    border-radius: 999rpx;
    background: rgba($brand-primary, 0.1);
    font-size: 20rpx;
    color: $brand-primary;
    width: fit-content;
  }

  &__time {
    font-size: 20rpx;
    color: $text-secondary;
  }

  &__stock {
    font-size: 20rpx;
    color: $text-secondary;
  }

  &__btn {
    margin-top: 16rpx;
    align-self: flex-end;
    padding: 12rpx 36rpx;
    border-radius: 999rpx;
    background: $brand-primary;

    text {
      font-size: 24rpx;
      color: #fff;
      font-weight: 600;
    }

    &--done {
      background: $bg-gray;

      text {
        color: $text-secondary;
      }
    }
  }
}
</style>
