import request from '@/utils/request'

export function orderDeskList(params?: any) {
    return request.get({ url: '/order/list', params }) //全部桌号
}

export function dishCateAll(params?: any) {
    return request.get({ url: '/order/dish/cate', params }) //菜品分类
}

export function dishListAll(params?: any) {
    return request.get({ url: '/order/dish/list', params }) //全部菜品
}

export function createOrders(params?: any) {
    return request.post({ url: '/order/create', params }) //创建订单
}

export function dishAdd(params?: any) {
    return request.get({ url: '/order/dishAdd', params }) //添加菜品
}

export function dishDel(params?: any) {
    return request.get({ url: '/order/dishDel', params }) //删除菜品
}

export function dishInc(params?: any) {
    return request.get({ url: '/order/dishInc', params }) //菜品+1
}

export function dishDec(params?: any) {
    return request.get({ url: '/order/dishDec', params }) //菜品-1
}

export function toEmptyy(params?: any) {
    return request.get({ url: '/order/toEmpty', params })
}

export function orderSubmit(params?: any) {
    return request.post({ url: '/order/submit', params })
}

export function orderCheckout(params?: any) {
    return request.get({ url: '/order/checkout', params })
}
