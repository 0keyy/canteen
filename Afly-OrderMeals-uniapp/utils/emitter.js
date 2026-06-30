import { showLoading, hideLoading } from './loading'

export function emitShowLoading(tip = '加载中...') {
  showLoading(tip)
  uni.$emit('__page_loading_show__', tip)
}

export function emitHideLoading() {
  hideLoading()
  uni.$emit('__page_loading_hide__')
}
