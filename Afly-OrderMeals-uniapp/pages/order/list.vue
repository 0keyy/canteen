<template>
  <view class="orders-page">
    <view class="orders-page__header" :style="headerStyle">
      <view class="orders-page__title-wrap" :style="titleBarStyle">
        <text class="orders-page__title">我的订单</text>
        <view class="orders-page__title-line"></view>
      </view>
    </view>

    <scroll-view class="orders-page__content" scroll-y :show-scrollbar="false">
      <view v-if="list.length > 0">
        <view v-for="item in list" :key="item.id" class="order-card" @click="goDetail(item.id)">
          <view class="order-card__header">
            <view class="order-card__store">
              <text class="order-card__store-name">{{ modeText(item.diningMode) }}</text>
              <text class="order-card__arrow">›</text>
            </view>
            <text
              class="order-card__status"
              :class="{
                'order-card__status--paid': item.payStatus === 1,
                'order-card__status--cancelled': item.status === 3
              }"
            >{{ statusText(item) }}</text>
          </view>
          <view class="order-card__body">
            <view class="order-card__amount-row">
              <text class="order-card__amount-label">订单金额</text>
              <text class="order-card__amount">¥{{ item.amount || '0.00' }}</text>
            </view>
            <text class="order-card__time">{{ item.createTime }}</text>
            <text class="order-card__pickup" v-if="item.pickupCode">取餐码：{{ item.pickupCode }}</text>
          </view>
        </view>
      </view>

      <view class="orders-page__empty" v-else>
        <view class="orders-page__empty-icon">
          <text class="orders-page__empty-emoji">📋</text>
        </view>
        <text class="orders-page__empty-title">暂无订单</text>
        <text class="orders-page__empty-desc">下单后可在此查看订单状态</text>
      </view>

      <view class="orders-page__bottom-space"></view>
    </scroll-view>

    <view class="app-tab-bar">
      <view
        v-for="(item, index) in tabbarList"
        :key="index"
        class="app-tab-item"
        @tap.stop="switchTabbar(item, index)"
      >
        <image
          v-if="item.selected || item.unselected"
          class="app-tab-icon"
          :src="tabbarSelected === index ? item.selected : item.unselected"
          mode="aspectFit"
        />
        <text
          class="app-tab-text"
          :style="{ color: tabbarSelected === index ? tabbarSelectedColor : tabbarDefaultColor }"
        >
          {{ item.name }}
        </text>
      </view>
    </view>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import navPageMixin from '../../mixins/nav-page'

export default {
  mixins: [tabbarPageMixin, navPageMixin],
  data() {
    return {
      list: []
    }
  },
  computed: {
    headerStyle() {
      const { headerHeight, statusBarHeight } = this.navMetrics
      return {
        height: `${headerHeight}px`,
        paddingTop: `${statusBarHeight}px`,
        boxSizing: 'border-box'
      }
    },
    titleBarStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` }
    }
  },
  onShow() {
    this.updateNavMetrics()
    this.setupTabbar(1)
    this.loadList()
  },
  methods: {
    modeText(mode) {
      return { 1: '堂食', 3: '外卖' }[mode] || '订单'
    },
    statusText(item) {
      if (item.payStatus === 0 || item.status === 4) return '待支付'
      if (item.status === 1) return '进行中'
      if (item.status === 2) return '已完成'
      if (item.status === 3) return '已取消'
      return '未知'
    },
    async loadList() {
      try {
        this.list = await orderApi.list()
      } catch (e) {
        this.list = []
      }
    },
    goDetail(orderId) {
      uni.navigateTo({ url: `/pages/order/detail?orderId=${orderId}` })
    }
  }
}
</script>

<style lang="scss" scoped>
.orders-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-page;

  &__header {
    flex-shrink: 0;
    background: $bg-page;
    border-bottom: 1rpx solid $divider-color;
  }

  &__title-wrap {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    box-sizing: border-box;
  }

  &__title {
    font-size: 34rpx;
    font-weight: bold;
    color: #333333;
    line-height: 1.2;
  }

  &__title-line {
    width: 48rpx;
    height: 6rpx;
    background: $brand-primary;
    border-radius: 3rpx;
    margin-top: 8rpx;
  }

  &__content {
    flex: 1;
    height: 0;
    padding-top: 8rpx;
    overflow: hidden;
  }

  &__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 120rpx 0 80rpx;
  }

  &__empty-icon {
    width: 160rpx;
    height: 160rpx;
    background: #F8F4F0;
    border-radius: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;
  }

  &__empty-emoji {
    font-size: 72rpx;
  }

  &__empty-title {
    font-size: 30rpx;
    color: #999999;
    margin-bottom: 12rpx;
  }

  &__empty-desc {
    font-size: 24rpx;
    color: #BBBBBB;
  }

  &__bottom-space {
    height: 24rpx;
  }
}

.order-card {
  background: #FFFFFF;
  border-radius: $radius-card;
  margin: 20rpx 24rpx;
  padding: 28rpx;
  box-shadow: $shadow-card;

  &:active {
    opacity: 0.9;
  }

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-bottom: 20rpx;
    border-bottom: 1rpx solid #F0F0F0;
  }

  &__store {
    display: flex;
    align-items: center;
  }

  &__store-name {
    font-size: 30rpx;
    font-weight: bold;
    color: #333333;
  }

  &__arrow {
    font-size: 30rpx;
    color: #999999;
    margin-left: 8rpx;
  }

  &__status {
    font-size: 26rpx;
    color: $text-price;
    font-weight: 500;

    &--paid {
      color: #4CAF50;
    }

    &--cancelled {
      color: #999999;
    }
  }

  &__body {
    padding-top: 20rpx;
  }

  &__amount-row {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
  }

  &__amount-label {
    font-size: 24rpx;
    color: #999999;
  }

  &__amount {
    font-size: 34rpx;
    font-weight: bold;
    color: #333333;
  }

  &__time {
    display: block;
    margin-top: 12rpx;
    font-size: 24rpx;
    color: #999999;
  }

  &__pickup {
    display: block;
    margin-top: 8rpx;
    font-size: 24rpx;
    color: $text-price;
    font-weight: 500;
  }
}
</style>
