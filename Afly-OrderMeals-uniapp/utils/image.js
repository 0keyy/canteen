import { BASE_URL } from './config'

const API_ORIGIN = BASE_URL.replace(/\/api\/?$/, '')

export const STATIC_IMAGE_PREFIX = 'https://backend.zhongtang-group.com/api/uploads/image/static'
export const SERVER_IMAGE_PREFIX = 'https://backend.zhongtang-group.com/api/uploads/image'

// 辅助函数：强制将 http 转为 https
function ensureHttps(url) {
  if (!url) return url
  return url.replace(/^http:/i, 'https:')
}

export function resolveImageUrl(url) {
  if (!url) return ''

  let value = String(url).trim()

  // 处理可能存在的嵌套 URL
  const nested = value.match(/^(https?:\/\/[^/]+(?:\/api\/uploads)?\/)(https?:\/\/.+)$/i)
  if (nested) {
    value = nested[2]
  }

  // 1. 已经是完整的 http/https 链接
  if (/^https?:\/\//i.test(value)) {
    return ensureHttps(value)  // 强制转为 https
  }

  // 2. 以 // 开头（协议相对 URL）
  if (value.startsWith('//')) {
    return `https:${value}`   // 直接补 https
  }

  // 3. 以 /api/ 开头的路径
  const path = value.startsWith('/') ? value : `/${value}`
  let fullUrl
  if (path.startsWith('/api/')) {
    fullUrl = `${API_ORIGIN}${path}`
  } else {
    fullUrl = `${API_ORIGIN}/api/uploads${path}`
  }

  // 强制将最终结果的 http 替换为 https
  return ensureHttps(fullUrl)
}