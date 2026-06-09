import { payApi } from '../../api/index'

// #ifdef MP-WEIXIN
import { wxPay } from './weixin'
// #endif

// #ifdef MP-ALIPAY
import { aliPay } from './alipay'
// #endif

// #ifdef APP-PLUS
import { appPay } from './app'
// #endif

export async function payOrder(orderId, payChannel, payScene) {
  const payInfo = await payApi.create({ orderId, payChannel, payScene })

  if (payInfo.mockPay) {
    await payApi.mockSuccess(payInfo.outTradeNo)
    return payInfo
  }

  // #ifdef MP-WEIXIN
  await wxPay(payInfo)
  // #endif

  // #ifdef MP-ALIPAY
  await aliPay(payInfo)
  // #endif

  // #ifdef APP-PLUS
  await appPay(payInfo)
  // #endif

  return payInfo
}
