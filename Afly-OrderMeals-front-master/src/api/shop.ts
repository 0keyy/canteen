import request from '@/utils/request'

export function getShopConfig(params?: any) {
    return request.get({ url: '/shop/config', params })
}

export function changeShopStatus(params?: any) {
    return request.get({ url: '/shop/change', params })
}

export function saveShopConfig(params?: any) {
    return request.post({ url: '/shop/save', params })
}

export function getPrinterList(params?: any) {
    return request.get({ url: '/printer/list', params })
}

export function getPrinterDetail(params?: any) {
    return request.get({ url: '/printer/detail', params })
}

export function addPrinter(params?: any) {
    return request.post({ url: '/printer/add', params })
}
