<template>
  <view class="coupon-center">
    <!-- 列表区域 -->
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
      >
        <!-- 左侧金额区 -->
        <view class="coupon-card__left">
          <text class="coupon-card__symbol">¥</text>
          <text class="coupon-card__amount">{{ coupon.discountAmount }}</text>
          <text class="coupon-card__condition">
            <template v-if="coupon.type === 2 && coupon.minAmount > 0">
              满{{ coupon.minAmount }}元可用
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

        <!-- 右侧详情区 -->
        <view class="coupon-card__right">
          <text class="coupon-card__name">{{ coupon.name }}</text>
          <text class="coupon-card__time" v-if="coupon.claimStartTime">
            {{ formatDate(coupon.claimStartTime) }}~{{ formatDate(coupon.claimEndTime) }}
          </text>
          <text class="coupon-card__restrict" v-if="coupon.type === 3 || coupon.type === 4">
            限到店使用
          </text>
          <text class="coupon-card__restrict" v-else-if="coupon.type === 5">
            限{{ coupon.nightStartTime || '?' }}-{{ coupon.nightEndTime || '?' }}使用
          </text>

          <view
            v-if="coupon.claimed"
            class="coupon-card__btn coupon-card__btn--done"
          >
            <text>已领取</text>
          </view>
          <view
            v-else
            class="coupon-card__btn"
            @tap.stop="claimCoupon(coupon)"
          >
            <text>领取</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { couponApi } from '../../api/index'

export default {
  data() {
    return {
      loading: false,
      coupons: []
    }
  },
  onShow() {
    this.loadCoupons()
  },
  methods: {
    formatDate(dateStr) {
      if (!dateStr) return ''
      // 将 2026-6-1 格式转为 2026.6.1
      return String(dateStr).replace(/-/g, '.')
    },
    async loadCoupons() {
      this.loading = true
      try {
        const coupons = await couponApi.center() || []
        const myCoupons1 = await couponApi.myCoupons(1) || []
        const myCoupons2 = await couponApi.myCoupons(2) || []
        const myCoupons3 = await couponApi.myCoupons(3) || []
        const allMyCoupons = [...myCoupons1, ...myCoupons2, ...myCoupons3]
        this.coupons = coupons

        const myCouponTemplateIds = new Set()
        allMyCoupons.forEach(c => {
          if (c.templateId) myCouponTemplateIds.add(String(c.templateId))
          if (c.couponTemplateId) myCouponTemplateIds.add(String(c.couponTemplateId))
        })

        const claimed = uni.getStorageSync('claimedCoupons') || {}

        this.coupons.forEach(c => {
          const centerCouponId = String(c.id)
          const centerTemplateId = String(c.templateId || c.id)
          const isClaimed =
            c.claimed ||
            c.status === 1 ||
            !!claimed[centerCouponId] ||
            !!claimed[centerTemplateId] ||
            myCouponTemplateIds.has(centerCouponId) ||
            myCouponTemplateIds.has(centerTemplateId)
          c.claimed = isClaimed
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
        const claimed = uni.getStorageSync('claimedCoupons') || {}
        claimed[coupon.id] = true
        if (coupon.templateId) {
          claimed[coupon.templateId] = true
        }
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
  background: #e7e7e7;

  &__status {
    padding: 200rpx 32rpx;
    text-align: center;
  }

  &__status-text {
    font-size: 28rpx;
    color: #999;
  }

  &__list {
    padding: 20rpx 24rpx;
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }
}

.coupon-card {
  display: flex;
  align-items: stretch;
  background: #ffffff;
  border-radius: 16rpx;
  overflow: hidden;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.06);

  &--claimed {
    opacity: 0.5;

    .coupon-card__btn {
      background: #cccccc;
    }
  }

  &__left {
    width: 200rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 28rpx 12rpx;
    background: #fff8f0;
    position: relative;
    flex-shrink: 0;

    // 右侧锯齿效果（用伪元素模拟）
    &::after {
      content: '';
      position: absolute;
      right: 0;
      top: 0;
      bottom: 0;
      width: 1rpx;
      background: repeating-linear-gradient(
        to bottom,
        transparent,
        transparent 12rpx,
        #f5f5f5 12rpx,
        #f5f5f5 24rpx
      );
    }
  }

  &__symbol {
    font-size: 26rpx;
    font-weight: 700;
    color: #be0000;
    line-height: 1;
  }

  &__amount {
    font-size: 60rpx;
    font-weight: 900;
    color: #be0000;
    line-height: 1.1;
    margin-top: 4rpx;
  }

  &__condition {
    margin-top: 8rpx;
    font-size: 20rpx;
    color: #be0000;
    font-weight: 500;
    text-align: center;
  }

  &__right {
    flex: 1;
    padding: 24rpx 28rpx;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 8rpx;
    min-width: 0;
  }

  &__name {
    font-size: 26rpx;
    font-weight: 600;
    color: #333;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__time {
    font-size: 22rpx;
    color: #999;
  }

  &__restrict {
    font-size: 22rpx;
    color: #bbb;
  }

  &__btn {
    margin-top: 8rpx;
    align-self: flex-end;
    padding: 12rpx 40rpx;
    border-radius: 999rpx;
    background: #be0000;
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 24rpx;
      color: #fff;
      font-weight: 600;
    }

    &--done {
      background: #cccccc;

      text {
        color: #fff;
      }
    }
  }
}
</style>
