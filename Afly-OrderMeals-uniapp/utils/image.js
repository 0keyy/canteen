import { BASE_URL } from './config'

const API_ORIGIN = BASE_URL.replace(/\/api\/?$/, '')

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
