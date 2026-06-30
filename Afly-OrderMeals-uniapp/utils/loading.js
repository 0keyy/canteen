let loadingInstance = null

export function setLoadingInstance(vm) {
  loadingInstance = vm
}

export function showLoading(tip = '加载中...') {
  if (loadingInstance && loadingInstance.show) {
    loadingInstance.show(tip)
  }
}

export function hideLoading() {
  if (loadingInstance && loadingInstance.hide) {
    loadingInstance.hide()
  }
}
