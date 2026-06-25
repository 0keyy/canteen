<script>
import { decorateApi } from './api/index'
import {
  filterTabbarList,
  getDefaultTabbar,
  readTabbarCache,
  writeTabbarCache
} from './utils/tabbar'

async function preloadTabbar() {
  try {
    const data = await decorateApi.tabbar()
    const list = filterTabbarList(data?.list || [])
    if (list.length >= 2) {
      writeTabbarCache({
        style: data?.style || getDefaultTabbar().style,
        list
      })
    }
  } catch (e) {
    // 使用本地默认配置
  }
}

export default {
  onLaunch() {
    const token = uni.getStorageSync('token')
    if (!token) {
      uni.reLaunch({ url: '/pages/login/index' })
      return
    }
    preloadTabbar()
  }
}
</script>

<style lang="scss">
page {
  background-color: $bg-page;
  font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', sans-serif;
  font-size: 28rpx;
  color: $text-primary;
  -webkit-font-smoothing: antialiased;
  -webkit-tap-highlight-color: transparent;
}

view, text, image, scroll-view, swiper {
  box-sizing: border-box;
}

.price {
  color: $text-price;
  font-weight: 900;
  font-size: 36rpx;
}

.safe-area-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}

/* 主按钮 */
.btn-primary {
  background: $brand-primary;
  color: $text-white;
  border-radius: 999rpx;
  font-weight: 600;
  text-align: center;
  transition: background $transition-fast;
}

.btn-primary:active {
  background: $brand-primary-press;
}

.btn-primary--disabled {
  background: #CCCCCC !important;
  color: $text-white;
}

/* 次按钮 */
.btn-secondary {
  background: $bg-surface;
  color: $text-secondary;
  border: 1rpx solid $border-light;
  border-radius: 999rpx;
  font-weight: 500;
  text-align: center;
}

.btn-secondary:active {
  background: $bg-gray;
}

.page-tabbar-spacer {
  height: $tabbar-height;
  flex-shrink: 0;
}

.app-tab-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1000;
  width: 100%;
  height: $tabbar-height;
  min-height: 100rpx;
  padding: 8rpx 16rpx env(safe-area-inset-bottom);
  display: flex;
  background: #FFFCF8;
  border-top: 1rpx solid $border-light;
  box-sizing: border-box;
}

.app-tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4rpx;
  min-height: 88rpx;
  transition: transform $transition-fast;

  &:active {
    transform: scale(0.92);
  }
}

.app-tab-item:not(.app-tab-item--active) .app-tab-icon {
  filter: grayscale(100%);
  opacity: 0.5;
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
}

.app-tab-text {
  font-size: 22rpx;
  font-weight: 600;
  line-height: 1.2;
}
</style>
