import { payApi } from '../../api/index'
import { PAY_CHANNEL } from './channels'

// #ifdef MP-WEIXIN
import { wxPay } from './weixin'
// #endif

// #ifdef MP-ALIPAY
import { aliPay } from './alipay'
// #endif

// #ifdef APP-PLUS
import { appPay } from './app'
// #endif

export { PAY_CHANNEL, DEFAULT_PAY_CHANNEL } from './channels'

/**
 * 发起订单支付
 * @param {number} orderId
 * @param {string} payChannel balance | aggregate | wxpay | alipay
 * @param {string} payScene mp | app
 */
export async function payOrder(orderId, payChannel, payScene = 'mp') {
  const payInfo = await payApi.create({ orderId, payChannel, payScene })

  // 余额等同步支付，后端已完成扣款
  if (payInfo.completed) {
    return payInfo
  }

  // 聚合支付暂未开通
  if (payChannel === PAY_CHANNEL.AGGREGATE) {
    throw new Error('聚合支付暂未开通，请使用余额支付')
  }

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
