const DEV_BASE_URL = 'http://localhost:8082/api'
const PROD_BASE_URL = '/api'

export const BASE_URL = process.env.NODE_ENV === 'development' ? DEV_BASE_URL : PROD_BASE_URL
export const MOCK_LOGIN = process.env.NODE_ENV === 'development'
export const DEFAULT_MOCK_MOBILE = '13800138000'
export const DEFAULT_SHOP_ID = 1
