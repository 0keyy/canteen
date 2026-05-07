<template>
    <div class="orders-lists">
        <el-card class="!border-none" shadow="never">
            <el-form :inline="true" class="mb-[-16px]">
                <el-form-item label="订单类型" class="w-[280px]">
                    <el-select class="w-[280px]" v-model="queryParams.type">
                        <el-option label="全部" value />
                        <el-option label="后台点单" value="0" />
                        <el-option label="扫码点单" value="1" />
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
                    :formatter="(row) => (row.type == 0 ? '后台点单' : '扫码点单')"
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
                <el-table-column label="操作" width="120" fixed="right"
                    ><template #default="{ row }">
                        <el-button type="primary" link :v-text="row.id"> 查看已点菜品 </el-button>
                    </template></el-table-column
                >
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pager" @change="getLists" />
            </div>
        </el-card>
    </div>
</template>

<script setup lang="ts">
import { ordersList } from '@/api/orders'
import { usePaging } from '@/hooks/usePaging'

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
