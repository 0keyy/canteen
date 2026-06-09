export function wxPay(payInfo) {
  return new Promise((resolve, reject) => {
    uni.requestPayment({
      provider: 'wxpay',
      timeStamp: payInfo.timeStamp,
      nonceStr: payInfo.nonceStr,
      package: payInfo.packageValue,
      signType: payInfo.signType,
      paySign: payInfo.paySign,
      success: resolve,
      fail: reject
    })
  })
}
