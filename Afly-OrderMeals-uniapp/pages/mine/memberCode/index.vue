<template>
  <view class="member-code-page">
    <!-- 顶部会员信息区 -->
    <view class="member-header">
      <view class="user-info">
        <view class="avatar-box">
          <image class="avatar-img" :src="avatarSrc" mode="aspectFill" />
        </view>
        <view class="user-text">
          <text class="user-name">{{ nickname || '加载中...' }}</text>
          <text class="user-desc">{{ level || '会员' }}</text>
        </view>
      </view>
	  <view class="member-logo">
	    <image src="/static/logo.png" mode="aspectFit" class="logo-img"></image>
	  </view>
    </view>

    <!-- 白色会员码卡片 -->
    <view class="code-card">
      <!-- 条形码 -->
      <view class="barcode-section">
        <!-- <view class="barcode"></view> -->
        <text class="card-no">会员卡号：{{ memberId || '--' }}</text>
      </view>

      <!-- 二维码区域 -->
      <view class="qrcode-section">
        <view class="qrcode-box">
          <!-- 绑定会员唯一ID，动态内容 -->
          <u-qrcode v-if="qrCodeContent" :value="qrCodeContent" size="320"></u-qrcode>
          <view v-else class="qrcode-placeholder">加载中...</view>
        </view>
        <view class="refresh-tip">
          <image src="/static/tabbar/刷新.png" mode="aspectFit" class="refresh-icon"></image>
          <text>会员码每30秒自动更新，请在店内消费使用</text>
        </view>
      </view>

      <!-- 余额 -->
      <view class="balance-section">
        <text class="balance-value">{{ balance || '0.00' }}</text>
        <text class="balance-label">余额</text>
      </view>
    </view>

    <!-- 底部说明 -->
    <view class="footer-tip">
      <text class="tip-text">使用会员码，可在门店享受会员优惠与积分抵扣</text>
    </view>
  </view>
</template>

<script>
import { memberApi } from '../../../api/index'
export default {
  data() {
    return {
      memberId: "",
      nickname: "",
      level: "",
      balance: "",
      avatarKey: "1",
      qrCodeContent: "",
      timer: null
    }
  },
  computed: {
    avatarSrc() {
      return `/static/${this.avatarKey || '1'}.png`
    }
  },
  onLoad() {
    this.avatarKey = uni.getStorageSync('avatarKey') || '1'
    this.loadMemberCode()
    this.timer = setInterval(() => {
      this.refreshQrCode()
    }, 30000)
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  },
  methods: {
    async loadMemberCode() {
      try {
        const res = await memberApi.code()
        if (res && res.code === 200 && res.data) {
          const data = res.data
          this.memberId = data.memberId || ''
          this.nickname = data.nickname || '会员'
          this.level = data.level || '普通会员'
          this.balance = data.balance != null ? data.balance : '0.00'
        }
      } catch (e) {
        console.log('会员码接口暂未开发', e)
      }
      this.refreshQrCode()
    },
    refreshQrCode() {
      if (!this.memberId) return
      const timeStamp = Date.now()
      this.qrCodeContent = `https://你的后端核销接口.com/verify?uid=${this.memberId}&ts=${timeStamp}`
    },
    goBack() {
      uni.navigateBack()
    }
  }
}
</script>

<style scoped>
.member-code-page {
  width: 100%;
  min-height: 100vh;
  background: #F7F0E8;
  padding: 30rpx;
  box-sizing: border-box;
}

/* 顶部会员信息 */
.member-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-radius: 30rpx 30rpx 30rpx 30rpx;
  padding: 30rpx;
  box-sizing: border-box;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 20rpx;
}

.avatar-box {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50%;
  overflow: hidden;
}

.avatar-img {
  width: 100%;
  height: 100%;
}

.user-text {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.user-name {
  font-size: 32rpx;
  font-weight: 600;
  color: #333;
}

.user-desc {
  font-size: 24rpx;
  color: #999;
}

.member-logo {
  width: 100rpx;
  height: 100rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.logo-text {
  font-size: 48rpx;
  color: #B88222;
  font-weight: 700;
}

/* 白色卡片 */
.code-card {
  background: #fff;
  border-radius: 30rpx 30rpx 30rpx 30rpx;
  padding: 40rpx 30rpx;
  margin-top: 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-sizing: border-box;
}

/* 条形码 */
.barcode-section {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  /* 加上和原来条码一样的高度，占位 */
  min-height: 140rpx;
  justify-content: flex-end;
}

.barcode {
  width: 100%;
  height: 140rpx;
  background: repeating-linear-gradient(
    90deg,
    #000 0 10rpx,
    transparent 10rpx 20rpx
  );
}

.card-no {
  margin-top: 16rpx;
  font-size: 24rpx;
  color: #b10a0f;
}

/* 二维码 */
.qrcode-section {
  margin-top: 30rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.qrcode-box {
  width: 360rpx;
  height: 360rpx;
  border: 2rpx solid #E5E5E5;
  border-radius: 12rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
}
.qrcode-placeholder {
  font-size: 24rpx;
  color: #999;
}
.refresh-tip {
  margin-top: 20rpx;
  font-size: 24rpx;
  color: #b10a0f; /* 文字基准灰色 */
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
}
.refresh-icon {
  width: 28rpx;
  height: 28rpx;
  filter: none;
  color: #b10a0f;
}

/* 余额 */
.balance-section {
  margin-top: 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 30rpx;
  border-top: 1rpx dashed #E5E5E5;
  width: 100%;
}

.balance-value {
  font-size: 48rpx;
  font-weight: 700;
  color: #b10a0f;
}

.balance-label {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #b10a0f;
}

/* 底部说明 */
.footer-tip {
  margin-top: 40rpx;
  padding: 0 20rpx;
}

.tip-text {
  font-size: 24rpx;
  color: #999;
  text-align: center;
  line-height: 1.6;
  margin-left: 50px;
}
</style>