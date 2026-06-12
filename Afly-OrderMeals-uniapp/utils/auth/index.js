import { authApi } from '../../api/index'

// #ifdef MP-WEIXIN
import { weixinLogin } from './weixin'
// #endif

// #ifdef MP-ALIPAY
import { alipayPhoneLogin } from './alipay'
// #endif

// #ifdef APP-PLUS
import { appSmsLogin } from './app'
// #endif

export async function loginWithPhone() {
  // #ifdef MP-WEIXIN
  return weixinLogin()
  // #endif

  // #ifdef MP-ALIPAY
  return alipayPhoneLogin()
  // #endif

  // #ifdef APP-PLUS
  return appSmsLogin()
  // #endif

  // #ifndef MP-WEIXIN || MP-ALIPAY || APP-PLUS
  throw new Error('当前平台暂不支持一键登录')
  // #endif
}

export function saveLoginResult(result) {
  if (result.token) {
    uni.setStorageSync('token', result.token)
  }
  if (result.userId) {
    uni.setStorageSync('userId', result.userId)
  }
  if (result.mobile) {
    uni.setStorageSync('mobile', result.mobile)
  }
  if (result.nickname) {
    uni.setStorageSync('nickname', result.nickname)
  }
}

export async function fetchProfile() {
  const profile = await authApi.profile()
  uni.setStorageSync('nickname', profile.nickname || '')
  uni.setStorageSync('mobile', profile.mobile || '')
  return profile
}
