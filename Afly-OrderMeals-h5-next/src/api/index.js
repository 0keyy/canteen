import { get, post } from './helpers'

const getSeller = get('fr/seller')
const getGoods = get('fr/goods')
const getDesk = get('fr/desk')
const createOrders = post('fr/create')
const hasCurrentOrders = get('fr/has')
const dishAdd = get('fr/dishAdd')
const dishDel = get('fr/dishDel')
const dishInc = get('fr/dishInc')
const dishDec = get('fr/dishDec')
const toEmpty = get('fr/toEmpty')
const submit = post('fr/submit')

export {
  getSeller,
  getGoods,
  getDesk,
  createOrders,
  hasCurrentOrders,
  dishAdd,
  dishDel,
  dishInc,
  dishDec,
  toEmpty,
  submit
}

// The ratings panel uses the legacy demo endpoint.
export async function getRatings() {
  const response = await fetch('/api/ratings')
  const payload = await response.json()
  if (!response.ok || payload.errno !== 0) {
    throw new Error(payload.msg || '获取评价失败')
  }
  return payload.data
}
