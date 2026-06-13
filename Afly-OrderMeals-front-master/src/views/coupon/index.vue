<template>
    <div class="coupon-list">
        <el-card class="!border-none" shadow="never">
            <el-form ref="formRef" class="mb-[-16px]" :model="queryParams" :inline="true">
                <el-form-item label="券名称">
                    <el-input
                        class="w-[280px]"
                        v-model="queryParams.name"
                        clearable
                        @keyup.enter="resetPage"
                    />
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
                <el-form-item label="状态">
                    <el-select class="w-[280px]" v-model="queryParams.isShow" clearable>
                        <el-option label="全部" value />
                        <el-option label="显示" :value="1" />
                        <el-option label="隐藏" :value="0" />
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetPage">查询</el-button>
                    <el-button @click="resetParams">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>
        <el-card class="!border-none mt-4" shadow="never">
            <div>
                <el-button v-perms="['coupon:template:list']" type="primary" @click="handleAdd">
                    <template #icon>
                        <icon name="el-icon-Plus" />
                    </template>
                    新增券模板
                </el-button>
            </div>
            <el-table class="mt-4" size="large" v-loading="pager.loading" :data="pager.lists">
                <el-table-column label="ID" prop="id" min-width="60" />
                <el-table-column label="券名称" prop="name" min-width="150" show-tooltip-when-overflow />
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
                <el-table-column label="使用门槛" min-width="90">
                    <template #default="{ row }">
                        <span v-if="row.minAmount && row.minAmount > 0">满¥{{ row.minAmount }}</span>
                        <span v-else>无门槛</span>
                    </template>
                </el-table-column>
                <el-table-column label="库存(已领/总量)" min-width="110">
                    <template #default="{ row }">
                        <span>{{ row.claimedCount || 0 }} / {{ row.totalStock > 0 ? row.totalStock : '不限' }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="领取时间" min-width="160">
                    <template #default="{ row }">
                        <span v-if="row.claimStartTime">{{ row.claimStartTime }} ~ {{ row.claimEndTime }}</span>
                        <span v-else>不限</span>
                    </template>
                </el-table-column>
                <el-table-column label="显示" min-width="70">
                    <template #default="{ row }">
                        <el-switch
                            v-perms="['coupon:template:list']"
                            v-model="row.isShow"
                            :active-value="1"
                            :inactive-value="0"
                            @change="changeStatus(row.id)"
                        />
                    </template>
                </el-table-column>
                <el-table-column label="排序" prop="sort" min-width="70" />
                <el-table-column label="创建时间" prop="createTime" min-width="140" />
                <el-table-column label="操作" width="130" fixed="right">
                    <template #default="{ row }">
                        <el-button v-perms="['coupon:template:list']" type="primary" link @click="handleEdit(row)">
                            编辑
                        </el-button>
                        <el-button v-perms="['coupon:template:list']" type="danger" link @click="handleDelete(row.id)">
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pager" @change="getLists" />
            </div>
        </el-card>

        <!-- 新增/编辑弹窗 -->
        <popup
            ref="editPopupRef"
            :title="editMode === 'add' ? '新增券模板' : '编辑券模板'"
            width="600px"
            :async="true"
            @confirm="handleSubmit"
        >
            <el-form ref="editFormRef" :model="formData" :rules="formRules" label-width="120px">
                <el-form-item label="券名称" prop="name">
                    <el-input v-model="formData.name" placeholder="请输入券名称" maxlength="64" />
                </el-form-item>
                <el-form-item label="券类型" prop="type">
                    <el-select v-model="formData.type" placeholder="请选择类型" @change="onTypeChange">
                        <el-option label="无门槛券" :value="1" />
                        <el-option label="满减券" :value="2" />
                        <el-option label="兑换券" :value="3" />
                        <el-option label="套餐券" :value="4" />
                        <el-option label="夜间券" :value="5" />
                    </el-select>
                </el-form-item>
                <el-form-item label="优惠金额(元)" prop="discountAmount">
                    <el-input-number v-model="formData.discountAmount" :min="0" :precision="2" />
                </el-form-item>
                <el-form-item v-if="formData.type === 2 || (formData.type === 5 && showNightThreshold)" label="使用门槛(元)" prop="minAmount">
                    <el-input-number v-model="formData.minAmount" :min="0" :precision="2" placeholder="满多少元可用" />
                </el-form-item>
                <template v-if="formData.type === 5">
                    <el-form-item label="夜间开始时间" prop="nightStartTime">
                        <el-time-picker v-model="formData.nightStartTime" format="HH:mm" value-format="HH:mm" placeholder="如 21:00" />
                    </el-form-item>
                    <el-form-item label="夜间结束时间" prop="nightEndTime">
                        <el-time-picker v-model="formData.nightEndTime" format="HH:mm" value-format="HH:mm" placeholder="如 06:00" />
                    </el-form-item>
                </template>
                <el-form-item label="有效天数" prop="validDays">
                    <el-input-number v-model="formData.validDays" :min="0" placeholder="0表示使用固定时间段" />
                    <span class="ml-2 text-xs text-gray-400">0=使用下方固定时间段</span>
                </el-form-item>
                <template v-if="!formData.validDays || formData.validDays === 0">
                    <el-form-item label="使用开始时间" prop="useStartTime">
                        <el-date-picker
                            v-model="formData.useStartTime"
                            type="datetime"
                            placeholder="选择开始时间"
                            value-format="x"
                        />
                    </el-form-item>
                    <el-form-item label="使用结束时间" prop="useEndTime">
                        <el-date-picker
                            v-model="formData.useEndTime"
                            type="datetime"
                            placeholder="选择结束时间"
                            value-format="x"
                        />
                    </el-form-item>
                </template>
                <el-form-item label="领取开始时间" prop="claimStartTime">
                    <el-date-picker
                        v-model="formData.claimStartTime"
                        type="datetime"
                        placeholder="选择领取开始时间"
                        value-format="x"
                    />
                </el-form-item>
                <el-form-item label="领取结束时间" prop="claimEndTime">
                    <el-date-picker
                        v-model="formData.claimEndTime"
                        type="datetime"
                        placeholder="选择领取结束时间"
                        value-format="x"
                    />
                </el-form-item>
                <el-form-item label="限量库存" prop="totalStock">
                    <el-input-number v-model="formData.totalStock" :min="0" placeholder="0表示不限量" />
                    <span class="ml-2 text-xs text-gray-400">0=不限量</span>
                </el-form-item>
                <el-form-item label="排序" prop="sort">
                    <el-input-number v-model="formData.sort" :min="0" />
                </el-form-item>
                <el-form-item label="是否显示" prop="isShow">
                    <el-switch
                        v-model="formData.isShow"
                        :active-value="1"
                        :inactive-value="0"
                    />
                </el-form-item>
            </el-form>
        </popup>
    </div>
</template>

<script lang="ts" setup name="couponIndex">
import { couponTemplateList, couponTemplateAdd, couponTemplateEdit, couponTemplateDel, couponTemplateStatus } from '@/api/coupon'
import { usePaging } from '@/hooks/usePaging'
import feedback from '@/utils/feedback'

const queryParams = reactive({
    name: '',
    type: '' as any,
    isShow: '' as any
})

const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: couponTemplateList,
    params: queryParams
})

// 类型映射
const typeLabel = (type: number) => {
    const map: Record<number, string> = { 1: '无门槛券', 2: '满减券', 3: '兑换券', 4: '套餐券', 5: '夜间券' }
    return map[type] || '未知'
}

const typeTagStyle = (type: number) => {
    const map: Record<number, string> = { 1: 'success', 2: 'primary', 3: 'warning', 4: 'warning', 5: 'danger' }
    return map[type] || 'info'
}

// 编辑弹窗
const editPopupRef = shallowRef()
const editFormRef = shallowRef()
const editMode = ref('add')
const showNightThreshold = ref(false)

const defaultFormData = {
    id: null as number | null,
    name: '',
    type: 1,
    discountAmount: 0,
    minAmount: 0,
    nightStartTime: '',
    nightEndTime: '',
    validDays: 0,
    useStartTime: null as any,
    useEndTime: null as any,
    claimStartTime: null as any,
    claimEndTime: null as any,
    totalStock: 0,
    sort: 0,
    isShow: 1
}

const formData = reactive({ ...defaultFormData })

const formRules = reactive({
    name: [{ required: true, message: '请输入券名称', trigger: 'blur' }],
    type: [{ required: true, message: '请选择券类型', trigger: 'change' }],
    discountAmount: [{ required: true, message: '请输入优惠金额', trigger: 'blur' }]
})

const resetForm = () => {
    Object.assign(formData, { ...defaultFormData })
    showNightThreshold.value = false
}

const onTypeChange = () => {
    // 夜间券：检查是否有门槛金额
    showNightThreshold.value = formData.minAmount > 0
}

const handleAdd = () => {
    editMode.value = 'add'
    resetForm()
    editPopupRef.value?.open()
}

const handleEdit = (row: any) => {
    editMode.value = 'edit'
    resetForm()
    // 回填数据
    Object.assign(formData, {
        id: row.id,
        name: row.name || '',
        type: row.type || 1,
        discountAmount: Number(row.discountAmount) || 0,
        minAmount: Number(row.minAmount) || 0,
        nightStartTime: row.nightStartTime || '',
        nightEndTime: row.nightEndTime || '',
        validDays: row.validDays || 0,
        useStartTime: row.useStartTime ? Number(row.useStartTime) * 1000 : null,
        useEndTime: row.useEndTime ? Number(row.useEndTime) * 1000 : null,
        claimStartTime: row.claimStartTime ? Number(row.claimStartTime) * 1000 : null,
        claimEndTime: row.claimEndTime ? Number(row.claimEndTime) * 1000 : null,
        totalStock: row.totalStock || 0,
        sort: row.sort || 0,
        isShow: row.isShow != null ? row.isShow : 1
    })
    showNightThreshold.value = row.minAmount > 0
    editPopupRef.value?.open()
}

const handleSubmit = async () => {
    try {
        await editFormRef.value?.validate()
        const params: any = { ...formData }
        // 时间字段转换为秒级时间戳
        if (params.useStartTime != null && typeof params.useStartTime === 'number') {
            params.useStartTime = Math.floor(params.useStartTime / 1000)
        }
        if (params.useEndTime != null && typeof params.useEndTime === 'number') {
            params.useEndTime = Math.floor(params.useEndTime / 1000)
        }
        if (params.claimStartTime != null && typeof params.claimStartTime === 'number') {
            params.claimStartTime = Math.floor(params.claimStartTime / 1000)
        }
        if (params.claimEndTime != null && typeof params.claimEndTime === 'number') {
            params.claimEndTime = Math.floor(params.claimEndTime / 1000)
        }
        // 非夜间券清除夜间时间
        if (params.type !== 5) {
            params.nightStartTime = ''
            params.nightEndTime = ''
        }
        // 非满减券且非夜间券有门槛的情况，清除门槛
        if (params.type !== 2 && !(params.type === 5 && params.minAmount > 0)) {
            params.minAmount = 0
        }

        if (editMode.value === 'add') {
            await couponTemplateAdd(params)
            feedback.msgSuccess('新增成功')
        } else {
            await couponTemplateEdit(params)
            feedback.msgSuccess('编辑成功')
        }
        editPopupRef.value?.close()
        getLists()
    } catch (error) {
        // 表单验证错误由 ElementPlus 处理
    }
}

const changeStatus = async (id: number) => {
    try {
        await couponTemplateStatus({ id })
        feedback.msgSuccess('修改成功')
        getLists()
    } catch (error) {
        getLists()
    }
}

const handleDelete = async (id: number) => {
    try {
        await feedback.confirm('确定要删除该券模板？')
        await couponTemplateDel({ id })
        feedback.msgSuccess('删除成功')
        getLists()
    } catch (error) {
        // 取消删除
    }
}

onActivated(() => {
    getLists()
})

getLists()
</script>
