<template>
  <view class="records">
    <scroll-view class="records__body" scroll-y>
      <view class="records__balance-card">
        <text class="records__balance-num">{{ pointsBalance }}</text>
        <text class="records__balance-label">当前积分</text>
      </view>

      <view class="records__list-card">
        <text class="records__list-title">积分记录</text>
        <view v-if="loading" class="records__empty">
          <text class="records__empty-text">加载中...</text>
        </view>
        <view v-else-if="list.length === 0" class="records__empty">
          <text class="records__empty-text">没有更多积分了~</text>
        </view>
        <view v-else class="records__list">
          <view
            v-for="(item, index) in list"
            :key="item.id"
            class="records__item"
            :class="{ 'records__item--last': index === list.length - 1 }"
          >
            <view class="records__item-left">
              <text class="records__item-title">{{ item.title }}</text>
              <text class="records__item-time">{{ item.time }}</text>
            </view>
            <text class="records__item-num" :class="{ 'records__item-num--red': item.points > 0 }">
              {{ item.points > 0 ? '+' : '' }}{{ item.points }}
            </text>
          </view>
        </view>
      </view>
    </scroll-view>
  </view>
</template>

<script setup>
import { ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { integralApi, authApi } from '../../api/index'

const loading = ref(false)
const pointsBalance = ref(0)
const list = ref([])

onShow(() => {
  loadBalance()
  loadList()
})

function goBack() {
  uni.navigateBack()
}

async function loadBalance() {
  try {
    const profile = await authApi.profile()
    if (profile && profile.points != null) {
      pointsBalance.value = profile.points
    } else if (profile && profile.data && profile.data.point != null) {
      pointsBalance.value = profile.data.point
    }
  } catch (e) {}
}

async function loadList() {
  loading.value = true
  try {
    const data = await integralApi.recordList()
    const arr = data?.list || data?.data || data || []
    if (Array.isArray(arr) && arr.length) {
      list.value = arr.map(item => ({
        id: item.id || item.recordId,
        title: item.title || item.desc || item.remark || item.source || '积分变动',
        points: item.points ?? item.integral ?? item.point ?? 0,
        time: item.createTime || item.time || item.updateTime || ''
      }))
    } else {
      list.value = []
    }
  } catch (e) {
    list.value = []
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.records {
  min-height: 100vh;
  background: #e5e5e5;
  display: flex;
  flex-direction: column;

  &__body {
    flex: 1;
    padding: 24rpx;
  }

  &__balance-card {
    background: #fff;
    border-radius: 16rpx;
    padding: 48rpx 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 24rpx;
  }

  &__balance-num {
    font-size: 64rpx;
    font-weight: 700;
    color: #b20300;
    line-height: 1;
  }

  &__balance-label {
    font-size: 26rpx;
    color: #333;
    margin-top: 12rpx;
  }

  &__list-card {
    background: #fff;
    border-radius: 16rpx;
    padding: 24rpx 28rpx;
  }

  &__list-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333;
    display: block;
    margin-bottom: 20rpx;
  }

  &__list {
    display: flex;
    flex-direction: column;
  }

  &__item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20rpx 0;
    border-bottom: 1rpx dashed #e0e0e0;

    &--last {
      border-bottom: none;
    }
  }

  &__item-left {
    display: flex;
    flex-direction: column;
    gap: 10rpx;
  }

  &__item-title {
    font-size: 28rpx;
    color: #333;
    font-weight: 500;
  }

  &__item-time {
    font-size: 22rpx;
    color: #999;
  }

  &__item-num {
    font-size: 32rpx;
    font-weight: 600;
    color: #333;

    &--red {
      color: #b20300;
    }
  }

  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40rpx 0;
  }

  &__empty-text {
    font-size: 22rpx;
    color: #7d7d7d;
  }
}
</style>
