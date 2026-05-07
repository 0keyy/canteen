<template>
    <div class="article-lists">
        <el-card class="!border-none" shadow="never">
            <el-form ref="formRef" class="mb-[-16px]" :model="queryParams" :inline="true">
                <el-form-item label="菜品名称">
                    <el-input
                        class="w-[280px]"
                        v-model="queryParams.title"
                        clearable
                        @keyup.enter="resetPage"
                    />
                </el-form-item>
                <el-form-item label="菜品分类">
                    <el-select class="w-[280px]" v-model="queryParams.cid">
                        <el-option label="全部" value />
                        <el-option
                            v-for="item in optionsData.articleCate"
                            :key="item.id"
                            :label="item.name"
                            :value="item.id"
                        />
                    </el-select>
                </el-form-item>
                <el-form-item label="菜品状态">
                    <el-select class="w-[280px]" v-model="queryParams.isShow">
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
                <router-link
                    v-perms="['dish:add', 'dish:add/edit']"
                    :to="{
                        path: getRoutePath('dish:add/edit')
                    }"
                >
                    <el-button class="mr-3" type="primary">
                        <template #icon>
                            <icon name="el-icon-Plus" />
                        </template>
                        添加菜品
                    </el-button>
                </router-link>
                <multi-del-btn></multi-del-btn>
            </div>
            <el-table class="mt-4" size="large" v-loading="pager.loading" :data="pager.lists">
                <el-table-column type="selection" width="55" />
                <el-table-column label="ID" type="index" min-width="80" />
                <el-table-column label="图片" min-width="100">
                    <template #default="{ row }">
                        <image-contain
                            v-if="row.image"
                            :src="row.image"
                            :width="60"
                            :height="45"
                            :preview-src-list="[row.image]"
                            preview-teleported
                            fit="contain"
                        />
                    </template>
                </el-table-column>
                <el-table-column
                    label="菜品名称"
                    prop="title"
                    min-width="160"
                    show-tooltip-when-overflow
                />
                <el-table-column label="菜品分类" prop="category" min-width="100" />
                <el-table-column label="价格" prop="summary" min-width="70" />
                <el-table-column
                    label="菜品描述"
                    prop="intro"
                    min-width="150"
                    show-tooltip-when-overflow
                />
                <el-table-column label="状态" min-width="100">
                    <template #default="{ row }">
                        <el-switch
                            v-perms="['dish:cate:change']"
                            v-model="row.isShow"
                            :active-value="1"
                            :inactive-value="0"
                            @change="changeStatus(row.id)"
                        />
                    </template>
                </el-table-column>
                <el-table-column label="排序" prop="sort" min-width="100" />
                <el-table-column label="添加时间" prop="createTime" min-width="120" />
                <el-table-column label="操作" width="120" fixed="right">
                    <template #default="{ row }">
                        <el-button v-perms="['dish:edit', 'dish:add/edit']" type="primary" link>
                            <router-link
                                :to="{
                                    path: getRoutePath('dish:add/edit'),
                                    query: {
                                        id: row.id
                                    }
                                }"
                            >
                                编辑
                            </router-link>
                        </el-button>
                        <el-button
                            v-perms="['dish:del']"
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
    </div>
</template>
<script lang="ts" setup name="articleLists">
import { articleLists, articleDelete, articleStatus, articleCateAll } from '@/api/article'
import { useDictOptions } from '@/hooks/useDictOptions'
import { usePaging } from '@/hooks/usePaging'
import { getRoutePath } from '@/router'
import feedback from '@/utils/feedback'
const queryParams = reactive({
    title: '',
    cid: '',
    isShow: ''
})
const { pager, getLists, resetPage, resetParams } = usePaging({
    fetchFun: articleLists,
    params: queryParams
})

const { optionsData } = useDictOptions<{
    articleCate: any[]
}>({
    articleCate: {
        api: articleCateAll
    }
})

const changeStatus = async (id: number) => {
    try {
        await articleStatus({ id })
        feedback.msgSuccess('修改成功')
        getLists()
    } catch (error) {
        getLists()
    }
}

const handleDelete = async (id: number) => {
    await feedback.confirm('确定要删除？')
    await articleDelete({ id })
    feedback.msgSuccess('删除成功')
    getLists()
}

onActivated(() => {
    getLists()
})

getLists()
</script>
