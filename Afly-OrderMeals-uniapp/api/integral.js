import { request } from '../utils/request.js'

// ========== 积分商城商品接口（你缺的这段）==========
export function getIntegralGoodsList() {
  return request({
    url: '/api/integral/goods/list',
    method: 'GET'
  })
}

// ========== 积分抽奖接口（原来就有的）==========
export function getDrawPrizeList() {
  return request({
    url: '/api/integral/draw/prizeList',
    method: 'GET'
  })
}

export function startDrawApi() {
  return request({
    url: '/api/integral/draw/start',
    method: 'POST'
  })
}