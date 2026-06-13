<template>
    <div class="coupon-verify">
        <el-card class="!border-none" shadow="never">
            <div class="text-lg font-bold mb-4">优惠券核销</div>
            <el-form :model="verifyForm" :rules="verifyRules" ref="verifyFormRef" label-width="120px">
                <el-form-item label="核销码" prop="verifyCode">
                    <div class="flex w-full">
                        <el-input
                            v-model="verifyForm.verifyCode"
                            placeholder="请输入或扫描核销码"
                            class="w-[400px]"
                            clearable
                            @keyup.enter="handleVerify"
                        />
                        <el-button type="primary" class="ml-4" :loading="verifying" @click="handleVerify">
                            查询核销
                        </el-button>
                    </div>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 核销结果 -->
        <el-card v-if="verifyResult" class="!border-none mt-4" shadow="never">
            <div class="text-lg font-bold mb-4">核销结果</div>
            <el-descriptions :column="2" border>
                <el-descriptions-item label="券名称">{{ verifyResult.templateName }}</el-descriptions-item>
                <el-descriptions-item label="券类型">
                    <el-tag :type="typeTagStyle(verifyResult.type)" size="small">
                        {{ typeLabel(verifyResult.type) }}
                    </el-tag>
                </el-descriptions-item>
                <el-descriptions-item label="优惠金额">¥{{ verifyResult.discountAmount }}</el-descriptions-item>
                <el-descriptions-item label="用户ID">{{ verifyResult.userId }}</el-descriptions-item>
                <el-descriptions-item label="核销码">{{ verifyForm.verifyCode }}</el-descriptions-item>
                <el-descriptions-item label="核销时间" v-if="verifyResult.verifyTime">{{ verifyResult.verifyTime }}</el-descriptions-item>
            </el-descriptions>

            <div class="mt-4">
                <el-button
                    type="danger"
                    :loading="confirming"
                    :disabled="confirmed"
                    @click="handleConfirm"
                >
                    {{ confirmed ? '已核销' : '确认核销' }}
                </el-button>
                <el-button @click="handleReset">重新核销</el-button>
            </div>
        </el-card>

        <!-- 未找到结果 -->
        <el-card v-if="verifyError" class="!border-none mt-4" shadow="never">
            <el-result icon="error" title="核销失败" :sub-title="verifyError">
                <template #extra>
                    <el-button type="primary" @click="handleReset">重新核销</el-button>
                </template>
            </el-result>
        </el-card>
    </div>
</template>

<script lang="ts" setup name="couponVerify">
import { couponVerify } from '@/api/coupon'
import feedback from '@/utils/feedback'

const verifyFormRef = shallowRef()
const verifyForm = reactive({
    verifyCode: ''
})

const verifyRules = {
    verifyCode: [{ required: true, message: '请输入核销码', trigger: 'blur' }]
}

const verifying = ref(false)
const confirming = ref(false)
const confirmed = ref(false)
const verifyResult = ref<any>(null)
const verifyError = ref('')

const typeLabel = (type: number) => {
    const map: Record<number, string> = { 1: '无门槛券', 2: '满减券', 3: '兑换券', 4: '套餐券', 5: '夜间券' }
    return map[type] || '未知'
}

const typeTagStyle = (type: number) => {
    const map: Record<number, string> = { 1: 'success', 2: 'primary', 3: 'warning', 4: 'warning', 5: 'danger' }
    return map[type] || 'info'
}

const handleVerify = async () => {
    try {
        await verifyFormRef.value?.validate()
        verifyError.value = ''
        verifyResult.value = null
        confirmed.value = false
        verifying.value = true
        const result = await couponVerify({ verifyCode: verifyForm.verifyCode })
        verifyResult.value = result
        feedback.msgSuccess('查询成功')
    } catch (error: any) {
        if (error?.msg || error?.message) {
            verifyError.value = error?.msg || error?.message
        } else if (typeof error === 'string') {
            verifyError.value = error
        }
        verifyResult.value = null
    } finally {
        verifying.value = false
    }
}

const handleConfirm = async () => {
    // 核销已经在查询时完成（后端 /api/coupon/verify 直接标记已使用），这里只是UI确认
    try {
        confirming.value = true
        confirmed.value = true
        feedback.msgSuccess('核销成功')
    } catch (error: any) {
        feedback.msgError(error?.msg || '核销失败')
    } finally {
        confirming.value = false
    }
}

const handleReset = () => {
    verifyForm.verifyCode = ''
    verifyResult.value = null
    verifyError.value = ''
    confirmed.value = false
}
</script>
