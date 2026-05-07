import request from '@/utils/request'

// 列表
export function deptLists(params?: any) {
    return request.get({ url: '/system/dept/list', params })
}

// 添加
export function deptAdd(params: any) {
    return request.post({ url: '/system/dept/add', params })
}

// 编辑
export function deptEdit(params: any) {
    return request.post({ url: '/system/dept/edit', params })
}

// 删除
export function deptDelete(params: any) {
    return request.post({ url: '/system/dept/del', params })
}

// 详情
export function deptDetail(params?: any) {
    return request.get({ url: '/system/dept/detail', params })
}

//二维码
export function createQr(params?: any) {
    return request.get({ url: '/system/dept/createQR', params })
}
