<template>
  <view class="lottery">
    <view class="lottery__header">
      <view class="lottery__back" @tap="goBack">
        <text class="lottery__back-icon">←</text>
      </view>
      <text class="lottery__title">积分抽奖</text>
      <view class="lottery__header-right"></view>
    </view>
    <view class="lottery__content">
      <view class="lottery__info">
        <text class="lottery__points">当前积分: {{ pointCount }}</text>
        <text class="lottery__cost">每次消耗 100 积分</text>
      </view>
      <view class="lottery__wheel-container">
        <view class="lottery__wheel">
          <view class="lottery__wheel-item" v-for="(prize, index) in prizes" :key="index" :style="{ transform: `rotate(${index * 45}deg)` }">
            <text class="lottery__prize-name">{{ prize }}</text>
          </view>
        </view>
        <view class="lottery__pointer"></view>
      </view>
      <view class="lottery__btn" :class="{ 'lottery__btn--disabled': pointCount < 100 || spinning }" @tap="startLottery">
        <text class="lottery__btn-text">{{ spinning ? '抽奖中...' : '立即抽奖' }}</text>
      </view>
      <view class="lottery__rules">
        <text class="lottery__rules-title">活动规则</text>
        <view class="lottery__rules-list">
          <text class="lottery__rules-item">1. 每次抽奖消耗 100 积分</text>
          <text class="lottery__rules-item">2. 奖品即时发放</text>
          <text class="lottery__rules-item">3. 每天限抽 10 次</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
import { authApi } from '../../api/index'

export default {
  name: 'Lottery',
  data() {
    return {
      pointCount: 0,
      spinning: false,
      prizes: ['100积分', '50积分', '优惠券', '谢谢参与', '200积分', '10积分', '神秘大奖', '再来一次']
    }
  },
  onShow() {
    this.loadUserInfo()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async loadUserInfo() {
      try {
        const profile = await authApi.profile()
        this.pointCount = profile?.point || 0
      } catch (e) {
        console.error('加载用户信息失败', e)
      }
    },
    async startLottery() {
      if (this.spinning || this.pointCount < 100) return
      
      this.spinning = true
      const randomAngle = Math.random() * 360 + 720
      
      setTimeout(() => {
        this.spinning = false
        const prizeIndex = Math.floor((360 - (randomAngle % 360)) / 45) % 8
        const prize = this.prizes[prizeIndex]
        
        uni.showModal({
          title: '抽奖结果',
          content: `恭喜您获得：${prize}`,
          showCancel: false,
          success: () => {
            this.loadUserInfo()
          }
        })
      }, 3000)
    }
  }
}
</script>

<style lang="scss" scoped>
.lottery {
  min-height: 100vh;
  background: linear-gradient(180deg, #FFDADA 0%, #FFFFFF 100%);

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 88rpx;
    padding: 0 32rpx;
    background: rgba(183, 39, 45, 0.95);
  }

  &__back {
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 40rpx;
    color: #fff;
  }

  &__title {
    font-size: 34rpx;
    font-weight: 700;
    color: #fff;
  }

  &__header-right {
    width: 60rpx;
  }

  &__content {
    padding: 40rpx 32rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  &__info {
    display: flex;
    gap: 40rpx;
    margin-bottom: 40rpx;
  }

  &__points {
    font-size: 30rpx;
    font-weight: 700;
    color: #B7272D;
  }

  &__cost {
    font-size: 26rpx;
    color: #999;
  }

  &__wheel-container {
    position: relative;
    width: 560rpx;
    height: 560rpx;
    margin-bottom: 40rpx;
  }

  &__wheel {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background: linear-gradient(145deg, #fff, #f0f0f0);
    box-shadow: 0 10rpx 30rpx rgba(0, 0, 0, 0.1);
    position: relative;
    overflow: hidden;
    border: 8rpx solid #B7272D;
  }

  &__wheel-item {
    position: absolute;
    width: 50%;
    height: 50%;
    top: 0;
    left: 50%;
    transform-origin: bottom left;
    display: flex;
    align-items: center;
    justify-content: center;
    
    &:nth-child(odd) {
      background: rgba(183, 39, 45, 0.1);
    }
    
    &:nth-child(even) {
      background: rgba(183, 39, 45, 0.05);
    }
  }

  &__prize-name {
    font-size: 24rpx;
    font-weight: 600;
    color: #B7272D;
    transform: rotate(-45deg);
    white-space: nowrap;
  }

  &__pointer {
    position: absolute;
    top: -10rpx;
    left: 50%;
    transform: translateX(-50%);
    width: 0;
    height: 0;
    border-left: 20rpx solid transparent;
    border-right: 20rpx solid transparent;
    border-top: 40rpx solid #B7272D;
    z-index: 10;
  }

  &__btn {
    width: 400rpx;
    height: 88rpx;
    border-radius: 44rpx;
    background: linear-gradient(180deg, #D44047, #B7272D);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 6rpx 16rpx rgba(183, 39, 45, 0.4);
    transition: all 0.3s ease;

    &:active {
      transform: scale(0.96);
    }

    &--disabled {
      background: #ccc;
      box-shadow: none;
    }
  }

  &__btn-text {
    font-size: 32rpx;
    font-weight: 700;
    color: #fff;
  }

  &__rules {
    margin-top: 40rpx;
    padding: 24rpx;
    background: #fff;
    border-radius: 16rpx;
    width: 100%;
    box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
  }

  &__rules-title {
    font-size: 28rpx;
    font-weight: 700;
    color: #333;
    margin-bottom: 16rpx;
    display: block;
  }

  &__rules-list {
    display: flex;
    flex-direction: column;
    gap: 12rpx;
  }

  &__rules-item {
    font-size: 24rpx;
    color: #666;
    line-height: 1.5;
  }
}
</style>