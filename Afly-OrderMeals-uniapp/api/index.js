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
  list: () => get('/front/order/list'),
  detail: (orderId) => get('/front/order/detail', { orderId }),
  cancel: (orderId, reason) => post('/front/order/cancel', null, { orderId, reason })
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
