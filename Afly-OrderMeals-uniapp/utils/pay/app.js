export function appPay(payInfo) {
  return new Promise((resolve, reject) => {
    const provider = payInfo.payChannel === 'alipay' ? 'alipay' : 'wxpay'
    uni.requestPayment({
      provider,
      orderInfo: payInfo.tradeNo || payInfo.packageValue,
      success: resolve,
      fail: reject
    })
  })
}
