<template>
    <div class="orders-lists">
        <el-card class="!border-none" shadow="never">
            <el-form :inline="true" class="mb-[-16px]">
                <el-form-item label="订单类型" class="w-[280px]">
                    <el-select class="w-[280px]" v-model="queryParams.type">
                        <el-option label="全部" value />
                        <el-option label="后台点单" value="0" />
                        <el-option label="扫码点单" value="1" />
                        <el-option label="小程序堂食自取" value="2" />
                        <el-option label="外带自取" value="3" />
                        <el-option label="外卖配送" value="4" />
                    </el-select>
                </el-form-item>
                <el-form-item label="订单状态" class="w-[280px]">
                    <el-select class="w-[280px]" v-model="queryParams.status">
                        <el-option label="全部" value />
                        <el-option label="待下单" value="0" />
                        <el-option label="待结帐" value="1" />
                        <el-option label="已完成" value="2" />
                    </el-select>
                </el-form-item>
                <el-form-item label="创建时间" class="w-[280px]">
                    <el-date-picker
                        v-model="createTime"
                        @change="setCreateTime"
                        type="datetimerange"
                        range-separator="-"
                        start-placeholder="开始时间"
                        end-placeholder="结束时间"
                    />
                </el-form-item>
                <el-form-item label="结账时间" class="w-[280px]">
                    <el-date-picker
                        v-model="checkoutTime"
                        @change="setCheckoutTime"
                        type="datetimerange"
                        range-separator="-"
                        start-placeholder="开始时间"
                        end-placeholder="结束时间"
                    />
                </el-form-item>
                <el-form-item class="w-[280px]">
                    <el-button type="primary" @click="resetPage">查询</el-button>
                    <el-button @click="resetParams">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>
        <el-card class="!border-none mt-4" shadow="never">
            <el-table v-loading="pager.loading" :data="pager.lists">
                <el-table-column type="index" min-width="80" />
                <el-table-column
                    label="订单号"
                    prop="number"
                    show-overflow-tooltip
                ></el-table-column>
                <el-table-column label="订单金额" prop="amount"></el-table-column>
                <el-table-column label="桌号" prop="deskName"></el-table-column>
                <el-table-column label="备注" prop="remark"></el-table-column>
                <el-table-column
                    label="类型"
                    prop="type"
                    :formatter="(row) => formatOrderType(row)"
                ></el-table-column>
                <el-table-column
                    label="状态"
                    prop="status"
                    :formatter="
                        (row) =>
                            row.status == 2 ? '已完成' : row.status == 0 ? '待下单' : '待结账'
                    "
                ></el-table-column>
                <el-table-column label="结账时间" prop="checkoutTime"></el-table-column>
                <el-table-column label="创建时间" prop="createTime"></el-table-column>
                <el-table-column label="操作" width="120" fixed="right">
                    <template #default="{ row }">
                        <el-button type="primary" link @click="handleViewDishes(row)">
                            查看已点菜品
                        </el-button>
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
import { ordersDish, ordersList } from '@/api/orders'
import { usePaging } from '@/hooks/usePaging'

const ORDER_TYPE_MAP: Record<number, string> = {
    0: '后台点单',
    1: '扫码点单',
    2: '小程序堂食自取',
    3: '外带自取',
    4: '外卖配送'
}

const formatOrderType = (row: { type?: number; diningMode?: number; source?: number }) => {
    if (row.type != null && ORDER_TYPE_MAP[row.type]) {
        return ORDER_TYPE_MAP[row.type]
    }
    if (row.source === 2 || row.source === 3) {
        if (row.diningMode === 3) return '外卖配送'
        if (row.diningMode === 1) return '小程序堂食自取'
        if (row.diningMode === 2) return '外带自取'
    }
    return '扫码点单'
}

const dishDialogVisible = ref(false)
const dishLoading = ref(false)
const dishList = ref<any[]>([])

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

const createTime = ref()
const checkoutTime = ref()
const queryParams = reactive({
    type: '',
    status: '',
    checkoutTime: '',
    createTime: ''
})
const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: ordersList,
    params: queryParams
})
const setCreateTime = (v: any) => {
    queryParams.createTime =
        Math.round(v[0].getTime() / 1000).toString() +
        ',' +
        Math.round(v[1].getTime() / 1000).toString()
}
const setCheckoutTime = (v: any) => {
    queryParams.checkoutTime =
        Math.round(v[0].getTime() / 1000).toString() +
        ',' +
        Math.round(v[1].getTime() / 1000).toString()
}
// watch(queryParams, (newV, oldV) => {
//     console.log(JSON.stringify(newV))
// })
getLists()
</script>

<style></style>
