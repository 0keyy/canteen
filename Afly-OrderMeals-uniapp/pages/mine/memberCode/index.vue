<template>
  <view class="member-code-page">
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
        <image :src="staticImgPrefix + '/logo.png'" mode="aspectFit" class="logo-img"></image>
      </view>
    </view>

    <view class="code-card">
      <view class="barcode-section">
        <text class="card-no">会员卡号：{{ memberId || '--' }}</text>
      </view>

      <view class="qrcode-section">
        <canvas
          v-if="qrCodeContent"
          canvas-id="tempQrCanvas"
          class="qrcode-canvas"
        ></canvas>
        <view v-else class="qrcode-placeholder">加载中...</view>
        <view class="refresh-tip">
          <image :src="staticImgPrefix + '/tabbar/刷新.png'" mode="aspectFit" class="refresh-icon"></image>
          <text>会员码每30秒自动更新，请在店内消费使用</text>
        </view>
      </view>

      <view class="balance-section">
        <text class="balance-value">{{ balance || '0.00' }}</text>
        <text class="balance-label">余额</text>
      </view>
    </view>

    <view class="footer-tip">
      <text class="tip-text">使用会员码，可在门店享受会员优惠与积分抵扣</text>
    </view>
  </view>
</template>

<script>
import { memberApi, authApi } from '../../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../../utils/image'
import { BASE_URL } from '../../../utils/config'
import uQRCode from 'uqrcodejs'

export default {
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      memberId: "",
      nickname: "",
      level: "",
      balance: "",
      avatarKey: "1",
      qrCodeContent: "",
      qrImageBase64: "",
      timer: null
    }
  },
  computed: {
    avatarSrc() {
      return `${this.staticImgPrefix}/${this.avatarKey || '1'}.png`
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
        const profile = await authApi.profile()
        if (profile) {
          this.nickname = profile.companyNickName || profile.nickname || profile.name || '会员'
          this.balance = profile.balance != null ? profile.balance : '0.00'
          this.memberId = profile.memberId || profile.id || profile.userId || ''
          this.level = profile.level || '普通会员'
        }
      } catch (e) {
        console.log('获取用户信息失败', e)
      }
      try {
        const res = await memberApi.code()
        if (res && res.code === 200 && res.data) {
          const data = res.data
          if (data.memberId) this.memberId = data.memberId
          if (data.nickname) this.nickname = data.nickname
          if (data.level) this.level = data.level
          if (data.balance != null) this.balance = data.balance
        }
      } catch (e) {
        console.log('会员码接口暂未开发', e)
      }
      this.refreshQrCode()
    },
    async refreshQrCode() {
      if (!this.memberId) return
      const timeStamp = Date.now()
      this.qrCodeContent = `${BASE_URL}/front/member/verify?uid=${this.memberId}&ts=${timeStamp}`
      await this.generateQrImage()
    },
    async generateQrImage() {
      try {
        const qrcode = new uQRCode()
        qrcode.data = this.qrCodeContent
        qrcode.errorLevel = 'M'
        qrcode.size = 300
        qrcode.foregroundColor = '#000000'
        qrcode.backgroundColor = '#ffffff'
        qrcode.margin = 10
        qrcode.make()

        const canvas = uni.createCanvasContext('tempQrCanvas')
        qrcode.canvasContext = canvas
        await qrcode.drawCanvas()
      } catch (e) {
        console.error('二维码生成失败', e)
      }
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

.member-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #fff;
  border-radius: 30rpx;
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

.logo-img {
  width: 100%;
  height: 100%;
}

.code-card {
  background: #fff;
  border-radius: 30rpx;
  padding: 40rpx 30rpx;
  margin-top: 40rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-sizing: border-box;
}

.barcode-section {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-height: 140rpx;
  justify-content: flex-end;
}

.card-no {
  margin-top: 16rpx;
  font-size: 24rpx;
  color: #b10a0f;
}

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

.qrcode-canvas {
  width: 300rpx;
  height: 300rpx;
}

.qrcode-placeholder {
  font-size: 24rpx;
  color: #999;
}

.refresh-tip {
  margin-top: 20rpx;
  font-size: 24rpx;
  color: #b10a0f;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
}

.refresh-icon {
  width: 28rpx;
  height: 28rpx;
  filter: none;
}

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

.footer-tip {
  margin-top: 40rpx;
  padding: 0 20rpx;
}

.tip-text {
  font-size: 24rpx;
  color: #999;
  text-align: center;
  line-height: 1.6;
}
</style>
