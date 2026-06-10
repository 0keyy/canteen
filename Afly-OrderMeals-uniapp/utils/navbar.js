/**
 * 自定义导航栏尺寸（避开状态栏 + 小程序胶囊）
 */
function readWindowInfo() {
  if (typeof uni.getWindowInfo === 'function') {
    return uni.getWindowInfo()
  }
  if (typeof wx !== 'undefined' && typeof wx.getWindowInfo === 'function') {
    return wx.getWindowInfo()
  }
  return null
}

function readDeviceInfo() {
  if (typeof uni.getDeviceInfo === 'function') {
    return uni.getDeviceInfo()
  }
  if (typeof wx !== 'undefined' && typeof wx.getDeviceInfo === 'function') {
    return wx.getDeviceInfo()
  }
  return null
}

function readLegacySystemInfo() {
  try {
    return uni.getSystemInfoSync()
  } catch (e) {
    return null
  }
}

export function getNavMetrics() {
  const fallback = {
    statusBarHeight: 20,
    navBarHeight: 44,
    headerHeight: 64
  }

  try {
    const windowInfo = readWindowInfo() || readLegacySystemInfo() || {}
    const deviceInfo = readDeviceInfo() || {}
    const statusBarHeight = Number(windowInfo.statusBarHeight || deviceInfo.statusBarHeight) || 20
    let menuButton = null

    if (typeof uni.getMenuButtonBoundingClientRect === 'function') {
      menuButton = uni.getMenuButtonBoundingClientRect()
    }

    if (menuButton && menuButton.height > 0) {
      const navBarHeight = (menuButton.top - statusBarHeight) * 2 + menuButton.height
      return {
        statusBarHeight,
        navBarHeight,
        headerHeight: statusBarHeight + navBarHeight
      }
    }

    const safeTop = windowInfo.safeAreaInsets?.top ?? windowInfo.safeArea?.top ?? statusBarHeight
    const status = Math.max(Number(safeTop) || 0, statusBarHeight)
    return {
      statusBarHeight: status,
      navBarHeight: 44,
      headerHeight: status + 44
    }
  } catch (e) {
    return fallback
  }
}

export function getMenuButtonMarginRight(fallback = 96) {
  try {
    const windowInfo = readWindowInfo() || readLegacySystemInfo() || {}
    const windowWidth = Number(windowInfo.windowWidth)
    if (!Number.isFinite(windowWidth) || windowWidth <= 0) {
      return fallback
    }

    if (typeof uni.getMenuButtonBoundingClientRect === 'function') {
      const menuButton = uni.getMenuButtonBoundingClientRect()
      const left = Number(menuButton?.left)
      if (Number.isFinite(left) && left > 0) {
        const margin = windowWidth - left + 8
        return Number.isFinite(margin) && margin > 0 ? margin : fallback
      }
    }

    return fallback
  } catch (e) {
    return fallback
  }
}

/** @deprecated 使用 getNavMetrics */
export function getNavPaddingTop() {
  return getNavMetrics().headerHeight
}
