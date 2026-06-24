const TAB_PAGES = [
  'pages/index/index',
  'pages/menu/index',
  'pages/points/index',
  'pages/mine/index'
]

const TAB_NAME_PATH_MAP = {
  '首页': 'pages/index/index',
  '点餐': 'pages/menu/index',
  '积分商城': 'pages/points/index',
  '我的': 'pages/mine/index'
}

const DEFAULT_TABBAR = {
  style: {
    defaultColor: '#999999',
    selectedColor: '#C41E3A'
  },
  list: [
    { name: '首页', selected: '/static/tabbar/首页 1.png', unselected: '/static/tabbar/首页 1.png', link: { path: '/pages/index/index' } },
    { name: '点餐', selected: '/static/tabbar/面条 1.png', unselected: '/static/tabbar/面条 1.png', link: { path: '/pages/menu/index' } },
    { name: '积分商城', selected: '/static/tabbar/商城-幸福餐桌 1.png', unselected: '/static/tabbar/商城-幸福餐桌 1.png', link: { path: '/pages/points/index' } },
    { name: '我的', selected: '/static/tabbar/头像 1.png', unselected: '/static/tabbar/头像 1.png', link: { path: '/pages/mine/index' } }
  ]
}

export function normalizeTabPath(path) {
  if (!path) return ''
  const raw = String(path).trim()
  return raw.startsWith('/') ? raw.slice(1) : raw
}

export function resolveTabPagePath(item) {
  const fromLink = normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath || '')
  if (fromLink) return fromLink
  return TAB_NAME_PATH_MAP[item?.name] || ''
}

export function filterTabbarList(list) {
  if (!Array.isArray(list)) return DEFAULT_TABBAR.list

  const mapped = list
    .map((item) => ({
      ...item,
      pagePath: resolveTabPagePath(item)
    }))
    .filter((item) => TAB_PAGES.includes(item.pagePath))

  if (mapped.length >= 2) {
    TAB_PAGES.forEach((pagePath, index) => {
      if (mapped.some((item) => item.pagePath === pagePath)) return
      const fallback = DEFAULT_TABBAR.list.find(
        (item) => normalizeTabPath(item.link.path) === pagePath
      )
      if (fallback) {
        mapped.splice(index, 0, {
          ...fallback,
          pagePath
        })
      }
    })
    return mapped
  }

  return DEFAULT_TABBAR.list
}

export function getDefaultTabbar() {
  return {
    ...DEFAULT_TABBAR,
    list: filterTabbarList(DEFAULT_TABBAR.list)
  }
}

export function hideNativeTabBar() {
  uni.hideTabBar({ animation: false, fail: () => {} })
}

export function normalizeTabbarItem(item) {
  const link = item?.link || {}
  const pagePath = resolveTabPagePath(item)
  return {
    ...item,
    pagePath,
    link: {
      ...link,
      path: link.path || link.url || (pagePath ? `/${pagePath}` : '')
    },
    selected: item?.selected || item?.selectedIcon || '',
    unselected: item?.unselected || item?.unselectedIcon || ''
  }
}

export const TABBAR_CACHE_VERSION = 4

export function readTabbarCache() {
  const cached = uni.getStorageSync('tabbarConfig')
  if (!cached || cached.version !== TABBAR_CACHE_VERSION) return null
  return cached
}

export function writeTabbarCache(config) {
  uni.setStorageSync('tabbarConfig', {
    version: TABBAR_CACHE_VERSION,
    ...config
  })
}
