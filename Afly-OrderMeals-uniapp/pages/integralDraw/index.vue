<template>
  <view class="draw-page">
    <!-- 左上角水印logo -->
    <image class="logo-water" src="/static/黑logo.png" mode="aspectFill"></image>

    <!-- 顶部头部 -->
    <view class="draw-header">
      <view class="draw-back" @tap="goBack">‹</view>
      <view class="draw-title-wrap">
        <text class="draw-title1">粮兴坊</text>
        <text class="draw-title2">积分抽奖</text>
      </view>
      <view class="draw-avatar-wrap">
        <image class="draw-avatar" src="/static/雀跃.png" mode="aspectFill"></image>
      </view>
    </view>

    <!-- 九宫格抽奖区域（纯文字，无图片） -->
    <view class="draw-box-wrap">
      <view class="draw-grid">
        <!-- 第一行 3个奖品 -->
        <view class="draw-item" :class="{active: activeIdx === 0}" v-for="(item, idx) in prizeList.slice(0,3)" :key="item.id || idx">
          <text class="item-num">{{ item.numText }}</text>
          <text class="item-desc">{{ item.descText }}</text>
        </view>
        <!-- 第二行左侧奖品 -->
        <view class="draw-item" :class="{active: activeIdx === 3}" v-for="(item, idx) in prizeList.slice(3,4)" :key="item.id || idx">
          <text class="item-num">{{ item.numText }}</text>
          <text class="item-desc">{{ item.descText }}</text>
        </view>
        <!-- 中间抽奖按钮 -->
        <view class="draw-item center-item" @tap="handleDraw" :class="{disabled: isRunning}">
          <text class="center-text">{{ isRunning ? '抽奖中' : '抽' }}</text>
          <text class="center-desc">消耗10积分</text>
        </view>
        <!-- 第二行右侧奖品 -->
        <view class="draw-item" :class="{active: activeIdx === 4}" v-for="(item, idx) in prizeList.slice(4,5)" :key="item.id || idx">
          <text class="item-num">{{ item.numText }}</text>
          <text class="item-desc">{{ item.descText }}</text>
        </view>
        <!-- 第三行 3个奖品 -->
        <view class="draw-item" :class="{active: activeIdx === idx + 5}" v-for="(item, idx) in prizeList.slice(5,8)" :key="item.id || idx">
          <text class="item-num">{{ item.numText }}</text>
          <text class="item-desc">{{ item.descText }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script>
// 对接后端积分接口
import { getDrawPrizeList, startDrawApi } from '@/api/integral'
export default {
  data() {
    return {
      // 后端返回奖品数组
      prizeList: [],
      // 兜底本地默认文字奖品（接口异常时显示）
      defaultPrize: [
        { id: 1, numText: "15积分", descText: "15积分券" },
        { id: 2, numText: "立减3元", descText: "3元优惠券" },
        { id: 3, numText: "满20减5", descText: "5元满减券" },
        { id: 4, numText: "10积分", descText: "10积分券" },
        { id: 5, numText: "立减1元", descText: "1元优惠券" },
        { id: 6, numText: "立减1元", descText: "1元优惠券" },
        { id: 7, numText: "5积分", descText: "5积分券" },
        { id: 8, numText: "满20减3", descText: "3元满减券" },
      ],
      activeIdx: 0, // 当前高亮下标 0~7
      timer: null, // 滚动定时器
      isRunning: false, // 是否正在抽奖动画
      speed: 80 // 滚动速度，数字越小滚动越快
    }
  },
  onLoad() {
    // 页面加载拉取后端奖品数据
    this.getPrizeData()
  },
  onUnload() {
    // 页面销毁清除定时器，防止持续滚动
    if (this.timer) clearInterval(this.timer)
  },
  methods: {
    // 1、请求后端奖品列表接口
    async getPrizeData() {
      try {
        const res = await getDrawPrizeList()
        // 后端正常返回8条奖品则覆盖本地数据
        if (res.code === 200 && Array.isArray(res.data) && res.data.length === 8) {
          this.prizeList = res.data
        } else {
          this.prizeList = this.defaultPrize
        }
      } catch (err) {
        // 接口报错、后端未开发，自动使用本地兜底数据，不弹窗报错
        this.prizeList = this.defaultPrize
      }
    },
    // 返回上一页（积分商城）
    goBack() {
      uni.navigateBack()
    },
    // 开启九宫格循环高亮滚动动画
    startScroll() {
      this.timer = setInterval(() => {
        this.activeIdx += 1
        if (this.activeIdx > 7) this.activeIdx = 0
      }, this.speed)
    },
    // 减速停止动画，定格到后端返回的中奖下标
    stopScroll(winIndex) {
      clearInterval(this.timer)
      let slowSpeed = this.speed
      const slowTimer = setInterval(() => {
        slowSpeed += 3
        clearInterval(this.timer)
        this.timer = setInterval(() => {
          this.activeIdx += 1
          if (this.activeIdx > 7) this.activeIdx = 0
        }, slowSpeed)
        // 滚动到中奖格子，完全停止
        if (this.activeIdx === winIndex) {
          clearInterval(this.timer)
          clearInterval(slowTimer)
          this.isRunning = false
          // 弹出中奖弹窗
          uni.showModal({
            title: '恭喜中奖',
            content: `您抽到：${this.prizeList[winIndex].descText}`,
            confirmText: '确定'
          })
        }
      }, 150)
    },
    // 点击中间【抽】按钮主逻辑
    async handleDraw() {
      if (this.isRunning) return
      this.isRunning = true
      // 先启动滚动动画
      this.startScroll()
      try {
        // 请求后端抽奖核心接口（扣积分、算中奖）
        const res = await startDrawApi()
        if (res.code === 200) {
          // 后端返回中奖下标，延迟减速定格
          setTimeout(() => {
            this.stopScroll(res.winIndex)
          }, 2200)
        } else {
          // 积分不足、库存不足等后端错误
          clearInterval(this.timer)
          this.isRunning = false
          uni.showToast({ title: res.msg || '抽奖失败', icon: 'none' })
        }
      } catch (e) {
        // 网络/接口异常处理
        clearInterval(this.timer)
        this.isRunning = false
        uni.showToast({ title: '网络异常', icon: 'none' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.draw-page {
  min-height: 100vh;
  position: relative;
  padding: calc(60rpx + env(safe-area-inset-top)) 32rpx 40rpx;
  overflow: hidden;
  background: linear-gradient(180deg, #ffd1d1, #fff0f0);
}

// 左上角半透明水印logo
.logo-water {
  position: absolute;
  left: 60rpx;
  top: calc(env(safe-area-inset-top) + 100rpx);
  width: 240rpx;
  height: 240rpx;
  opacity: 0.12;
  z-index: 0;
  pointer-events: none;
}

// 顶部标题区域
.draw-header {
  position: relative;
  z-index: 2;
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-top: 240rpx;
  margin-bottom: 100rpx;

  .draw-back {
    position: fixed;
    left: 20rpx;
    top: calc(env(safe-area-inset-top) + 60rpx);
    font-size: 70rpx;
    color: #222;
    width: 60rpx;
    height: 60rpx;
    display: flex;
    align-items: center;
    z-index: 99;
  }

  .draw-title-wrap {
    flex: 1;
    padding-left: 30rpx;
    padding-top: 10px;
    .draw-title1 {
      font-size: 95rpx;
      color: #b82222;
      font-weight: 900;
      display: block;
      letter-spacing: 4rpx;
    }
    .draw-title2 {
      font-size: 95rpx;
      color: #b82222;
      font-weight: 900;
      letter-spacing: 6rpx;
    }
  }

  .draw-avatar-wrap {
    position: absolute;
    right: -10px;
    top: 18rpx;
  }
  .draw-avatar {
    width: 250rpx;
    height: 350rpx;
  }
}

// 九宫格外层红色容器
.draw-box-wrap {
  position: relative;
  z-index: 2;
  background: #a81c1c;
  border-radius: 24rpx;
  padding: 40rpx;
}
.draw-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12rpx;
}
.draw-item {
  background: #fff;
  border-radius: 18rpx;
  padding: 40rpx 16rpx;
  text-align: center;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  transition: all 0.1s;
  // 滚动高亮样式
  &.active {
    background: #ffe6e6;
    transform: scale(1.03);
  }

  .item-num {
    font-size: 45rpx;
    color: #b82222;
    font-weight: bold;
    display: block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .item-desc {
    font-size: 25rpx;
    color: #666;
  }
}
// 中间抽奖按钮格子
.center-item {
  background: #fff8f8;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 18rpx;
  padding: 40rpx 16rpx;
  box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.05);
  &.disabled {
    opacity: 0.7;
  }
  .center-text {
    font-size: 50rpx;
    color: #b82222;
    font-weight: bold;
  }
  .center-desc {
    font-size: 20rpx;
    color: #999;
    margin-top: 8rpx;
  }
}
</style>