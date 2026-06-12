import { authApi } from '../../api/index'
import { saveLoginResult } from './index'

export async function weixinLogin() {
  const loginRes = await new Promise((resolve, reject) => {
    uni.login({
      provider: 'weixin',
      success: resolve,
      fail: reject
    })
  })

  if (!loginRes.code) {
    throw new Error('微信授权失败，请重试')
  }

  const result = await authApi.wxLogin(loginRes.code)
  if (!result.token) {
    throw new Error('登录失败，请检查小程序 AppID 与后端配置是否一致')
  }
  saveLoginResult(result)
  return result
}
