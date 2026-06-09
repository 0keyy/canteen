<script>
import { decorateApi } from './api/index'
import { filterTabbarList, getDefaultTabbar } from './utils/tabbar'

async function preloadTabbar() {
  try {
    const data = await decorateApi.tabbar()
    const list = filterTabbarList(data?.list || [])
    if (list.length >= 2) {
      uni.setStorageSync('tabbarConfig', {
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
  background-color: #FAF7F2;
  font-family: -apple-system, BlinkMacSystemFont, 'PingFang SC', 'Microsoft YaHei', 'Helvetica Neue', sans-serif;
  font-size: 28rpx;
  color: #333333;
  -webkit-font-smoothing: antialiased;
  -webkit-tap-highlight-color: transparent;
}

view, text, image, scroll-view, swiper {
  box-sizing: border-box;
}

.price {
  color: #E53935;
  font-weight: bold;
  font-size: 36rpx;
}

.safe-area-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}

/* 主按钮 */
.btn-primary {
  background: #FF6B35;
  color: #FFFFFF;
  border-radius: 999rpx;
  font-weight: bold;
  text-align: center;
  transition: background 0.15s ease;
}

.btn-primary:active {
  background: #D95420;
}

.btn-primary--disabled {
  background: #CCCCCC !important;
  color: #FFFFFF;
}

/* 次按钮 */
.btn-secondary {
  background: #FFFFFF;
  color: #666666;
  border: 1rpx solid #EEEEEE;
  border-radius: 999rpx;
  font-weight: 500;
  text-align: center;
}

.btn-secondary:active {
  background: #FAFAFA;
}

.app-tab-bar {
  flex-shrink: 0;
  width: 100%;
  height: calc(100rpx + env(safe-area-inset-bottom));
  padding-bottom: env(safe-area-inset-bottom);
  display: flex;
  background: #FFFFFF;
  border-top: 1rpx solid #F0F0F0;
  box-sizing: border-box;
}

.app-tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100rpx;
}

.app-tab-icon {
  width: 44rpx;
  height: 44rpx;
  margin-bottom: 4rpx;
}

.app-tab-text {
  font-size: 22rpx;
  line-height: 1.2;
}
</style>
