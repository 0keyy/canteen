<template>
  <view class="order-page">
    <!-- ===== Header: red gradient ===== -->
    <view class="order-page__header" :style="headerPaddingStyle">
      <view class="order-page__brand-row">
        <image class="order-page__logo" src="/static/白logo.png" mode="aspectFit" />
        <image class="order-page__mascot" src="/static/点赞.png" mode="aspectFit" />
      </view>
      <text class="order-page__slogan">良心好食材</text>
      <view class="order-page__store-status">
        <text class="order-page__store-status-text">粮兴坊正在营业中</text>
        <text class="order-page__store-hours">营业时间: 6:00-22:00</text>
      </view>
      <!-- Hanging sign dining mode toggle -->
      <view class="order-page__mode-sign">
        <view class="order-page__mode-sign-rope"></view>
        <view class="order-page__mode-sign-board">
          <view
            :class="['order-page__mode-tab', diningMode === 1 ? 'order-page__mode-tab--active' : '']"
            @tap="switchMode(1)"
          >
            <text class="order-page__mode-tab-text">堂食</text>
          </view>
          <view
            :class="[
              'order-page__mode-tab',
              diningMode === 3 ? 'order-page__mode-tab--active' : '',
              shop && shop.deliveryEnable !== 1 ? 'order-page__mode-tab--disabled' : ''
            ]"
            @tap="switchMode(3)"
          >
            <text class="order-page__mode-tab-text">外卖</text>
          </view>
        </view>
      </view>
    </view>

    <!-- ===== Loading / Empty ===== -->
    <view v-if="loading" class="order-page__loading">加载中...</view>
    <view v-else-if="menu.length === 0" class="order-page__empty">暂无菜品，请先在后台添加菜品分类和菜品</view>

    <!-- ===== Main: sidebar + dishes ===== -->
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
            <image :src="food.image" class="menu-card__image" mode="aspectFill" />
            <view class="menu-card__info">
              <text class="menu-card__name">{{ food.title }}</text>
              <view class="menu-card__tags" v-if="foodTag(idx)">
                <text class="menu-card__tag">{{ foodTag(idx) }}</text>
              </view>
              <text class="menu-card__sales">月销{{ food.sales || 13 }}</text>
              <view class="menu-card__bottom">
                <text class="menu-card__price">¥{{ food.price }}</text>
                <view class="menu-card__actions">
                  <template v-if="getCount(food.id) > 0">
                    <view class="menu-card__btn menu-card__btn--minus" @tap.stop="decFood(food)">
                      <text class="menu-card__btn-icon">−</text>
                    </view>
                    <text class="menu-card__count">{{ getCount(food.id) }}</text>
                  </template>
                  <view
                    class="menu-card__spec-btn"
                    :class="{ 'menu-card__spec-btn--disabled': cartBusy }"
                    @tap.stop="addFood(food)"
                  >
                    <text class="menu-card__spec-btn-text">选规格</text>
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

    <!-- ===== Bottom Cart Bar ===== -->
    <view
      class="cart-bar"
      :class="{ 'cart-bar--disabled': !cartReady || cartItemCount === 0 }"
      @tap="goConfirm"
    >
      <view class="cart-bar__avatar-wrap">
        <image class="cart-bar__avatar" src="/static/新版小唐.png" mode="aspectFit" />
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

    <!-- ===== Bottom TabBar ===== -->
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
            :class="{ 'app-tab-icon--inactive': tabbarSelected !== index }"
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
      return `¥${this.totalPrice}`
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

  /* ===== Header ===== */
  &__header {
    flex-shrink: 0;
    padding: 0 32rpx 28rpx;
    background: linear-gradient(135deg, #C41E3A 0%, #E8364E 60%, #F05A6E 100%);
    position: relative;
    overflow: visible;
  }

  &__brand-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__logo {
    width: 160rpx;
    height: 64rpx;
  }

  &__mascot {
    width: 72rpx;
    height: 72rpx;
  }

  &__slogan {
    display: block;
    margin-top: 8rpx;
    font-size: 24rpx;
    font-weight: 600;
    color: $text-white;
    opacity: 0.9;
    letter-spacing: 4rpx;
  }

  &__store-status {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-top: 16rpx;
  }

  &__store-status-text {
    font-size: 22rpx;
    color: $text-white;
    opacity: 0.85;
  }

  &__store-hours {
    font-size: 22rpx;
    color: $text-white;
    opacity: 0.7;
  }

  /* Hanging sign toggle */
  &__mode-sign {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 20rpx;
  }

  &__mode-sign-rope {
    width: 4rpx;
    height: 24rpx;
    background: rgba(255, 255, 255, 0.5);
  }

  &__mode-sign-board {
    display: flex;
    align-items: center;
    background: $brand-yellow;
    border-radius: 12rpx;
    padding: 4rpx;
    box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.15);
    position: relative;

    &::before,
    &::after {
      content: '';
      position: absolute;
      top: -12rpx;
      width: 4rpx;
      height: 14rpx;
      background: rgba(255, 255, 255, 0.5);
    }

    &::before {
      left: 40rpx;
    }

    &::after {
      right: 40rpx;
    }
  }

  &__mode-tab {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 112rpx;
    height: 56rpx;
    border-radius: 8rpx;
    transition: background $transition-fast;

    &--active {
      background: $brand-primary;
      box-shadow: $shadow-sm;
    }

    &--disabled {
      opacity: 0.45;
    }
  }

  &__mode-tab-text {
    font-size: 26rpx;
    font-weight: 700;
    color: $text-primary;
  }

  &__mode-tab--active &__mode-tab-text {
    color: $text-white;
  }

  /* ===== Loading / Empty ===== */
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

  /* ===== Main content ===== */
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

/* ===== Menu Card ===== */
.menu-card {
  display: flex;
  padding: 16rpx;
  background: $bg-surface;
  border-radius: $radius-card;
  border: 1rpx solid $border-light;

  &__image {
    width: 176rpx;
    height: 176rpx;
    flex-shrink: 0;
    border-radius: $radius-sm;
  }

  &__info {
    flex: 1;
    margin-left: 20rpx;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    min-height: 176rpx;
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

  &__tags {
    margin-top: 8rpx;
  }

  &__tag {
    display: inline-block;
    padding: 2rpx 12rpx;
    font-size: 18rpx;
    font-weight: 600;
    color: $brand-primary;
    border: 1rpx solid $brand-primary;
    border-radius: $radius-tag;
    background: rgba($brand-primary, 0.06);
  }

  &__sales {
    font-size: $font-size-desc;
    color: $text-tertiary;
    margin-top: 6rpx;
  }

  &__bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 8rpx;
  }

  &__price {
    color: $brand-primary;
    font-size: $font-size-price;
    font-weight: 900;
  }

  &__actions {
    display: flex;
    align-items: center;
    gap: 8rpx;
  }

  &__btn {
    width: 44rpx;
    height: 44rpx;
    border-radius: 50%;
    border: 1rpx solid $border-light;
    background: $bg-surface;
    display: flex;
    align-items: center;
    justify-content: center;

    &--minus {
      border-color: $text-tertiary;
    }
  }

  &__btn-icon {
    color: $text-secondary;
    font-size: 28rpx;
    font-weight: bold;
    line-height: 1;
  }

  &__count {
    min-width: 36rpx;
    text-align: center;
    font-size: 26rpx;
    font-weight: bold;
    color: $text-primary;
  }

  &__spec-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 48rpx;
    padding: 0 20rpx;
    border: 2rpx solid $brand-primary;
    border-radius: $radius-btn;
    background: rgba($brand-primary, 0.04);

    &--disabled {
      opacity: 0.5;
    }
  }

  &__spec-btn-text {
    font-size: 22rpx;
    font-weight: 700;
    color: $brand-primary;
  }
}

/* ===== Cart Bar ===== */
.cart-bar {
  position: fixed;
  left: 32rpx;
  right: 32rpx;
  bottom: calc(#{$tabbar-height} + 12rpx);
  z-index: 99;
  display: flex;
  align-items: center;
  gap: 16rpx;
  padding: 12rpx 16rpx 12rpx 12rpx;
  background: $text-primary;
  border-radius: 999rpx;
  box-shadow: $shadow-hero;

  &--disabled {
    opacity: 0.75;
  }

  &__avatar-wrap {
    position: relative;
    width: 88rpx;
    height: 88rpx;
    flex-shrink: 0;
  }

  &__avatar {
    width: 88rpx;
    height: 88rpx;
    border-radius: 50%;
  }

  &__badge {
    position: absolute;
    top: -6rpx;
    right: -6rpx;
    min-width: 36rpx;
    height: 36rpx;
    background: $brand-primary;
    border-radius: 18rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 8rpx;
    border: 3rpx solid $text-primary;
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
    height: 80rpx;
    padding: 0 48rpx;
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
    font-size: 30rpx;
    font-weight: 900;
  }
}

/* ===== Bottom TabBar ===== */
.app-tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-around;
  height: $tabbar-height;
  padding-bottom: env(safe-area-inset-bottom);
  background: $bg-surface;
  border-top: 1rpx solid $divider-color;
}

.app-tab-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  flex: 1;
  gap: 4rpx;

  &--active {
    .app-tab-text {
      font-weight: 700;
    }
  }
}

.app-tab-icon-wrap {
  width: 48rpx;
  height: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.app-tab-icon {
  width: 44rpx;
  height: 44rpx;

  &--inactive {
    filter: grayscale(1) opacity(0.45);
  }
}

.app-tab-text {
  font-size: 20rpx;
  line-height: 1.2;
}
</style>
