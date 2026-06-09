import { authApi } from '../../api/index'
import { saveLoginResult } from './index'

export async function appSmsLogin() {
  const mobile = await promptMobile()
  await authApi.smsSend(mobile)
  const code = await promptCode()
  const result = await authApi.smsLogin(mobile, code)
  saveLoginResult(result)
  return result
}

function promptMobile() {
  return new Promise((resolve, reject) => {
    uni.$once('app-sms-mobile', resolve)
    uni.$once('app-sms-cancel', () => reject(new Error('用户取消登录')))
    uni.navigateTo({ url: '/pages/login/index?action=sms' })
  })
}

function promptCode() {
  return new Promise((resolve, reject) => {
    uni.$once('app-sms-code', resolve)
    uni.$once('app-sms-cancel', () => reject(new Error('用户取消登录')))
  })
}

export function submitAppSms(mobile, code) {
  uni.$emit('app-sms-mobile', mobile)
  uni.$emit('app-sms-code', code)
}
