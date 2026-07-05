<template>
  <view class="orders-page">
    <!-- 顶部导航 -->
    <view class="orders-page__navbar" :style="navbarStyle">
      <view class="orders-page__navbar-left" @tap="goBack">
        <text class="orders-page__navbar-back">‹</text>
      </view>
      <view class="orders-page__navbar-title">
        <!-- <text class="orders-page__navbar-title-text">我的订单</text> -->
      </view>
      <view class="orders-page__navbar-right">
        <text class="orders-page__navbar-search">⌕</text>
      </view>
    </view>

    <!-- Tabs -->
    <view class="orders-page__tabs">
      <view
        v-for="(tab, idx) in tabs"
        :key="tab.key"
        class="orders-page__tab-item"
        :class="{ 'orders-page__tab-item--active': activeTab === idx }"
        @tap="switchTab(idx)"
      >
        <text class="orders-page__tab-text">{{ tab.name }}</text>
        <view v-if="activeTab === idx" class="orders-page__tab-line"></view>
      </view>
    </view>

    <!-- 列表内容 -->
    <scroll-view class="orders-page__content" scroll-y :show-scrollbar="false">
      <view v-if="currentList.length > 0" class="orders-page__list">
        <view v-for="order in currentList" :key="order.id" class="order-item" @tap="goDetail(order.id)">
          <view v-for="(dish, dIdx) in order.dishes" :key="dIdx" class="order-item__dish">
            <image class="order-item__dish-img" :src="dish.image" mode="aspectFill" />
            <view class="order-item__dish-info">
              <text class="order-item__dish-name">{{ dish.name }}</text>
              <text class="order-item__dish-time">{{ order.createTime }}</text>
            </view>
            <view class="order-item__dish-right">
              <text class="order-item__dish-status" :class="`order-item__dish-status--${order.statusKey}`">{{ order.statusText }}</text>
              <text class="order-item__dish-price">共{{ dish.quantity }}份 ¥{{ dish.price }}</text>
              <view v-if="order.statusKey === 'completed'" class="order-item__btn order-item__btn--primary" @tap.stop="reorder(order)">
                <text class="order-item__btn-text">再来一单</text>
              </view>
              <view v-else-if="order.statusKey === 'shipping'" class="order-item__btn order-item__btn--primary" @tap.stop="confirmReceive(order)">
                <text class="order-item__btn-text">再来一单</text>
              </view>
            </view>
          </view>
          <view v-if="order.dishes.length > 1" class="order-item__more" @tap.stop="goDetail(order.id)">
            <text class="order-item__more-text">更多</text>
          </view>
        </view>
      </view>

      <view class="orders-page__empty" v-else>
        <text class="orders-page__empty-text">快去下单吧</text>
      </view>

      <view class="orders-page__bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

const TABS = [
  { key: 'all', name: '全部' },
  { key: 'paying', name: '待支付' },
  { key: 'shipping', name: '待发货' },
  { key: 'delivering', name: '待收货' },
  { key: 'refund', name: '退款/售后' }
]

export default {
  data() {
    return {
      tabs: TABS,
      activeTab: 0,
      allList: [],
      navHeight: 0,
      statusBarHeight: 0,
      staticImgPrefix: STATIC_IMAGE_PREFIX
    }
  },
  computed: {
    navbarStyle() {
      return `padding-top: ${this.statusBarHeight}px; height: ${44 + this.statusBarHeight}px;`
    },
    currentList() {
      if (this.activeTab === 0) return this.allList
      const key = TABS[this.activeTab].key
      return this.allList.filter(o => o.statusKey === key)
    }
  },
  onLoad(options) {
    const sys = uni.getSystemInfoSync()
    this.statusBarHeight = sys.statusBarHeight || 20
    if (options && options.tab !== undefined) {
      const tabIdx = parseInt(options.tab)
      if (!isNaN(tabIdx) && tabIdx >= 0 && tabIdx < TABS.length) {
        this.activeTab = tabIdx
      }
    }
    this.loadList()
  },
  onShow() {
    this.loadList()
  },
  methods: {
    async loadList() {
      try {
        const data = await orderApi.list()
        let list = []
        if (Array.isArray(data)) {
          list = data
        } else if (data && Array.isArray(data.list)) {
          list = data.list
        } else if (data && Array.isArray(data.data)) {
          list = data.data
        }
        if (list.length > 0) {
          this.allList = list.map(item => this.normalizeOrder(item))
        } else {
          this.allList = this.getMockList()
        }
      } catch (e) {
        this.allList = this.getMockList()
      }
    },
    normalizeOrder(item) {
      const statusInfo = this.getStatusInfo(item)
      let dishes = []
      if (Array.isArray(item.dishes)) {
        dishes = item.dishes
      } else if (item.dish) {
        dishes = [item.dish]
      } else if (Array.isArray(item.goodsList)) {
        dishes = item.goodsList
      } else if (Array.isArray(item.orderDishes)) {
        dishes = item.orderDishes
      }

      const dishList = dishes.length > 0 ? dishes.slice(0, 2).map(d => ({
        id: d.id || d.dishId || d.goodsId,
        name: d.name || d.dishName || d.goodsName || '',
        image: d.image || d.img || d.cover || d.goodsImage || d.dishImage || '',
        price: d.price || d.dishPrice || d.goodsPrice || 0,
        quantity: d.quantity || d.count || d.dishQuantity || d.num || 1
      })) : []

      if (dishList.length === 0) {
        const modeName = item.diningMode === 3 ? '外卖' : (item.diningMode === 1 ? '堂食' : '订单')
        dishList.push({
          id: item.id,
          name: item.dishName || `${modeName}订单`,
          image: item.image || '',
          price: item.amount || 0,
          quantity: 1
        })
      }

      return {
        id: item.id || item.orderId || item.oid,
        createTime: item.createTime || item.time || item.orderTime || '',
        amount: item.amount || item.totalAmount || item.totalPrice || 0,
        statusKey: statusInfo.key,
        statusText: statusInfo.text,
        dishes: dishList
      }
    },
    getStatusInfo(item) {
      if (item.payStatus === 0 || item.status === 4) {
        return { key: 'paying', text: '待支付' }
      }
      if (item.status === 1 && item.shippingStatus === 0) {
        return { key: 'shipping', text: '待发货' }
      }
      if (item.status === 1 && item.shippingStatus === 1) {
        return { key: 'delivering', text: '待收货' }
      }
      if (item.status === 2) {
        return { key: 'completed', text: '已完成' }
      }
      if (item.status === 3) {
        return { key: 'refund', text: '已退款' }
      }
      if (item.status === 5) {
        return { key: 'refund', text: '退款中' }
      }
      return { key: 'completed', text: '已完成' }
    },
    getMockList() {
      return [
        {
          id: 1,
          createTime: '2026-06-01 18:11:31',
          amount: 3,
          statusKey: 'completed',
          statusText: '已完成',
          dishes: [
            { id: 1, name: '可口可乐', image: this.staticImgPrefix + '/首页广告.png', price: '3', quantity: 1 }
          ]
        },
        {
          id: 2,
          createTime: '2026-06-01 18:11:31',
          amount: 15,
          statusKey: 'delivering',
          statusText: '待收货',
          dishes: [
            { id: 2, name: '红烧牛肉面', image: this.staticImgPrefix + '/首页广告.png', price: '15', quantity: 1 }
          ]
        }
      ]
    },
    switchTab(idx) {
      this.activeTab = idx
    },
    goBack() {
      const pages = getCurrentPages()
      if (pages.length > 1) {
        uni.navigateBack()
      } else {
        uni.switchTab({ url: '/pages/mine/index' })
      }
    },
    goDetail(orderId) {
      uni.navigateTo({ url: `/pages/order/detail?orderId=${orderId}` })
    },
    reorder(order) {
      uni.switchTab({ url: '/pages/menu/index' })
    },
    confirmReceive(order) {
      uni.showToast({ title: '确认收货功能开发中', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
$brand-primary: #b31212;
$text-primary: #333333;
$text-secondary: #494949;
$text-tertiary: #CCCCCC;
$bg-gray: #e9e9e9;
$bg-white: #FFFFFF;
$border-light: #EEEEEE;

.orders-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-gray;

  &__navbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 24rpx;
    box-sizing: border-box;
    flex-shrink: 0;
  }

  &__navbar-left,
  &__navbar-right {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__navbar-back {
    font-size: 64rpx;
    color: $text-primary;
    line-height: 1;
    font-weight: 300;
  }

  &__navbar-search {
    font-size: 36rpx;
    color: $text-primary;
    line-height: 1;
  }

  &__navbar-title {
    flex: 1;
    text-align: center;
  }

  &__navbar-title-text {
    font-size: 32rpx;
    font-weight: 600;
    color: $text-primary;
  }

  &__tabs {
    display: flex;
    align-items: center;
    padding: 0 12rpx;
    flex-shrink: 0;
    border-bottom: 1rpx solid $border-light;
  }

  &__tab-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 24rpx 0 20rpx;
    position: relative;
	font-weight: 700;
	
  }

  &__tab-text {
    font-size: 28rpx;
    color: $text-secondary;
    line-height: 90rpx;
  }

  &__tab-item--active &__tab-text {
    font-weight: 700;
	color: $brand-primary;
  }

  // &__tab-line {
  //   position: absolute;
  //   bottom: 8rpx;
  //   width: 40rpx;
  //   height: 6rpx;
  //   background: $brand-primary;
  //   border-radius: 3rpx;
  // }

  &__content {
    flex: 1;
    height: 0;
    padding: 24rpx;
	width: 95vw;
    // box-sizing: border-box;
	background: $bg-white;
	border-radius: 8rpx;
	margin: 0 auto;
  }

  &__list {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 120rpx 0;
  }

  &__empty-text {
    font-size: 26rpx;
    color: $text-secondary;
  }

  &__bottom-space {
    height: 60rpx;
  }
}

.order-item {
  background: $bg-white;
  border-radius: 16rpx;
  padding: 24rpx;
  display: flex;
  flex-direction: column;
  gap: 20rpx;

  &__dish {
    display: flex;
    align-items: flex-start;
    gap: 20rpx;
  }

  &__dish-img {
    width: 140rpx;
    height: 140rpx;
    border-radius: 12rpx;
    flex-shrink: 0;
    background: #F0F0F0;
  }

  &__dish-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 12rpx;
    padding-top: 4rpx;
  }

  &__dish-name {
    font-size: 28rpx;
    font-weight: 600;
    color: $text-primary;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
  }

  &__dish-time {
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__dish-right {
    flex-shrink: 0;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 8rpx;
    padding-top: 4rpx;
  }

  &__dish-status {
    font-size: 26rpx;
    font-weight: 600;
    color: $brand-primary;

    &--completed {
      color: $text-secondary;
    }

    &--paying {
      color: $brand-primary;
    }

    &--shipping {
      color: #FF9800;
    }

    &--delivering {
      color: #FF9800;
    }

    &--refund {
      color: $text-tertiary;
    }
  }

  &__dish-price {
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__btn {
    padding: 10rpx 28rpx;
    border-radius: 999rpx;
    margin-top: 4rpx;

    &--primary {
      background: $brand-primary;
    }
  }

  &__btn-text {
    font-size: 22rpx;
    color: #FFFFFF;
    font-weight: 500;
  }

  &__more {
    padding-top: 8rpx;
    border-top: 1rpx solid $border-light;
    text-align: center;
  }

  &__more-text {
    font-size: 24rpx;
    color: $text-secondary;
  }
}
</style>
