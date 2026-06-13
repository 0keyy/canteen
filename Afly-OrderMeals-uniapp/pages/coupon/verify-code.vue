<template>
  <view class="verify-code-page">
    <view v-if="loading" class="verify-code-page__status">
      <text>加载中...</text>
    </view>

    <template v-else>
      <view class="verify-code-page__card">
        <text class="verify-code-page__title">核销码</text>
        <view class="verify-code-page__code-wrap">
          <text class="verify-code-page__code">{{ code }}</text>
        </view>
        <text class="verify-code-page__tip">请向店员出示此码进行核销</text>
      </view>

      <view class="verify-code-page__info">
        <text class="verify-code-page__info-text">
          此券仅支持到店扫码核销，不会在下单时自动抵扣
        </text>
      </view>
    </template>
  </view>
</template>

<script>
import { couponApi } from '../../api/index'

export default {
  data() {
    return {
      loading: false,
      code: '',
      couponId: null
    }
  },
  onLoad(options) {
    this.couponId = options.id
    this.loadCode()
  },
  methods: {
    async loadCode() {
      this.loading = true
      try {
        this.code = await couponApi.verifyCode(this.couponId) || ''
      } catch (e) {
        uni.showToast({ title: e || '获取核销码失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.verify-code-page {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 80rpx 32rpx;

  &__status {
    padding-top: 200rpx;
    font-size: 28rpx;
    color: $text-secondary;
  }

  &__card {
    width: 100%;
    background: #fff;
    border-radius: $radius-card;
    padding: 48rpx 32rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: $shadow-card;
  }

  &__title {
    font-size: 32rpx;
    font-weight: 700;
    color: $text-primary;
    margin-bottom: 32rpx;
  }

  &__code-wrap {
    padding: 24rpx 48rpx;
    background: $bg-gray;
    border-radius: 12rpx;
    border: 2rpx dashed $brand-primary;
    margin-bottom: 24rpx;
  }

  &__code {
    font-size: 56rpx;
    font-weight: 900;
    color: $brand-primary;
    letter-spacing: 12rpx;
    font-family: monospace;
  }

  &__tip {
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__info {
    margin-top: 48rpx;
    padding: 24rpx;
    background: rgba($brand-orange-light, 0.08);
    border-radius: $radius-card;
    width: 100%;
  }

  &__info-text {
    font-size: 24rpx;
    color: $text-secondary;
    text-align: center;
  }
}
</style>
