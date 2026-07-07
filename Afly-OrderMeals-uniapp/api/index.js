import { get, post } from '../utils/request'

export const authApi = {
  wxLogin: (code) => post('/front/auth/wx/login', { code }),
  wxPhone: (openid, phoneCode) => post('/front/auth/wx/phone', { openid, phoneCode }),
  aliLogin: (authCode) => post('/front/auth/ali/login', { authCode }),
  aliPhone: (authCode) => post('/front/auth/ali/phone', { authCode }),
  smsSend: (mobile) => post('/front/auth/app/sms/send', { mobile }),
  smsLogin: (mobile, code) => post('/front/auth/app/sms/login', { mobile, code }),
  mockPhoneLogin: (mobile) => post('/front/auth/mock/phone', { mobile }),
  profile: () => get('/front/auth/profile'),
  
  
  updateProfile: (data) => post('/front/auth/profile/update', data),
  
  
  logout: () => post('/front/auth/logout')
}

export const companyApi = {
  deptList: () => get('/front/company/dept/list'),
  status: () => get('/front/company/status'),
  auth: (data) => post('/front/company/auth', data)
}

export const orderApi = {
  shop: (aid) => get('/front/order/shop', { aid }),
  menu: (aid) => get('/front/order/menu', { aid }),
  cartCreate: (data) => post('/front/order/cart/create', data),
  cartHas: (aid) => get('/front/order/cart/has', { aid }),
  dishAdd: (orderId, dishId) => post('/front/order/cart/dishAdd', { orderId, dishId }),
  dishInc: (id) => post('/front/order/cart/dishInc', null, { id }),
  dishDec: (id) => post('/front/order/cart/dishDec', null, { id }),
  dishDel: (id) => post('/front/order/cart/dishDel', null, { id }),
  toEmpty: (orderId) => post('/front/order/cart/toEmpty', null, { orderId }),
  submit: (data) => post('/front/order/submit', data),
  list: (status, page = 1, pageSize = 20) => get('/front/order/list', { status, page, pageSize }),
    detail: (orderId) => get('/front/order/detail', { orderId }),
    cancel: (orderId, reason) => post('/front/order/cancel', null, { orderId, reason }),
    confirmReceive: (orderId) => post('/front/order/confirmReceive', null, { orderId })
  }

export const addressApi = {
  list: () => get('/front/address/list'),
  detail: (id) => get('/front/address/detail', { id }),
  save: (data) => post('/front/address/save', data),
  delete: (id) => post('/front/address/delete', null, { id }),
  setDefault: (id) => post('/front/address/setDefault', null, { id })
}

export const decorateApi = {
  tabbar: () => get('/front/decorate/tabbar'),
  page: (id = 1) => get('/front/decorate/page', { id })
}

export const payApi = {
  methods: (orderId) => get('/front/pay/methods', { orderId }),
  create: (data) => post('/front/pay/create', data),
  mockSuccess: (outTradeNo) => post('/front/pay/mock/success', null, { outTradeNo }),
  status: (outTradeNo) => get('/front/pay/status', { outTradeNo })
}

export const couponApi = {
  center: () => get('/front/coupon/center'),
  claim: (templateId) => post('/front/coupon/claim', { templateId }),
  myCoupons: (status) => get('/front/coupon/my', { status }),
  bestForOrder: (orderId) => get('/front/coupon/bestForOrder', { orderId }),
  verifyCode: (userCouponId) => get('/front/coupon/verifyCode', { userCouponId })
}

export const walletApi = {
  balance: () => get('/front/wallet/balance'),
  rechargeCreate: (amount) => post('/front/wallet/recharge/create', { amount }),
  rechargeList: (page = 1, pageSize = 20) => get('/front/wallet/recharge/list', { page, pageSize }),
  transactionList: (page = 1, pageSize = 20) => get('/front/wallet/transaction/list', { page, pageSize })
}

export const serviceApi = {
  hotline: () => get('/front/service/hotline')
}

export const memberApi = {
  code: () => get('/front/member/code')
}

export const integralApi = {
  categoryList: () => get('/front/integral/category/list'),
  goodsList: (categoryId, page = 1, pageSize = 20) => get('/front/integral/goods/list', { categoryId, page, pageSize }),
  exchange: (goodsId) => post('/front/integral/goods/exchange', { goodsId }),
  recordList: (page = 1, pageSize = 20) => get('/front/integral/record/list', { page, pageSize }),
  exchangeList: (page = 1, pageSize = 20) => get('/front/integral/exchange/list', { page, pageSize }),
  rules: () => get('/front/integral/rules')
}

export const signinApi = {
  status: () => get('/front/signin/status'),
  sign: () => post('/front/signin/sign'),
  rewards: () => get('/front/signin/rewards')
}

export const lotteryApi = {
  info: () => get('/front/lottery/info'),
  draw: () => post('/front/lottery/draw'),
  prizes: () => get('/front/lottery/prizes')
}

// 客服聊天 API
export const chatApi = {
  // 获取聊天历史记录
  // params: { page, pageSize }
  history: (params = {}) => get('/front/chat/history', params),

  // 发送消息
  // data: { content, type: 'text'|'image'|'voice', extra? }
  send: (data) => post('/front/chat/send', data),

  // 获取客服在线状态
  onlineStatus: () => get('/front/chat/online'),

  // 上报用户已读状态
  read: (msgId) => post('/front/chat/read', { msgId }),

  // 上传图片/语音
  upload: (filePath, type = 'image') => {
    return new Promise((resolve, reject) => {
      uni.uploadFile({
        url: BASE_URL + '/front/chat/upload',
        filePath,
        name: 'file',
        formData: { type },
        header: { token: uni.getStorageSync('token') },
        success: (res) => {
          try {
            const data = JSON.parse(res.data)
            resolve(data)
          } catch (e) {
            reject(e)
          }
        },
        fail: reject
      })
    })
  }
}
