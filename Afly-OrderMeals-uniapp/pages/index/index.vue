<template>
  <view class="home">
    <scroll-view class="home__content" scroll-y :show-scrollbar="false">
      <view class="home__scroll-inner">
        <view class="home__header" :style="headerStyle">
          <view class="home__store-bar" :style="storeBarStyle">
            <text class="home__store-name">{{ storeName }}</text>
          </view>
        </view>

        <view class="home__banner-section" v-if="bannerList.length">
        <swiper
          class="home__swiper"
          circular
          autoplay
          :interval="4000"
          :duration="600"
          indicator-dots
          indicator-color="rgba(255,255,255,0.5)"
          indicator-active-color="#FFFFFF"
        >
          <swiper-item v-for="(item, index) in bannerList" :key="index">
            <image :src="item.image" class="home__banner-image" mode="aspectFill" />
          </swiper-item>
        </swiper>
        </view>

        <view class="home__sections">
        <view class="home__primary-card">
          <view class="home__primary-item" @click="selectMode(1)">
            <view class="home__primary-icon-wrap">
              <text class="home__primary-icon">🏪</text>
            </view>
            <text class="home__primary-name">自提</text>
            <text class="home__primary-desc">下单免排队</text>
          </view>
          <view class="home__primary-divider"></view>
          <view
            class="home__primary-item"
            :class="{ 'home__primary-item--disabled': shop && shop.deliveryEnable !== 1 }"
            @click="selectMode(3)"
          >
            <view class="home__primary-icon-wrap">
              <text class="home__primary-icon">🚚</text>
            </view>
            <text class="home__primary-name">外卖</text>
            <text class="home__primary-desc">美味配送到家</text>
          </view>
        </view>

        <view class="home__shortcut-row">
          <view
            class="home__shortcut-item"
            v-for="item in shortcuts"
            :key="item.name"
            @tap="onShortcutTap(item)"
          >
            <view class="home__shortcut-icon-wrap">
              <text class="home__shortcut-icon">{{ item.icon }}</text>
            </view>
            <text class="home__shortcut-name">{{ item.name }}</text>
            <text class="home__shortcut-desc">{{ item.desc }}</text>
          </view>
        </view>

        <view class="home__recommend">
          <view class="home__recommend-header">
            <view class="home__recommend-title-wrap">
              <text class="home__recommend-title">招牌推荐</text>
              <view class="home__recommend-underline"></view>
            </view>
            <text class="home__recommend-link" @tap="goMenu">去点单 ></text>
          </view>

          <view
            class="home__dish-card"
            v-for="dish in recommendDishes"
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

          <view class="home__recommend-empty" v-if="!recommendLoading && recommendDishes.length === 0">
            <text class="home__recommend-empty-text">暂无推荐菜品</text>
          </view>
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
import { orderApi, decorateApi } from '../../api/index'
import { DEFAULT_SHOP_ID } from '../../utils/config'
import { resolveImageUrl } from '../../utils/image'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      navMetrics: getNavMetrics(),
      shop: null,
      aid: DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      shortcuts: [
        { name: '积分商城', desc: '神秘好物等你来', icon: '🛍️' },
        { name: '储值优惠', desc: '查看&绑定', icon: '🎁' },
        { name: '优惠券包', desc: '享多重优惠', icon: '🎫' }
      ]
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
    storeBarStyle() {
      return { height: `${this.navMetrics.navBarHeight}px` }
    },
    storeName() {
      return this.shop?.name || '粮兴坊'
    },
    bannerList() {
      if (this.banners.length) return this.banners
      if (this.shop?.image) return [{ image: this.shop.image }]
      return []
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
    this.loadShop()
    this.loadDecoration()
    this.loadRecommend()
  },
  methods: {
    updateNavPadding() {
      this.navMetrics = getNavMetrics()
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
        const widgets = JSON.parse(page?.pageData || '[]')
        const bannerWidget = widgets.find((item) => item.name === 'banner')
        if (bannerWidget?.content?.enabled === 1 && Array.isArray(bannerWidget.content.data)) {
          this.banners = bannerWidget.content.data
            .filter((item) => item.image)
            .map((item) => ({
              ...item,
              image: resolveImageUrl(item.image)
            }))
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
      uni.navigateTo({ url: '/pages/menu/index' })
    },
    goMenu() {
      uni.setStorageSync('diningMode', 1)
      uni.navigateTo({ url: '/pages/menu/index' })
    },
    selectSpec() {
      this.goMenu()
    },
    onShortcutTap() {
      uni.showToast({ title: '功能开发中', icon: 'none' })
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

  &__header {
    flex-shrink: 0;
  }

  &__store-bar {
    display: flex;
    align-items: center;
    padding: 0 $page-pad;
    box-sizing: border-box;
  }

  &__store-name {
    font-size: 34rpx;
    font-weight: bold;
    color: $brand-primary;
    letter-spacing: 2rpx;
    line-height: 1;
  }

  &__banner-section {
    padding: 0 $page-pad;
    margin-top: 8rpx;
    margin-bottom: $section-gap;
  }

  &__swiper {
    height: 320rpx;
    border-radius: $radius-card;
    overflow: hidden;
    box-shadow: $shadow-card;
  }

  &__banner-image {
    width: 100%;
    height: 320rpx;
  }

  &__sections {
    padding: 0 $page-pad;
    display: flex;
    flex-direction: column;
    gap: $section-gap;
  }

  &__primary-card {
    display: flex;
    align-items: stretch;
    background: #FFFFFF;
    border-radius: $radius-card;
    box-shadow: $shadow-card;
    overflow: hidden;
  }

  &__primary-item {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 32rpx 16rpx 28rpx;

    &:active {
      background: #FAFAFA;
    }

    &--disabled {
      opacity: 0.45;
    }
  }

  &__primary-divider {
    width: 1rpx;
    align-self: stretch;
    background: #F0F0F0;
    margin: 24rpx 0;
  }

  &__primary-icon-wrap {
    width: 88rpx;
    height: 88rpx;
    border-radius: 24rpx;
    background: $bg-category-active;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__primary-icon {
    font-size: 44rpx;
    line-height: 1;
  }

  &__primary-name {
    margin-top: 14rpx;
    font-size: 32rpx;
    font-weight: bold;
    color: $brand-primary;
  }

  &__primary-desc {
    margin-top: 6rpx;
    font-size: 22rpx;
    color: #999999;
  }

  &__shortcut-row {
    display: flex;
    gap: 16rpx;
  }

  &__shortcut-item {
    flex: 1;
    background: #FFFFFF;
    border-radius: $radius-card;
    padding: 24rpx 10rpx 20rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: $shadow-card;
    min-height: 168rpx;
    box-sizing: border-box;
  }

  &__shortcut-item:active {
    opacity: 0.85;
  }

  &__shortcut-icon-wrap {
    width: 72rpx;
    height: 72rpx;
    border-radius: 20rpx;
    background: $bg-category-active;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__shortcut-icon {
    font-size: 36rpx;
    line-height: 1;
  }

  &__shortcut-name {
    margin-top: 12rpx;
    font-size: 26rpx;
    font-weight: bold;
    color: #333333;
  }

  &__shortcut-desc {
    margin-top: 6rpx;
    font-size: 20rpx;
    color: #999999;
    text-align: center;
    line-height: 1.35;
    padding: 0 4rpx;
  }

  &__recommend {
    padding-top: 12rpx;
  }

  &__recommend-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: $section-gap;
  }

  &__recommend-title-wrap {
    position: relative;
    display: inline-flex;
  }

  &__recommend-title {
    font-size: 34rpx;
    font-weight: bold;
    color: #333333;
    position: relative;
    z-index: 1;
  }

  &__recommend-underline {
    position: absolute;
    bottom: 4rpx;
    left: 0;
    right: 0;
    height: 12rpx;
    background: rgba(255, 213, 79, 0.45);
    border-radius: 6rpx;
  }

  &__recommend-link {
    font-size: 26rpx;
    color: $brand-primary;
    font-weight: 500;
    padding: 8rpx 0;
  }

  &__dish-card {
    display: flex;
    align-items: stretch;
    background: #FFFFFF;
    border-radius: $radius-card;
    padding: 20rpx;
    margin-bottom: $section-gap;
    box-shadow: $shadow-card;
  }

  &__dish-card:last-child {
    margin-bottom: 0;
  }

  &__dish-card:active {
    opacity: 0.92;
  }

  &__dish-image-wrap {
    position: relative;
    flex-shrink: 0;
  }

  &__dish-image {
    width: 168rpx;
    height: 168rpx;
    border-radius: 16rpx;
    background: #F5F5F5;
  }

  &__dish-badge {
    position: absolute;
    top: 0;
    left: 0;
    background: $brand-red;
    border-radius: 16rpx 0 12rpx 0;
    padding: 4rpx 14rpx;
  }

  &__dish-badge-text {
    font-size: 20rpx;
    color: #FFFFFF;
    font-weight: 500;
  }

  &__dish-info {
    flex: 1;
    margin-left: 20rpx;
    min-width: 0;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding: 4rpx 0;
  }

  &__dish-name {
    font-size: 30rpx;
    font-weight: bold;
    color: #333333;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__dish-desc {
    margin-top: 8rpx;
    font-size: 22rpx;
    color: #999999;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    line-height: 1.4;
  }

  &__dish-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 12rpx;
  }

  &__dish-price {
    font-size: 34rpx;
    font-weight: bold;
    color: $text-price;
  }

  &__dish-btn {
    flex-shrink: 0;
    background: $brand-primary;
    border-radius: 999rpx;
    padding: 12rpx 28rpx;
  }

  &__dish-btn-text {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: 500;
    white-space: nowrap;
  }

  &__recommend-empty {
    padding: 60rpx 0 40rpx;
    text-align: center;
    background: #FFFFFF;
    border-radius: $radius-card;
    box-shadow: $shadow-card;
  }

  &__recommend-empty-text {
    font-size: 26rpx;
    color: #999999;
  }

  &__bottom-space {
    height: calc(120rpx + env(safe-area-inset-bottom));
  }
}
</style>
