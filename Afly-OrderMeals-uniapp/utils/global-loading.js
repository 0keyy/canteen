export function showGlobalLoading(tip = '加载中...') {
  uni.$emit('__global_loading_show__', tip)
}

export function hideGlobalLoading() {
  uni.$emit('__global_loading_hide__')
}

export function getMinDuration() {
  return 300
}
