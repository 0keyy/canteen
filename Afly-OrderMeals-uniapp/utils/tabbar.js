import { STATIC_IMAGE_PREFIX } from './image'

function s(path) {
  return `${STATIC_IMAGE_PREFIX}${path}`
}

const TAB_PAGES = [
  'pages/index/index',
  'pages/menu/index',
  'pages/points/index',
  'pages/mine/index'
]

// 原生 tabBar 页面（pages.json 中 tabBar.list 注册的页面）
export const NATIVE_TAB_PAGES = [
  'pages/index/index',
  'pages/menu/index',
  'pages/points/index',
  'pages/mine/index'
]

const TAB_NAME_PATH_MAP = {
  '首页': 'pages/index/index',
  '点餐': 'pages/menu/index',
  '点单': 'pages/menu/index',
  '菜单': 'pages/menu/index',
  '堂食': 'pages/menu/index',
  '外卖': 'pages/menu/index',
  '积分商城': 'pages/points/index',
  '积分': 'pages/points/index',
  '商城': 'pages/points/index',
  '积分商店': 'pages/points/index',
  '积分中心': 'pages/points/index',
  '我的': 'pages/mine/index',
  '个人中心': 'pages/mine/index',
  '我的主页': 'pages/mine/index',
  '会员中心': 'pages/mine/index'
}

const DEFAULT_TABBAR = {
  style: {
    defaultColor: '#999999',
    selectedColor: '#C41E3A'
  },
  list: [
    { name: '首页', selected: s('/tabbar/首页 1.png'), unselected: s('/tabbar/首页 1.png'), link: { path: '/pages/index/index' } },
    { name: '点餐', selected: s('/tabbar/面条 1.png'), unselected: s('/tabbar/面条 1.png'), link: { path: '/pages/menu/index' } },
    { name: '积分商城', selected: s('/tabbar/积分商城.png'), unselected: s('/tabbar/积分商城.png'), link: { path: '/pages/points/index' } },
    { name: '我的', selected: s('/tabbar/头像 1.png'), unselected: s('/tabbar/头像 1.png'), link: { path: '/pages/mine/index' } }
  ]
}

export function normalizeTabPath(path) {
  if (!path) return ''
  const raw = String(path).trim()
  return raw.startsWith('/') ? raw.slice(1) : raw
}

export function resolveTabPagePath(item) {
  const name = item?.name || ''
  const fromName = TAB_NAME_PATH_MAP[name]
  if (fromName) return fromName
  const fromLink = normalizeTabPath(item?.link?.path || item?.link?.url || item?.pagePath || '')
  if (fromLink && /\//.test(fromLink)) return fromLink
  const fromLinkName = TAB_NAME_PATH_MAP[fromLink]
  if (fromLinkName) return fromLinkName
  return ''
}

export function filterTabbarList(list) {
  if (!Array.isArray(list)) return DEFAULT_TABBAR.list

  const excludedNames = ['订单', '我的订单']

  const mapped = list
    .filter((item) => !excludedNames.includes(item?.name))
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
  const getFirstValue = (keys) => {
    for (const key of keys) {
      if (item?.[key]) return item[key]
    }
    if (item?.icon && typeof item.icon === 'object') {
      for (const key of keys) {
        if (item.icon?.[key]) return item.icon[key]
      }
    }
    return ''
  }
  const selectedKeys = [
    'selected', 'selectedIcon', 'selectedIconPath', 'selectedImage',
    'activeIcon', 'iconSelected', 'selectIcon', 'activeImage',
    'iconActive', 'selected_url', 'selectedUrl'
  ]
  const unselectedKeys = [
    'unselected', 'unselectedIcon', 'unselectedIconPath', 'unselectedImage',
    'inactiveIcon', 'iconUnselected', 'defaultIcon', 'defaultImage',
    'iconDefault', 'normalIcon', 'normal', 'unselected_url', 'unselectedUrl'
  ]
  let selectedImg = getFirstValue(selectedKeys)
  let unselectedImg = getFirstValue(unselectedKeys)
  if (!selectedImg && !unselectedImg && item?.icon) {
    if (typeof item.icon === 'string') {
      selectedImg = item.icon
      unselectedImg = item.icon
    }
  }
  if (!selectedImg && unselectedImg) selectedImg = unselectedImg
  if (!unselectedImg && selectedImg) unselectedImg = selectedImg
  return {
    ...item,
    pagePath,
    link: {
      ...link,
      path: pagePath ? `/${pagePath}` : (link.path || link.url || '')
    },
    selected: selectedImg,
    unselected: unselectedImg
  }
}

export const TABBAR_CACHE_VERSION = 16

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
