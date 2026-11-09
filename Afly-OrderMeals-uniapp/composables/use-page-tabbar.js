import { ref } from 'vue'
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

export function usePageTabbar() {
  const tabbarSelected = ref(0)
  const tabbarDefaultColor = ref('#999999')
  const tabbarSelectedColor = ref('#C41E3A')
  const tabbarList = ref(getDefaultTabbar().list)

  function setupTabbar(selectedIndex) {
    tabbarSelected.value = selectedIndex
    if (!tabbarList.value?.length) {
      applyTabbarConfig(getDefaultTabbar())
    }
    hideNativeTabBar()
    loadTabbar()
  }

  async function loadTabbar() {
    const cached = readTabbarCache()
    if (cached?.list?.length) {
      applyTabbarConfig(cached)
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
        applyTabbarConfig(config)
      }
    } catch (e) {
      if (!cached?.list?.length) {
        applyTabbarConfig(getDefaultTabbar())
      }
    }
  }

  function applyTabbarConfig(config) {
    const style = config?.style || {}
    tabbarDefaultColor.value = style.defaultColor || '#999999'
    tabbarSelectedColor.value = style.selectedColor || '#C41E3A'
    const list = config.list || getDefaultTabbar().list
    tabbarList.value = list.map((item) => {
      const normalized = normalizeTabbarItem(item)
      const isLocal = (p) => !p || p.startsWith('/static') || p.startsWith('static')
      return {
        ...normalized,
        selected: isLocal(normalized.selected) ? normalized.selected : resolveImageUrl(normalized.selected),
        unselected: isLocal(normalized.unselected) ? normalized.unselected : resolveImageUrl(normalized.unselected)
      }
    })
  }

  function switchTabbar(item, index) {
    const path = normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath)
    if (!path) return
    if (tabbarSelected.value === index) return
    uni.switchTab({
      url: `/${path}`
    }).catch(() => {
      uni.reLaunch({ url: `/${path}` }).catch(() => {})
    })
  }

  return {
    tabbarSelected,
    tabbarDefaultColor,
    tabbarSelectedColor,
    tabbarList,
    setupTabbar,
    switchTabbar
  }
}
