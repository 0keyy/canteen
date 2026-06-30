export function showGlobalLoading(tip = '加载中...') {
  uni.$emit('__global_loading_show__', tip)
}

export function hideGlobalLoading() {
  uni.$emit('__global_loading_hide__')
}
