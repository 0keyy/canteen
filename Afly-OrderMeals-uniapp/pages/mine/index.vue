<template>
  <view class="mine-page">
    <scroll-view class="mine-page__scroll" scroll-y :show-scrollbar="false">
      <!-- Header Section -->
      <view class="mine-page__header" :style="headerPaddingStyle">
        <text class="mine-page__watermark">惠</text>
        <view class="mine-page__user-row" @tap="goProfile">
          <image class="mine-page__avatar" src="/static/tabbar/头像 1.png" mode="aspectFill" />
          <view class="mine-page__user-info">
            <view class="mine-page__name-row">
              <text class="mine-page__nickname">{{ nickname || '未登录用户' }}</text>
              <text class="mine-page__level-tag">初级会员</text>
            </view>
          </view>
          <image class="mine-page__mascot" src="/static/雀跃.png" mode="aspectFit" />
        </view>
      </view>

      <!-- Account Statistics Bar -->
      <view class="mine-page__stats-card">
        <view class="mine-page__stat-item" @tap="onStatTap('balance')">
          <text class="mine-page__stat-value">{{ balance }}</text>
          <text class="mine-page__stat-label">余额</text>
        </view>
        <view class="mine-page__stat-divider"></view>
        <view class="mine-page__stat-item" @tap="onStatTap('points')">
          <text class="mine-page__stat-value">0</text>
          <text class="mine-page__stat-label">积分</text>
        </view>
        <view class="mine-page__stat-divider"></view>
        <view class="mine-page__stat-item" @tap="onStatTap('coupon')">
          <text class="mine-page__stat-value">{{ couponCount }}</text>
          <text class="mine-page__stat-label">卡券</text>
        </view>
      </view>

      <!-- Order Management Section -->
      <view class="mine-page__card">
        <view class="mine-page__card-header">
          <text class="mine-page__card-title">我的订单</text>
          <view class="mine-page__card-more" @tap="onViewAllOrders">
            <text class="mine-page__card-more-text">全部</text>
            <text class="mine-page__card-more-arrow">></text>
          </view>
        </view>
        <view class="mine-page__order-row">
          <view class="mine-page__order-item" @tap="onOrderTap('待支付')">
            <image class="mine-page__order-icon" src="/static/tabbar/待支付 1.png" mode="aspectFit" />
            <text class="mine-page__order-label">待支付</text>
          </view>
          <view class="mine-page__order-item" @tap="onOrderTap('待发货')">
            <image class="mine-page__order-icon" src="/static/tabbar/待发货 1.png" mode="aspectFit" />
            <text class="mine-page__order-label">待发货</text>
          </view>
          <view class="mine-page__order-item" @tap="onOrderTap('待收货')">
            <image class="mine-page__order-icon" src="/static/tabbar/待收货 1.png" mode="aspectFit" />
            <text class="mine-page__order-label">待收货</text>
          </view>
          <view class="mine-page__order-item" @tap="onOrderTap('退款售后')">
            <image class="mine-page__order-icon" src="/static/tabbar/售后 1.png" mode="aspectFit" />
            <text class="mine-page__order-label">退款售后</text>
          </view>
        </view>
      </view>

      <!-- Feature Grid -->
      <view class="mine-page__card mine-page__card--grid">
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('我的订单')">
          <image class="mine-page__grid-icon" src="/static/tabbar/全部订单 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">我的订单</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('地址管理')">
          <image class="mine-page__grid-icon" src="/static/tabbar/地址管理 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">地址管理</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('客服中心')">
          <image class="mine-page__grid-icon" src="/static/tabbar/客服 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">客服中心</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('充值中心')">
          <image class="mine-page__grid-icon" src="/static/tabbar/充值 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">充值中心</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('红包卡券')">
          <image class="mine-page__grid-icon" src="/static/tabbar/卡券 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">红包卡券</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('签到中心')">
          <image class="mine-page__grid-icon" src="/static/tabbar/签到 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">签到中心</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('积分抽奖')">
          <image class="mine-page__grid-icon" src="/static/tabbar/抽奖 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">积分抽奖</text>
        </view>
        <view class="mine-page__grid-item" @tap="onFeatureItemTap('安全退出')">
          <image class="mine-page__grid-icon" src="/static/tabbar/退出 1.png" mode="aspectFit" />
          <text class="mine-page__grid-label">安全退出</text>
        </view>
      </view>

      <view class="mine-page__bottom-space"></view>
    </scroll-view>

    <!-- Bottom TabBar -->
    <view class="app-tab-bar">
      <view
        v-for="(item, index) in tabbarList"
        :key="index"
        class="app-tab-item"
        :class="{ 'app-tab-item--active': tabbarSelected === index }"
        @tap.stop="switchTabbar(item, index)"
      >
        <view class="app-tab-icon-wrap">
          <image
            class="app-tab-icon"
            :class="{ 'app-tab-icon--inactive': tabbarSelected !== index }"
            :src="tabbarSelected === index ? item.selected : item.unselected"
            mode="aspectFit"
          />
        </view>
        <text
          class="app-tab-text"
          :style="{ color: tabbarSelected === index ? tabbarSelectedColor : tabbarDefaultColor }"
        >
          {{ item.name }}
        </text>
      </view>
    </view>
  </view>
</template>

<script>
import { authApi, couponApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      navMetrics: getNavMetrics(),
      nickname: '',
      mobile: '',
      companyVerified: false,
      balance: 0,
      couponCount: 0
    }
  },
  computed: {
    headerPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` }
    }
  },
  onShow() {
    this.navMetrics = getNavMetrics()
    this.setupTabbar(3)
    this.nickname = uni.getStorageSync('nickname')
    this.mobile = uni.getStorageSync('mobile')
    this.loadProfile()
  },
  methods: {
    goProfile() {
      uni.navigateTo({ url: '/pages/mine/profile' })
    },
    async loadProfile() {
      try {
        const profile = await authApi.profile()
        if (profile) {
          this.nickname = profile.nickname || this.nickname
          this.mobile = profile.mobile || this.mobile
          this.companyVerified = !!profile.companyVerified
          this.balance = profile.balance != null ? profile.balance : 0
          uni.setStorageSync('companyVerified', this.companyVerified)
        }
      } catch (e) {
        this.companyVerified = !!uni.getStorageSync('companyVerified')
      }

      try {
        const myCoupons = await couponApi.myCoupons(1) || []
        this.couponCount = myCoupons.length
      } catch (e) {
        this.couponCount = 0
      }
    },
    onViewAllOrders() {
      uni.switchTab({ url: '/pages/order/list' })
    },
    onOrderTap(status) {
      uni.switchTab({ url: '/pages/order/list' })
    },
    onStatTap(type) {
      if (type === 'coupon') {
        uni.navigateTo({ url: '/pages/coupon/wallet' })
      }
    },
    onFeatureItemTap(name) {
      if (name === '我的订单') {
        uni.switchTab({ url: '/pages/order/list' })
        return
      }
      if (name === '地址管理') {
        uni.navigateTo({ url: '/pages/address/list' })
        return
      }
      if (name === '红包卡券') {
        uni.navigateTo({ url: '/pages/coupon/wallet' })
        return
      }
      if (name === '安全退出') {
        this.logout()
        return
      }
      uni.showToast({ title: '功能开发中', icon: 'none' })
    },
    async logout() {
      try {
        await authApi.logout()
      } catch (e) {}
      uni.clearStorageSync()
      uni.reLaunch({ url: '/pages/login/index' })
    }
  }
}
</script>

<style lang="scss" scoped>
.mine-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-gray;

  &__scroll {
    flex: 1;
    height: 0;
  }

  /* Header */
  &__header {
    position: relative;
    padding: 0 32rpx 48rpx;
    background: linear-gradient(180deg, $bg-profile-start 0%, $bg-profile-end 100%);
    overflow: hidden;
  }

  &__watermark {
    position: absolute;
    right: 40rpx;
    top: 50%;
    transform: translateY(-55%);
    font-size: 280rpx;
    font-weight: 900;
    color: rgba(196, 30, 58, 0.06);
    line-height: 1;
    pointer-events: none;
  }

  &__user-row {
    display: flex;
    align-items: center;
    gap: 20rpx;
    position: relative;
    z-index: 1;
  }

  &__avatar {
    width: 112rpx;
    height: 112rpx;
    border-radius: 50%;
    border: 4rpx solid rgba(255, 255, 255, 0.6);
    flex-shrink: 0;
  }

  &__user-info {
    flex: 1;
    min-width: 0;
  }

  &__name-row {
    display: flex;
    align-items: center;
    gap: 12rpx;
    flex-wrap: wrap;
  }

  &__nickname {
    font-size: 34rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__level-tag {
    padding: 4rpx 18rpx;
    border-radius: $radius-tag;
    background: #FFF3E0;
    font-size: 20rpx;
    font-weight: 600;
    color: #E8A040;
  }

  &__mascot {
    width: 120rpx;
    height: 120rpx;
    flex-shrink: 0;
  }

  /* Stats Card */
  &__stats-card {
    display: flex;
    align-items: center;
    margin: -24rpx 24rpx 0;
    padding: 28rpx 0;
    background: $bg-surface;
    border-radius: $radius-card;
    box-shadow: $shadow-card;
    position: relative;
    z-index: 2;
  }

  &__stat-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 4rpx;
  }

  &__stat-value {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__stat-label {
    font-size: 22rpx;
    font-weight: 600;
    color: $text-secondary;
  }

  &__stat-divider {
    width: 1rpx;
    height: 48rpx;
    background: $border-light;
  }

  /* Card */
  &__card {
    margin: 20rpx 24rpx 0;
    padding: 24rpx;
    background: $bg-surface;
    border-radius: $radius-card;
    box-shadow: $shadow-sm;

    &--grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24rpx 0;
    }
  }

  &__card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24rpx;
  }

  &__card-title {
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__card-more {
    display: flex;
    align-items: center;
    gap: 4rpx;
  }

  &__card-more-text {
    font-size: 24rpx;
    color: $text-tertiary;
  }

  &__card-more-arrow {
    font-size: 24rpx;
    color: $text-tertiary;
  }

  /* Order Row */
  &__order-row {
    display: flex;
    align-items: center;
    justify-content: space-around;
  }

  &__order-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10rpx;
  }

  &__order-icon {
    width: 56rpx;
    height: 56rpx;
  }

  &__order-label {
    font-size: 22rpx;
    font-weight: 600;
    color: $text-primary;
  }

  /* Feature Grid */
  &__grid-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10rpx;
  }

  &__grid-icon {
    width: 56rpx;
    height: 56rpx;
  }

  &__grid-label {
    font-size: 22rpx;
    font-weight: 600;
    color: $text-primary;
    text-align: center;
  }

  &__bottom-space {
    height: $tabbar-height;
  }
}
</style>
