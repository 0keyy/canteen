<template>
  <view class="order-page">
    <view class="order-page__header" :style="headerPaddingStyle">
      <view class="order-page__back-btn" @tap="goBack">
        <text class="order-page__back-icon">‹</text>
      </view>
      <!-- 轮播图 -->
      <view class="order-page__banner" v-if="displayBanners.length">
        <swiper
          class="order-page__swiper"
          :autoplay="displayBanners.length > 1"
          :circular="displayBanners.length > 1"
          :interval="4000"
          :duration="500"
        >
          <swiper-item v-for="(banner, idx) in displayBanners" :key="idx" class="order-page__swiper-item">
            <image :src="banner.image" class="order-page__banner-image" mode="aspectFit" />
          </swiper-item>
        </swiper>
      </view>
      
      <view class="order-page__store-card">
        <view class="order-page__store-info">
          <text class="order-page__store-open">{{ shopName }}正在营业中</text>
          <text class="order-page__store-time">营业时间：6:00-22:00</text>
        </view>
        <view class="order-page__mode-board" @tap="toggleMode">
          <image class="order-page__mode-board-bg" :src="staticImgPrefix + '/tabbar/矢量 38.png'" mode="aspectFit" />
          <text class="order-page__mode-board-text">{{ diningMode === 3 ? '外卖' : '自取' }}</text>
        </view>
      </view>
    </view>

    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
    <view v-if="loading" class="order-page__loading">加载中...</view>
    <view v-else-if="menu.length === 0" class="order-page__empty">暂无菜品，请先在后台添加菜品分类和菜品</view>
    <view v-else class="order-page__main">
      <view class="order-page__sidebar-wrap">
        <!-- 侧边独立滚动，与菜品区完全隔离 -->
        <scroll-view 
          scroll-y 
          class="sidebar-scroll" 
          :show-scrollbar="false"
          scroll-with-animation
          enhanced
        >
          <menu-category-sidebar
            :menu="menu"
            :active-index="activeIndex"
            :cart-map="cartMap"
            @select="selectCategory"
          />
          <!-- 底部留白避开购物车+底部tab遮挡 -->
          <view class="sidebar-bottom-space"></view>
        </scroll-view>
      </view>

      <!-- 菜品区独立滚动，内容少时原生自动禁止滑动 -->
      <scroll-view 
        scroll-y 
        class="order-page__dishes" 
        :show-scrollbar="false"
        scroll-with-animation
        enhanced
      >
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
                    :class="{ 'menu-card__btn--disabled': cartBusy || !cartReady }"
                    @tap.stop="decFood(food)"
                  >
                    <text class="menu-card__btn-icon">−</text>
                  </view>
                  <text class="menu-card__count" v-if="getCount(food.id) > 0">{{ getCount(food.id) }}</text>
                  <view
                    class="menu-card__btn menu-card__btn--plus"
                    :class="{ 'menu-card__btn--disabled': cartBusy || !cartReady }"
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
      <view class="cart-bar__bag" @tap.stop="openCart">
        <image class="cart-bar__person" :src="staticImgPrefix + '/点赞.png'" mode="aspectFit" />
        <view class="cart-bar__badge" v-if="cartItemCount > 0">
          <text class="cart-bar__badge-text">{{ cartItemCount }}</text>
        </view>
      </view>
      <text class="cart-bar__price">{{ cartSummary }}</text>
      <view class="cart-bar__btn"
        :class="{ 'cart-bar__btn--disabled': !cartReady || cartItemCount === 0 }"
      >
        <text class="cart-bar__btn-text">去结算</text>
      </view>
    </view>

    <!-- 购物车弹窗遮罩 -->
    <view class="cart-mask" v-if="showCartPopup" @tap="closeCart"></view>
    
    <!-- 购物车弹窗 -->
    <view class="cart-popup" v-if="showCartPopup">
      <view class="cart-popup__header">
        <text class="cart-popup__title">购物车</text>
        <text class="cart-popup__clear" @tap="clearCart">清空购物车</text>
      </view>
      <scroll-view scroll-y class="cart-popup__content">
        <view v-if="cartList.length === 0" class="cart-popup__empty">
          <text>购物车是空的</text>
        </view>
        <view v-for="item in cartList" :key="item.odid" class="cart-popup__item">
          <image :src="item.food.image" class="cart-popup__image" mode="aspectFit" />
          <view class="cart-popup__info">
            <text class="cart-popup__name">{{ item.food.name }}</text>
            <text class="cart-popup__price">¥{{ item.price }}</text>
          </view>
          <view class="cart-popup__quantity">
            <view class="cart-popup__btn cart-popup__btn--minus" @tap="decFood(item.food)">
              <text>-</text>
            </view>
            <text class="cart-popup__count">{{ item.count }}</text>
            <view class="cart-popup__btn cart-popup__btn--plus" @tap="addFood(item.food)">
              <text>+</text>
            </view>
          </view>
        </view>
      </scroll-view>
      <view class="cart-popup__footer">
        <view class="cart-popup__total">
          <text class="cart-popup__total-label">合计：</text>
          <text class="cart-popup__total-price">¥{{ totalPrice }}</text>
        </view>
        <view 
          class="cart-popup__submit" 
          :class="{ 'cart-popup__submit--disabled': cartItemCount === 0 }"
          @tap="goConfirm"
        >
          <text>去结算</text>
        </view>
      </view>
    </view>

    <!-- 清空购物车确认弹窗遮罩 -->
    <view class="clear-mask" v-if="showClearConfirm"></view>
    
    <!-- 清空购物车确认弹窗 -->
    <view class="clear-confirm" v-if="showClearConfirm">
      <text class="clear-confirm__title">清空购物车？</text>
      <view class="clear-confirm__actions">
        <view class="clear-confirm__btn clear-confirm__btn--cancel" @tap="showClearConfirm = false">
          <text>取消</text>
        </view>
        <view class="clear-confirm__btn clear-confirm__btn--confirm" @tap="confirmClearCart">
          <text>确定</text>
        </view>
      </view>
    </view>

    </view>
</template>

<script>
import { orderApi, decorateApi } from '../../api/index'
import { DEFAULT_SHOP_ID } from '../../utils/config'
import { resolveImageUrl, STATIC_IMAGE_PREFIX } from '../../utils/image'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getMenuButtonMarginRight, getNavMetrics } from '../../utils/navbar'
import PageLoading from '../../components/page-loading/page-loading.vue'
import MenuCategorySidebar from '../../components/menu-category-sidebar/menu-category-sidebar.vue'

export default {
  mixins: [tabbarPageMixin],
  components: { PageLoading, MenuCategorySidebar },
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
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
      pageLoading: false,
      pageLoadingTip: '',
      cartReady: false,
      cartBusy: false,
      cartInitPromise: null,
      banners: [],
      showCartPopup: false,
      showClearConfirm: false
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
    displayBanners() {
      if (this.banners.length) return this.banners
      return [{ image: this.staticImgPrefix + '/首页广告.png' }]
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
    },
    cartList() {
      return Object.values(this.cartMap).map((item) => {
        const food = this.findFood(item.dishId)
        return {
          ...item,
          food
        }
      }).filter(item => item.food)
    }
  },
  onLoad() {
    this.diningMode = Number(uni.getStorageSync('diningMode') || 1)
    this.updateNavPadding()
    this.loadShop()
    this.loadBanners()
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
    if (!this.loading && !this.cartBusy) {
      this.refreshCartState()
    }
  },
  methods: {
    goBack() {
      const pages = getCurrentPages()
      if (pages.length <= 1) {
        uni.switchTab({ url: '/pages/index/index' })
      } else {
        uni.navigateBack({ delta: 1 })
      }
    },
    openCart() {
      this.showCartPopup = true
    },
    closeCart() {
      this.showCartPopup = false
    },
    clearCart() {
      this.showClearConfirm = true
    },
    async confirmClearCart() {
      this.showClearConfirm = false
      if (!this.orderId || this.cartItemCount === 0) return
      try {
        await orderApi.toEmpty(this.orderId)
        await this.syncCart()
        uni.showToast({ title: '已清空购物车', icon: 'success' })
      } catch (e) {
        uni.showToast({ title: '清空失败', icon: 'none' })
      }
    },
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
    goToConfirm() {
      if (this.cartItemCount === 0) {
        uni.showToast({ title: '请先选择菜品', icon: 'none' })
        return
      }
      if (this.diningMode === 3) {
        const addr = uni.getStorageSync('selectedAddress')
        if (!addr) {
          uni.navigateTo({ url: '/pages/address/list?select=1' })
          return
        }
      }
      uni.navigateTo({ url: '/pages/cart/confirm' })
    },
    toggleMode() {
      const next = this.diningMode === 3 ? 1 : 3
      this.switchMode(next)
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
    async loadBanners() {
      try {
        const page = await decorateApi.page(1)
        const widgets = this.parsePageWidgets(page?.pageData)
        const bannerWidget = widgets.find((item) => item.name === 'banner')
        const data = bannerWidget?.content?.data
        if (bannerWidget && this.isWidgetEnabled(bannerWidget.content?.enabled) && Array.isArray(data)) {
          this.banners = data
            .map((item) => this.normalizeBannerItem(item))
            .filter(Boolean)
        } else {
          this.banners = []
        }
      } catch (e) {
        this.banners = []
      }
    },
    parsePageWidgets(pageData) {
      if (!pageData) return []
      if (Array.isArray(pageData)) return pageData
      try {
        const parsed = JSON.parse(pageData)
        return Array.isArray(parsed) ? parsed : []
      } catch (e) {
        return []
      }
    },
    isWidgetEnabled(enabled) {
      if (enabled === undefined || enabled === null) return true
      return enabled !== 0 && enabled !== false && enabled !== '0'
    },
    normalizeBannerItem(item) {
      const rawImage = item?.image || item?.img || item?.url || ''
      const image = resolveImageUrl(rawImage)
      return image ? { ...item, image } : null
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
    parseCartHasId(has) {
      if (!has) return null
      const id = has.oid ? Number(has.oid) : (has.id ? Number(has.id) : null)
      return id || null
    },
    isCartHasSubmitted(has) {
      if (!has) return false
      return !!(has.submitTime || (has.status !== undefined && Number(has.status) > 0))
    },
    parseCartHasItems(has) {
      if (!has) return []
      return has.dish || has.dishes || []
    },
    async bootstrap() {
      this.pageLoading = true
      this.pageLoadingTip = '加载中...'
      this.loading = true
      this.cartReady = false
      try {
        await this.loadMenu()
        await this.initCart()
      } catch (e) {
        this.cartReady = false
        console.error('菜单页加载失败:', e)
        uni.showToast({ title: e.message || e || '页面加载失败', icon: 'none', duration: 3000 })
      } finally {
        this.loading = false
        this.pageLoading = false
      }
    },
    async loadMenu() {
      const list = await orderApi.menu(this.aid)
      console.log('menu raw data type:', typeof list)
      console.log('menu raw count:', Array.isArray(list) ? list.length : 0)
      if (Array.isArray(list)) {
        console.log('menu raw names:', list.map(c => c.name).join(', '))
        list.forEach((c, i) => {
          const keys = Object.keys(c)
          console.log(`category ${i}: name=${c.name}, sort=${c.sort}, order=${c.order}, seq=${c.seq}, keys=${keys.join(',')}, foods=${(c.foods || []).length}, dishes=${(c.dishes || []).length}, items=${(c.items || []).length}`)
        })
      }
      this.menu = (Array.isArray(list) ? list : [])
        .sort((a, b) => {
          const sortA = Number(a.sort || a.order || a.seq || 0)
          const sortB = Number(b.sort || b.order || b.seq || 0)
          return sortA - sortB
        })
        .map((cate) => {
          const foods = cate.foods || cate.dishes || cate.items || []
          return {
            ...cate,
            foods: foods.map((food) => ({
              ...food,
              image: resolveImageUrl(food.image)
            }))
          }
        })
      console.log('menu after process:', JSON.stringify(this.menu.map(c => ({name: c.name, sort: c.sort, foodCount: (c.foods || []).length}))))
      this.activeIndex = 0
    },
    async initOrder() {
      const has = await orderApi.cartHas(this.aid)
      const existingId = this.parseCartHasId(has)
      const existingMode = has?.diningMode !== undefined ? Number(has.diningMode) : null
      const isSubmitted = this.isCartHasSubmitted(has)
      if (existingId && existingMode === this.diningMode && !isSubmitted) {
        this.orderId = existingId
        return
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
    async initCart() {
      if (this.cartInitPromise) {
        await this.cartInitPromise
        return
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
    },
    async refreshCartState() {
      if (this.cartInitPromise) {
        await this.cartInitPromise
        return
      }
      try {
        const has = await orderApi.cartHas(this.aid)
        const activeCartId = this.parseCartHasId(has)
        const isSubmitted = this.isCartHasSubmitted(has)
        const validCartId = activeCartId && !isSubmitted ? activeCartId : null

        if (!validCartId) {
          if (this.orderId) {
            this.orderId = 0
            this.setCartMap({})
          }
          await this.initCart()
          return
        }

        if (this.orderId !== validCartId) {
          this.orderId = validCartId
        }
        await this.syncCart()
        this.cartReady = true
      } catch (e) {
        console.error('购物车刷新失败:', e)
      }
    },
    async ensureCart() {
      if (this.cartInitPromise) {
        await this.cartInitPromise
      }
      if (!this.cartReady || !this.orderId) {
        await this.initCart()
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
      const hasId = this.parseCartHasId(has)
      if (!hasId || hasId !== this.orderId || this.isCartHasSubmitted(has)) {
        this.setCartMap({})
        return
      }
      const items = this.parseCartHasItems(has)
      const map = {}
      items.forEach((item) => {
        const dishId = Number(item.dishId)
        const food = this.findFood(dishId)
        const key = this.dishKey(dishId)
        const count = Number(item.count || item.quantity) || 0
        const existing = map[key]
        if (existing) {
          existing.count += count
          return
        }
        map[key] = {
          odid: Number(item.id),
          dishId,
          count,
          price: food?.price || 0
        }
      })
      this.setCartMap(map)
    },
    async addFood(food, _isRetry = false) {
      if (this.cartBusy || !this.cartReady) return
      this.cartBusy = true
      try {
        await this.ensureCart()
        const dishId = Number(food.id)
        const key = this.dishKey(dishId)
        const current = this.cartMap[key]
        if (!current) {
          await orderApi.dishAdd(this.orderId, dishId)
        } else {
          await orderApi.dishInc(current.odid)
        }
        await this.syncCart()
      } catch (e) {
        const errMsg = e.message || String(e) || ''
        if (!_isRetry && (errMsg.includes('不可用') || errMsg.includes('购物车'))) {
          this.orderId = 0
          this.cartReady = false
          this.cartBusy = false
          return this.addFood(food, true)
        }
        if (errMsg === '成功' || errMsg.includes('操作成功')) {
          await this.syncCart()
          return
        }
        uni.showToast({ title: errMsg || '加购失败', icon: 'none' })
        await this.syncCart()
      } finally {
        this.cartBusy = false
      }
    },
    async decFood(food, _isRetry = false) {
      if (this.cartBusy || !this.cartReady) return
      const dishId = Number(food.id)
      const key = this.dishKey(dishId)
      const current = this.cartMap[key]
      if (!current) return
      this.cartBusy = true
      try {
        await this.ensureCart()
        if (current.count <= 1) {
          await orderApi.dishDel(current.odid)
        } else {
          await orderApi.dishDec(current.odid)
        }
        await this.syncCart()
      } catch (e) {
        const errMsg = e.message || String(e) || ''
        if (!_isRetry && (errMsg.includes('不可用') || errMsg.includes('购物车'))) {
          this.orderId = 0
          this.cartReady = false
          this.cartBusy = false
          return this.decFood(food, true)
        }
        if (errMsg === '成功' || errMsg.includes('操作成功')) {
          await this.syncCart()
          return
        }
        uni.showToast({ title: errMsg || '操作失败', icon: 'none' })
        await this.syncCart()
      } finally {
        this.cartBusy = false
      }
    },
    async goConfirm() {
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
/* 核心修复：禁止页面全局滚动，解决左右联动滑动 */
page {
  height: 100%;
  overflow: hidden;
}
.order-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-page;

  &__header {
    flex-shrink: 0;
    position: relative;
    padding: 0;
    background: transparent;
    overflow: hidden;
    border-bottom: none;
	margin-top: -62px;
  }

  &__back-btn {
    position: absolute;
    left: 20rpx;
    top: 170rpx;
    z-index: 10;
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 80rpx;
    color: #FFFFFF;
    font-weight: 300;
    line-height: 1;
  }

 
  &__banner {
    flex-shrink: 0;
    position: relative;
    z-index: 2;
    padding: 0;
    margin: 0;
  }

  &__swiper {
    width: 100%;
    height: 630rpx;
    border-radius: 0;
    overflow: hidden;
  }

  &__swiper-item {
    width: 100%;
    height: 630rpx;
  }

  &__banner-image {
    width: 100%;
    height: 630rpx;
    display: block;
    border-radius: 0;
  }

  &__brand-hero {
    position: relative;
    z-index: 2;
    display: flex;
    align-items: flex-end;
    justify-content: flex-end;
    margin: 0 -24rpx;
    height: 230rpx;
    padding: 0 58rpx 0 24rpx;
    box-sizing: border-box;
    overflow: hidden;
    background: linear-gradient(180deg, #F78D94 0%, #E84D58 100%);
  }

  &__brand-hero::before {
    content: '惠';
    position: absolute;
    left: 30rpx;
    top: -18rpx;
    font-size: 150rpx;
    line-height: 1;
    color: rgba(255, 255, 255, 0.18);
    font-weight: 900;
  }

  &__brand-copy {
    position: relative;
    z-index: 2;
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  &__brand-name {
    font-size: 48rpx;
    color: $brand-primary;
    line-height: 1.1;
    font-weight: 500;
  }

  &__brand-slogan {
    margin-top: 18rpx;
    font-size: 54rpx;
    line-height: 1.1;
    color: #FFFFFF;
    font-weight: 900;
  }

  &__brand-bg-person {
    position: relative;
    z-index: 1;
    width: 190rpx;
    height: 222rpx;
    opacity: 0.92;
    flex-shrink: 0;
  }

  &__store-card {
    position: absolute;
    z-index: 4;
    bottom: -10rpx;
    left: 0;
    right: 0;
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 126rpx;
    padding: 22rpx 54rpx 22rpx 34rpx;
    background: #FEFCF8;
    border-radius: 18rpx 18rpx 0 0;
  }

  &__store-info {
    flex: 1;
    min-width: 0;
  }

  &__store-open {
    display: block;
    font-size: 32rpx;
    color: #111111;
    font-weight: 900;
  }

  &__store-time {
    display: block;
    margin-top: 8rpx;
    font-size: 18rpx;
    color: #999999;
  }

  &__mode-board {
    position: relative;
    width: 122rpx;
    height: 110rpx;
    flex-shrink: 0;
    margin-top: -10rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__mode-board-bg {
    position: absolute;
    inset: 0;
    width: 122rpx;
    height: 110rpx;
  }

  &__mode-board-text {
    position: relative;
    z-index: 1;
    margin-top: 30rpx;
    font-size: 28rpx;
    color: #111111;
    font-weight: 900;
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
    align-items: stretch;
    overflow: hidden; /* 锁住主区域，内部滚动互不干扰 */
    min-height: 0;
  }

  &__sidebar-wrap {
    width: 172rpx;
    flex-shrink: 0;
    background: #f7f7f7;
    position: relative;
    height: 100%;
    overflow: hidden;
    .sidebar-scroll {
      height: 100%;
    }
  }
  .sidebar-bottom-space {
    height: 140rpx;
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
  left: 70rpx;
  right: 38rpx;
  bottom: 30rpx;
  z-index: 99;
  display: flex;
  align-items: center;
  gap: 16rpx;
  min-height: 88rpx;
  padding: 10rpx 18rpx 10rpx 58rpx;
  background: linear-gradient(90deg, #B80000 0%, #D00000 62%, #E33A30 100%);
  border-radius: 12rpx;
  box-shadow: 0 8rpx 20rpx rgba(208, 0, 0, 0.26);
  overflow: visible;

  &--disabled {
    background: #999999;
    box-shadow: none;
  }

  &__bag {
    position: relative;
    width: 100rpx;
    height: 112rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 0;
    background: transparent;
    flex-shrink: 0;
    margin-left: -50rpx;
    margin-top: -40rpx;
  }

  &__person {
    width: 1250rpx;
    height: 150rpx;
    display: block;
  }

  &__badge {
    position: absolute;
    top: 22rpx;
    right: 6rpx;
    min-width: 30rpx;
    height: 30rpx;
    background: #FF4A3D;
    border-radius: 15rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 6rpx;
    border: 2rpx solid #FFFFFF;
  }

  &__badge-text {
    color: $text-white;
    font-size: 20rpx;
    font-weight: bold;
  }

  &__price {
    flex: 1;
    color: $text-white;
    font-size: 42rpx;
    font-weight: 900;
  }

  &__btn {
    flex-shrink: 0;
    height: 76rpx;
    padding: 0 28rpx;
    background: transparent;
    border-radius: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__btn--disabled {
    background: transparent;
  }

  &__btn-text {
    color: $text-white;
    font-size: 28rpx;
    font-weight: 900;
  }
}

.cart-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 100;
}

.cart-popup {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background: #FFFFFF;
  border-radius: 32rpx 32rpx 0 0;
  z-index: 101;
  max-height: 70vh;
  display: flex;
  flex-direction: column;
  animation: slideUp 0.3s ease;

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 30rpx 32rpx;
    border-bottom: 1rpx solid #f0f0f0;
  }

  &__title {
    font-size: 36rpx;
    font-weight: 600;
    color: #333333;
  }

  &__clear {
    font-size: 28rpx;
    color: #999999;
  }

  &__content {
    flex: 1;
    padding: 20rpx 32rpx;
    overflow-y: auto;
  }

  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 200rpx;
    color: #999999;
    font-size: 28rpx;
  }

  &__item {
    display: flex;
    align-items: center;
    padding: 24rpx 0;
    border-bottom: 1rpx solid #f5f5f5;

    &:last-child {
      border-bottom: none;
    }
  }

  &__image {
    width: 160rpx;
    height: 160rpx;
    border-radius: 12rpx;
    flex-shrink: 0;
  }

  &__info {
    flex: 1;
    margin-left: 20rpx;
    min-width: 0;
  }

  &__name {
    display: block;
    font-size: 32rpx;
    color: #333333;
    font-weight: 600;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__price {
    display: block;
    font-size: 32rpx;
    color: #E33A30;
    font-weight: 900;
    margin-top: 8rpx;
  }

  &__quantity {
    display: flex;
    align-items: center;
    gap: 24rpx;
    flex-shrink: 0;
  }

  &__btn {
    width: 56rpx;
    height: 56rpx;
    border-radius: 50%;
    border: 2rpx solid #E33A30;
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 36rpx;
      color: #E33A30;
      font-weight: bold;
      line-height: 1;
    }

    &--minus {
      border-color: #999999;
      text {
        color: #999999;
      }
    }
  }

  &__count {
    font-size: 32rpx;
    color: #333333;
    font-weight: 600;
    min-width: 48rpx;
    text-align: center;
  }

  &__footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 24rpx 32rpx;
    padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
    background: #FFFFFF;
    border-top: 1rpx solid #f0f0f0;
  }

  &__total {
    display: flex;
    align-items: baseline;
  }

  &__total-label {
    font-size: 28rpx;
    color: #666666;
  }

  &__total-price {
    font-size: 44rpx;
    color: #E33A30;
    font-weight: 900;
    margin-left: 8rpx;
  }

  &__submit {
    height: 88rpx;
    padding: 0 48rpx;
    background: linear-gradient(90deg, #B80000 0%, #D00000 62%, #E33A30 100%);
    border-radius: 44rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      color: #FFFFFF;
      font-size: 32rpx;
      font-weight: 600;
    }

    &--disabled {
      background: #CCCCCC;
    }
  }
}

.clear-mask {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 102;
}

.clear-confirm {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background: #FFFFFF;
  border-radius: 24rpx;
  padding: 48rpx 64rpx;
  z-index: 103;
  min-width: 560rpx;

  &__title {
    display: block;
    text-align: center;
    font-size: 36rpx;
    color: #333333;
    font-weight: 600;
    margin-bottom: 48rpx;
  }

  &__actions {
    display: flex;
    border-top: 1rpx solid #f0f0f0;
  }

  &__btn {
    flex: 1;
    height: 96rpx;
    display: flex;
    align-items: center;
    justify-content: center;

    text {
      font-size: 32rpx;
    }

    &--cancel {
      border-right: 1rpx solid #f0f0f0;
      text {
        color: #999999;
      }
    }

    &--confirm {
      text {
        color: #E33A30;
        font-weight: 600;
      }
    }
  }
}

@keyframes slideUp {
  from {
    transform: translateY(100%);
  }
  to {
    transform: translateY(0);
  }
}
</style>