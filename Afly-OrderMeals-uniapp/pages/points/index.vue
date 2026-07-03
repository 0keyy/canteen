<template>
  <view class="points-page">
    <scroll-view class="points-page__scroll" scroll-y :show-scrollbar="false">
      <!-- 顶部红色渐变区 -->
      <view class="points-page__hero" :style="heroPaddingStyle">
        <view class="points-page__hero-content">
          <view class="points-page__points-row">
            <view class="points-page__points-info">
              <text class="points-page__points-value">{{ pointsBalance }} <text class="points-page__points-text">积分</text></text>
              <text class="points-page__points-label">积分享好礼，别忘记使用哦</text>
            </view>
            <image class="points-page__mascot" :src="staticImgPrefix + '/static/看书.png'" mode="aspectFit" />
          </view>
          <view class="points-page__scan-btn" @tap="onScan">
            <view class="points-page__scan-icon"></view>
          </view>
        </view>
      </view>

      <!-- 导航标签 -->
      <view class="points-page__content-panel">
        <view class="points-page__nav-tabs">
          <view
            v-for="(tab, index) in navTabs"
            :key="index"
            class="points-page__nav-tab"
            :class="{ 'points-page__nav-tab--active': activeTab === index }"
            @tap="selectTab(index)"
          >
            <text class="points-page__nav-tab-text">{{ tab }}</text>
          </view>
        </view>

        <!-- 推广卡片 -->
        <view class="points-page__promo-row">
          <view class="points-page__promo-card points-page__promo-card--lottery">
            <view class="points-page__promo-main">
              <text class="points-page__promo-title">积分抽奖</text>
              <text class="points-page__promo-sub">赢取优惠券</text>
            </view>
            <text class="points-page__promo-watermark">惠</text>
          </view>
          <view class="points-page__promo-card points-page__promo-card--checkin">
            <view class="points-page__promo-main">
              <text class="points-page__promo-title">每日签到</text>
              <text class="points-page__promo-sub">每天有惊喜</text>
            </view>
            <text class="points-page__promo-watermark">惠</text>
          </view>
        </view>

        <!-- 分类筛选 -->
        <view class="points-page__category-bar">
          <scroll-view scroll-x class="points-page__category-scroll" :show-scrollbar="false">
            <view class="points-page__category-list">
              <view
                v-for="(cat, index) in categories"
                :key="index"
                class="points-page__category-item"
                :class="{ 'points-page__category-item--active': activeCategory === index }"
                @tap="selectCategory(index)"
              >
                <text class="points-page__category-text">{{ cat }}</text>
              </view>
            </view>
          </scroll-view>
        </view>

        <!-- 商品网格 -->
        <view class="points-page__product-grid">
          <view
            v-for="product in products"
            :key="product.id"
            class="points-page__product-card"
          >
            <view class="points-page__product-image-wrap">
              <image class="points-page__product-image" :src="product.image" mode="aspectFill" />
            </view>
            <view class="points-page__product-info">
              <text class="points-page__product-title">{{ product.title }}</text>
              <view class="points-page__product-bottom">
                <view class="points-page__product-points">
                  <text class="points-page__product-points-num">{{ product.points }}</text>
                  <text class="points-page__product-points-unit">积分</text>
                </view>
                <text class="points-page__product-redeemed">已兑{{ product.redeemed }}份</text>
              </view>
            </view>
          </view>
        </view>
      </view>

      <view class="points-page__bottom-space"></view>
    </scroll-view>

    <!-- 底部 TabBar -->
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
import { authApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'
import { normalizeTabPath } from '../../utils/tabbar'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      navMetrics: getNavMetrics(),
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      pointsBalance: 0,
      activeTab: 1,
      activeCategory: 0,
      navTabs: ['积分规则', '积分明细', '兑换记录'],
      categories: ['全部', '积分秒杀', '堂食专享', '外卖专享'],
      products: [
        {
          id: 1,
          image: STATIC_IMAGE_PREFIX + '/static/1.png',
          label: '可口可乐',
          title: '【堂食专享】可口可乐',
          points: 10,
          redeemed: 47
        },
        {
          id: 2,
          image: STATIC_IMAGE_PREFIX + '/static/2.png',
          label: '薯条',
          title: '【堂食专享】香脆薯条',
          points: 20,
          redeemed: 32
        },
        {
          id: 3,
          image: STATIC_IMAGE_PREFIX + '/static/3.png',
          label: '奶茶',
          title: '【外卖专享】珍珠奶茶',
          points: 30,
          redeemed: 58
        },
        {
          id: 4,
          image: STATIC_IMAGE_PREFIX + '/static/4.png',
          label: '鸡翅',
          title: '【积分秒杀】香辣鸡翅',
          points: 50,
          redeemed: 19
        }
      ]
    }
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` }
    }
  },
  onShow() {
    this.navMetrics = getNavMetrics()
    this.setupTabbar(2)
    this.loadPoints()
  },
  methods: {
    async loadPoints() {
      try {
        const profile = await authApi.profile()
        if (profile && profile.points != null) {
          this.pointsBalance = profile.points
        }
      } catch (e) {}
    },
    selectCategory(index) {
      this.activeCategory = index
    },
    selectTab(index) {
      this.activeTab = index
    },
    onScan() {
      uni.showToast({ title: '扫码功能开发中', icon: 'none' })
    },
    switchTabbar(item, index) {
      const path = normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath)
      if (!path) return
      if (this.tabbarSelected === index) return
      uni.switchTab({
        url: `/${path}`,
        fail: () => {
          uni.reLaunch({ url: `/${path}` })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.points-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #F5F5F5;

  &__scroll {
    flex: 1;
    height: 0;
  }

  /* ===== 顶部红色渐变区 ===== */
  &__hero {
    background: linear-gradient(180deg, #FFD4D4 0%, #FF7984 100%);
    position: relative;
    overflow: hidden;
  }

  &__hero-content {
    padding: 26rpx $spacing-page 34rpx;
    position: relative;
  }

  &__points-row {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
  }

  &__points-info {
    display: flex;
    flex-direction: column;
  }

  &__points-value {
    font-size: 80rpx;
    font-weight: 900;
    color: $brand-primary;
    line-height: 1.1;
  }
	&__points-text{
		font-size: 16px;
		color: #000;
	}
  &__points-label {
    margin-top: 8rpx;
    font-size: 16rpx;
    color: #5a5a5a;
    line-height: 1.4;
  }

  &__mascot {
    width: 178rpx;
    height: 178rpx;
    flex-shrink: 0;
  }

  &__scan-btn {
    position: absolute;
    top: 16rpx;
    right: $spacing-page;
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__scan-icon {
    width: 40rpx;
    height: 40rpx;
    border: 4rpx solid $text-white;
    border-radius: 8rpx;
    position: relative;

    &::before,
    &::after {
      content: '';
      position: absolute;
      background: $text-white;
    }

    &::before {
      top: 8rpx;
      left: 50%;
      transform: translateX(-50%);
      width: 4rpx;
      height: 16rpx;
    }

    &::after {
      left: 8rpx;
      top: 50%;
      transform: translateY(-50%);
      width: 16rpx;
      height: 4rpx;
    }
  }

  /* ===== 导航标签 ===== */
  &__nav-tabs {
    display: flex;
    background: #FFFFFF;
    padding: 0 16rpx;
    box-shadow: none;
  }

  &__nav-tab {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24rpx 0;
    position: relative;

    &--active {
      .points-page__nav-tab-text {
        color: $brand-primary;
        font-weight: 700;
      }

      &::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 48rpx;
        height: 6rpx;
        border-radius: 3rpx;
        background: $brand-primary;
      }
    }
  }

  &__nav-tab-text {
    font-size: $font-size-base;
    color: $text-secondary;
    font-weight: 500;
  }

  /* ===== 推广卡片 ===== */
  &__promo-row {
    display: flex;
    gap: 20rpx;
    padding: 24rpx $spacing-page 0;
  }

  &__promo-card {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 24rpx;
    border-radius: 16rpx;
    position: relative;
    overflow: hidden;
    background: linear-gradient(135deg, #FF4F59 0%, #FFB5A8 100%);
  }

  &__promo-main {
    display: flex;
    flex-direction: column;
    z-index: 1;
  }

  &__promo-title {
    font-size: 48rpx;
    font-weight: 900;
    color: #D00000;
  }

  &__promo-sub {
    margin-top: 6rpx;
    font-size: 22rpx;
    color: rgba(255, 255, 255, 0.85);
  }

  &__promo-watermark {
    position: absolute;
    right: 12rpx;
    bottom: -28rpx;
    font-size: 132rpx;
    line-height: 1;
    color: rgba(255, 255, 255, 0.42);
    font-weight: 900;
  }

  /* ===== 分类筛选 ===== */
  &__category-bar {
    padding: 24rpx $spacing-page 0;
  }

  &__category-scroll {
    white-space: nowrap;
  }

  &__category-list {
    display: inline-flex;
    gap: 8rpx;
  }

  &__category-item {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 12rpx 32rpx;
    border-radius: $radius-tag;
    background: #FFFFFF;
    box-shadow: none;

    &--active {
      background: transparent;

      .points-page__category-text {
        color: $brand-primary;
        font-weight: 700;
      }

      &::after {
        content: '';
        position: absolute;
        left: 26rpx;
        right: 26rpx;
        bottom: 4rpx;
        height: 4rpx;
        border-radius: 2rpx;
        background: $brand-primary;
      }
    }
  }

  &__category-text {
    font-size: $font-size-base;
    color: $text-secondary;
    font-weight: 500;
    white-space: nowrap;
  }

  /* ===== 商品网格 ===== */
  &__product-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20rpx;
    padding: 18rpx $spacing-page 0;
  }

  &__product-card {
    background: $bg-surface;
    border-radius: 10rpx;
    overflow: hidden;
    box-shadow: none;

    &:active {
      opacity: 0.92;
    }
  }

  &__product-image-wrap {
    position: relative;
    width: 100%;
    height: 230rpx;
  }

  &__product-image {
    width: 100%;
    height: 230rpx;
    background: $bg-gray;
  }

  &__product-badge {
    position: absolute;
    top: 0;
    left: 0;
    background: $brand-primary;
    border-radius: $radius-card 0 12rpx 0;
    padding: 4rpx 16rpx;
  }

  &__product-badge-text {
    font-size: 20rpx;
    color: $text-white;
    font-weight: 600;
  }

  &__product-info {
    padding: 16rpx 20rpx 20rpx;
  }

  &__product-title {
    font-size: $font-size-base;
    font-weight: 700;
    color: $text-primary;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    display: block;
  }

  &__product-bottom {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin-top: 12rpx;
  }

  &__product-points {
    display: flex;
    align-items: baseline;
  }

  &__product-points-num {
    font-size: $font-size-price;
    font-weight: 900;
    color: $brand-primary;
    line-height: 1;
  }

  &__product-points-unit {
    font-size: $font-size-desc;
    color: $brand-primary;
    font-weight: 600;
    margin-left: 4rpx;
  }

  &__product-redeemed {
    font-size: $font-size-desc;
    color: $text-tertiary;
  }

  /* ===== 底部占位 ===== */
  &__bottom-space {
    height: $tabbar-height;
  }
}

/* ===== 底部 TabBar ===== */
.app-tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  width: 100%;
  height: calc(108rpx + env(safe-area-inset-bottom));
  padding: 8rpx 16rpx env(safe-area-inset-bottom);
  display: flex;
  background: rgba(255, 252, 248, 0.98);
  border-top: 1rpx solid $border-light;
  box-sizing: border-box;
  backdrop-filter: blur(8px);
}

.app-tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4rpx;
  min-height: 88rpx;
  border-radius: 32rpx;
}

.app-tab-icon-wrap {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 56rpx;
  height: 56rpx;
}

.app-tab-icon {
  width: 44rpx;
  height: 44rpx;
  display: block;

  &--inactive {
    filter: grayscale(1) opacity(0.45);
  }
}

.app-tab-text {
  font-size: 22rpx;
  font-weight: 600;
  line-height: 1.2;
}
</style>
  &__content-panel {
    position: relative;
    margin-top: -18rpx;
    background: #FFFFFF;
    border-radius: 20rpx 20rpx 0 0;
    overflow: hidden;
  }
