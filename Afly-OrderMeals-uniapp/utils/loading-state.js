let _needShowLoading = false

export function needShowLoading() {
  return _needShowLoading
}

export function setNeedShowLoading(val) {
  _needShowLoading = val
}