import { showLoading, hideLoading } from './loading'

let hideTimer = null

function autoHideLoading(delay = 500) {
  if (hideTimer) clearTimeout(hideTimer)
  hideTimer = setTimeout(() => {
    hideLoading()
    hideTimer = null
  }, delay)
}

export function navigateTo(options) {
  showLoading()
  const originalSuccess = options.success
  const originalFail = options.fail
  const originalComplete = options.complete

  return uni.navigateTo({
    ...options,
    success: (res) => {
      autoHideLoading(300)
      if (originalSuccess) originalSuccess(res)
    },
    fail: (err) => {
      hideLoading()
      if (originalFail) originalFail(err)
    },
    complete: (res) => {
      if (originalComplete) originalComplete(res)
    }
  })
}

export function redirectTo(options) {
  showLoading()
  const originalSuccess = options.success
  const originalFail = options.fail

  return uni.redirectTo({
    ...options,
    success: (res) => {
      autoHideLoading(300)
      if (originalSuccess) originalSuccess(res)
    },
    fail: (err) => {
      hideLoading()
      if (originalFail) originalFail(err)
    }
  })
}

export function switchTab(options) {
  showLoading()
  const originalSuccess = options.success
  const originalFail = options.fail

  return uni.switchTab({
    ...options,
    success: (res) => {
      autoHideLoading(300)
      if (originalSuccess) originalSuccess(res)
    },
    fail: (err) => {
      hideLoading()
      if (originalFail) originalFail(err)
    }
  })
}

export function reLaunch(options) {
  showLoading()
  const originalSuccess = options.success
  const originalFail = options.fail

  return uni.reLaunch({
    ...options,
    success: (res) => {
      autoHideLoading(300)
      if (originalSuccess) originalSuccess(res)
    },
    fail: (err) => {
      hideLoading()
      if (originalFail) originalFail(err)
    }
  })
}

export function navigateBack(options) {
  showLoading()
  const originalSuccess = options?.success
  const originalFail = options?.fail

  return uni.navigateBack({
    ...options,
    success: (res) => {
      autoHideLoading(200)
      if (originalSuccess) originalSuccess(res)
    },
    fail: (err) => {
      hideLoading()
      if (originalFail) originalFail(err)
    }
  })
}

export default {
  navigateTo,
  redirectTo,
  switchTab,
  reLaunch,
  navigateBack,
  showLoading,
  hideLoading
}
