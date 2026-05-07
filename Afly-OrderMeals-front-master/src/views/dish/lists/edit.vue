<template>
    <div class="article-edit">
        <el-card class="!border-none" shadow="never">
            <el-page-header content="菜品编辑" @back="$router.back()" />
        </el-card>
        <el-card class="mt-4 !border-none" shadow="never">
            <el-form
                ref="formRef"
                class="ls-form"
                :model="formData"
                label-width="85px"
                :rules="rules"
            >
                <div class="xl:flex">
                    <div>
                        <el-form-item label="菜品名称" prop="title">
                            <div class="w-80">
                                <el-input
                                    v-model="formData.title"
                                    placeholder="请输入菜品名称"
                                    type="textarea"
                                    :autosize="{ minRows: 3, maxRows: 3 }"
                                    maxlength="64"
                                    show-word-limit
                                    clearable
                                />
                            </div>
                        </el-form-item>
                        <el-form-item label="价格(元)" prop="summary">
                            <div class="w-80">
                                <el-input-number
                                    v-model="formData.summary"
                                    :precision="2"
                                    :min="0.01"
                                    controls-position="right"
                                />
                            </div>
                        </el-form-item>
                        <el-form-item label="菜品分类" prop="cid">
                            <el-select
                                class="w-80"
                                v-model="formData.cid"
                                placeholder="请选择菜品分类"
                                clearable
                            >
                                <el-option
                                    v-for="item in optionsData.articleCate"
                                    :key="item.id"
                                    :label="item.name"
                                    :value="item.id"
                                />
                            </el-select>
                        </el-form-item>
                        <el-form-item label="菜品简介" prop="intro">
                            <div class="w-80">
                                <el-input
                                    v-model="formData.intro"
                                    placeholder="请输入菜品简介"
                                    type="textarea"
                                    :autosize="{ minRows: 3, maxRows: 6 }"
                                    :maxlength="200"
                                    show-word-limit
                                    clearable
                                />
                            </div>
                        </el-form-item>
                        <el-form-item label="菜品图片" prop="image">
                            <div>
                                <div>
                                    <material-picker v-model="formData.image" :limit="1" />
                                </div>
                            </div>
                        </el-form-item>
                        <el-form-item label="排序" prop="sort">
                            <div>
                                <el-input-number v-model="formData.sort" :min="0" :max="9999" />
                                <div class="form-tips">默认为0， 数值越大越排前</div>
                            </div>
                        </el-form-item>
                        <el-form-item label="状态" required prop="isShow">
                            <el-radio-group v-model="formData.isShow">
                                <el-radio :label="1">显示</el-radio>
                                <el-radio :label="0">隐藏</el-radio>
                            </el-radio-group>
                        </el-form-item>
                    </div>
                </div>
            </el-form>
        </el-card>
        <footer-btns>
            <el-button type="primary" @click="handleSave">保存</el-button>
        </footer-btns>
    </div>
</template>

<script lang="ts" setup name="articleListsEdit">
import type { FormInstance } from 'element-plus'
import feedback from '@/utils/feedback'
import { useDictOptions } from '@/hooks/useDictOptions'
import { articleCateAll, articleDetail, articleEdit, articleAdd } from '@/api/article'
import useMultipleTabs from '@/hooks/useMultipleTabs'

const route = useRoute()
const router = useRouter()
const formData = reactive<any>({
    id: '',
    title: '',
    image: '',
    cid: '',
    intro: '',
    author: '',
    content: '',
    visit: 0,
    sort: 0,
    isShow: 1,
    summary: ''
})

const { removeTab } = useMultipleTabs()
const formRef = shallowRef<FormInstance>()
const rules = reactive({
    title: [{ required: true, message: '请输入文章标题', trigger: 'blur' }],
    cid: [{ required: true, message: '请选择文章栏目', trigger: 'blur' }],
    summary: [{ required: true, message: '请输入价格', trigger: 'blur' }],
    image: [{ required: true, message: '添加菜品图片', trigger: 'change' }]
})

const getDetails = async () => {
    const data = await articleDetail({
        id: route.query.id
    })
    Object.keys(formData).forEach((key) => {
        //@ts-ignore
        formData[key] = data[key]
    })
}

const { optionsData } = useDictOptions<{
    articleCate: any[]
}>({
    articleCate: {
        api: articleCateAll
    }
})

const handleSave = async () => {
    await formRef.value?.validate()
    if (route.query.id) {
        await articleEdit(formData)
    } else {
        await articleAdd(formData)
    }
    feedback.msgSuccess('操作成功')
    removeTab()
    router.back()
}

route.query.id && getDetails()
</script>
