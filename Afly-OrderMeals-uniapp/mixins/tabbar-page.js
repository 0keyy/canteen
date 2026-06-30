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
import { showGlobalLoading, hideGlobalLoading } from '../utils/global-loading'

export default {
  data() {
    return {
      tabbarSelected: 0,
      tabbarDefaultColor: '#999999',
      tabbarSelectedColor: '#C41E3A',
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
      this.tabbarSelectedColor = style.selectedColor || '#C41E3A'
      const list = config.list || getDefaultTabbar().list
      this.tabbarList = list.map((item) => {
        const normalized = normalizeTabbarItem(item)
        const isLocal = (p) => !p || p.startsWith('/static') || p.startsWith('static')
        return {
          ...normalized,
          selected: isLocal(normalized.selected) ? normalized.selected : resolveImageUrl(normalized.selected),
          unselected: isLocal(normalized.unselected) ? normalized.unselected : resolveImageUrl(normalized.unselected)
        }
      })
    },
    switchTabbar(item, index) {
      const path = normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath)
      if (!path) return
      if (this.tabbarSelected === index) return
      // 使用全局 loading，新页面的 PageLoading 会监听到并显示
      showGlobalLoading()
      uni.switchTab({
        url: `/${path}`,
        fail: () => {
          uni.reLaunch({ url: `/${path}` })
        }
      })
      // 300ms 后关闭全局 loading
      setTimeout(() => {
        hideGlobalLoading()
      }, 300)
    }
  }
}
