import axios from 'ts-axios-new'
const urlMap = {
  development: 'http://192.168.2.17:8082/api/',
  // 与 H5 同域，由 8084 站点 Nginx 反代 /api/ -> 8082
  production: '/api/'
}
const baseUrl = urlMap[process.env.NODE_ENV]
const ERR_OK = 200

function rejectWithMessage(err) {
  const body = err.response && err.response.data
  if (body && typeof body === 'object' && body.msg) {
    return Promise.reject(new Error(body.msg))
  }
  if (err.message) {
    return Promise.reject(err)
  }
  return Promise.reject(
    new Error('网络异常：请确认后端 like-admin 已启动（默认端口 8082）')
  )
}

export function get(url) {
  return function(params = {}) {
    return axios
      .get(baseUrl + url, {
        params
      })
      .then((res) => {
        const payload = res.data
        if (!payload || typeof payload !== 'object') {
          return Promise.reject(new Error('服务器返回格式错误'))
        }
        const { code, data, msg } = payload
        if (code === ERR_OK) {
          return data
        }
        return Promise.reject(new Error(msg || '请求失败'))
      })
      .catch((err) => rejectWithMessage(err))
  }
}

export function post(url) {
  return function(params = {}) {
    return axios
      .post(baseUrl + url, params)
      .then((res) => {
        const payload = res.data
        if (!payload || typeof payload !== 'object') {
          return Promise.reject(new Error('服务器返回格式错误'))
        }
        const { code, data, msg } = payload
        if (code === ERR_OK) {
          return data
        }
        return Promise.reject(new Error(msg || '请求失败'))
      })
      .catch((err) => rejectWithMessage(err))
  }
}
