<template>
  <view class="login-page">
    <view class="login-page__status-bar"></view>
    <view class="login-page__header">
      <text class="login-page__title">欢迎点餐</text>
      <text class="login-page__sub">微信一键登录，快速下单</text>
    </view>

    <!-- #ifdef MP-WEIXIN -->
    <button
      class="login-page__btn"
      :loading="loading"
      @click="handleWxLogin"
    >
      微信一键登录
    </button>
    <!-- #endif -->

    <!-- #ifdef MP-ALIPAY -->
    <button class="login-page__btn" :loading="loading" @click="handleAliLogin">支付宝登录</button>
    <!-- #endif -->

    <!-- #ifdef APP-PLUS -->
    <view class="login-page__form">
      <input v-model="mobile" class="login-page__input" type="number" maxlength="11" placeholder="请输入手机号" />
      <view class="login-page__code-row">
        <input v-model="smsCode" class="login-page__input login-page__code-input" type="number" maxlength="6" placeholder="验证码" />
        <button class="login-page__code-btn" :disabled="countdown > 0" @click="sendSms">{{ countdown > 0 ? countdown + 's' : '获取验证码' }}</button>
      </view>
      <button class="login-page__btn" :loading="loading" @click="handleSmsLogin">登录</button>
    </view>
    <!-- #endif -->
  </view>
</template>

<script>
import { authApi } from '../../api/index'
import { saveLoginResult } from '../../utils/auth/index'

export default {
  data() {
    return {
      loading: false,
      mobile: '',
      smsCode: '',
      countdown: 0,
      timer: null
    }
  },
  methods: {
    goHome() {
      uni.switchTab({ url: '/pages/index/index' })
    },
    async handleWxLogin() {
      this.loading = true
      try {
        const loginRes = await new Promise((resolve, reject) => {
          uni.login({ provider: 'weixin', success: resolve, fail: reject })
        })
        if (!loginRes.code) {
          throw new Error('微信授权失败，请重试')
        }
        const result = await authApi.wxLogin(loginRes.code)
        if (!result.token) {
          throw new Error('登录失败，请检查小程序 AppID 与后端配置是否一致')
        }
        saveLoginResult(result)
        this.goHome()
      } catch (err) {
        uni.showToast({ title: err.message || err, icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    async handleAliLogin() {
      this.loading = true
      try {
        const authCode = await new Promise((resolve, reject) => {
          my.getAuthCode({ scopes: ['auth_user'], success: (res) => resolve(res.authCode), fail: reject })
        })
        let result = await authApi.aliLogin(authCode)
        if (result.needBindPhone) {
          result = await authApi.aliPhone(authCode)
        }
        saveLoginResult(result)
        this.goHome()
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    async sendSms() {
      if (!/^1\d{10}$/.test(this.mobile)) {
        uni.showToast({ title: '请输入正确手机号', icon: 'none' })
        return
      }
      await authApi.smsSend(this.mobile)
      this.countdown = 60
      this.timer = setInterval(() => {
        this.countdown -= 1
        if (this.countdown <= 0) {
          clearInterval(this.timer)
        }
      }, 1000)
      uni.showToast({ title: '验证码已发送', icon: 'none' })
    },
    async handleSmsLogin() {
      if (!this.mobile || !this.smsCode) {
        uni.showToast({ title: '请填写手机号和验证码', icon: 'none' })
        return
      }
      this.loading = true
      try {
        const result = await authApi.smsLogin(this.mobile, this.smsCode)
        saveLoginResult(result)
        this.goHome()
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      } finally {
        this.loading = false
      }
    }
  },
  onUnload() {
    if (this.timer) {
      clearInterval(this.timer)
    }
  }
}
</script>

<style lang="scss" scoped>
.login-page {
  min-height: 100vh;
  padding: 0 48rpx 120rpx;
  background: $bg-page;

  &__status-bar {
    height: env(safe-area-inset-top, 44px);
  }

  &__header {
    padding-top: 80rpx;
    margin-bottom: 80rpx;
  }

  &__title {
    display: block;
    font-size: 48rpx;
    font-weight: bold;
    color: #333333;
  }

  &__sub {
    display: block;
    margin-top: 16rpx;
    color: #999999;
    font-size: 28rpx;
  }

  &__form {
    margin-top: 24rpx;
  }

  &__input {
    background: #FFFFFF;
    border-radius: 16rpx;
    padding: 28rpx 24rpx;
    margin-bottom: 24rpx;
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  }

  &__code-row {
    display: flex;
    gap: 16rpx;
  }

  &__code-input {
    flex: 1;
  }

  &__code-btn {
    width: 220rpx;
    font-size: 24rpx;
    background: #FFFFFF;
    color: $brand-primary;
    border-radius: 16rpx;
    box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  }

  &__btn {
    margin-top: 24rpx;
    background: $brand-primary;
    color: $text-white;
    border-radius: $radius-btn;
    font-size: 32rpx;
    font-weight: bold;

    &:active {
      background: $brand-primary-press;
    }
  }

  &__tip {
    display: block;
    margin-top: 16rpx;
    text-align: center;
    font-size: 24rpx;
    color: #999999;
  }
}
</style>
