<template>
  <view class="wrap">
    <view class="header">
      <text class="title">零钱明细</text>
      <view class="avatar"></view>
    </view>
    <scroll-view scroll-y class="list-wrap">
      <view class="month-title">2026年6月</view>
      <view class="item" v-for="item in detailList" :key="item.id">
        <view class="left">
          <text class="time">{{ item.time }}</text>
          <text class="desc">{{ item.name }}</text>
        </view>
        <text class="money" :class="item.type">
          {{ item.type === 'add' ? '+' : '-' }} {{ item.num }}
        </text>
      </view>
      <view class="empty" v-if="detailList.length === 0">暂无收支明细记录</view>
    </scroll-view>
    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import PageLoading from '../../components/page-loading/page-loading.vue'
export default {
  components: { PageLoading },
  data() {
    return {
      detailList: [],
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  onLoad() {
    // 读取充值存入的本地记录
    this.detailList = uni.getStorageSync('detailList') || []
  },
  methods: {
    goWithLoading(url, type = 'navigateTo', tip = '加载中...') {
      this.pageLoadingTip = tip
      this.pageLoading = true
      setTimeout(() => {
        if (type === 'switchTab') { uni.switchTab({ url }) }
        else if (type === 'reLaunch') { uni.reLaunch({ url }) }
        else if (type === 'redirectTo') { uni.redirectTo({ url }) }
        else if (type === 'navigateBack') { uni.navigateBack() }
        else { uni.navigateTo({ url }) }
        setTimeout(() => { this.pageLoading = false }, 500)
      }, 100)
    }
  }
}
</script>

<style scoped>
page {
  background: #eee;
  margin: 0;
  padding: 0;
}
.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 40rpx 30rpx;
  background: linear-gradient(135deg, #ffc8c8, #f8a8b8);
}
.title {
  font-size: 34rpx;
  color: #fff;
}
.avatar {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background: #fff;
}
.list-wrap {
  margin: -30rpx 30rpx 0;
  border-radius: 20rpx;
  background: #fff;
  padding: 30rpx;
  min-height: 80vh;
}
.month-title {
  font-size: 28rpx;
  color: #999;
  margin-bottom: 30rpx;
}
.item {
  display: flex;
  justify-content: space-between;
  padding: 20rpx 0;
  border-bottom: 1rpx solid #f2f2f2;
}
.left .time {
  display: block;
  font-size: 26rpx;
  color: #999;
}
.left .desc {
  font-size: 30rpx;
  color: #333;
  margin-top: 8rpx;
}
.money.add {
  font-size: 32rpx;
  color: #d82626;
}
.money.sub {
  font-size: 32rpx;
  color: #333;
}
.empty {
  text-align: center;
  padding: 80rpx 0;
  color: #999;
  font-size: 28rpx;
}
</style>