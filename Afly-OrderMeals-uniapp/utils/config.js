import {
  DEV_API_BASE_URL,
  PROD_API_BASE_URL,
  WX_APP_NAME
} from '../config/weixin.js'

export { WX_APP_NAME }

export const BASE_URL = process.env.NODE_ENV === 'development' ? DEV_API_BASE_URL : PROD_API_BASE_URL
export const MOCK_LOGIN = false
export const DEFAULT_MOCK_MOBILE = '13800138000'
export const DEFAULT_SHOP_ID = 1
