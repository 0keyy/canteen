import { BASE_URL } from './config'

function buildUrl(url, params) {
  if (!params || Object.keys(params).length === 0) {
    return url
  }
  const query = Object.keys(params)
    .filter((key) => params[key] !== undefined && params[key] !== null)
    .map((key) => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
    .join('&')
  return `${url}?${query}`
}

export function request(options) {
  const token = uni.getStorageSync('token')
  const finalUrl = options.params ? buildUrl(options.url, options.params) : options.url
  const timeout = options.timeout || 30000

  return new Promise((resolve, reject) => {
    uni.request({
      url: BASE_URL + finalUrl,
      method: options.method || 'GET',
      data: options.data || {},
      timeout,
      header: {
        'Content-Type': 'application/json',
        'like-uniapp': token || ''
      },
      success(res) {
        const body = res.data || {}
        if (body.code === 200) {
          resolve(body.data)
        } else if (body.code === 401 || body.code === 310 || body.code === 332 || body.code === 333) {
          uni.removeStorageSync('token')
          uni.reLaunch({ url: '/pages/login/index' })
          reject(body.msg || '请先登录')
        } else {
          reject(body.msg || '请求失败')
        }
      },
      fail(err) {
        reject(err.errMsg || '网络错误')
      }
    })
  })
}

export function get(url, params) {
  return request({ url, method: 'GET', params })
}

export function post(url, data, params) {
  return request({ url, method: 'POST', data, params })
}
