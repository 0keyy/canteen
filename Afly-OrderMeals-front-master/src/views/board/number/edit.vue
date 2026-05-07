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
            <el-form ref="formRef" :model="formData" label-width="84px" :rules="formRules">
                <el-form-item label="选择区域" prop="areaId" v-if="formData.areaId !== 0">
                    <el-tree-select
                        class="flex-1"
                        v-model="formData.areaId"
                        :data="optionsData.area"
                        clearable
                        node-key="id"
                        :props="{
                            value: 'id',
                            label: 'name'
                        }"
                        check-strictly
                        :default-expand-all="true"
                        placeholder="请选择区域"
                    />
                </el-form-item>
                <el-form-item label="桌号名称" prop="name">
                    <el-input
                        v-model="formData.name"
                        placeholder="请输入桌号名称"
                        clearable
                        :maxlength="100"
                    />
                </el-form-item>
                <el-form-item label="最多人数" prop="num">
                    <el-input-number v-model="formData.num" :min="1" :max="100" step-strictly />
                </el-form-item>
                <el-form-item label="排序" prop="sort">
                    <div>
                        <el-input-number v-model="formData.sort" :min="0" :max="9999" />
                        <div class="form-tips">默认为0， 数值越大越排前</div>
                    </div>
                </el-form-item>
                <el-form-item label="启用" prop="isStop">
                    <el-switch v-model="formData.isStop" :active-value="0" :inactive-value="1" />
                </el-form-item>
            </el-form>
        </popup>
    </div>
</template>
<script lang="ts" setup>
import type { FormInstance } from 'element-plus'
import { deptEdit, deptAdd, deptDetail } from '@/api/org/department'
import Popup from '@/components/popup/index.vue'
import { useDictOptions } from '@/hooks/useDictOptions'
import feedback from '@/utils/feedback'
import { postAll } from '@/api/org/post'
const emit = defineEmits(['success', 'close'])
const formRef = shallowRef<FormInstance>()
const popupRef = shallowRef<InstanceType<typeof Popup>>()
const mode = ref('add')
const popupTitle = computed(() => {
    return mode.value == 'edit' ? '编辑' : '添加桌号'
})
const formData = reactive({
    id: '',
    areaId: '' as string | number,
    name: '',
    num: 1,
    sort: 0,
    isStop: 0
})
// const checkMobile = (rule: any, value: any, callback: any) => {
//     if (!value) {
//         return callback()
//     } else {
//         const reg = /^[1][3,4,5,6,7,8,9][0-9]{9}$/
//         console.log(reg.test(value))
//         if (reg.test(value)) {
//             callback()
//         } else {
//             return callback(new Error('请输入正确的手机号'))
//         }
//     }
// }
const formRules = {
    areaId: [
        {
            required: true,
            message: '请选择区域',
            trigger: ['change']
        }
    ],
    name: [
        {
            required: true,
            message: '请输入部门名称',
            trigger: ['blur']
        }
    ],
    num: [
        {
            required: true,
            message: '请设置最多就餐人数',
            trigger: ['blur']
        }
    ]
}

const { optionsData } = useDictOptions<{
    area: any[]
}>({
    area: {
        api: postAll
    }
})

const handleSubmit = async () => {
    await formRef.value?.validate()
    mode.value == 'edit' ? await deptEdit(formData) : await deptAdd(formData)
    popupRef.value?.close()
    feedback.msgSuccess('操作成功')
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
    const data = await deptDetail({
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
