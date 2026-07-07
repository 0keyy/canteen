<template>
  <view class="exch">
    <scroll-view class="exch__body" scroll-y>
      <view v-if="loading" class="exch__empty">
        <text class="exch__empty-text">加载中...</text>
      </view>
      <view v-else-if="list.length === 0" class="exch__empty">
        <text class="exch__empty-text">暂无兑换记录</text>
      </view>
      <view v-else class="exch__list">
        <view
          v-for="item in list"
          :key="item.id"
          class="exch__card"
        >
          <image class="exch__img" :src="item.image" mode="aspectFill" />
          <view class="exch__info">
            <text class="exch__name">{{ item.name }}</text>
            <view class="exch__sub">
              <text class="exch__time">{{ item.time }}</text>
              <text class="exch__points">{{ item.points }}积分</text>
            </view>
          </view>
          <view class="exch__right">
            <text class="exch__status">兑换成功</text>
          </view>
        </view>
      </view>
      <view class="exch__bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { integralApi } from '../../api/index'
import { resolveImageUrl } from '../../utils/image'

export default {
  data() {
    return {
      loading: false,
      list: []
    }
  },
  onShow() {
    this.loadList()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async loadList() {
      this.loading = true
      try {
        const data = await integralApi.exchangeList()
        const arr = data?.list || data?.data || data || []
        if (Array.isArray(arr) && arr.length) {
          this.list = arr.map(item => ({
            id: item.id || item.exchangeId,
            name: item.name || item.title || item.goodsName || '商品',
            image: resolveImageUrl(item.image || item.img || item.goodsImage || ''),
            points: item.points || item.integral || item.costPoints || 0,
            time: item.createTime || item.time || item.updateTime || ''
          }))
        } else {
          this.list = []
        }
      } catch (e) {
        this.list = []
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.exch {
  min-height: 100vh;
  background: #e9e9e9;
  display: flex;
  flex-direction: column;

  &__body {
    flex: 1;
    padding: 24rpx;
  }

  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 100rpx 0;
  }

  &__empty-text {
    font-size: 28rpx;
    color: #999;
  }

  &__list {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  &__card {
    display: flex;
    align-items: center;
    background: #fff;
    border-radius: 16rpx;
    padding: 24rpx 28rpx;
    gap: 20rpx;
  }

  &__img {
    width: 100rpx;
    height: 100rpx;
    border-radius: 12rpx;
    background: #f0f0f0;
    flex-shrink: 0;
  }

  &__info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    height: 100rpx;
  }

  &__name {
    font-size: 30rpx;
    color: #333;
    font-weight: 500;
    line-height: 1.3;
  }

  &__sub {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__time {
    font-size: 22rpx;
    color: #999;
  }

  &__points {
    font-size: 22rpx;
    color: #666;
  }

  &__right {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    justify-content: center;
    flex-shrink: 0;
    height: 100rpx;
  }

  &__status {
    font-size: 26rpx;
    color: #b20300;
    font-weight: 500;
  }

  &__bottom {
    height: 40rpx;
  }
}
</style>
