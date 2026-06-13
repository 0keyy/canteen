import request from '@/utils/request'

// 模板列表
export function couponTemplateList(params?: any) {
    return request.get({ url: '/coupon/template/list', params })
}

// 模板详情
export function couponTemplateDetail(params: any) {
    return request.get({ url: '/coupon/template/detail', params })
}

// 新增模板
export function couponTemplateAdd(params: any) {
    return request.post({ url: '/coupon/template/add', params })
}

// 编辑模板
export function couponTemplateEdit(params: any) {
    return request.post({ url: '/coupon/template/edit', params })
}

// 删除模板
export function couponTemplateDel(params: any) {
    return request.post({ url: '/coupon/template/del', params })
}

// 状态切换
export function couponTemplateStatus(params: any) {
    return request.post({ url: '/coupon/template/change', params })
}

// 核销验证
export function couponVerify(params: any) {
    return request.post({ url: '/coupon/verify', params })
}
