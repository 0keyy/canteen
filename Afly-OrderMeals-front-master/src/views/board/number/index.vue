<template>
    <div class="dept-lists">
        <el-card class="!border-none" shadow="never">
            <el-form ref="formRef" class="mb-[-16px]" :model="queryParams" :inline="true">
                <el-form-item label="桌号名称" prop="name">
                    <el-input
                        class="w-[280px]"
                        v-model="queryParams.name"
                        clearable
                        @keyup.enter="getLists"
                    />
                </el-form-item>
                <el-form-item label="区域">
                    <el-select class="w-[280px]" v-model="queryParams.areaId">
                        <el-option label="全部" value />
                        <el-option
                            v-for="item in optionsData.areas"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id"
                        />
                    </el-select>
                </el-form-item>
                <el-form-item label="状态" prop="isStop">
                    <el-select class="w-[280px]" v-model="queryParams.isStop">
                        <el-option label="全部" value />
                        <el-option label="正常" value="0" />
                        <el-option label="停用" value="1" />
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
                <el-button v-perms="['system:dept:add']" type="primary" @click="handleAdd()">
                    <template #icon>
                        <icon name="el-icon-Plus" />
                    </template>
                    新增
                </el-button>
                <multi-del-btn></multi-del-btn>
            </div>
            <el-table
                ref="tableRef"
                class="mt-4"
                size="large"
                v-loading="pager.loading"
                :data="pager.lists"
            >
                <el-table-column type="selection" width="55" />
                <el-table-column
                    label="桌号名称"
                    prop="name"
                    min-width="100"
                    show-overflow-tooltip
                />
                <el-table-column label="区域" prop="area" min-width="80" show-overflow-tooltip />
                <el-table-column label="最大人数" prop="num" min-width="60" />
                <el-table-column label="状态" prop="isStop" min-width="100">
                    <template #default="{ row }">
                        <el-tag class="ml-2" :type="row.isStop ? 'danger' : ''">
                            {{ row.isStop ? '停用' : '正常' }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="排序" prop="sort" min-width="60" />
                <el-table-column label="创建时间" prop="updateTime" min-width="180" />
                <el-table-column label="操作" width="200" fixed="right">
                    <template #default="{ row }">
                        <el-button
                            v-perms="['system:dept:add']"
                            type="primary"
                            link
                            @click="handleCreate(row.id)"
                        >
                            生成二维码
                        </el-button>
                        <el-button
                            v-perms="['system:dept:edit']"
                            type="primary"
                            link
                            @click="handleEdit(row)"
                        >
                            编辑
                        </el-button>
                        <el-button
                            v-perms="['system:dept:del']"
                            type="danger"
                            link
                            @click="handleDelete(row.id)"
                        >
                            删除
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pager" @change="getLists" />
            </div>
        </el-card>
        <edit-popup v-if="showEdit" ref="editRef" @success="getLists" @close="showEdit = false" />
    </div>
</template>
<script lang="ts" setup name="department">
import type { ElTable, FormInstance } from 'element-plus'
import EditPopup from './edit.vue'
import { createQr, deptDelete, deptLists } from '@/api/org/department'
import feedback from '@/utils/feedback'
import { useDictOptions } from '@/hooks/useDictOptions'
import { postAll } from '@/api/org/post'
import { usePaging } from '@/hooks/usePaging'
const tableRef = shallowRef<InstanceType<typeof ElTable>>()
const editRef = shallowRef<InstanceType<typeof EditPopup>>()
const formRef = shallowRef<FormInstance>()
// const loading = ref(false)
// const lists = ref<any[]>([])
const queryParams = reactive({
    isStop: '',
    name: '',
    areaId: ''
})
const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: deptLists,
    params: queryParams
})

const showEdit = ref(false)
// const getLists = async () => {
//     loading.value = true
//     lists.value = await deptLists(queryParams)
//     loading.value = false
// }

const { optionsData } = useDictOptions<{
    areas: any[]
}>({
    areas: {
        api: postAll
    }
})

const handleAdd = async (id?: number) => {
    showEdit.value = true
    await nextTick()
    if (id) {
        editRef.value?.setFormData({
            pid: id
        })
    }
    editRef.value?.open('add')
}

/** data URL 过长时 window.open(data:...) 常见空白页，用 Blob URL 打开 */
const openDataUrlInNewTab = (dataUrl: string) => {
    const m = /^data:([^;]+);base64,(.+)$/.exec(dataUrl)
    if (!m) {
        const w = window.open()
        if (w) {
            w.document.write(
                `<!DOCTYPE html><html><head><meta charset="utf-8"><title>二维码</title></head><body style="margin:0;display:flex;justify-content:center;align-items:center;min-height:100vh;background:#f5f5f5"><img src="${dataUrl.replace(/"/g, '&quot;')}" alt="二维码" style="max-width:100%;height:auto" /></body></html>`
            )
            w.document.close()
        }
        return
    }
    const bytes = Uint8Array.from(atob(m[2]), (c) => c.charCodeAt(0))
    const blob = new Blob([bytes], { type: m[1] })
    const url = URL.createObjectURL(blob)
    const opened = window.open(url)
    if (opened) {
        opened.addEventListener('beforeunload', () => URL.revokeObjectURL(url))
        setTimeout(() => URL.revokeObjectURL(url), 120_000)
    } else {
        URL.revokeObjectURL(url)
        feedback.msgError('弹窗被拦截，请允许本站弹出窗口')
    }
}

const handleCreate = (id?: number) => {
    feedback.loading('正在生成...')
    createQr({ id: id })
        .then((res: string) => {
            feedback.closeLoading()
            if (!res) {
                feedback.msgError('二维码生成失败')
                return
            }
            openDataUrlInNewTab(res)
        })
        .catch(() => {
            feedback.closeLoading()
        })
    console.log('创建桌号二维码' + id)
}

const handleEdit = async (data: any) => {
    showEdit.value = true
    await nextTick()
    editRef.value?.open('edit')
    editRef.value?.getDetail(data)
}

const handleDelete = async (id: number) => {
    await feedback.confirm('确定要删除？')
    await deptDelete({ id })
    feedback.msgSuccess('删除成功')
    getLists()
}

const handleMultiDel = () => {
    console.log('批量删除')
}

onMounted(async () => {
    await getLists()
})
</script>
