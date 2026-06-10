import { decorateApi } from '../api/index'
import { resolveImageUrl } from '../utils/image'
import {
  filterTabbarList,
  getDefaultTabbar,
  hideNativeTabBar,
  normalizeTabPath,
  normalizeTabbarItem,
  readTabbarCache,
  writeTabbarCache
} from '../utils/tabbar'

export default {
  data() {
    return {
      tabbarSelected: 0,
      tabbarDefaultColor: '#999999',
      tabbarSelectedColor: '#B10A0F',
      tabbarList: getDefaultTabbar().list
    }
  },
  methods: {
    setupTabbar(selectedIndex) {
      this.tabbarSelected = selectedIndex
      if (!this.tabbarList?.length) {
        this.applyTabbarConfig(getDefaultTabbar())
      }
      hideNativeTabBar()
      this.loadTabbar()
    },
    async loadTabbar() {
      const cached = readTabbarCache()
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
          writeTabbarCache(config)
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
      this.tabbarSelectedColor = style.selectedColor || '#B10A0F'
      const list = config.list || getDefaultTabbar().list
      this.tabbarList = list.map((item) => {
        const normalized = normalizeTabbarItem(item)
        return {
          ...normalized,
          selected: resolveImageUrl(normalized.selected),
          unselected: resolveImageUrl(normalized.unselected)
        }
      })
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
