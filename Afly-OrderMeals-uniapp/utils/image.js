import { BASE_URL } from './config'

const API_ORIGIN = BASE_URL.replace(/\/api\/?$/, '')

// 服务器图片前缀，所有 /static 下的图片都从服务器加载
export const STATIC_IMAGE_PREFIX = 'https://canteen.zhongtang-group.com/api/uploads/image/static'

// 兼容旧引用
export const SERVER_IMAGE_PREFIX = 'https://canteen.zhongtang-group.com/api/uploads/image'

export function resolveImageUrl(url) {
  if (!url) return ''

  let value = String(url).trim()

  const nested = value.match(/^(https?:\/\/[^/]+(?:\/api\/uploads)?\/)(https?:\/\/.+)$/i)
  if (nested) {
    value = nested[2]
  }

  if (/^https?:\/\//i.test(value)) {
    return value
  }

  if (value.startsWith('//')) {
    return `https:${value}`
  }

  const path = value.startsWith('/') ? value : `/${value}`
  if (path.startsWith('/api/')) {
    return `${API_ORIGIN}${path}`
  }
  return `${API_ORIGIN}/api/uploads${path}`
}
