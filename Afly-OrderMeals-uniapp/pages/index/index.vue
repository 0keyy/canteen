<template>
  <view class="home">
    <scroll-view class="home__content" scroll-y :show-scrollbar="false">
      <view class="home__scroll-inner">
        <!-- 顶部纯轮播区域 -->
        <view class="home__banner-top" :style="heroPaddingStyle">
          <!-- 悬浮积分卡片，贴轮播底部，盖在轮播上面 -->
          <view class="banner-user-card">
            <text class="card-name">用户123</text>
            <view class="card-right">
              <text class="card-num">0 积分</text>
              <text class="card-num">0 优惠券</text>
            </view>
          </view>
        
          <view class="home__banner-wrap">
            <swiper
              class="home__swiper"
              :circular="displayBanners.length > 1"
              :autoplay="displayBanners.length > 0"
              :interval="4000"
              :duration="600"
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

        <!-- 到店/外卖卡片 独立区块 -->
        <view class="home__primary-cards">
          <view class="home__primary-card-item" @click="selectMode(1)">
            <view class="home__primary-card-text">
              <text class="home__primary-name">到店堂食</text>
            </view>
            <image class="home__primary-card-img" src="/static/图层 2.png" mode="aspectFit" />
          </view>
          <view
            class="home__primary-card-item"
            :class="{ 'home__primary-card-item--disabled': shop && shop.deliveryEnable !== 1 }"
            @click="selectMode(3)"
          >
            <view class="home__primary-card-text">
              <text class="home__primary-name">外卖配送</text>
            </view>
            <image class="home__primary-card-img" src="/static/小唐骑车.png" mode="aspectFit" />
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
              <view class="home__recommend-title-row">
                <text class="home__recommend-title">粮兴推荐</text>
                <text class="home__recommend-tag">限时优惠</text>
              </view>
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

        </view>

        <view class="home__bottom-space"></view>
      </view>
    </scroll-view>

    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>

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
import PageLoading from '../../components/page-loading/page-loading.vue'

export default {
  mixins: [tabbarPageMixin],
  components: { PageLoading },
  data() {
    return {
      navMetrics: getNavMetrics(),
      menuButtonRight: 96,
      shop: null,
      aid: DEFAULT_SHOP_ID,
      banners: [],
      recommendDishes: [],
      recommendLoading: false,
      pageLoading: false,
      pageLoadingTip: '',
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
      // 修复：不要负数，避免轮播顶到刘海遮挡卡片
      return {
        paddingTop: `${statusBarHeight + -55}px`
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
      this.pageLoading = true
      this.pageLoadingTip = '加载中...'
      try {
        await this.loadShop()
        await this.loadDecoration()
        await this.loadRecommend()
      } finally {
        this.pageLoading = false
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
      if (item?.name === '积分商城') {
        uni.navigateTo({ url: '/pages/integralShop/index' })
        return
      }
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

  /* 顶部轮播容器 必须加relative，作为卡片定位父级 */
  &__banner-top {
    width: 100%;
    box-sizing: border-box;
    position: relative;
    overflow: hidden; /* 新增核心代码 */
  }

  &__banner-wrap {
    width: 100%;
    padding: 0;
    border-radius: 0;
    background: transparent;
    border: none;
  }

  /* 悬浮积分卡片，贴轮播底部，只占一小条 */
  .banner-user-card {
    position: absolute;
    left: 40rpx;
    right: 35rpx;
    bottom: 30rpx;
    height: 100rpx;
    z-index: 99;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 30rpx;
  
    /* 背景渐变：底部深棕红，往上半透明渐变 */
    background: linear-gradient(
      180deg,
      rgba(80, 40, 30, 0.95) 0%,
      rgba(60, 25, 20, 0.85) 50%,
      rgba(40, 15, 10, 0.75) 100%
    );
  
    /* 圆角：上面圆弧，下面隐藏 */
    border-radius: 20rpx 20rpx 0 0;
  
    .card-name {
      font-size: 28rpx;
  
      /* 用户123：浅米黄色，和图中品牌文字更接近 */
      color: #ffdd99;
  
      font-weight: 500;
	  transform: translateY(-8rpx);
    }
  
    .card-right {
      display: flex;
      gap: 40rpx;
	  transform: translateY(-8rpx);
  
      .card-num {
        font-size: 28rpx;
  
        /* 积分/优惠券文字：白色更清楚 */
        color: #ffffff;
  
        /* 如果想和用户123同色，就改成： */
        /* color: #f7e8c8; */
      }
    }
  }

  &__swiper {
    width: 100%;
    height: 600rpx;
    border-radius: 0;
    overflow: hidden;
  }

  &__swiper-item {
    width: 100%;
    height: 550rpx;
  }

  &__banner-image {
    display: block;
    width: 100%;
    height: 550rpx;
  }

  &__banner-placeholder {
    width: 100%;
    height: 550rpx;
    background: #f5f5f5;
  }

  /* 到店外卖卡片独立区块 */
  &__primary-cards {
    display: flex;
    gap: 16rpx;
    margin: 24rpx $page-pad;
    padding: 0;
    background: transparent;
  }

  &__primary-card-item {
    flex: 1;
    position: relative;
    background: linear-gradient(180deg, #FFDADA 0%, #FFFFFF 76%);
	height: 200rpx;
    border-radius: $radius-card;
    padding: 24rpx 20rpx 20rpx;
    box-shadow: $shadow-sm;
    overflow: hidden;
    transition: transform $transition-fast;

    &:active {
      transform: scale(0.96);
    }

    &--disabled {
      opacity: 0.45;
    }
  }

  &__primary-card-img {
    width: 180rpx;
    height: 140rpx;
    flex-shrink: 0;
    position: absolute;
    right: 8rpx;
    bottom: 8rpx;
  }

  &__primary-card-text {
    display: flex;
    flex-direction: column;
    gap: 4rpx;
  }

  &__primary-name {
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  /* ===== 内容区 ===== */
  &__sections {
    padding: 0 $page-pad 16rpx;
    display: flex;
    flex-direction: column;
    gap: 26rpx;
  }

  &__shortcut-row {
    display: flex;
    gap: 16rpx;
    margin-top: 14rpx;
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
    transition: transform $transition-fast;

    &:active {
      transform: scale(0.96);
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
    background: rgba(177,10,15,0.08);
    border-radius: 50%;

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

    &--recharge {
      border: 3rpx solid $brand-primary;
      border-radius: 50%;

      &::before {
        content: '￥';
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -52%);
        font-size: 26rpx;
        line-height: 1;
        color: $brand-primary;
        font-weight: 700;
      }
    }

    &--order {
      border: 3rpx solid $brand-primary;
      border-radius: 6rpx;

      &::before {
        content: '';
        position: absolute;
        left: 12rpx;
        top: 10rpx;
        width: 20rpx;
        height: 3rpx;
        background: $brand-primary;
        box-shadow: 0 10rpx 0 $brand-primary, 0 20rpx 0 $brand-primary;
      }
    }

    &--service {
      border: 3rpx solid $brand-primary;
      border-top-color: transparent;
      border-radius: 50%;

      &::before {
        content: '';
        position: absolute;
        left: -8rpx;
        top: 18rpx;
        width: 10rpx;
        height: 16rpx;
        border: 3rpx solid $brand-primary;
        border-radius: 8rpx;
        box-shadow: 42rpx 0 0 -3rpx transparent, 42rpx 0 0 0 $brand-primary;
      }

      &::after {
        content: '';
        position: absolute;
        right: 4rpx;
        bottom: 2rpx;
        width: 12rpx;
        height: 3rpx;
        background: $brand-primary;
        border-radius: 999rpx;
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
    margin-bottom: 18rpx;
  }

  &__recommend-title-row {
    display: flex;
    align-items: center;
    gap: 12rpx;
  }

  &__recommend-title {
    font-size: 32rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__recommend-tag {
    height: 30rpx;
    line-height: 30rpx;
    padding: 0 16rpx;
    border-radius: 0 999rpx 0 999rpx;
    background: #FFD978;
    color: #FFFFFF;
    font-size: 20rpx;
    font-weight: 700;
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
    gap: 18rpx;
  }

  &__dish-item {
    display: flex;
    align-items: center;
    gap: 20rpx;
    padding: 18rpx 22rpx;
    margin: 0 10rpx;
    background: #FFE8CD;
    border-radius: 16rpx;
    box-shadow: none;
    transition: transform $transition-fast;

    &:active {
      transform: scale(0.98);
    }
  }

  &__dish-image-wrap {
    position: relative;
    flex-shrink: 0;
  }

  &__dish-image {
    width: 128rpx;
    height: 128rpx;
    border-radius: 10rpx;
    background: $bg-gray;
  }

  &__dish-badge {
    position: absolute;
    top: 0;
    left: 0;
    background: #c82d24;
    border-radius: 8rpx;
    padding: 4rpx 12rpx;
  }

  &__dish-badge-text {
    font-size: 20rpx;
    color: $text-white;
    font-weight: 600;
  }

  &__dish-info {
    position: relative;
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 0 160rpx 0 0;
  }

  &__dish-name {
    font-size: 24rpx;
    font-weight: 700;
    line-height: 1.35;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__dish-desc {
    margin-top: 6rpx;
    font-size: 20rpx;
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
    display: block;
    margin-top: 10rpx;
  }

  &__dish-price {
    font-size: 30rpx;
    font-weight: 900;
    color: $text-price;
  }

  &__dish-btn {
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    background: #c82d24;
    border-radius: 999rpx;
    padding: 12rpx 28rpx;
    box-shadow: none;
    transition: transform $transition-fast;

    &:active {
      transform: translateY(-50%) scale(0.95);
    }
  }

  &__dish-btn-text {
    font-size: 22rpx;
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

  &__bottom-space {
    height: $tabbar-height;
  }
}
</style>