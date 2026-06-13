import request from '@/utils/request'

export function creditConfigDetail() {
    return request.get({ url: '/company/credit/config/detail' })
}

export function creditConfigSave(data: {
    creditEnable: number
    roleConfigs: Array<{
        roleId: number
        roleName: string
        monthlyLimit: number
        isEnable: number
    }>
}) {
    return request.post({ url: '/company/credit/config/save', data })
}

export function creditLogList(params?: any) {
    return request.get({ url: '/company/credit/log/list', params })
}

export function creditMonthlyStats(params?: any) {
    return request.get({ url: '/company/credit/stats/monthly', params })
}

export function creditLogSync() {
    return request.post({ url: '/company/credit/log/sync' })
}
