const TAB_PAGES = [
  'pages/index/index',
  'pages/order/list',
  'pages/mine/index'
]

const DEFAULT_TABBAR = {
  style: {
    defaultColor: '#999999',
    selectedColor: '#FF6B35'
  },
  list: [
    { name: '首页', selected: '', unselected: '', link: { path: '/pages/index/index' } },
    { name: '订单', selected: '', unselected: '', link: { path: '/pages/order/list' } },
    { name: '我的', selected: '', unselected: '', link: { path: '/pages/mine/index' } }
  ]
}

export function normalizeTabPath(path) {
  if (!path) return ''
  const raw = String(path).trim()
  return raw.startsWith('/') ? raw.slice(1) : raw
}

export function filterTabbarList(list) {
  if (!Array.isArray(list)) return DEFAULT_TABBAR.list
  const filtered = list
    .map((item) => ({
      ...item,
      pagePath: normalizeTabPath(item?.link?.path || item?.link?.url || '')
    }))
    .filter((item) => TAB_PAGES.includes(item.pagePath))
  return filtered.length >= 2 ? filtered : DEFAULT_TABBAR.list
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
