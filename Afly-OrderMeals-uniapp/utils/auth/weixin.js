import { authApi } from '../../api/index'
import { saveLoginResult } from './index'

export async function weixinPhoneLogin() {
  const loginRes = await new Promise((resolve, reject) => {
    uni.login({
      provider: 'weixin',
      success: resolve,
      fail: reject
    })
  })

  const wxLogin = await authApi.wxLogin(loginRes.code)
  if (wxLogin.token && !wxLogin.needBindPhone) {
    saveLoginResult(wxLogin)
    return wxLogin
  }

  const phoneCode = await getPhoneCode()
  const result = await authApi.wxPhone(wxLogin.openid, phoneCode)
  saveLoginResult(result)
  return result
}

function getPhoneCode() {
  return new Promise((resolve, reject) => {
    uni.$once('wx-phone-code', (code) => resolve(code))
    uni.$once('wx-phone-cancel', () => reject(new Error('用户取消授权')))
    uni.navigateTo({ url: '/pages/login/index?action=bindPhone' })
  })
}

export async function bindPhoneByButton(e) {
  if (!e.detail.code) {
    throw new Error('获取手机号失败')
  }
  uni.$emit('wx-phone-code', e.detail.code)
}
