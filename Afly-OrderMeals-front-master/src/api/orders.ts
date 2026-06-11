import request from '@/utils/request'

export function ordersList(params?: any) {
    return request.get({ url: '/orders/list', params })
}

export function getOrdersCurrent(params?: any) {
    return request.get({ url: '/orders/current', params })
}

export function ordersDish(params?: { id: number }) {
    return request.get({ url: '/orders/dish', params })
}

export function ordersCall(orderId: number) {
    return request.post({ url: '/orders/call', params: { orderId } })
}

export function ordersComplete(orderId: number) {
    return request.post({ url: '/orders/complete', params: { orderId } })
}
