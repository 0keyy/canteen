import { decorateApi } from '../api/index'
import { resolveImageUrl } from '../utils/image'
import { filterTabbarList, getDefaultTabbar, hideNativeTabBar, normalizeTabPath } from '../utils/tabbar'

export default {
  data() {
    return {
      tabbarSelected: 0,
      tabbarDefaultColor: '#999999',
      tabbarSelectedColor: '#FF6B35',
      tabbarList: getDefaultTabbar().list
    }
  },
  methods: {
    setupTabbar(selectedIndex) {
      hideNativeTabBar()
      this.tabbarSelected = selectedIndex
      this.loadTabbar()
    },
    async loadTabbar() {
      const cached = uni.getStorageSync('tabbarConfig')
      if (cached?.list?.length) {
        this.applyTabbarConfig(cached)
      }
      try {
        const data = await decorateApi.tabbar()
        const list = filterTabbarList(data?.list || [])
        if (list.length >= 2) {
          const config = {
            style: data?.style || {},
            list
          }
          uni.setStorageSync('tabbarConfig', config)
          this.applyTabbarConfig(config)
        }
      } catch (e) {
        if (!cached?.list?.length) {
          this.applyTabbarConfig(getDefaultTabbar())
        }
      }
    },
    applyTabbarConfig(config) {
      const style = config?.style || {}
      this.tabbarDefaultColor = style.defaultColor || '#999999'
      this.tabbarSelectedColor = style.selectedColor || '#FF6B35'
      const list = config.list || getDefaultTabbar().list
      this.tabbarList = list.map((item) => ({
        ...item,
        pagePath: normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath || ''),
        selected: resolveImageUrl(item.selected),
        unselected: resolveImageUrl(item.unselected)
      }))
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
