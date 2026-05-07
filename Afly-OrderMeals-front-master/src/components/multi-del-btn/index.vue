<template>
    <el-popover trigger="click" placement="top">
        <div style="text-align: right; margin: 0">
            <el-button @click="handleMultiDel" style="width: 100%" size="large" text
                >批量删除</el-button
            >
        </div>
        <template #reference>
            <el-button> 批量操作 </el-button>
        </template>
    </el-popover>
</template>

<script setup lang="ts">
const handleMultiDel = () => {
    console.log('批量删除')
}
</script>

<style></style>
