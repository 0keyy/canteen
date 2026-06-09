<template>
  <view class="order-page">
    <view class="order-page__header" :style="headerPaddingStyle">
      <view class="order-page__nav-row" :style="navRowStyle">
        <view class="order-page__back" @tap="goBack">
          <text class="order-page__back-icon">‹</text>
          <text class="order-page__back-text">返回</text>
        </view>
        <text class="order-page__nav-title">{{ shopName }}</text>
        <view class="order-page__nav-spacer"></view>
      </view>
      <view class="order-page__mode-row">
        <view class="order-page__mode-tag order-page__mode-tag--active">
          <text class="order-page__mode-text">{{ diningModeText }}</text>
        </view>
      </view>
    </view>

    <view v-if="loading" class="order-page__loading">加载中...</view>
    <view v-else-if="menu.length === 0" class="order-page__empty">暂无菜品，请先在后台添加菜品分类和菜品</view>
    <view v-else class="order-page__main">
      <scroll-view scroll-y class="order-page__categories" :show-scrollbar="false">
        <view
          v-for="(cate, index) in menu"
          :key="index"
          :class="['order-page__category-item', activeIndex === index ? 'order-page__category-item--active' : '']"
          @click="activeIndex = index"
        >
          <text
            :class="['order-page__category-name', activeIndex === index ? 'order-page__category-name--active' : '']"
          >{{ cate.name }}</text>
          <text v-if="cateCount(index) > 0" class="order-page__category-badge">{{ cateCount(index) }}</text>
        </view>
      </scroll-view>

      <scroll-view scroll-y class="order-page__dishes" :show-scrollbar="false">
        <view class="order-page__dish-list">
          <view v-for="(food, idx) in currentFoods" :key="food.id" class="menu-card">
            <view class="menu-card__image-wrap">
              <image :src="food.image" class="menu-card__image" mode="aspectFill" />
              <view class="menu-card__tag" v-if="foodTag(idx)">
                <text class="menu-card__tag-text">{{ foodTag(idx) }}</text>
              </view>
            </view>
            <view class="menu-card__info">
              <text class="menu-card__name">{{ food.title }}</text>
              <text class="menu-card__desc" v-if="food.intro">{{ food.intro }}</text>
              <view class="menu-card__bottom">
                <text class="menu-card__price">¥{{ food.price }}</text>
                <view class="menu-card__actions">
                  <view
                    class="menu-card__btn menu-card__btn--minus"
                    v-if="getCount(food.id) > 0"
                    @click="decFood(food)"
                  >
                    <text class="menu-card__btn-icon">−</text>
                  </view>
                  <text class="menu-card__count" v-if="getCount(food.id) > 0">{{ getCount(food.id) }}</text>
                  <view
                    class="menu-card__btn menu-card__btn--plus"
                    :class="{ 'menu-card__btn--disabled': cartBusy }"
                    @click="addFood(food)"
                  >
                    <text class="menu-card__btn-icon menu-card__btn-icon--plus">+</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
        <view v-if="currentFoods.length === 0" class="order-page__dish-empty">该分类暂无菜品</view>
      </scroll-view>
    </view>

    <view
      class="cart-bar safe-area-bottom"
      :class="{ 'cart-bar--disabled': !cartReady || cartItemCount === 0 }"
    >
      <view class="cart-bar__left" @click="goConfirm">
        <view class="cart-bar__icon-wrap">
          <text class="cart-bar__icon">🛒</text>
          <view class="cart-bar__badge" v-if="cartItemCount > 0">
            <text class="cart-bar__badge-text">{{ cartItemCount }}</text>
          </view>
        </view>
        <view class="cart-bar__price-wrap">
          <text class="cart-bar__label">合计</text>
          <text class="cart-bar__price">{{ cartSummary }}</text>
        </view>
      </view>
      <view
        class="cart-bar__btn"
        :class="{ 'cart-bar__btn--disabled': !cartReady || cartItemCount === 0 }"
        @click="goConfirm"
      >
        <text class="cart-bar__btn-text">结算</text>
      </view>
    </view>
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { DEFAULT_SHOP_ID } from '../../utils/config'
import { resolveImageUrl } from '../../utils/image'
import navPageMixin from '../../mixins/nav-page'

export default {
  mixins: [navPageMixin],
  data() {
    return {
      aid: DEFAULT_SHOP_ID,
      shop: null,
      diningMode: 1,
      orderId: 0,
      menu: [],
      activeIndex: 0,
      cartMap: {},
      loading: true,
      cartReady: false,
      cartBusy: false,
      cartInitPromise: null
    }
  },
  computed: {
    headerPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight}px` }
    },
    navRowStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` }
    },
    shopName() {
      return this.shop?.name || '粮兴坊'
    },
    diningModeText() {
      return { 1: '堂食', 3: '外卖配送' }[this.diningMode] || '堂食'
    },
    currentFoods() {
      return this.menu[this.activeIndex]?.foods || []
    },
    totalPrice() {
      let total = 0
      Object.values(this.cartMap).forEach((item) => {
        total += Number(item.price) * item.count
      })
      return total.toFixed(2)
    },
    cartItemCount() {
      return Object.values(this.cartMap).reduce((sum, item) => sum + item.count, 0)
    },
    cartSummary() {
      if (!this.cartReady) return '购物车准备中...'
      if (this.cartItemCount === 0) return '¥0.00'
      return `¥${this.totalPrice}`
    }
  },
  onLoad() {
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    this.updateNavMetrics()
    this.loadShop()
    this.bootstrap()
  },
  onShow() {
    this.updateNavMetrics()
    if (!this.loading && this.cartReady) {
      this.syncCart()
    }
  },
  methods: {
    async loadShop() {
      try {
        this.shop = await orderApi.shop(this.aid)
      } catch (e) {
        this.shop = null
      }
    },
    goBack() {
      const pages = getCurrentPages()
      if (pages.length > 1) {
        uni.navigateBack()
        return
      }
      uni.switchTab({ url: '/pages/index/index' })
    },
    foodTag(index) {
      const tags = ['热销', '新品', '特价']
      return index < 3 ? tags[index] : ''
    },
    dishKey(dishId) {
      return String(dishId)
    },
    getCount(dishId) {
      return this.cartMap[this.dishKey(dishId)]?.count || 0
    },
    cateCount(index) {
      const foods = this.menu[index]?.foods || []
      return foods.reduce((sum, food) => sum + this.getCount(food.id), 0)
    },
    findFood(dishId) {
      const targetId = Number(dishId)
      for (const cate of this.menu) {
        const food = cate.foods.find((f) => Number(f.id) === targetId)
        if (food) return food
      }
      return null
    },
    setCartMap(map) {
      this.cartMap = { ...map }
    },
    patchCartItem(dishId, item) {
      const key = this.dishKey(dishId)
      const next = { ...this.cartMap }
      if (item) {
        next[key] = item
      } else {
        delete next[key]
      }
      this.cartMap = next
    },
    async bootstrap() {
      this.loading = true
      this.cartReady = false
      try {
        await this.loadMenu()
        await this.initOrder()
        await this.syncCart()
        this.cartReady = !!this.orderId
      } catch (e) {
        this.cartReady = false
        uni.showToast({ title: e.message || e || '页面加载失败', icon: 'none' })
      } finally {
        this.loading = false
      }
    },
    async loadMenu() {
      const list = await orderApi.menu(this.aid)
      this.menu = (Array.isArray(list) ? list : []).map((cate) => ({
        ...cate,
        foods: (cate.foods || []).map((food) => ({
          ...food,
          image: resolveImageUrl(food.image)
        }))
      }))
      this.activeIndex = 0
    },
    async initOrder() {
      const has = await orderApi.cartHas(this.aid)
      if (has?.oid && Number(has.diningMode) === this.diningMode) {
        this.orderId = Number(has.oid)
        return
      }
      if (has?.oid) {
        await orderApi.toEmpty(has.oid)
        this.setCartMap({})
      }
      const orderId = await orderApi.cartCreate({
        aid: this.aid,
        diningMode: this.diningMode,
        deskId: this.diningMode === 1 ? 1 : 0,
        userNum: 1,
        source: 2
      })
      this.orderId = Number(orderId)
      if (!this.orderId) {
        throw new Error('购物车创建失败')
      }
    },
    async ensureCart() {
      if (this.orderId) {
        return this.orderId
      }
      if (this.cartInitPromise) {
        await this.cartInitPromise
        return this.orderId
      }
      this.cartInitPromise = (async () => {
        await this.initOrder()
        await this.syncCart()
        this.cartReady = !!this.orderId
      })()
      try {
        await this.cartInitPromise
      } finally {
        this.cartInitPromise = null
      }
      if (!this.orderId) {
        throw new Error('购物车未就绪')
      }
      return this.orderId
    },
    async syncCart() {
      if (!this.orderId) {
        this.setCartMap({})
        return
      }
      const has = await orderApi.cartHas(this.aid)
      if (!has?.oid || Number(has.oid) !== this.orderId) {
        this.setCartMap({})
        return
      }
      const map = {}
      ;(has.dish || []).forEach((item) => {
        const dishId = Number(item.dishId)
        const food = this.findFood(dishId)
        const key = this.dishKey(dishId)
        const existing = map[key]
        if (existing) {
          existing.count += Number(item.count) || 0
          return
        }
        map[key] = {
          odid: Number(item.id),
          dishId,
          count: Number(item.count) || 0,
          price: food?.price || 0
        }
      })
      this.setCartMap(map)
    },
    async addFood(food) {
      if (this.cartBusy) return
      this.cartBusy = true
      try {
        await this.ensureCart()
        const dishId = Number(food.id)
        const key = this.dishKey(dishId)
        const current = this.cartMap[key]
        if (!current) {
          const odid = Number(await orderApi.dishAdd(this.orderId, dishId))
          if (!odid) {
            throw new Error('加购失败')
          }
          this.patchCartItem(dishId, {
            odid,
            dishId,
            count: 1,
            price: food.price
          })
        } else {
          await orderApi.dishInc(current.odid)
          this.patchCartItem(dishId, {
            ...current,
            count: current.count + 1
          })
        }
      } catch (e) {
        uni.showToast({ title: e.message || e || '加购失败', icon: 'none' })
        await this.syncCart()
      } finally {
        this.cartBusy = false
      }
    },
    async decFood(food) {
      if (this.cartBusy) return
      const dishId = Number(food.id)
      const key = this.dishKey(dishId)
      const current = this.cartMap[key]
      if (!current) return
      this.cartBusy = true
      try {
        await this.ensureCart()
        if (current.count <= 1) {
          await orderApi.dishDel(current.odid)
          this.patchCartItem(dishId, null)
        } else {
          await orderApi.dishDec(current.odid)
          this.patchCartItem(dishId, {
            ...current,
            count: current.count - 1
          })
        }
      } catch (e) {
        uni.showToast({ title: e.message || e || '操作失败', icon: 'none' })
        await this.syncCart()
      } finally {
        this.cartBusy = false
      }
    },
    async goConfirm() {
      if (!this.cartReady) {
        uni.showToast({ title: '购物车准备中，请稍候', icon: 'none' })
        return
      }
      if (this.cartItemCount === 0) {
        uni.showToast({ title: '请先选择菜品', icon: 'none' })
        return
      }
      try {
        await this.ensureCart()
        await this.syncCart()
        if (this.cartItemCount === 0) {
          uni.showToast({ title: '请先选择菜品', icon: 'none' })
          return
        }
        uni.setStorageSync('orderId', this.orderId)
        uni.navigateTo({ url: '/pages/cart/confirm' })
      } catch (e) {
        uni.showToast({ title: e.message || e || '购物车未就绪', icon: 'none' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.order-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-page;

  &__header {
    background: $bg-page;
    padding-bottom: 12rpx;
    flex-shrink: 0;
    border-bottom: 1rpx solid $divider-color;
  }

  &__nav-row {
    display: flex;
    align-items: center;
    padding: 0 24rpx;
    box-sizing: border-box;
  }

  &__back {
    display: flex;
    align-items: center;
    min-width: 120rpx;
    min-height: 64rpx;
    padding: 0 8rpx;
  }

  &__back:active {
    opacity: 0.7;
  }

  &__back-icon {
    color: $text-primary;
    font-size: 44rpx;
    font-weight: bold;
    line-height: 1;
    margin-right: 4rpx;
    margin-top: -4rpx;
  }

  &__back-text {
    color: $text-secondary;
    font-size: 28rpx;
    line-height: 1;
  }

  &__nav-title {
    flex: 1;
    text-align: center;
    font-size: 32rpx;
    font-weight: bold;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    padding: 0 16rpx;
  }

  &__nav-spacer {
    min-width: 120rpx;
  }

  &__mode-row {
    padding: 8rpx 24rpx 0;
  }

  &__mode-tag {
    display: inline-flex;
    padding: 6rpx 20rpx;
    border-radius: $radius-tag;
    background: $bg-surface;
    border: 1rpx solid $border-light;

    &--active {
      background: $brand-primary;
      border-color: $brand-primary;
    }
  }

  &__mode-text {
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__mode-tag--active &__mode-text {
    color: $text-white;
    font-weight: bold;
  }

  &__loading,
  &__empty {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    color: $text-tertiary;
    padding: 0 48rpx;
    text-align: center;
    line-height: 1.6;
    font-size: 26rpx;
  }

  &__main {
    flex: 1;
    display: flex;
    overflow: hidden;
    min-height: 0;
  }

  &__categories {
    width: 176rpx;
    height: 100%;
    background: $bg-gray;
    flex-shrink: 0;
  }

  &__category-item {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 32rpx 12rpx;
    transition: background $transition-fast;

    &--active {
      background: $bg-category-active;
    }
  }

  &__category-name {
    font-size: 24rpx;
    color: $text-secondary;
    text-align: center;
    line-height: 1.4;

    &--active {
      color: $text-primary;
      font-weight: bold;
    }
  }

  &__category-badge {
    position: absolute;
    top: 10rpx;
    right: 10rpx;
    min-width: 28rpx;
    height: 28rpx;
    line-height: 28rpx;
    padding: 0 6rpx;
    border-radius: 14rpx;
    background: $brand-red;
    color: $text-white;
    font-size: 18rpx;
    text-align: center;
  }

  &__dishes {
    flex: 1;
    height: 100%;
    background: $bg-page;
  }

  &__dish-list {
    padding: 16rpx 16rpx 8rpx;
  }

  &__dish-empty {
    padding: 80rpx 24rpx;
    text-align: center;
    color: $text-tertiary;
    font-size: 26rpx;
  }
}

.menu-card {
  display: flex;
  padding: 20rpx;
  margin-bottom: 16rpx;
  background: $bg-surface;
  border-radius: $radius-card;
  box-shadow: $shadow-card;

  &__image-wrap {
    position: relative;
    width: 200rpx;
    height: 150rpx;
    flex-shrink: 0;
    border-radius: $radius-sm;
    overflow: hidden;
  }

  &__image {
    width: 100%;
    height: 100%;
  }

  &__tag {
    position: absolute;
    top: 0;
    left: 0;
    padding: 4rpx 12rpx;
    background: $brand-red;
    border-radius: 0 0 $radius-sm 0;
  }

  &__tag-text {
    font-size: 18rpx;
    color: $text-white;
    font-weight: bold;
  }

  &__info {
    flex: 1;
    margin-left: 20rpx;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-height: 150rpx;
    overflow: hidden;
  }

  &__name {
    font-size: $font-size-base;
    font-weight: bold;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__desc {
    font-size: $font-size-desc;
    color: $text-desc;
    margin-top: 8rpx;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    line-height: 1.4;
  }

  &__bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 12rpx;
  }

  &__price {
    color: $text-price;
    font-size: $font-size-price;
    font-weight: bold;
  }

  &__actions {
    display: flex;
    align-items: center;
  }

  &__btn {
    width: 52rpx;
    height: 52rpx;
    border-radius: 50%;
    border: 1rpx solid $border-light;
    background: $bg-surface;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background $transition-fast;

    &:active {
      background: $bg-category-active;
    }

    &--disabled {
      opacity: 0.5;
    }
  }

  &__btn-icon {
    color: $text-secondary;
    font-size: 32rpx;
    font-weight: bold;
    line-height: 1;

    &--plus {
      color: $brand-primary;
    }
  }

  &__count {
    min-width: 48rpx;
    text-align: center;
    font-size: 28rpx;
    font-weight: bold;
    color: $text-primary;
  }
}

.cart-bar {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 24rpx;
  background: $bg-surface;
  border-top: 1rpx solid $divider-color;

  &--disabled {
    opacity: 0.85;
  }

  &__left {
    display: flex;
    align-items: center;
    flex: 1;
    overflow: hidden;
  }

  &__icon-wrap {
    position: relative;
    width: 72rpx;
    height: 72rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  &__icon {
    font-size: 44rpx;
  }

  &__badge {
    position: absolute;
    top: 0;
    right: 0;
    min-width: 32rpx;
    height: 32rpx;
    background: $brand-red;
    border-radius: 16rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 6rpx;
  }

  &__badge-text {
    color: $text-white;
    font-size: 20rpx;
    font-weight: bold;
  }

  &__price-wrap {
    margin-left: 12rpx;
    display: flex;
    align-items: baseline;
    overflow: hidden;
  }

  &__label {
    font-size: 24rpx;
    color: $text-secondary;
    margin-right: 8rpx;
  }

  &__price {
    color: $text-price;
    font-size: 36rpx;
    font-weight: bold;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  &__btn {
    flex-shrink: 0;
    min-width: 200rpx;
    height: 80rpx;
    padding: 0 48rpx;
    background: $brand-primary;
    border-radius: $radius-btn;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 24rpx;
    transition: background $transition-fast;

    &:active {
      background: $brand-primary-press;
    }

    &--disabled {
      background: #CCCCCC;
    }
  }

  &__btn-text {
    color: $text-white;
    font-size: $font-size-btn;
    font-weight: bold;
  }
}
</style>
