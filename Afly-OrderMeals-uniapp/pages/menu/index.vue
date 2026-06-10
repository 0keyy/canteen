<template>
  <view class="order-page">
    <view class="order-page__header" :style="headerPaddingStyle">
      <view class="order-page__search-row" :style="searchRowStyle">
        <view class="order-page__search" @tap.stop="goSearch">
          <view class="order-page__search-icon"></view>
          <text class="order-page__search-text">点击搜索</text>
        </view>
      </view>

      <view class="order-page__store-row">
        <view class="order-page__store-info">
          <view class="order-page__store-name-row">
            <view class="order-page__store-star"></view>
            <text class="order-page__store-name">{{ shopName }}</text>
            <text class="order-page__store-arrow">›</text>
          </view>
          <view class="order-page__store-distance">
            <view class="order-page__pin-icon"></view>
            <text class="order-page__distance-text">{{ distanceText }}</text>
          </view>
        </view>
        <view class="order-page__mode-switch">
          <view
            :class="['order-page__mode-btn', diningMode === 1 ? 'order-page__mode-btn--active' : '']"
            @tap="switchMode(1)"
          >
            <text class="order-page__mode-btn-text">自取</text>
          </view>
          <view
            :class="[
              'order-page__mode-btn',
              diningMode === 3 ? 'order-page__mode-btn--active' : '',
              shop && shop.deliveryEnable !== 1 ? 'order-page__mode-btn--disabled' : ''
            ]"
            @tap="switchMode(3)"
          >
            <text class="order-page__mode-btn-text">外卖</text>
          </view>
        </view>
      </view>

      <view class="order-page__notice">
        <view class="order-page__notice-left">
          <view class="order-page__bell-icon"></view>
          <text class="order-page__notice-text">欢迎光临，很高兴为您服务</text>
        </view>
        <text class="order-page__notice-more">门店信息⌄</text>
      </view>
    </view>

    <view v-if="loading" class="order-page__loading">加载中...</view>
    <view v-else-if="menu.length === 0" class="order-page__empty">暂无菜品，请先在后台添加菜品分类和菜品</view>
    <view v-else class="order-page__main">
      <menu-category-sidebar
        :menu="menu"
        :active-index="activeIndex"
        :cart-map="cartMap"
        @select="selectCategory"
      />

      <scroll-view scroll-y class="order-page__dishes" :show-scrollbar="false">
        <text class="order-page__section-title">{{ currentCategoryName }}</text>
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
                    @tap.stop="decFood(food)"
                  >
                    <text class="menu-card__btn-icon">−</text>
                  </view>
                  <text class="menu-card__count" v-if="getCount(food.id) > 0">{{ getCount(food.id) }}</text>
                  <view
                    class="menu-card__btn menu-card__btn--plus"
                    :class="{ 'menu-card__btn--disabled': cartBusy }"
                    @tap.stop="addFood(food)"
                  >
                    <text class="menu-card__btn-icon menu-card__btn-icon--plus">+</text>
                  </view>
                </view>
              </view>
            </view>
          </view>
        </view>
        <view v-if="currentFoods.length === 0" class="order-page__dish-empty">该分类暂无菜品</view>
        <view class="order-page__dish-bottom-space"></view>
      </scroll-view>
    </view>

    <view
      class="cart-bar"
      :class="{ 'cart-bar--disabled': !cartReady || cartItemCount === 0 }"
      @tap="goConfirm"
    >
      <view class="cart-bar__bag">
        <view class="cart-bar__bag-icon"></view>
        <view class="cart-bar__badge" v-if="cartItemCount > 0">
          <text class="cart-bar__badge-text">{{ cartItemCount }}</text>
        </view>
      </view>
      <text class="cart-bar__price">{{ cartSummary }}</text>
      <view
        class="cart-bar__btn"
        :class="{ 'cart-bar__btn--disabled': !cartReady || cartItemCount === 0 }"
      >
        <text class="cart-bar__btn-text">去结算</text>
      </view>
    </view>

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
  </view>
</template>

<script>
import { orderApi } from '../../api/index'
import { DEFAULT_SHOP_ID } from '../../utils/config'
import { resolveImageUrl } from '../../utils/image'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getMenuButtonMarginRight, getNavMetrics } from '../../utils/navbar'

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      navMetrics: getNavMetrics(),
      menuButtonRight: 96,
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
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` }
    },
    searchRowStyle() {
      return { paddingRight: `${this.menuButtonRight}px` }
    },
    shopName() {
      return this.shop?.name || '粮兴坊'
    },
    distanceText() {
      if (this.shop?.distance) return `距离您${this.shop.distance}km`
      return '欢迎到店用餐'
    },
    currentFoods() {
      return this.menu[this.activeIndex]?.foods || []
    },
    currentCategoryName() {
      return this.menu[this.activeIndex]?.name || '推荐'
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
      if (!this.cartReady) return '¥0.00'
      if (this.cartItemCount === 0) return '¥0.00'
      return `¥ ${this.totalPrice}`
    }
  },
  onLoad() {
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    this.updateNavPadding()
    this.loadShop()
    this.bootstrap()
  },
  onShow() {
    this.updateNavPadding()
    this.setupTabbar(1)
    const mode = Number(uni.getStorageSync('diningMode') || 1)
    if (mode !== this.diningMode) {
      this.diningMode = mode
      this.bootstrap()
      return
    }
    if (!this.loading && this.cartReady) {
      this.syncCart()
    }
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = getNavMetrics()
      this.menuButtonRight = getMenuButtonMarginRight(96)
    },
    selectCategory(index) {
      this.activeIndex = index
    },
    goSearch() {
      uni.showToast({ title: '搜索功能开发中', icon: 'none' })
    },
    async switchMode(mode) {
      if (mode === this.diningMode) return
      if (mode === 3 && this.shop && this.shop.deliveryEnable !== 1) {
        uni.showToast({ title: '暂未开启外卖', icon: 'none' })
        return
      }
      uni.setStorageSync('diningMode', mode)
      this.diningMode = mode
      if (mode === 3) {
        uni.navigateTo({ url: '/pages/address/list?select=1' })
        return
      }
      await this.bootstrap()
    },
    async loadShop() {
      try {
        this.shop = await orderApi.shop(this.aid)
      } catch (e) {
        this.shop = null
      }
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
    flex-shrink: 0;
    padding: 0 24rpx 24rpx;
    background: $bg-surface;
    border-bottom: 1rpx solid $divider-color;
  }

  &__search-row {
    margin-bottom: 24rpx;
  }

  &__search {
    display: flex;
    align-items: center;
    height: 64rpx;
    padding: 0 24rpx;
    border: 1rpx solid $border-light;
    border-radius: 999rpx;
    background: $bg-surface;
  }

  &__search-icon {
    width: 28rpx;
    height: 28rpx;
    border: 3rpx solid $text-tertiary;
    border-radius: 50%;
    position: relative;
    flex-shrink: 0;
    margin-right: 12rpx;

    &::after {
      content: '';
      position: absolute;
      width: 10rpx;
      height: 3rpx;
      background: $text-tertiary;
      border-radius: 2rpx;
      bottom: -2rpx;
      right: -6rpx;
      transform: rotate(45deg);
    }
  }

  &__search-text {
    font-size: 24rpx;
    font-weight: 600;
    color: $text-secondary;
  }

  &__store-row {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 16rpx;
  }

  &__store-info {
    flex: 1;
    min-width: 0;
  }

  &__store-name-row {
    display: flex;
    align-items: center;
    gap: 8rpx;
  }

  &__store-star {
    width: 28rpx;
    height: 28rpx;
    position: relative;
    flex-shrink: 0;

    &::before {
      content: '★';
      color: $brand-primary;
      font-size: 28rpx;
      line-height: 1;
    }
  }

  &__store-name {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__store-arrow {
    font-size: 28rpx;
    color: $text-tertiary;
    flex-shrink: 0;
  }

  &__store-distance {
    display: flex;
    align-items: center;
    gap: 6rpx;
    margin-top: 8rpx;
  }

  &__pin-icon {
    width: 20rpx;
    height: 20rpx;
    border: 3rpx solid $text-tertiary;
    border-radius: 50% 50% 50% 0;
    transform: rotate(-45deg);
    flex-shrink: 0;
  }

  &__distance-text {
    font-size: 22rpx;
    color: $text-secondary;
  }

  &__mode-switch {
    display: grid;
    grid-template-columns: 1fr 1fr;
    width: 256rpx;
    flex-shrink: 0;
    padding: 4rpx;
    background: $bg-gray;
    border-radius: $radius-card;
  }

  &__mode-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 64rpx;
    border-radius: 24rpx;
    transition: background $transition-fast;

    &--active {
      background: $brand-primary;
      box-shadow: $shadow-sm;
    }

    &--disabled {
      opacity: 0.45;
    }
  }

  &__mode-btn-text {
    font-size: 26rpx;
    font-weight: 600;
    color: $text-secondary;
  }

  &__mode-btn--active &__mode-btn-text {
    color: $text-white;
  }

  &__notice {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 24rpx;
    padding: 16rpx 24rpx;
    background: $bg-gray;
    border-radius: $radius-card;
  }

  &__notice-left {
    display: flex;
    align-items: center;
    gap: 8rpx;
    flex: 1;
    min-width: 0;
  }

  &__bell-icon {
    width: 24rpx;
    height: 24rpx;
    border: 3rpx solid $brand-primary;
    border-radius: 4rpx 4rpx 2rpx 2rpx;
    position: relative;
    flex-shrink: 0;

    &::before {
      content: '';
      position: absolute;
      top: -8rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 8rpx;
      height: 8rpx;
      border: 3rpx solid $brand-primary;
      border-radius: 50%;
    }
  }

  &__notice-text {
    font-size: 22rpx;
    color: $text-secondary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__notice-more {
    font-size: 22rpx;
    color: $text-secondary;
    flex-shrink: 0;
    margin-left: 12rpx;
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

  &__dishes {
    flex: 1;
    height: 100%;
    background: $bg-surface;
    padding: 24rpx;
    box-sizing: border-box;
  }

  &__section-title {
    display: block;
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
    margin-bottom: 24rpx;
  }

  &__dish-list {
    display: flex;
    flex-direction: column;
    gap: 24rpx;
  }

  &__dish-empty {
    padding: 80rpx 24rpx;
    text-align: center;
    color: $text-tertiary;
    font-size: 26rpx;
  }

  &__dish-bottom-space {
    height: calc(140rpx + #{$tabbar-height});
  }
}

.menu-card {
  display: flex;
  padding: 16rpx;
  background: $bg-surface;
  border-radius: $radius-card;

  &__image-wrap {
    position: relative;
    width: 176rpx;
    height: 132rpx;
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
    margin-left: 16rpx;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-height: 132rpx;
    overflow: hidden;
  }

  &__name {
    font-size: $font-size-base;
    font-weight: 900;
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
    font-weight: 900;
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
  position: fixed;
  left: 32rpx;
  right: 32rpx;
  bottom: calc(#{$tabbar-height} + 12rpx);
  z-index: 99;
  display: flex;
  align-items: center;
  gap: 24rpx;
  padding: 16rpx 16rpx 16rpx 24rpx;
  background: $text-primary;
  border-radius: 999rpx;
  box-shadow: $shadow-hero;

  &--disabled {
    opacity: 0.75;
  }

  &__bag {
    position: relative;
    width: 96rpx;
    height: 96rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: rgba(255, 252, 248, 0.1);
    flex-shrink: 0;
  }

  &__bag-icon {
    width: 40rpx;
    height: 36rpx;
    border: 3rpx solid $text-white;
    border-radius: 8rpx 8rpx 12rpx 12rpx;
    position: relative;

    &::before {
      content: '';
      position: absolute;
      top: -10rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 20rpx;
      height: 10rpx;
      border: 3rpx solid $text-white;
      border-bottom: none;
      border-radius: 10rpx 10rpx 0 0;
    }
  }

  &__badge {
    position: absolute;
    top: 0;
    right: 0;
    min-width: 36rpx;
    height: 36rpx;
    background: $brand-primary;
    border-radius: 18rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 8rpx;
  }

  &__badge-text {
    color: $text-white;
    font-size: 20rpx;
    font-weight: bold;
  }

  &__price {
    flex: 1;
    color: $text-white;
    font-size: 40rpx;
    font-weight: 900;
  }

  &__btn {
    flex-shrink: 0;
    height: 96rpx;
    padding: 0 56rpx;
    background: $brand-primary;
    border-radius: 999rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__btn--disabled {
    background: #666666;
  }

  &__btn-text {
    color: $text-white;
    font-size: 32rpx;
    font-weight: 900;
  }
}
</style>
