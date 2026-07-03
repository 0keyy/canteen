import { BASE_URL } from './config'

const API_ORIGIN = BASE_URL.replace(/\/api\/?$/, '')

export const STATIC_IMAGE_PREFIX = 'https://canteen.zhongtang-group.com/api/uploads/image/static'

export function resolveStaticUrl(path) {
  if (!path) return ''
  if (/^https?:\/\//i.test(path)) return path
  const p = path.startsWith('/') ? path : `/${path}`
  return `${STATIC_IMAGE_PREFIX}${p}`
}

export function resolveImageUrl(url) {
  if (!url) return ''

  let value = String(url).trim()

  // 处理嵌套 URL
  const nested = value.match(/^(https?:\/\/[^/]+(?:\/api\/uploads)?\/)(https?:\/\/.+)$/i)
  if (nested) {
    value = nested[2]
  }

  // ⭐ 关键修改：只要是以 http:// 或 https:// 开头，都强制转成 https://
  if (/^https?:\/\//i.test(value)) {
    return value.replace(/^http:/i, 'https:')  // 替换协议
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