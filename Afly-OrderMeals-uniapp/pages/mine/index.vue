<template>
  <view class="profile-page">
    <view class="profile-page__header" :style="headerPaddingStyle">
      <view class="profile-page__nav-row" :style="navRowStyle">
        <text class="profile-page__page-title">我的</text>
      </view>
      <view class="profile-page__user-section">
        <view class="profile-page__avatar">
          <text class="profile-page__avatar-text">👤</text>
        </view>
        <view class="profile-page__user-info">
          <text class="profile-page__nickname">{{ nickname || '未登录用户' }}</text>
          <text class="profile-page__mobile">{{ mobile || '请登录后查看' }}</text>
        </view>
      </view>
    </view>

    <scroll-view class="profile-page__content" scroll-y :show-scrollbar="false">
      <view class="profile-page__section">
        <view class="profile-page__section-header">
          <text class="profile-page__section-title">我的服务</text>
        </view>
        <view class="profile-page__menu-grid">
          <view class="profile-page__menu-item" @click="goOrders">
            <text class="profile-page__menu-icon">📋</text>
            <text class="profile-page__menu-name">我的订单</text>
          </view>
          <view class="profile-page__menu-item" @click="goAddress">
            <text class="profile-page__menu-icon">📍</text>
            <text class="profile-page__menu-name">收货地址</text>
          </view>
          <view class="profile-page__menu-item" @click="logout">
            <text class="profile-page__menu-icon">🚪</text>
            <text class="profile-page__menu-name">退出登录</text>
          </view>
        </view>
      </view>

      <view class="profile-page__footer">
        <text class="profile-page__footer-text">点餐系统</text>
      </view>

      <view class="profile-page__bottom-space"></view>
    </scroll-view>

    <view class="app-tab-bar">
      <view
        v-for="(item, index) in tabbarList"
        :key="index"
        class="app-tab-item"
        @tap.stop="switchTabbar(item, index)"
      >
        <image
          v-if="item.selected || item.unselected"
          class="app-tab-icon"
          :src="tabbarSelected === index ? item.selected : item.unselected"
          mode="aspectFit"
        />
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
import navPageMixin from '../../mixins/nav-page'

export default {
  mixins: [tabbarPageMixin, navPageMixin],
  data() {
    return {
      nickname: '',
      mobile: ''
    }
  },
  computed: {
    headerPaddingStyle() {
      return {
        paddingTop: `${this.navMetrics.statusBarHeight}px`
      }
    },
    navRowStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` }
    }
  },
  onShow() {
    this.updateNavMetrics()
    this.setupTabbar(2)
    this.nickname = uni.getStorageSync('nickname')
    this.mobile = uni.getStorageSync('mobile')
  },
  methods: {
    goOrders() {
      uni.switchTab({ url: '/pages/order/list' })
    },
    goAddress() {
      uni.navigateTo({ url: '/pages/address/list' })
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
  background: $bg-page;

  &__header {
    flex-shrink: 0;
    background: $bg-page;
    padding-bottom: 24rpx;
    border-bottom: 1rpx solid $divider-color;
  }

  &__nav-row {
    display: flex;
    align-items: center;
    padding: 0 32rpx;
    box-sizing: border-box;
  }

  &__page-title {
    font-size: 34rpx;
    font-weight: bold;
    color: #333333;
    line-height: 1;
  }

  &__user-section {
    display: flex;
    align-items: center;
    padding: 16rpx 32rpx 0;
  }

  &__avatar {
    width: 100rpx;
    height: 100rpx;
    background: #FFFFFF;
    border-radius: 50rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.06);
    flex-shrink: 0;
  }

  &__avatar-text {
    font-size: 48rpx;
  }

  &__user-info {
    margin-left: 24rpx;
    flex: 1;
    min-width: 0;
  }

  &__nickname {
    display: block;
    font-size: 32rpx;
    font-weight: bold;
    color: #333333;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__mobile {
    display: block;
    font-size: 24rpx;
    color: #999999;
    margin-top: 8rpx;
  }

  &__content {
    flex: 1;
    height: 0;
    overflow: hidden;
  }

  &__section {
    background: #FFFFFF;
    margin: 16rpx 24rpx;
    border-radius: $radius-card;
    padding: 24rpx;
    box-shadow: $shadow-sm;
  }

  &__section-header {
    margin-bottom: 20rpx;
  }

  &__section-title {
    font-size: 30rpx;
    font-weight: bold;
    color: #333333;
  }

  &__menu-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16rpx;
  }

  &__menu-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 16rpx 0;
  }

  &__menu-item:active {
    opacity: 0.7;
  }

  &__menu-icon {
    font-size: 44rpx;
    margin-bottom: 8rpx;
  }

  &__menu-name {
    font-size: 22rpx;
    color: #666666;
  }

  &__footer {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 40rpx 0 20rpx;
  }

  &__footer-text {
    font-size: 24rpx;
    color: #999999;
  }

  &__bottom-space {
    height: 24rpx;
  }
}
</style>
