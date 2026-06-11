<template>
    <div class="miniapp-orders">
        <el-card class="!border-none" shadow="never">
            <el-tabs v-model="activeTab" @tab-change="onTabChange">
                <el-tab-pane label="制作中" name="processing" />
                <el-tab-pane label="待取餐" name="called" />
                <el-tab-pane label="已完成" name="done" />
                <el-tab-pane label="全部" name="all" />
            </el-tabs>
            <el-form :inline="true" class="mb-[-16px]">
                <el-form-item label="就餐方式" class="w-[220px]">
                    <el-select v-model="queryParams.diningMode" class="w-[220px]" clearable placeholder="全部">
                        <el-option label="堂食/自提" :value="1" />
                        <el-option label="外带" :value="2" />
                        <el-option label="外卖" :value="3" />
                    </el-select>
                </el-form-item>
                <el-form-item label="手机号" class="w-[220px]">
                    <el-input v-model="queryParams.contactMobile" placeholder="联系人手机号" clearable />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetPage">查询</el-button>
                    <el-button @click="resetParams">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <el-card class="!border-none mt-4" shadow="never">
            <el-table v-loading="pager.loading" :data="pager.lists" row-key="id">
                <el-table-column label="取餐码" prop="pickupCode" width="90">
                    <template #default="{ row }">
                        <span class="pickup-code">{{ row.pickupCode || '-' }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="订单号" prop="number" min-width="160" show-overflow-tooltip />
                <el-table-column label="金额" prop="amount" width="90" />
                <el-table-column label="就餐方式" width="100" :formatter="(row) => diningModeText(row.diningMode)" />
                <el-table-column label="联系人" width="100" prop="contactName" />
                <el-table-column label="手机号" width="120" prop="contactMobile" />
                <el-table-column label="支付方式" width="90" :formatter="(row) => payTypeText(row.payType)" />
                <el-table-column label="状态" width="100">
                    <template #default="{ row }">
                        <el-tag :type="statusTagType(row)" size="small">{{ statusText(row) }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="下单时间" prop="submitTime" width="170" />
                <el-table-column label="叫号时间" prop="calledTime" width="170" />
                <el-table-column label="操作" width="220" fixed="right">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="handleViewDishes(row)">菜品</el-button>
                        <el-button
                            v-if="canCall(row)"
                            type="warning"
                            link
                            @click="handleCall(row)"
                        >叫号</el-button>
                        <el-button
                            v-if="canComplete(row)"
                            type="success"
                            link
                            @click="handleComplete(row)"
                        >完成</el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pager" @change="getLists" />
            </div>
        </el-card>

        <el-dialog v-model="dishDialogVisible" title="已点菜品" width="520px">
            <el-table v-loading="dishLoading" :data="dishList" empty-text="暂无菜品">
                <el-table-column label="菜品名称" prop="name" min-width="160" />
                <el-table-column label="数量" prop="number" width="80" />
                <el-table-column label="单价" prop="amount" width="100" />
            </el-table>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { ordersCall, ordersComplete, ordersDish, ordersList } from '@/api/orders'
import { usePaging } from '@/hooks/usePaging'
import feedback from '@/utils/feedback'

const activeTab = ref('processing')
const dishDialogVisible = ref(false)
const dishLoading = ref(false)
const dishList = ref<any[]>([])

const queryParams = reactive({
    channel: 'miniapp',
    diningMode: '',
    contactMobile: '',
    status: 1,
    payStatus: 1,
    called: 0
})

const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: ordersList,
    params: queryParams
})

const diningModeText = (mode?: number) => {
    if (mode === 1) return '堂食/自提'
    if (mode === 2) return '外带'
    if (mode === 3) return '外卖'
    return '-'
}

const payTypeText = (payType?: string) => {
    if (payType === 'balance') return '余额'
    if (payType === 'wxpay') return '微信'
    if (payType === 'alipay') return '支付宝'
    if (payType === 'aggregate') return '在线支付'
    return payType || '-'
}

const statusText = (row: any) => {
    if (row.status === 4 && row.payStatus === 0) return '待支付'
    if (row.status === 3) return '已取消'
    if (row.status === 2) return '已完成'
    if (row.status === 1 && row.payStatus === 1) {
        return row.calledTime && row.calledTime !== '-' ? '待取餐' : '制作中'
    }
    return '未知'
}

const statusTagType = (row: any) => {
    const text = statusText(row)
    if (text === '制作中') return 'warning'
    if (text === '待取餐') return 'success'
    if (text === '已完成') return 'info'
    if (text === '待支付') return 'danger'
    return ''
}

const canCall = (row: any) => row.status === 1 && row.payStatus === 1 && (!row.calledTime || row.calledTime === '-')
const canComplete = (row: any) => row.status === 1 && row.payStatus === 1

const applyTab = (tab: string) => {
    queryParams.channel = 'miniapp'
    queryParams.diningMode = ''
    queryParams.contactMobile = ''
    if (tab === 'processing') {
        queryParams.status = 1
        queryParams.payStatus = 1
        queryParams.called = 0
    } else if (tab === 'called') {
        queryParams.status = 1
        queryParams.payStatus = 1
        queryParams.called = 1
    } else if (tab === 'done') {
        queryParams.status = 2
        queryParams.payStatus = ''
        queryParams.called = ''
    } else {
        queryParams.status = ''
        queryParams.payStatus = ''
        queryParams.called = ''
    }
}

const onTabChange = (tab: string) => {
    applyTab(tab)
    resetPage()
}

const handleViewDishes = async (row: { id: number }) => {
    dishDialogVisible.value = true
    dishLoading.value = true
    dishList.value = []
    try {
        dishList.value = await ordersDish({ id: row.id })
    } finally {
        dishLoading.value = false
    }
}

const handleCall = async (row: { id: number; pickupCode?: string }) => {
    try {
        await feedback.confirm(`确定叫号取餐码 ${row.pickupCode || row.id} 吗？`)
        await ordersCall(row.id)
        feedback.notifySuccess('叫号成功')
        getLists()
    } catch {
        // 用户取消或接口失败（失败时 request 层已提示）
    }
}

const handleComplete = async (row: { id: number; pickupCode?: string }) => {
    try {
        await feedback.confirm(`确认取餐码 ${row.pickupCode || row.id} 已取餐并完成订单吗？`)
        await ordersComplete(row.id)
        feedback.notifySuccess('订单已完成')
        getLists()
    } catch {
        // 用户取消或接口失败（失败时 request 层已提示）
    }
}

applyTab(activeTab.value)
getLists()
</script>

<style scoped>
.pickup-code {
    font-size: 18px;
    font-weight: 700;
    color: #e6a23c;
    letter-spacing: 2px;
}
</style>
