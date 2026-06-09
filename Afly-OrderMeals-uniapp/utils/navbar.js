/**
 * 自定义导航栏尺寸（避开状态栏 + 小程序胶囊）
 */
export function getNavMetrics() {
  const fallback = {
    statusBarHeight: 20,
    navBarHeight: 44,
    headerHeight: 64
  }
  try {
    const sys = uni.getSystemInfoSync()
    const statusBarHeight = sys.statusBarHeight || 20
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

    const safeTop = sys.safeAreaInsets?.top ?? sys.safeArea?.top ?? statusBarHeight
    const status = Math.max(safeTop, statusBarHeight)
    return {
      statusBarHeight: status,
      navBarHeight: 44,
      headerHeight: status + 44
    }
  } catch (e) {
    return fallback
  }
}

/** @deprecated 使用 getNavMetrics */
export function getNavPaddingTop() {
  return getNavMetrics().headerHeight
}
