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
