<template>
    <div class="goods-item">
        <el-card class="w-full" shadow="never" :body-style="{ padding: '10px' }">
            <p class="text-xl font-bold">{{ props.goodsItem.title }}</p>
            <div>
                <b style="color: coral">{{ props.goodsItem.summary }}</b
                ><span class="p-1 rounded ml-2" style="background-color: #e0eee0">{{
                    '×' + props.goodsItem.num
                }}</span>
                <span class="float-right">
                    <el-button-group size="small">
                        <el-button @click="reduce()"> - </el-button>
                        <el-button @click="add()"> + </el-button>
                    </el-button-group></span
                >
            </div>
        </el-card>
    </div>
</template>

<script setup lang="ts">
const emit = defineEmits(['add', 'reduce'])
const props = defineProps({
    goodsItem: {
        type: Object,
        default: () => ({})
    }
})
const add = () => {
    emit('add', props.goodsItem)
}
const reduce = () => {
    emit('reduce', props.goodsItem)
}
</script>

<style></style>
