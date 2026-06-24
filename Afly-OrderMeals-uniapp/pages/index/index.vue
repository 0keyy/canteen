<template>
  <view class="home">
    <scroll-view class="home__content" scroll-y :show-scrollbar="false">
      <view class="home__scroll-inner">
        <!-- Hero 广告区 -->
        <view class="home__hero">
          <image class="home__hero-bg" src="/static/首页广告.png" mode="aspectFill" />
          <view class="home__hero-overlay" :style="heroPaddingStyle">
            <!-- 用户信息栏 -->
            <view class="home__user-bar">
              <text class="home__user-name">{{ nickname || '用户' }}</text>
              <view class="home__user-stats">
                <text class="home__user-stat">0 积分</text>
                <text class="home__user-stat">0 优惠券</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 就餐方式卡片 -->
        <view class="home__dining-section">
          <view class="home__dining-card" @tap="selectMode(1)">
            <text class="home__dining-name">到店堂食</text>
            <image class="home__dining-img" src="/static/图层 2.png" mode="aspectFit" />
          </view>
          <view class="home__dining-card" @tap="selectMode(3)">
            <text class="home__dining-name">外卖配送</text>
            <image class="home__dining-img" src="/static/小唐骑车.png" mode="aspectFit" />
          </view>
        </view>

        <!-- 快捷入口 -->
        <view class="home__shortcuts">
          <view class="home__shortcut-item" v-for="item in shortcuts" :key="item.name" @tap="onShortcutTap(item)">
            <view class="home__shortcut-icon-wrap">
              <image class="home__shortcut-icon" :src="item.icon" mode="aspectFit" />
            </view>
            <text class="home__shortcut-name">{{ item.name }}</text>
          </view>
        </view>

        <!-- 粮兴推荐 -->
        <view class="home__recommend">
          <view class="home__recommend-header">
            <view class="home__recommend-title-row">
              <text class="home__recommend-title">粮兴推荐</text>
              <text class="home__recommend-tag">限时优惠</text>
            </view>
          </view>

          <view class="home__dish-list" v-if="homeRecommendDishes.length">
            <view class="home__dish-item" v-for="dish in homeRecommendDishes" :key="dish.id" @tap="goMenu">
              <image class="home__dish-image" :src="dish.image" mode="aspectFill" />
              <view class="home__dish-info">
                <text class="home__dish-name">{{ dish.title }}</text>
                <text class="home__dish-desc">{{ dish.intro || '匠心制作，每日新鲜' }}</text>
                <view class="home__dish-bottom">
                  <text class="home__dish-price">¥{{ dish.price }}</text>
                  <view class="home__dish-btn" @tap.stop="goMenu">
                    <text class="home__dish-btn-text">立即下单</text>
                  </view>
                </view>
              </view>
            </view>
          </view>

          <view class="home__recommend-empty" v-if="!recommendLoading && homeRecommendDishes.length === 0">
            <text class="home__recommend-empty-text">暂无推荐菜品</text>
          </view>
        </view>

        <view class="home__bottom-space"></view>
      </view>
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
import { orderApi, decorateApi } from '../../api/index'
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
      shop: null,
      aid: DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      shortcuts: [
        { name: '充值中心', icon: '/static/tabbar/充值 1.png' },
        { name: '红包卡券', icon: '/static/tabbar/卡券 1.png' },
        { name: '订单详情', icon: '/static/tabbar/全部订单 1.png' },
        { name: '客服中心', icon: '/static/tabbar/客服 1.png' }
      ]
    }
  },
  computed: {
    nickname() {
      return uni.getStorageSync('nickname') || ''
    },
    heroPaddingStyle() {
      const { statusBarHeight } = this.navMetrics
      return { paddingTop: `${statusBarHeight + 8}px` }
    },
    homeRecommendDishes() {
      return this.recommendDishes.slice(0, 2)
    }
  },
  onLoad() { this.updateNavPadding() },
  onReady() { this.updateNavPadding() },
  onShow() {
    this.updateNavPadding()
    this.setupTabbar(0)
    this.loadPageContent()
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = getNavMetrics()
      this.menuButtonRight = getMenuButtonMarginRight(96)
    },
    async loadPageContent() {
      await this.loadShop()
      await this.loadDecoration()
      this.loadRecommend()
    },
    async loadShop() {
      try {
        const shop = await orderApi.shop(this.aid)
        if (shop?.image) shop.image = resolveImageUrl(shop.image)
        this.shop = shop
      } catch (e) {
        uni.showToast({ title: e.message || e, icon: 'none' })
      }
    },
    async loadDecoration() {
      try {
        const page = await decorateApi.page(1)
        const widgets = this.parsePageWidgets(page?.pageData)
        const bannerWidget = widgets.find((item) => item.name === 'banner')
        const data = bannerWidget?.content?.data
        if (bannerWidget && this.isWidgetEnabled(bannerWidget.content?.enabled) && Array.isArray(data)) {
          this.banners = data.map((item) => this.normalizeBannerItem(item)).filter(Boolean)
        }
      } catch (e) { this.banners = [] }
    },
    parsePageWidgets(pageData) {
      if (!pageData) return []
      if (Array.isArray(pageData)) return pageData
      try { const p = JSON.parse(pageData); return Array.isArray(p) ? p : [] } catch (e) { return [] }
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
    async loadRecommend() {
      this.recommendLoading = true
      try {
        const list = await orderApi.menu(this.aid)
        const foods = []
        ;(Array.isArray(list) ? list : []).forEach((cate) => {
          ;(cate.foods || []).forEach((food) => {
            foods.push({ ...food, image: resolveImageUrl(food.image) })
          })
        })
        this.recommendDishes = foods.slice(0, 5)
      } catch (e) { this.recommendDishes = [] }
      finally { this.recommendLoading = false }
    },
    selectMode(mode) {
      if (mode === 3 && this.shop && this.shop.deliveryEnable !== 1) {
        uni.showToast({ title: '暂未开启外卖', icon: 'none' })
        return
      }
      uni.setStorageSync('diningMode', mode)
      if (mode === 3) {
        uni.navigateTo({ url: '/pages/address/list?select=1' })
        return
      }
      uni.switchTab({ url: '/pages/menu/index' })
    },
    goMenu() {
      uni.setStorageSync('diningMode', 1)
      uni.switchTab({ url: '/pages/menu/index' })
    },
    onShortcutTap(item) {
      if (item?.name === '红包卡券') {
        uni.navigateTo({ url: '/pages/coupon/wallet' })
        return
      }
      if (item?.name === '订单详情') {
        uni.switchTab({ url: '/pages/order/list' })
        return
      }
      uni.showToast({ title: '功能开发中', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
$page-pad: 24rpx;

.home {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-page;

  &__content {
    flex: 1;
    background: $bg-page;
    overflow: hidden;
  }

  &__scroll-inner {
    box-sizing: border-box;
  }

  /* ===== Hero 广告区 ===== */
  &__hero {
    position: relative;
    color: $text-white;
    overflow: hidden;
	height:480rpx;
  }

  &__hero-bg {
    width: 100%;
    height: 520rpx;
    display: block;
  }

  &__hero-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
  }

  /* ===== 用户信息栏 ===== */
  &__user-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    background: linear-gradient(to right, #8b4a45, #3c120e);
    border-radius: 15rpx 15rpx 0 0;
    padding: 14rpx $page-pad;
    width: 90%;
	margin-left: 40rpx;
	height: 80rpx;
  }

  &__user-name {
    font-size: 24rpx;
    font-weight: 500;
    color: #ffd48b;
  }

  &__user-stats {
    display: flex;
    align-items: center;
    gap: 48rpx;
	
  }

  &__user-stat {
    font-size: 20rpx;
    color: rgba(255, 255, 255, 0.85);
  }

  /* ===== 就餐方式卡片 ===== */
  &__dining-section {
    display: flex;
    gap: 20rpx;
    padding: 24rpx $page-pad 0;
    margin-top: -4rpx;
  }

  &__dining-card {
    flex: 1;
	height: 220rpx;
    background: linear-gradient(to bottom, #f7afaa, #ffffff);
    border-radius: $radius-card;
    padding: 24rpx 16rpx 20rpx 24rpx;
    display: flex;
    flex-direction: row;
    align-items: flex-start;
    justify-content: space-between;
    box-shadow: 0 4rpx 20rpx rgba(196, 30, 58, 0.08);
    overflow: hidden;

    &:active {
      opacity: 0.92;
      transform: scale(0.98);
    }
  }

  &__dining-img {
    width: 200rpx;
    height: 150rpx;
    flex-shrink: 0;
  }

  &__dining-name {
    font-size: 34rpx;
    font-weight: 900;
    color: #000;
    letter-spacing: 2rpx;
    padding-top: 8rpx;
    white-space: nowrap;
  }

  /* ===== 快捷入口 ===== */
  &__shortcuts {
    display: flex;
    justify-content: space-around;
    padding: 36rpx 16rpx 0;
  }

  &__shortcut-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 10rpx;

    &:active {
      opacity: 0.88;
    }
  }

  &__shortcut-icon-wrap {
    width: 100rpx;
    height: 100rpx;
    background: rgba($brand-primary, 0.04);
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__shortcut-icon {
    width: 56rpx;
    height: 56rpx;
  }

  &__shortcut-name {
    font-size: 22rpx;
    color: $text-secondary;
    font-weight: 500;
  }

  /* ===== 粮兴推荐 ===== */
  &__recommend {
    padding: 36rpx $page-pad 0;
  }

  &__recommend-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20rpx;
  }

  &__recommend-title-row {
    display: flex;
    align-items: center;
    gap: 12rpx;
  }

  &__recommend-title {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__recommend-tag {
    font-size: 20rpx;
    font-weight: 600;
    color: #FFFFFF;
    background: #ffd880;
    border-radius: 0 99rpx 0 99rpx;
    padding: 4rpx 16rpx;
  }

  &__recommend-link {
    display: flex;
    align-items: center;
    gap: 4rpx;
  }

  &__recommend-link-text {
    font-size: 24rpx;
    color: $brand-primary;
    font-weight: 600;
  }

  &__recommend-link-arrow {
    font-size: 32rpx;
    color: $brand-primary;
    line-height: 1;
  }

  &__dish-list {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  &__dish-item {
	margin: 0px 8px;
    display: flex;
    align-items: center;
    gap: 24rpx;
    padding: 24rpx;
    background:#ffe8cd;
    border-radius: $radius-lg;
    box-shadow: $shadow-sm;

    &:active { opacity: 0.92; }
  }

  &__dish-image {
    width: 192rpx;
    height: 192rpx;
    border-radius: $radius-card;
    background: $bg-gray;
    flex-shrink: 0;
  }

  &__dish-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 8rpx;
  }

  &__dish-name {
    font-size: 30rpx;
    font-weight: 900;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__dish-desc {
    margin-top: 8rpx;
    font-size: 22rpx;
    color: $text-secondary;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    line-height: 1.5;
  }

  &__dish-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__dish-price {
    font-size: 36rpx;
    font-weight: 900;
    color: #000;
  }

  &__dish-btn {
    background: #be0000;
    border-radius: 999rpx;
    padding: 12rpx 32rpx;
  }

  &__dish-btn-text {
    font-size: 24rpx;
    color: $text-white;
    font-weight: 600;
    white-space: nowrap;
  }

  &__recommend-empty {
    padding: 60rpx 0 40rpx;
    text-align: center;
    background: $bg-surface;
    border-radius: $radius-card;
  }

  &__recommend-empty-text {
    font-size: 26rpx;
    color: $text-secondary;
  }

  &__bottom-space {
    height: $tabbar-height;
  }
}
</style>
