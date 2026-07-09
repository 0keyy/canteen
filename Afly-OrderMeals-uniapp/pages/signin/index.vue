<template>
  <view class="signin-page">
    <view class="signin-page__header" :style="headerStyle">
      <view class="signin-page__nav-bar">
        <view class="signin-page__back-btn" @tap="goBack">
          <text class="signin-page__back-icon">‹</text>
        </view>
        <view class="signin-page__nav-placeholder"></view>
      </view>
      <view class="signin-page__header-body">
        <view class="signin-page__title">签到送福利</view>
        <view class="signin-page__header-character">
          <image class="signin-page__character-img" :src="staticImgPrefix + '/专注.png'" mode="aspectFit" />
        </view>
      </view>
    </view>

    <view class="signin-page__content">
      <view class="signin-page__card">
        <view class="signin-page__section">
          <text class="signin-page__section-title">今日签到</text>

          <view class="signin-page__date-list">
              <scroll-view scroll-x class="signin-page__date-scroll">
                <view class="signin-page__date-track">
                  <view
                    v-for="(day, index) in dateList"
                    :key="index"
                    class="signin-page__date-item"
                    :class="[
                      `signin-page__date-item--${day.status}`,
                      { 'signin-page__date-item--today': day.isToday }
                    ]"
                  >
                    <view class="signin-page__date-header">
                      <text class="signin-page__date-text">{{ day.month }}</text>
                    </view>
                    <view class="signin-page__date-body">
                      <image
                        class="signin-page__date-icon"
                        :src="staticImgPrefix + '/tabbar/日历 1.png'"
                        mode="aspectFit"
                      />
                    </view>
                    <view v-if="day.signed" class="signin-page__date-check">
                      <text class="signin-page__date-check-text">✓</text>
                    </view>
                  </view>
                </view>
              </scroll-view>
            </view>

          <view class="signin-page__sign-btn-wrap">
            <view
              class="signin-page__sign-btn"
              :class="{ 'signin-page__sign-btn--disabled': hasSigned }"
              @tap="handleSign"
            >
              <text class="signin-page__sign-text">{{ hasSigned ? '今日已签到' : '立即签到' }}</text>
            </view>
          </view>
        </view>

        <view class="signin-page__divider"></view>

        <view class="signin-page__section">
          <text class="signin-page__section-title">连续签到奖励</text>

          <view class="signin-page__reward-list">
            <view
              v-for="(reward, index) in rewardList"
              :key="index"
              class="signin-page__reward-item"
            >
              <view class="signin-page__reward-coins">
                <image
                  class="signin-page__reward-image"
                  :src="staticImgPrefix + '/tabbar/签到.png'"
                  mode="aspectFit"
                />
              </view>
              <view class="signin-page__reward-info">
                <text class="signin-page__reward-amount">{{ reward.amount }}积分</text>
                <text class="signin-page__reward-condition">{{ reward.condition }}</text>
              </view>
              <view class="signin-page__reward-status">
                <text class="signin-page__reward-status-text">{{ reward.completed ? '已完成' : '待完成' }}</text>
              </view>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { signinApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'
import { getNavMetrics } from '../../utils/navbar'

export default {
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      navMetrics: getNavMetrics(),
      signinInfo: {
        avatar: '',
        continuousDays: 0
      },
      hasSigned: false,
      dateList: [],
      rewardList: []
    }
  },
  computed: {
    headerStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight}px` }
    }
  },
  onShow() {
    this.navMetrics = getNavMetrics()
    this.loadSigninStatus()
    this.loadRewardList()
    this.generateDateList()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    generateDateList() {
      const today = new Date()
      const list = []
      const continuousDays = this.signinInfo.continuousDays || 0
      for (let i = 0; i < 6; i++) {
        const date = new Date(today)
        date.setDate(today.getDate() + i - (continuousDays > 0 ? 1 : 0))
        const month = date.getMonth() + 1
        const day = date.getDate()
        let status = 'future'
        let signed = false
        let isToday = false
        if (i === 0 && continuousDays > 0) {
          status = 'past'
          signed = true
        } else if (i === 1 || (i === 0 && continuousDays === 0)) {
          status = 'active'
          isToday = true
          if (this.hasSigned) {
            signed = true
            status = 'signed'
          }
        } else {
          status = 'future'
        }
        list.push({
          month: `${month}.${day}`,
          day: day,
          isToday: isToday,
          signed: signed,
          status: status
        })
      }
      this.dateList = list
    },
    async loadSigninStatus() {
      try {
        const data = await signinApi.status()
        if (data) {
          this.signinInfo = { ...data, avatar: data.avatar || '' }
          this.hasSigned = data.hasSigned || false
        }
      } catch (e) {
        this.signinInfo = { avatar: '', continuousDays: 1 }
        this.hasSigned = false
      }
    },
    async loadRewardList() {
      try {
        const data = await signinApi.rewards()
        if (Array.isArray(data)) {
          this.rewardList = data.map(item => ({
            amount: item.amount || 0,
            condition: item.condition || '',
            completed: item.completed || false
          }))
        }
      } catch (e) {
        this.rewardList = [
          { amount: 5, condition: '连续签到1天', completed: false },
          { amount: 10, condition: '连续签到2天', completed: false },
          { amount: 15, condition: '连续签到4天', completed: false },
          { amount: 20, condition: '连续签到5天', completed: false }
        ]
      }
    },
    async handleSign() {
      if (this.hasSigned) return
      try {
        const data = await signinApi.sign()
        if (data && data.success) {
          uni.showToast({ title: '签到成功', icon: 'success' })
          this.hasSigned = true
          this.signinInfo.continuousDays = (this.signinInfo.continuousDays || 0) + 1
          this.generateDateList()
          this.loadRewardList()
        } else {
          uni.showToast({ title: data?.message || '签到失败', icon: 'none' })
        }
      } catch (e) {
        uni.showToast({ title: '签到失败', icon: 'none' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.signin-page {
  min-height: 100vh;
  background: #F5F5F5;
  display: flex;
  flex-direction: column;

  &__header {
    background: linear-gradient(180deg, #FFB4B4 0%, #FFD4D4 100%);
    position: relative;
    height: 30vh;
    min-height: 280rpx;
    padding-bottom: 60rpx;
  }

  &__nav-bar {
    display: flex;
    align-items: center;
    height: 88rpx;
    padding: 0 32rpx;
  }

  &__nav-placeholder {
    flex: 1;
  }

  &__back-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  &__back-icon {
    font-size: 80rpx;
    color: #312626;
    font-weight: 300;
    line-height: 1;
  }

  &__header-body {
    display: flex;
    align-items: flex-end;
    padding: 20rpx 32rpx 0;
	position: relative;
  }

  &__title {
    font-size: 80rpx;
    font-weight: 700;
    color: #b20300;
    flex: 1;
    padding-bottom: 45rpx;
  }

  &__header-character {
    width: 320rpx;
    height: 320rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
	position: absolute;
	right: 0;
	bottom: -85rpx;
  }

  &__character-img {
    width: 320rpx;
    height: 320rpx;
  }

  &__content {
    flex: 1;
    padding: 0 24rpx 32rpx;
    margin-top: -50rpx;
    position: relative;
    z-index: 2;
  }

  &__card {
    background: #FFFFFF;
    border-radius: 50rpx;
    padding: 32rpx;
    box-shadow: 0 8rpx 30rpx rgba(0, 0, 0, 0.08);
  }

  .character {
    width: 140rpx;
    height: 140rpx;
    position: relative;

    &__hair {
      position: absolute;
      top: 10rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 100rpx;
      height: 60rpx;
      background: #2C2C2C;
      border-radius: 50rpx 50rpx 0 0;
    }

    &__hairbun {
      position: absolute;
      top: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 48rpx;
      height: 48rpx;
      background: #2C2C2C;
      border-radius: 50%;
      z-index: 2;
    }

    &__pin {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%) rotate(45deg);
      width: 6rpx;
      height: 24rpx;
      background: #E8B84A;
      border-radius: 2rpx;
    }

    &__face {
      position: absolute;
      top: 40rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 96rpx;
      height: 90rpx;
      background: #FFE5D4;
      border-radius: 48rpx 48rpx 44rpx 44rpx;
      z-index: 1;
    }

    &__brow {
      position: absolute;
      top: 24rpx;
      width: 20rpx;
      height: 4rpx;
      background: #2C2C2C;
      border-radius: 2rpx;

      &--left {
        left: 16rpx;
        transform: rotate(-10deg);
      }

      &--right {
        right: 16rpx;
        transform: rotate(10deg);
      }
    }

    &__eye {
      position: absolute;
      top: 36rpx;
      width: 12rpx;
      height: 12rpx;
      background: #2C2C2C;
      border-radius: 50%;

      &--left {
        left: 20rpx;
      }

      &--right {
        right: 20rpx;
      }
    }

    &__nose {
      position: absolute;
      top: 50rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 8rpx;
      height: 6rpx;
      background: #E8B89A;
      border-radius: 50%;
    }

    &__mouth {
      position: absolute;
      top: 62rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 16rpx;
      height: 8rpx;
      border: 2rpx solid #D06060;
      border-top: none;
      border-radius: 0 0 16rpx 16rpx;
    }

    &__blush {
      position: absolute;
      top: 54rpx;
      width: 16rpx;
      height: 10rpx;
      background: rgba(255, 140, 140, 0.5);
      border-radius: 50%;

      &--left {
        left: 10rpx;
      }

      &--right {
        right: 10rpx;
      }
    }
  }

  &__section {
    &:not(:first-child) {
      padding-top: 0;
    }
  }

  &__section-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #262626;
    margin-bottom: 24rpx;
    display: block;
  }

  &__divider {
    height: 1rpx;
    background: #F0F0F0;
    margin: 32rpx 0;
  }

  &__date-list {
    margin-bottom: 32rpx;
  }

  &__date-scroll {
    white-space: nowrap;
    width: 100%;
  }

  &__date-track {
    display: inline-flex;
    gap: 16rpx;
    padding: 4rpx 0;
  }

  &__date-item {
    width: 100rpx;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    border-radius: 16rpx;
    overflow: hidden;
    position: relative;
    flex-shrink: 0;

    &--past {
      .signin-page__date-header {
        background: #999999;
      }
      .signin-page__date-body {
        background: #F0F0F0;
      }
      .signin-page__date-text {
        color: #FFFFFF;
      }
      .signin-page__date-icon {
        filter: grayscale(100%);
        opacity: 0.5;
      }
    }

    &--active {
      .signin-page__date-header {
        background: #b20300;
      }
      .signin-page__date-body {
        background: #FFE8E8;
      }
      .signin-page__date-text {
        color: #FFFFFF;
      }
      .signin-page__date-icon {
        filter: none;
        opacity: 1;
      }
    }

    &--signed {
      .signin-page__date-header {
        background: #FF9999;
      }
      .signin-page__date-body {
        background: #FFE8E8;
      }
      .signin-page__date-text {
        color: #FFFFFF;
      }
      .signin-page__date-icon {
        filter: none;
        opacity: 1;
      }
    }

    &--future {
      .signin-page__date-header {
        background: #FFB4B4;
      }
      .signin-page__date-body {
        background: #FFF5F5;
      }
      .signin-page__date-text {
        color: #FFFFFF;
      }
      .signin-page__date-icon {
        filter: none;
        opacity: 0.7;
      }
    }
  }

  &__date-header {
    height: 40rpx;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 16rpx 16rpx 0 0;
  }

  &__date-text {
    font-size: 22rpx;
    font-weight: 600;
  }

  &__date-body {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16rpx 0;
    border-radius: 0 0 16rpx 16rpx;
  }

  &__date-icon {
    width: 48rpx;
    height: 48rpx;
  }

  &__date-check {
    position: absolute;
    top: 8rpx;
    right: 8rpx;
    width: 24rpx;
    height: 24rpx;
    background: #b20300;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__date-check-text {
    font-size: 16rpx;
    color: #FFFFFF;
    font-weight: 700;
  }

  &__sign-btn-wrap {
    margin-bottom: 0;
  }

  &__sign-btn {
    background: #b20300;
    border-radius: 36rpx;
	padding: 8rpx;
    text-align: center;
	width: 350rpx;
	margin: 0 auto;

    &:active {
      opacity: 0.9;

    }

    &--disabled {
      background: #CCCCCC;
    }
  }

  &__sign-text {
    font-size: 32rpx;
    color: #FFFFFF;
  }

  &__reward-list {
    display: flex;
    flex-direction: column;
    gap: 16rpx;
  }

  &__reward-item {
    display: flex;
    align-items: center;
    padding: 20rpx 24rpx;
    background: #FFFAF5;
    border-radius: 12rpx;
  }

  &__reward-coins {
    width: 80rpx;
    height: 80rpx;
    margin-right: 20rpx;
    flex-shrink: 0;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__reward-image {
    width: 75rpx;
    height: 75rpx;
    display: block;
  }

  &__reward-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 4rpx;
  }

  &__reward-amount {
    font-size: 28rpx;
    font-weight: 600;
    color: #333333;
  }

  &__reward-condition {
    font-size: 22rpx;
    color: #999999;
  }

  &__reward-status {
    flex-shrink: 0;
  }

  &__reward-status-text {
    font-size: 24rpx;
    color: #f1d4d4;
    font-weight: 500;
    background:#b20300;
    padding: 8rpx 20rpx;
    border-radius: 999rpx;
  }
}
</style>
