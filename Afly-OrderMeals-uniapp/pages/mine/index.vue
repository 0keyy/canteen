<template>
  <view class="profile-page">
    <scroll-view class="profile-page__scroll" scroll-y :show-scrollbar="false">
      <view class="profile-page__hero" :style="heroPaddingStyle">
        <view class="profile-page__user-row">
          <view class="profile-page__avatar"></view>
          <view class="profile-page__user-info">
            <view class="profile-page__name-row">
              <text class="profile-page__nickname">{{ nickname || '未登录用户' }}</text>
              <text v-if="companyVerified" class="profile-page__level-tag profile-page__level-tag--verified">已认证</text>
              <text v-else class="profile-page__level-tag">默认等级</text>
            </view>
            <text class="profile-page__mobile">{{ mobile || '请登录后查看' }}</text>
            <text v-if="companyVerified && companyDeptName" class="profile-page__company">{{ companyDeptName }}</text>
          </view>
          <view class="profile-page__qr-btn" @tap="onFeatureTap('会员码')">
            <view class="profile-page__qr-icon"></view>
          </view>
        </view>

        <view class="profile-page__stats">
          <view class="profile-page__stat-item">
            <text class="profile-page__stat-value">{{ balance }}</text>
            <text class="profile-page__stat-label">余额</text>
          </view>
          <view class="profile-page__stat-item">
            <text class="profile-page__stat-value">0</text>
            <text class="profile-page__stat-label">优惠券</text>
          </view>
        </view>

        <view class="profile-page__vip-card">
          <view class="profile-page__vip-top">
            <view>
              <text class="profile-page__vip-title">SVIP 1</text>
              <text class="profile-page__vip-desc">再获得1000个成长值升级为青铜</text>
            </view>
            <view class="profile-page__vip-crown"></view>
          </view>
          <view class="profile-page__vip-progress">
            <view class="profile-page__vip-progress-bar"></view>
          </view>
          <text class="profile-page__vip-progress-text">0/1000</text>
        </view>
      </view>

      <view class="profile-page__sections">
        <view class="profile-page__card">
          <text class="profile-page__card-title">我的订单</text>
          <view class="profile-page__grid">
            <view
              v-for="item in primaryActions"
              :key="item.title"
              class="profile-page__grid-item"
              @tap="onActionTap(item)"
            >
              <view class="profile-page__grid-icon profile-page__grid-icon--primary">
                <view :class="['profile-page__action-icon', `profile-page__action-icon--${item.icon}`]"></view>
              </view>
              <text class="profile-page__grid-label">{{ item.title }}</text>
            </view>
          </view>
        </view>

        <view class="profile-page__card profile-page__card--grid">
          <view
            v-for="item in secondaryActions"
            :key="item.title"
            class="profile-page__grid-item"
            @tap="onActionTap(item)"
          >
            <view class="profile-page__grid-icon">
              <view :class="['profile-page__action-icon', `profile-page__action-icon--${item.icon}`]"></view>
            </view>
            <text class="profile-page__grid-label">{{ item.title }}</text>
          </view>
        </view>

        <view class="profile-page__footer">
          <text class="profile-page__footer-text">小程序餐饮系统</text>
          <text class="profile-page__footer-sub">点击了解详情</text>
        </view>

        <view class="profile-page__bottom-space"></view>
      </view>
    </scroll-view>

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
import { authApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'

const PRIMARY_ACTIONS = [
  { title: '我的订单', icon: 'orders' },
  { title: '地址管理', icon: 'address' },
  { title: '联系客服', icon: 'service' },
  { title: '会员码', icon: 'code' }
]

const SECONDARY_ACTIONS = [
  { title: '公司认证', icon: 'check' },
  { title: '充值中心', icon: 'wallet' },
  { title: '积分商城', icon: 'coins' },
  { title: '集点有礼', icon: 'star' },
  { title: '优惠券包', icon: 'ticket' },
  { title: '会员日', icon: 'crown' },
  { title: '退出登录', icon: 'logout' }
]

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      navMetrics: getNavMetrics(),
      nickname: '',
      mobile: '',
      companyVerified: false,
      companyDeptName: '',
      balance: 0,
      primaryActions: PRIMARY_ACTIONS,
      secondaryActions: SECONDARY_ACTIONS
    }
  },
  computed: {
    heroPaddingStyle() {
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
    async loadProfile() {
      try {
        const profile = await authApi.profile()
        if (profile) {
          this.nickname = profile.nickname || this.nickname
          this.mobile = profile.mobile || this.mobile
          this.companyVerified = !!profile.companyVerified
          this.companyDeptName = profile.companyDeptName || ''
          this.balance = profile.balance != null ? profile.balance : 0
          uni.setStorageSync('companyVerified', this.companyVerified)
          uni.setStorageSync('companyDeptName', this.companyDeptName)
        }
      } catch (e) {
        this.companyVerified = !!uni.getStorageSync('companyVerified')
        this.companyDeptName = uni.getStorageSync('companyDeptName') || ''
      }
    },
    onActionTap(item) {
      if (item.title === '我的订单') {
        uni.switchTab({ url: '/pages/order/list' })
        return
      }
      if (item.title === '地址管理') {
        uni.navigateTo({ url: '/pages/address/list' })
        return
      }
      if (item.title === '公司认证') {
        uni.navigateTo({ url: '/pages/mine/company-auth' })
        return
      }
      if (item.title === '退出登录') {
        this.logout()
        return
      }
      this.onFeatureTap(item.title)
    },
    onFeatureTap(title) {
      uni.showToast({ title: `${title}功能开发中`, icon: 'none' })
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
.profile-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-gray;

  &__scroll {
    flex: 1;
    height: 0;
  }

  &__hero {
    padding: 0 32rpx 32rpx;
    background: linear-gradient(135deg, rgba(255, 139, 26, 0.3) 0%, $bg-warm 45%, $bg-page 100%);
  }

  &__user-row {
    display: flex;
    align-items: center;
    gap: 24rpx;
  }

  &__avatar {
    width: 112rpx;
    height: 112rpx;
    border-radius: 50%;
    background: $bg-surface;
    box-shadow: $shadow-sm;
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
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__level-tag {
    padding: 4rpx 16rpx;
    border-radius: 999rpx;
    background: rgba(177, 10, 15, 0.1);
    font-size: 20rpx;
    color: $brand-primary;

    &--verified {
      background: rgba(34, 139, 34, 0.12);
      color: #228B22;
    }
  }

  &__company {
    display: block;
    margin-top: 4rpx;
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__mobile {
    display: block;
    margin-top: 6rpx;
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__qr-btn {
    width: 80rpx;
    height: 80rpx;
    border-radius: $radius-card;
    background: $bg-surface;
    box-shadow: $shadow-sm;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  &__qr-icon {
    width: 40rpx;
    height: 40rpx;
    border: 3rpx solid $text-primary;
    border-radius: 6rpx;
    position: relative;

    &::before,
    &::after {
      content: '';
      position: absolute;
      width: 8rpx;
      height: 8rpx;
      background: $text-primary;
    }

    &::before {
      top: 6rpx;
      left: 6rpx;
    }

    &::after {
      bottom: 6rpx;
      right: 6rpx;
    }
  }

  &__stats {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24rpx;
    margin-top: 32rpx;
    text-align: center;
  }

  &__stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }

  &__stat-value {
    display: block;
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__stat-label {
    display: block;
    margin-top: 4rpx;
    font-size: 24rpx;
    font-weight: 600;
    color: $text-secondary;
  }

  &__vip-card {
    margin-top: 32rpx;
    padding: 24rpx;
    border-radius: $radius-card;
    background: linear-gradient(135deg, $text-primary 0%, $brand-primary 100%);
    box-shadow: $shadow-card;
  }

  &__vip-top {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
  }

  &__vip-title {
    display: block;
    font-size: 32rpx;
    font-weight: 900;
    color: $text-white;
  }

  &__vip-desc {
    display: block;
    margin-top: 4rpx;
    font-size: 22rpx;
    color: rgba(255, 252, 248, 0.8);
  }

  &__vip-crown {
    width: 64rpx;
    height: 64rpx;
    position: relative;

    &::before {
      content: '♛';
      font-size: 64rpx;
      color: $brand-orange-light;
      line-height: 1;
    }
  }

  &__vip-progress {
    margin-top: 24rpx;
    height: 12rpx;
    border-radius: 999rpx;
    background: rgba(255, 252, 248, 0.2);
    overflow: hidden;
  }

  &__vip-progress-bar {
    width: 18%;
    height: 100%;
    border-radius: 999rpx;
    background: $brand-orange-light;
  }

  &__vip-progress-text {
    display: block;
    margin-top: 4rpx;
    text-align: right;
    font-size: 20rpx;
    color: rgba(255, 252, 248, 0.8);
  }

  &__sections {
    padding: 20rpx 24rpx 0;
  }

  &__card {
    background: $bg-surface;
    border-radius: $radius-card;
    padding: 24rpx;
    box-shadow: $shadow-sm;
    margin-bottom: 20rpx;

    &--grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20rpx;
    }
  }

  &__card-title {
    display: block;
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
    margin-bottom: 24rpx;
  }

  &__grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20rpx;
  }

  &__grid-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12rpx;
  }

  &__grid-icon {
    width: 80rpx;
    height: 80rpx;
    border-radius: $radius-card;
    background: $bg-gray;
    display: flex;
    align-items: center;
    justify-content: center;

    &--primary {
      background: rgba(177, 10, 15, 0.1);
    }
  }

  &__grid-label {
    font-size: 22rpx;
    font-weight: 600;
    color: $text-primary;
    text-align: center;
  }

  &__action-icon {
    width: 36rpx;
    height: 36rpx;
    position: relative;

    &--orders {
      border: 3rpx solid $brand-primary;
      border-radius: 4rpx;

      &::before {
        content: '';
        position: absolute;
        top: 8rpx;
        left: 6rpx;
        right: 6rpx;
        height: 3rpx;
        background: $brand-primary;
        box-shadow: 0 8rpx 0 $brand-primary;
      }
    }

    &--address {
      border: 3rpx solid $brand-primary;
      border-radius: 50% 50% 50% 0;
      transform: rotate(-45deg);
    }

    &--service {
      border: 3rpx solid $brand-primary;
      border-radius: 50%;

      &::before {
        content: '';
        position: absolute;
        bottom: 6rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 16rpx;
        height: 10rpx;
        border: 3rpx solid $brand-primary;
        border-top: none;
        border-radius: 0 0 12rpx 12rpx;
      }
    }

    &--code {
      border: 3rpx solid $brand-primary;
      border-radius: 4rpx;
    }

    &--wallet {
      border: 3rpx solid $brand-primary;
      border-radius: 8rpx;
    }

    &--check,
    &--coins,
    &--star,
    &--ticket,
    &--crown,
    &--logout {
      border: 3rpx solid $brand-primary;
      border-radius: 50%;
    }
  }

  &__footer {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 32rpx 0 16rpx;
  }

  &__footer-text {
    font-size: 24rpx;
    color: $text-secondary;
    line-height: 1.6;
    text-align: center;
  }

  &__footer-sub {
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__bottom-space {
    height: $tabbar-height;
  }
}
</style>
