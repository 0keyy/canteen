function endpoint(path) {
  return new URL('/api/' + path, window.location.origin)
}

async function request(url, options) {
  const response = await fetch(url, options)
  const payload = await response.json().catch(() => null)
  if (!payload || typeof payload !== 'object') {
    throw new Error(response.ok ? '服务器返回格式错误' : `请求失败（${response.status}）`)
  }
  if (!response.ok || payload.code !== 200) {
    throw new Error(payload.msg || '请求失败')
  }
  return payload.data
}

export function get(path) {
  return (params = {}) => {
    const url = endpoint(path)
    for (const [key, value] of Object.entries(params)) {
      if (value != null) {
        url.searchParams.set(key, value)
      }
    }
    return request(url)
  }
}

export function post(path) {
  return (params = {}) => request(endpoint(path), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params)
  })
}
