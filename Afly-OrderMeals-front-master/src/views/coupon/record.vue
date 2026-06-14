<template>
    <div class="coupon-record">
        <el-card class="!border-none" shadow="never">
            <el-form ref="formRef" class="mb-[-16px]" :model="queryParams" :inline="true">
                <el-form-item label="状态">
                    <el-select class="w-[280px]" v-model="queryParams.status" clearable>
                        <el-option label="全部" value />
                        <el-option label="已领取" :value="1" />
                        <el-option label="已使用" :value="2" />
                        <el-option label="已过期" :value="3" />
                    </el-select>
                </el-form-item>
                <el-form-item label="券类型">
                    <el-select class="w-[280px]" v-model="queryParams.type" clearable>
                        <el-option label="全部" value />
                        <el-option label="无门槛券" :value="1" />
                        <el-option label="满减券" :value="2" />
                        <el-option label="兑换券" :value="3" />
                        <el-option label="套餐券" :value="4" />
                        <el-option label="夜间券" :value="5" />
                    </el-select>
                </el-form-item>
                <el-form-item label="用户/券搜索">
                    <el-input
                        class="w-[280px]"
                        v-model="queryParams.userInfo"
                        clearable
                        placeholder="昵称/手机号/券名称"
                        @keyup.enter="resetPage"
                    />
                </el-form-item>
                <el-form-item label="领取时间">
                    <el-date-picker
                        v-model="claimTimeRange"
                        @change="onClaimTimeChange"
                        type="datetimerange"
                        range-separator="-"
                        start-placeholder="开始时间"
                        end-placeholder="结束时间"
                        value-format="x"
                    />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetPage">查询</el-button>
                    <el-button @click="handleReset">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>
        <el-card class="!border-none mt-4" shadow="never">
            <el-table class="mt-4" size="large" v-loading="pager.loading" :data="pager.lists">
                <el-table-column label="ID" prop="id" min-width="60" />
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="font-medium">
                            {{ row.userCompanyName || row.userRealName || row.userNickname || '-' }}
                        </div>
                        <div class="text-xs text-gray-400">
                            {{ row.userMobile || '-' }}
                            <span v-if="row.userNickname && row.userNickname !== (row.userCompanyName || row.userRealName)">
                                · {{ row.userNickname }}
                            </span>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="券名称" prop="templateName" min-width="140" show-overflow-tooltip />
                <el-table-column label="类型" min-width="90">
                    <template #default="{ row }">
                        <el-tag :type="typeTagStyle(row.type)" size="small">
                            {{ typeLabel(row.type) }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="优惠金额" min-width="90">
                    <template #default="{ row }">¥{{ row.discountAmount }}</template>
                </el-table-column>
                <el-table-column label="状态" min-width="90">
                    <template #default="{ row }">
                        <el-tag :type="statusTagStyle(row.status)" size="small">
                            {{ statusLabel(row.status) }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="领取时间" prop="claimTimeFormatted" min-width="160" />
                <el-table-column label="使用时间" prop="useTimeFormatted" min-width="160" />
                <el-table-column label="核销管理员" min-width="120">
                    <template #default="{ row }">
                        <span v-if="row.verifyAdminName">{{ row.verifyAdminName }}</span>
                        <span v-else>-</span>
                    </template>
                </el-table-column>
                <el-table-column label="核销时间" prop="verifyTimeFormatted" min-width="160" />
                <el-table-column label="关联订单" min-width="140">
                    <template #default="{ row }">
                        <span v-if="row.orderNumber">{{ row.orderNumber }}</span>
                        <span v-else>-</span>
                    </template>
                </el-table-column>
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pager" @change="getLists" />
            </div>
        </el-card>
    </div>
</template>

<script lang="ts" setup name="couponRecord">
import { couponRecordList } from '@/api/coupon'
import { usePaging } from '@/hooks/usePaging'

const queryParams = reactive({
    status: '' as any,
    type: '' as any,
    userInfo: '',
    claimTime: ''
})

const claimTimeRange = ref()

const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: couponRecordList,
    params: queryParams
})

const statusLabel = (status: number) => {
    const map: Record<number, string> = { 1: '已领取', 2: '已使用', 3: '已过期' }
    return map[status] || '未知'
}

const statusTagStyle = (status: number) => {
    const map: Record<number, string> = { 1: 'success', 2: '', 3: 'info' }
    return map[status] || 'info'
}

const typeLabel = (type: number) => {
    const map: Record<number, string> = { 1: '无门槛券', 2: '满减券', 3: '兑换券', 4: '套餐券', 5: '夜间券' }
    return map[type] || '未知'
}

const typeTagStyle = (type: number) => {
    const map: Record<number, string> = { 1: 'success', 2: 'primary', 3: 'warning', 4: 'warning', 5: 'danger' }
    return map[type] || 'info'
}

// 时间范围选择器 → 逗号分隔的秒级时间戳
const onClaimTimeChange = (val: any) => {
    if (val && val.length === 2) {
        queryParams.claimTime = Math.round(Number(val[0]) / 1000) + ',' + Math.round(Number(val[1]) / 1000)
    } else {
        queryParams.claimTime = ''
    }
}

// 重置时也清空时间选择器
const handleReset = () => {
    claimTimeRange.value = null
    resetParams()
}

onActivated(() => {
    getLists()
})

getLists()
</script>
