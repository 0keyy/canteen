<template>
  <view class="orders-page">
    <scroll-view class="orders-page__content" scroll-y :show-scrollbar="false">
      <view class="orders-page__header-card">
        <text class="orders-page__title">我的订单</text>

        <view v-if="pendingTotal > 0" class="orders-page__pending">
          <text class="orders-page__pending-title">待提交订单</text>
          <text class="orders-page__pending-desc">已选菜品合计 ¥ {{ pendingTotal.toFixed(2) }}，可继续确认取餐方式。</text>
          <view class="orders-page__pending-btn" @tap="goMenu">
            <text class="orders-page__pending-btn-text">去提交</text>
            <text class="orders-page__pending-arrow">›</text>
          </view>
        </view>
      </view>

      <view v-if="list.length > 0" class="orders-page__list">
        <view v-for="item in list" :key="item.id" class="order-card" @click="goDetail(item.id)">
          <view class="order-card__icon-wrap">
            <view class="order-card__icon"></view>
          </view>
          <view class="order-card__body">
            <view class="order-card__top">
              <text class="order-card__title">{{ orderTitle(item) }}</text>
              <text
                class="order-card__status"
                :class="{
                  'order-card__status--paid': item.payStatus === 1,
                  'order-card__status--cancelled': item.status === 3
                }"
              >{{ statusText(item) }}</text>
            </view>
            <text class="order-card__meta">{{ item.createTime }} · #{{ item.id }}</text>
            <view class="order-card__bottom">
              <text class="order-card__amount">¥{{ item.amount || '0.00' }}</text>
              <view class="order-card__reorder" @click.stop="reorder(item)">
                <text class="order-card__reorder-icon">↻</text>
                <text class="order-card__reorder-text">再来一单</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="orders-page__empty" v-else>
        <view class="orders-page__empty-icon">
          <view class="orders-page__empty-icon-inner"></view>
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
        :class="{ 'app-tab-item--active': tabbarSelected === index }"
        @tap.stop="switchTabbar(item, index)"
      >
        <view class="app-tab-icon-wrap">
          <image
            class="app-tab-icon"
            :src="tabbarSelected === index ? item.selected : item.unselected"
            mode="aspectFit"
          />
        </view>
        <text
          class="app-tab-text"
          :style="{ color: tabbarSelected === index ? tabbarSelectedColor : tabbarDefaultColor }"
        >
          {{ item.name }}
        </text>
      </view>
    </view>
    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { DEFAULT_SHOP_ID } from '../../utils/config'
import tabbarPageMixin from '../../mixins/tabbar-page'
import PageLoading from '../../components/page-loading/page-loading.vue'

export default {
  components: { PageLoading },
  mixins: [tabbarPageMixin],
  data() {
    return {
      list: [],
      pendingTotal: 0,
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  onShow() {
    this.setupTabbar(2)
    this.loadList()
    this.loadPendingCart()
  },
  methods: {
    async loadPendingCart() {
      try {
        const has = await orderApi.cartHas(DEFAULT_SHOP_ID)
        if (!has?.oid || !Array.isArray(has.dish) || has.dish.length === 0) {
          this.pendingTotal = 0
          return
        }
        let total = 0
        has.dish.forEach((item) => {
          total += Number(item.price || 0) * (Number(item.count) || 0)
        })
        this.pendingTotal = total
      } catch (e) {
        this.pendingTotal = 0
      }
    },
    modeText(mode) {
      return { 1: '堂食', 3: '外卖' }[mode] || '订单'
    },
    statusText(item) {
      if (item.payStatus === 0 || item.status === 4) return '待支付'
      if (item.status === 1 && Number(item.calledTime) > 0) return '请取餐'
      if (item.status === 1) return '制作中'
      if (item.status === 2) return '已完成'
      if (item.status === 3) return '已取消'
      return '未知'
    },
    orderTitle(item) {
      return `${this.modeText(item.diningMode)}订单`
    },
    async loadList() {
      try {
        this.list = await orderApi.list()
      } catch (e) {
        this.list = []
      }
    },
    goDetail(orderId) {
      this.goWithLoading(`/pages/order/detail?orderId=${orderId}`, 'navigateTo')
    },
    goMenu() {
      this.goWithLoading('/pages/menu/index', 'switchTab')
    },
    reorder() {
      this.goWithLoading('/pages/menu/index', 'switchTab')
    },
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

<style lang="scss" scoped>
.orders-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-gray;

  &__content {
    flex: 1;
    height: 0;
    padding: 24rpx;
    box-sizing: border-box;
    /* ========== 新增控制整体上下偏移的代码 ========== */
    margin-top: 80rpx; 
    /* 调整说明：40rpx是下移距离，数值越大页面整体越往下，改成0就恢复原位 */
  }

  &__header-card {
    background: $bg-surface;
    border-radius: $radius-card;
    padding: 24rpx;
    box-shadow: $shadow-sm;
  }

  &__title {
    display: block;
    margin-top: 4rpx;
    font-size: 40rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__pending {
    margin-top: 24rpx;
    padding: 24rpx;
    border-radius: $radius-card;
    background: linear-gradient(135deg, $brand-primary 0%, $brand-orange-light 100%);
  }

  &__pending-title {
    display: block;
    font-size: 32rpx;
    font-weight: 900;
    color: $text-white;
  }

  &__pending-desc {
    display: block;
    margin-top: 8rpx;
    font-size: 22rpx;
    color: rgba(255, 252, 248, 0.9);
    line-height: 1.5;
  }

  &__pending-btn {
    display: inline-flex;
    align-items: center;
    gap: 4rpx;
    margin-top: 16rpx;
    padding: 0 32rpx;
    height: 64rpx;
    background: $bg-surface;
    border-radius: 999rpx;
  }

  &__pending-btn-text {
    font-size: 24rpx;
    font-weight: 600;
    color: $text-primary;
  }

  &__pending-arrow {
    font-size: 28rpx;
    color: $text-primary;
    line-height: 1;
  }

  &__list {
    margin-top: 24rpx;
    display: flex;
    flex-direction: column;
    gap: 20rpx;
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
    background: $bg-surface;
    border-radius: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 32rpx;
    box-shadow: $shadow-sm;
  }

  &__empty-icon-inner {
    width: 48rpx;
    height: 56rpx;
    border: 4rpx solid $text-tertiary;
    border-radius: 6rpx;

    &::before {
      content: '';
      display: block;
      margin: 12rpx auto 0;
      width: 28rpx;
      height: 4rpx;
      background: $text-tertiary;
      box-shadow: 0 10rpx 0 $text-tertiary, 0 20rpx 0 $text-tertiary;
    }
  }

  &__empty-title {
    font-size: 30rpx;
    color: $text-secondary;
    margin-bottom: 12rpx;
  }

  &__empty-desc {
    font-size: 24rpx;
    color: $text-tertiary;
  }


  &__bottom-space {
    height: $tabbar-height;
  }
}

.order-card {
  display: flex;
  gap: 24rpx;
  background: $bg-surface;
  border-radius: $radius-card;
  padding: 24rpx;
  box-shadow: $shadow-sm;

  &:active {
    opacity: 0.92;
  }

  &__icon-wrap {
    width: 80rpx;
    height: 80rpx;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(177, 10, 15, 0.1);
    border-radius: $radius-card;
  }

  &__icon {
    width: 36rpx;
    height: 44rpx;
    border: 3rpx solid $brand-primary;
    border-radius: 4rpx;

    &::before {
      content: '';
      display: block;
      margin: 8rpx auto 0;
      width: 22rpx;
      height: 3rpx;
      background: $brand-primary;
      box-shadow: 0 8rpx 0 $brand-primary, 0 16rpx 0 $brand-primary;
    }
  }

  &__body {
    flex: 1;
    min-width: 0;
  }

  &__top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12rpx;
  }

  &__title {
    flex: 1;
    font-size: 30rpx;
    font-weight: 900;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__status {
    font-size: 22rpx;
    font-weight: 600;
    color: $brand-primary;
    flex-shrink: 0;

    &--paid {
      color: #4CAF50;
    }

    &--cancelled {
      color: $text-tertiary;
    }
  }

  &__meta {
    display: block;
    margin-top: 8rpx;
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 16rpx;
  }

  &__amount {
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__reorder {
    display: flex;
    align-items: center;
    gap: 6rpx;
    padding: 8rpx 24rpx;
    border: 1rpx solid $border-light;
    border-radius: 999rpx;
  }

  &__reorder-icon {
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__reorder-text {
    font-size: 22rpx;
    font-weight: 600;
    color: $text-secondary;
  }
}
</style>
