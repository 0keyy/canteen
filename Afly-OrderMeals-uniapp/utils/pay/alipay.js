export function aliPay(payInfo) {
  return new Promise((resolve, reject) => {
    uni.requestPayment({
      provider: 'alipay',
      orderInfo: payInfo.tradeNo,
      success: resolve,
      fail: reject
    })
  })
}
