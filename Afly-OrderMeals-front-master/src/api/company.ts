import request from '@/utils/request'

export function companyAuthList(params?: any) {
    return request.get({ url: '/company/auth/list', params })
}

export function companyPointsLogList(params?: any) {
    return request.get({ url: '/company/points/log/list', params })
}

export function companyGrantPoints(userId: number) {
    return request.post(
        { url: '/company/points/grant', params: { userId } },
        { isParamsToData: false }
    )
}

export function companyGrantPointsAll() {
    return request.post({ url: '/company/points/grant/all' })
}
