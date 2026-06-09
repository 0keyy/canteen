import { authApi } from '../../api/index'
import { saveLoginResult } from './index'

export async function alipayPhoneLogin() {
  const authCode = await new Promise((resolve, reject) => {
    my.getAuthCode({
      scopes: ['auth_user'],
      success: (res) => resolve(res.authCode),
      fail: reject
    })
  })

  const aliLogin = await authApi.aliLogin(authCode)
  if (aliLogin.token && !aliLogin.needBindPhone) {
    saveLoginResult(aliLogin)
    return aliLogin
  }

  const result = await authApi.aliPhone(authCode)
  saveLoginResult(result)
  return result
}
