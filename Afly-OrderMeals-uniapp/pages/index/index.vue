<template>
  <view class="home">
    <scroll-view class="home__content" scroll-y :show-scrollbar="false">
      <view class="home__scroll-inner">
        <!-- 渐变顶栏：搜索 → 轮播 → 自提/外卖 -->
        <view class="home__hero">
          <view class="home__hero-inner" :style="heroPaddingStyle">
            <view class="home__nav-row" :style="searchRowStyle">
              <view class="home__search" @tap.stop="goSearch">
                <view class="home__search-icon"></view>
                <text class="home__search-text">点击搜索</text>
              </view>
            </view>
            <text class="home__slogan">食材当日现备 · 好滋味有温度 · 新鲜现做</text>

            <view class="home__banner-section">
              <view class="home__banner-wrap">
                <swiper
                  class="home__swiper"
                  :circular="displayBanners.length > 1"
                  :autoplay="displayBanners.length > 0"
                  :interval="4000"
                  :duration="600"
                  indicator-dots
                  indicator-color="rgba(255,255,255,0.45)"
                  indicator-active-color="#FFFFFF"
                >
                  <swiper-item
                    v-for="(item, index) in displayBanners"
                    :key="index"
                    class="home__swiper-item"
                  >
                    <image
                      v-if="item.image"
                      :src="item.image"
                      class="home__banner-image"
                      mode="aspectFill"
                    />
                    <view v-else class="home__banner-placeholder"></view>
                  </swiper-item>
                </swiper>
              </view>
            </view>

            <view class="home__primary-card">
              <view class="home__primary-item" @click="selectMode(1)">
                <view class="home__icon home__icon--store"></view>
                <text class="home__primary-name">自提</text>
                <text class="home__primary-desc">下单免排队</text>
              </view>
              <view class="home__primary-divider"></view>
              <view
                class="home__primary-item"
                :class="{ 'home__primary-item--disabled': shop && shop.deliveryEnable !== 1 }"
                @click="selectMode(3)"
              >
                <view class="home__icon home__icon--delivery"></view>
                <text class="home__primary-name">外卖</text>
                <text class="home__primary-desc">美味配送到家</text>
              </view>
            </view>
          </view>
        </view>

        <view class="home__sections">
          <view class="home__shortcut-row">
            <view
              class="home__shortcut-item"
              v-for="item in shortcuts"
              :key="item.name"
              @tap="onShortcutTap(item)"
            >
              <view class="home__icon" :class="item.iconClass"></view>
              <text class="home__shortcut-name">{{ item.name }}</text>
              <text class="home__shortcut-desc">{{ item.desc }}</text>
            </view>
          </view>

          <view class="home__recommend">
            <view class="home__recommend-header">
              <text class="home__recommend-title">招牌推荐</text>
              <view class="home__recommend-link" @tap="goMenu">
                <text class="home__recommend-link-text">去点单</text>
                <text class="home__recommend-link-arrow">›</text>
              </view>
            </view>

            <view class="home__dish-list" v-if="homeRecommendDishes.length">
              <view
                class="home__dish-item"
                v-for="dish in homeRecommendDishes"
                :key="dish.id"
                @tap="selectSpec(dish)"
              >
                <view class="home__dish-image-wrap">
                  <image class="home__dish-image" :src="dish.image" mode="aspectFill" />
                  <view class="home__dish-badge" v-if="dish.badge">
                    <text class="home__dish-badge-text">{{ dish.badge }}</text>
                  </view>
                </view>
                <view class="home__dish-info">
                  <text class="home__dish-name">{{ dish.title }}</text>
                  <text class="home__dish-desc">{{ dish.intro || '匠心制作，每日新鲜' }}</text>
                  <view class="home__dish-bottom">
                    <text class="home__dish-price">¥{{ dish.price }}</text>
                    <view class="home__dish-btn" @tap.stop="selectSpec(dish)">
                      <text class="home__dish-btn-text">选规格</text>
                    </view>
                  </view>
                </view>
              </view>
            </view>

            <view class="home__recommend-empty" v-if="!recommendLoading && homeRecommendDishes.length === 0">
              <text class="home__recommend-empty-text">暂无推荐菜品</text>
            </view>
          </view>

          <view class="home__promo" @tap="goCouponCenter">
            <view class="home__promo-icon home__icon home__icon--coupon"></view>
            <view class="home__promo-content">
              <text class="home__promo-sub">限时优惠</text>
              <text class="home__promo-title">领取优惠券，下单更优惠</text>
            </view>
            <text class="home__promo-arrow">›</text>
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
        { name: '积分商城', desc: '神秘好物等你来', iconClass: 'home__icon--points' },
        { name: '领券中心', desc: '限时领取优惠', iconClass: 'home__icon--coupon' },
        { name: '优惠券包', desc: '享多重优惠', iconClass: 'home__icon--wallet' }
      ]
    }
  },
  computed: {
    heroPaddingStyle() {
      const { statusBarHeight } = this.navMetrics
      return {
        paddingTop: `${statusBarHeight + 10}px`
      }
    },
    searchRowStyle() {
      return { paddingRight: `${this.menuButtonRight}px` }
    },
    displayBanners() {
      if (this.banners.length) return this.banners
      return [{ image: '' }]
    },
    homeRecommendDishes() {
      return this.recommendDishes.slice(0, 2)
    }
  },
  onLoad() {
    this.updateNavPadding()
  },
  onReady() {
    this.updateNavPadding()
  },
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
    async loadShop() {
      try {
        const shop = await orderApi.shop(this.aid)
        if (shop?.image) {
          shop.image = resolveImageUrl(shop.image)
        }
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
    async loadRecommend() {
      this.recommendLoading = true
      try {
        const list = await orderApi.menu(this.aid)
        const foods = []
        ;(Array.isArray(list) ? list : []).forEach((cate) => {
          ;(cate.foods || []).forEach((food) => {
            foods.push({
              ...food,
              image: resolveImageUrl(food.image)
            })
          })
        })
        this.recommendDishes = foods.slice(0, 5).map((food, index) => ({
          ...food,
          badge: index === 0 ? '招牌' : index === 1 ? '热卖' : ''
        }))
      } catch (e) {
        this.recommendDishes = []
      } finally {
        this.recommendLoading = false
      }
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
    selectSpec() {
      this.goMenu()
    },
    goSearch() {
      uni.showToast({ title: '搜索功能开发中', icon: 'none' })
    },
    onShortcutTap(item) {
      if (item?.name === '优惠券包') {
        uni.navigateTo({ url: '/pages/coupon/wallet' })
        return
      }
      if (item?.name === '领券中心') {
        uni.navigateTo({ url: '/pages/coupon/center' })
        return
      }
      uni.showToast({ title: '功能开发中', icon: 'none' })
    },
    goCouponCenter() {
      uni.navigateTo({ url: '/pages/coupon/center' })
    }
  }
}
</script>

<style lang="scss" scoped>
$page-pad: $spacing-page;
$section-gap: 20rpx;

.home {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: $bg-page;

  &__scroll-inner {
    box-sizing: border-box;
  }

  &__content {
    flex: 1;
    background: $bg-page;
    overflow: hidden;
  }

  /* ===== 顶部渐变区（对齐 HomeView 结构） ===== */
  &__hero {
    background: linear-gradient(180deg, $brand-primary 0%, $brand-orange-light 100%);
    color: $text-white;
  }

  &__hero-inner {
    padding: 0 $page-pad 24rpx;
    box-sizing: border-box;
  }

  &__nav-row {
    display: flex;
    align-items: center;
    margin-bottom: 12rpx;
  }

  &__search {
    flex: 1;
    display: flex;
    align-items: center;
    height: 56rpx;
    padding: 0 24rpx;
    background: rgba(255, 252, 248, 0.9);
    border-radius: 999rpx;
    box-sizing: border-box;
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
    color: $text-primary;
  }

  &__slogan {
    display: block;
    margin-bottom: 12rpx;
    font-size: 20rpx;
    color: rgba(255, 252, 248, 0.9);
    line-height: 1.4;
  }

  &__banner-section {
    margin-top: 12rpx;
  }

  &__banner-wrap {
    padding: 4rpx;
    border-radius: $radius-card;
    background: rgba(255, 252, 248, 0.15);
  }

  &__swiper {
    width: 100%;
    height: 280rpx;
    border-radius: 28rpx;
    overflow: hidden;
    background: linear-gradient(135deg, $brand-primary-dark 0%, $brand-primary 50%, $brand-orange-light 100%);
  }

  &__swiper-item {
    width: 100%;
    height: 280rpx;
  }

  &__banner-image {
    display: block;
    width: 100%;
    height: 280rpx;
  }

  &__banner-placeholder {
    width: 100%;
    height: 280rpx;
    background: linear-gradient(135deg, $brand-primary-dark 0%, $brand-primary 50%, $brand-orange-light 100%);
  }

  &__primary-card {
    display: flex;
    align-items: stretch;
    margin-top: 20rpx;
    background: $bg-surface;
    border: 4rpx solid rgba(255, 252, 248, 0.85);
    border-radius: $radius-card;
    overflow: hidden;
  }

  &__primary-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 4rpx;
    padding: 20rpx 16rpx;

    &:active {
      background: $bg-gray;
    }

    &--disabled {
      opacity: 0.45;
    }
  }

  &__primary-divider {
    width: 1rpx;
    align-self: stretch;
    background: $divider-color;
    margin: 24rpx 0;
  }

  &__primary-name {
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__primary-desc {
    font-size: 20rpx;
    color: $text-secondary;
  }

  /* ===== 内容区 ===== */
  &__sections {
    margin-top: -8rpx;
    padding: 0 $page-pad 16rpx;
    display: flex;
    flex-direction: column;
    gap: 24rpx;
  }

  &__shortcut-row {
    display: flex;
    gap: 16rpx;
  }

  &__shortcut-item {
    flex: 1;
    background: $bg-surface;
    border-radius: $radius-card;
    padding: 20rpx 12rpx 16rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: $shadow-sm;
    box-sizing: border-box;

    &:active {
      opacity: 0.88;
    }
  }

  &__shortcut-name {
    margin-top: 8rpx;
    font-size: 26rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__shortcut-desc {
    margin-top: 4rpx;
    font-size: 20rpx;
    color: $text-secondary;
    text-align: center;
    line-height: 1.35;
  }

  /* ===== 红色线描图标 ===== */
  &__icon {
    width: 48rpx;
    height: 48rpx;
    position: relative;
    box-sizing: border-box;

    &--store {
      border: 3rpx solid $brand-primary;
      border-radius: 8rpx;

      &::before {
        content: '';
        position: absolute;
        top: -14rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 0;
        border-left: 16rpx solid transparent;
        border-right: 16rpx solid transparent;
        border-bottom: 14rpx solid $brand-primary;
      }

      &::after {
        content: '';
        position: absolute;
        bottom: 10rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 20rpx;
        height: 20rpx;
        border: 3rpx solid $brand-primary;
        border-radius: 2rpx;
      }
    }

    &--delivery {
      border: 3rpx solid $brand-primary;
      border-radius: 8rpx 8rpx 4rpx 4rpx;
      margin-top: 4rpx;

      &::before {
        content: '';
        position: absolute;
        top: 14rpx;
        left: -10rpx;
        width: 14rpx;
        height: 14rpx;
        border: 3rpx solid $brand-primary;
        border-radius: 50%;
        background: transparent;
      }

      &::after {
        content: '';
        position: absolute;
        top: 14rpx;
        right: -10rpx;
        width: 14rpx;
        height: 14rpx;
        border: 3rpx solid $brand-primary;
        border-radius: 50%;
        background: transparent;
      }
    }

    &--points {
      border: 3rpx solid $brand-primary;
      border-radius: 50%;

      &::before {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -60%);
        width: 6rpx;
        height: 6rpx;
        background: $brand-primary;
        border-radius: 50%;
        box-shadow:
          -10rpx 6rpx 0 $brand-primary,
          10rpx 6rpx 0 $brand-primary,
          0 14rpx 0 $brand-primary;
      }
    }

    &--wallet {
      border: 3rpx solid $brand-primary;
      border-radius: 8rpx;

      &::before {
        content: '';
        position: absolute;
        top: -8rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 20rpx;
        height: 12rpx;
        border: 3rpx solid $brand-primary;
        border-bottom: none;
        border-radius: 8rpx 8rpx 0 0;
      }

      &::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 12rpx;
        height: 12rpx;
        border: 3rpx solid $brand-primary;
        border-radius: 50%;
      }
    }

    &--coupon {
      border: 3rpx dashed $brand-primary;
      border-radius: 6rpx;

      &::before,
      &::after {
        content: '';
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        width: 10rpx;
        height: 10rpx;
        background: $bg-surface;
        border: 3rpx solid $brand-primary;
        border-radius: 50%;
      }

      &::before {
        left: -8rpx;
      }

      &::after {
        right: -8rpx;
      }
    }
  }

  /* ===== 招牌推荐 ===== */
  &__recommend {
    padding-top: 0;
  }

  &__recommend-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 16rpx;
  }

  &__recommend-title {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__recommend-link {
    display: flex;
    align-items: center;
    gap: 4rpx;
    height: 56rpx;
    padding: 0 12rpx;
    border-radius: 999rpx;
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
    margin-top: -2rpx;
  }

  &__dish-list {
    display: flex;
    flex-direction: column;
    gap: 20rpx;
  }

  &__dish-item {
    display: flex;
    align-items: stretch;
    gap: 24rpx;
    padding: 24rpx;
    background: $bg-surface;
    border-radius: $radius-lg;
    box-shadow: $shadow-sm;

    &:active {
      opacity: 0.92;
    }
  }

  &__dish-image-wrap {
    position: relative;
    flex-shrink: 0;
  }

  &__dish-image {
    width: 192rpx;
    height: 192rpx;
    border-radius: $radius-card;
    background: $bg-gray;
  }

  &__dish-badge {
    position: absolute;
    top: 0;
    left: 0;
    background: $brand-primary;
    border-radius: $radius-card 0 12rpx 0;
    padding: 4rpx 14rpx;
  }

  &__dish-badge-text {
    font-size: 20rpx;
    color: $text-white;
    font-weight: 600;
  }

  &__dish-info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 4rpx 0;
  }

  &__dish-name {
    font-size: 32rpx;
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
    margin-top: 12rpx;
  }

  &__dish-price {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-price;
  }

  &__dish-btn {
    flex-shrink: 0;
    background: $brand-primary;
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
    box-shadow: $shadow-card;
  }

  &__recommend-empty-text {
    font-size: 26rpx;
    color: $text-secondary;
  }

  /* ===== 储值营销条 ===== */
  &__promo {
    display: flex;
    align-items: center;
    gap: 24rpx;
    padding: 24rpx;
    border-radius: $radius-card;
    background: linear-gradient(135deg, $text-primary 0%, $brand-primary 100%);
    box-shadow: $shadow-card;

    &:active {
      opacity: 0.92;
    }
  }

  &__promo-icon {
    flex-shrink: 0;
    border-color: rgba(255, 252, 248, 0.85) !important;

    &::before,
    &::after {
      border-color: rgba(255, 252, 248, 0.85) !important;
    }
  }

  &__promo-content {
    flex: 1;
    min-width: 0;
  }

  &__promo-sub {
    display: block;
    font-size: 24rpx;
    color: rgba(255, 252, 248, 0.8);
    line-height: 1.4;
  }

  &__promo-title {
    display: block;
    margin-top: 4rpx;
    font-size: 28rpx;
    font-weight: 900;
    color: $text-white;
    line-height: 1.35;
  }

  &__promo-arrow {
    flex-shrink: 0;
    font-size: 40rpx;
    color: $text-white;
    line-height: 1;
  }

  &__bottom-space {
    height: $tabbar-height;
  }
}
</style>
