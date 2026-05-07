<template>
    <div class="edit-popup">
        <popup
            ref="popupRef"
            :title="popupTitle"
            :async="true"
            width="550px"
            @confirm="handleSubmit"
            @close="handleClose"
        >
            <el-form ref="formRef" :model="formData" label-width="120px" :rules="formRules">
                <el-form-item label="打印机名称" prop="name">
                    <el-input v-model="formData.name" placeholder="请输入打印机名称" clearable />
                </el-form-item>
                <el-form-item label="终端号" prop="finalNumber">
                    <el-input
                        v-model="formData.finalNumber"
                        placeholder="请输入打印机终端号"
                        clearable
                    />
                </el-form-item>
                <el-form-item label="打印机密钥" prop="secret">
                    <el-input v-model="formData.secret" placeholder="请输入打印机密钥" clearable />
                </el-form-item>
                <el-form-item label="设备类型" prop="type">
                    <el-select v-model="formData.type" placeholder="请选择设备类型">
                        <el-option label="芯烨云" :value="1" />
                    </el-select>
                </el-form-item>
                <el-form-item label="小票模板" prop="mode">
                    <el-select v-model="formData.mode" placeholder="请选择打印模板">
                        <el-option label="模板01" :value="1" />
                    </el-select>
                </el-form-item>
                <!-- <el-form-item label="排序" prop="sort">
                    <div>
                        <el-input-number v-model="formData.sort" :min="0" :max="9999" />
                        <div class="form-tips">默认为0， 数值越大越排前</div>
                    </div>
                </el-form-item> -->
                <el-form-item label="状态" prop="status">
                    <el-switch v-model="formData.status" :active-value="1" :inactive-value="0" />
                </el-form-item>
            </el-form>
        </popup>
    </div>
</template>
<script lang="ts" setup>
import type { FormInstance } from 'element-plus'
import { articleCateEdit } from '@/api/article'
import Popup from '@/components/popup/index.vue'
import feedback from '@/utils/feedback'
import { addPrinter, getPrinterDetail } from '@/api/shop'
const emit = defineEmits(['success', 'close'])
const formRef = shallowRef<FormInstance>()
const popupRef = shallowRef<InstanceType<typeof Popup>>()
const mode = ref('add')
const popupTitle = computed(() => {
    return mode.value == 'edit' ? '编辑' : '新增'
})
const formData = reactive({
    id: '',
    name: '',
    type: '',
    finalNumber: '',
    secret: '',
    mode: '',
    status: ''
})

const formRules = {
    name: [
        {
            required: true,
            message: '请输入名称',
            trigger: ['blur']
        }
    ],
    type: [
        {
            required: true,
            message: '请选择类型',
            trigger: ['blur']
        }
    ],
    finalNumber: [
        {
            required: true,
            message: '请输入终端号',
            trigger: ['blur']
        }
    ],
    secret: [
        {
            required: true,
            message: '请输入密钥',
            trigger: ['blur']
        }
    ],
    mode: [
        {
            required: true,
            message: '请选择模板',
            trigger: ['blur']
        }
    ]
}

const handleSubmit = async () => {
    await formRef.value?.validate()
    mode.value == 'edit' ? await articleCateEdit(formData) : await addPrinter(formData)
    feedback.msgSuccess('操作成功')
    popupRef.value?.close()
    emit('success')
}

const open = (type = 'add') => {
    mode.value = type
    popupRef.value?.open()
}

const setFormData = (data: Record<any, any>) => {
    for (const key in formData) {
        if (data[key] != null && data[key] != undefined) {
            //@ts-ignore
            formData[key] = data[key]
        }
    }
}

const getDetail = async (row: Record<string, any>) => {
    const data = await getPrinterDetail({
        id: row.id
    })
    setFormData(data)
}

const handleClose = () => {
    emit('close')
}

defineExpose({
    open,
    setFormData,
    getDetail
})
</script>
