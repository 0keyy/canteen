import request from '@/utils/request'

export function companyAuthList(params?: any) {
    return request.get({ url: '/company/auth/list', params })
}

export function companyPointsLogList(params?: any) {
    return request.get({ url: '/company/points/log/list', params })
}

export function companyGrantPoints(userId: number, amount?: number) {
    const data: { userId: number; amount?: number } = { userId }
    if (amount != null && amount > 0) {
        data.amount = amount
    }
    return request.post({ url: '/company/points/grant', data })
}

export function companyGrantPointsAll(amount?: number) {
    const data: { amount?: number } = {}
    if (amount != null && amount > 0) {
        data.amount = amount
    }
    return request.post({ url: '/company/points/grant/all', data })
}
