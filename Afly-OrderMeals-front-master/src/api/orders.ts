import request from '@/utils/request'

export function ordersList(params?: any) {
    return request.get({ url: '/orders/list', params })
}

export function getOrdersCurrent(params?: any) {
    return request.get({ url: '/orders/current', params })
}
