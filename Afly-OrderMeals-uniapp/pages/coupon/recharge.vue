<template>
  <view class="recharge-page">
    <!-- 顶部余额区域 -->
    <view class="recharge-page__header">
      <view class="recharge-page__balance-card">
        <view class="recharge-page__balance-icon">
          <image :src="staticImgPrefix + '/tabbar/充值金额 1.png'" mode="" class="recharge-page__balance-image"></image>
        </view>
        <text class="recharge-page__balance-label">我的余额</text>
        <text class="recharge-page__balance-value">¥{{ formatBalance }}</text>
      </view>
    </view>

    <scroll-view class="recharge-page__scroll" scroll-y :show-scrollbar="false">
      <!-- 充值金额选择 -->
      <view class="recharge-page__section">
        <text class="recharge-page__section-title">充值</text>
        <view class="recharge-page__amount-grid">
          <view
            v-for="(item, index) in amountOptions"
            :key="index"
            class="recharge-page__amount-item"
            :class="{ 'recharge-page__amount-item--active': !isCustom && selectedAmount === item }"
            @tap="selectPreset(item)"
          >
            <text class="recharge-page__amount-text">{{ item }}元</text>
          </view>
          <!-- 自定义金额 -->
          <view
            class="recharge-page__amount-item recharge-page__amount-item--custom"
            :class="{ 'recharge-page__amount-item--active': isCustom }"
            @tap="selectCustom"
          >
            <input
              v-if="isCustom"
              class="recharge-page__custom-input"
              type="digit"
              v-model="customAmount"
              placeholder="金额"
              :focus="isCustom"
              @blur="onCustomBlur"
            />
            <text v-else class="recharge-page__amount-text">自定义</text>
          </view>
        </view>
      </view>

      <view class="recharge-page__bottom-space"></view>
    </scroll-view>

    <!-- 底部操作栏 -->
    <view class="recharge-page__footer safe-area-bottom">
      <view class="recharge-page__recharge-btn" @tap="onRecharge">
        <text class="recharge-page__recharge-btn-text">充值</text>
      </view>
      <view class="recharge-page__record-link" @tap="goRecord">
        <text class="recharge-page__record-text">查看明细</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onLoad, onShow } from '@dcloudio/uni-app'
import { walletApi, payApi, authApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

// #ifdef MP-WEIXIN
import { wxPay } from '../../utils/pay/weixin'
// #endif

// #ifdef MP-ALIPAY
import { aliPay } from '../../utils/pay/alipay'
// #endif

const staticImgPrefix = ref(STATIC_IMAGE_PREFIX)
const balance = ref(0)
const selectedAmount = ref(10)
const amountOptions = ref([10, 20, 50, 100, 200, 500])
const isCustom = ref(false)
const customAmount = ref('')

const formatBalance = computed(() => Number(balance.value || 0).toFixed(2))

const finalAmount = computed(() => {
  if (isCustom.value) {
    const n = parseFloat(customAmount.value)
    return (!isNaN(n) && n > 0) ? n : 0
  }
  return selectedAmount.value
})

onLoad(() => {
  loadBalance()
})

onShow(() => {
  loadBalance()
})

async function loadBalance() {
  try {
    const profile = await authApi.profile()
    if (profile && profile.balance != null) {
      balance.value = profile.balance
    }
  } catch (e) {
    balance.value = 0
  }
}

function selectPreset(amount) {
  isCustom.value = false
  selectedAmount.value = amount
}

function selectCustom() {
  isCustom.value = true
}

function onCustomBlur() {
  if (!customAmount.value || parseFloat(customAmount.value) <= 0) {
    isCustom.value = false
    customAmount.value = ''
  }
}

async function onRecharge() {
  const amount = finalAmount.value
  if (!amount || amount <= 0) {
    uni.showToast({ title: '请选择或输入充值金额', icon: 'none' })
    return
  }
  try {
    const res = await walletApi.rechargeCreate(amount)
    if (res && res.outTradeNo) {
      const payInfo = await payApi.create({
        outTradeNo: res.outTradeNo,
        payChannel: 'balance',
        payScene: 'mp'
      })
      if (payInfo.completed) {
        uni.showToast({ title: '充值成功', icon: 'success' })
        loadBalance()
        return
      }
      if (payInfo.mockPay) {
        await payApi.mockSuccess(payInfo.outTradeNo)
        uni.showToast({ title: '充值成功', icon: 'success' })
        loadBalance()
        return
      }
      // #ifdef MP-WEIXIN
      await wxPay(payInfo)
      // #endif
      // #ifdef MP-ALIPAY
      await aliPay(payInfo)
      // #endif
      uni.showToast({ title: '充值成功', icon: 'success' })
      loadBalance()
    }
  } catch (e) {
    uni.showToast({ title: e.message || e || '充值失败', icon: 'none' })
  }
}

function goRecord() {
  uni.showToast({ title: '明细功能开发中', icon: 'none' })
}
</script>

<style lang="scss" scoped>
.recharge-page {
  min-height: 100vh;
  background: #F5F5F5;
  display: flex;
  flex-direction: column;

  &__header {
    background: #FFFFFF;
    padding: 60rpx 32rpx 40rpx;
  }

  &__balance-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    color: #111111;
  }

  &__balance-icon {
    width: 120rpx;
    height: 120rpx;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 24rpx;
  }

  &__balance-image {
    width: 100rpx;
	height: 100rpx;
	
  }

  &__balance-label {
    font-size: 28rpx;
    color: #1b1b1b;
    margin-bottom: 16rpx;
  }

  &__balance-value {
    font-size: 64rpx;
    font-weight: 700;
    color: #111111;
    line-height: 1;
  }

  &__scroll {
    flex: 1;
	margin-top: 100rpx;
  }

  &__section {
    background: #FFFFFF;
    margin: 24rpx;
    border-radius: 24rpx;
    padding: 32rpx 28rpx;
  }

  &__section-title {
    font-size: 28rpx;
    font-weight: 600;
    color: #333333;
    margin-bottom: 24rpx;
    display: block;
  }

  &__amount-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20rpx;
  }

  &__amount-item {
    width: calc((100% - 50rpx) / 3);
    height: 120rpx;
    border-radius: 12rpx;
    background: #9e9e9e;
    display: flex;
    align-items: center;
    justify-content: center;

    &--active {
      background: #b20300;

      .recharge-page__amount-text {
        color: #FFFFFF;
      }
    }

    &:active {
      opacity: 0.8;
    }
  }

  &__amount-text {
    font-size: 28rpx;
    color: #ededed;
    font-weight: 700;
  }

  &__custom-input {
    width: 100%;
    text-align: center;
    font-size: 28rpx;
    font-weight: 700;
    color: #FFFFFF;
  }

  &__amount-item--custom {
    position: relative;
  }

  &__bottom-space {
    height: 40rpx;
  }

  &__footer {
    background: #FFFFFF;
    padding: 24rpx 32rpx 20rpx;
    box-shadow: 0 -4rpx 20rpx rgba(0, 0, 0, 0.06);
    flex-shrink: 0;
  }

  &__recharge-btn {
    background: linear-gradient(135deg, #b20300 0%, #A01731 100%);
    height: 88rpx;
    border-radius: 44rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    &:active {
      transform: scale(0.98);
      opacity: 0.9;
    }
  }

  &__recharge-btn-text {
    font-size: 32rpx;
    font-weight: 600;
    color: #FFFFFF;
  }

  &__record-link {
    margin-top: 24rpx;
    display: flex;
    justify-content: center;
  }

  &__record-text {
    font-size: 26rpx;
    color: #999999;
  }
}
</style>
