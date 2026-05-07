<template>
    <div class="order-console">
        <el-drawer
            v-model="showOrderConsole"
            title="开始点餐"
            direction="rtl"
            size="80%"
            :before-close="beforeClose"
        >
            <div class="p-2 md:w-1/4 w-full md:h-full h-auto float-left">
                <el-card shadow="never" :body-style="{ padding: '10px' }">
                    <template #header>
                        <div
                            class="justify-between items-center flex text-xl font-semibold font-mono"
                        >
                            <span>{{ '桌台：' + data.deskName }}</span>
                            <span>{{ data.currentNum + '/' + data.deskCap }}</span>
                        </div>
                    </template>
                    <el-scrollbar ref="scrollbarRef" height="500px">
                        <div ref="innerRef">
                            <el-empty
                                v-if="data.selectGoods.length == 0 ? true : false"
                                description="啥也没有，快点击商品添加吧"
                            />
                            <!-- 已选商品 -->
                            <goods-item
                                v-for="item in data.selectGoods"
                                :key="item"
                                class="scrollbar-demo-item"
                                :goods-item="item"
                                @add="add"
                                @reduce="reduce"
                            >
                            </goods-item>
                        </div>
                    </el-scrollbar>
                    <el-input
                        v-model="params.remark"
                        maxlength="30"
                        placeholder="订单备注"
                        show-word-limit
                        type="textarea"
                    />
                    <el-divider />
                    <el-alert :closable="false">
                        <template #title>
                            <div class="justify-between flex w-full">
                                <div class="text-xl">
                                    价格：<b
                                        style="color: sandybrown"
                                        v-text="orderData.priceSum.toFixed(2)"
                                    ></b>
                                </div>
                            </div>
                        </template>
                        <template #default>
                            <div>
                                <div class="text-xl">
                                    数量：<b v-text="orderData.numSum.toString()"></b>
                                </div>
                            </div> </template
                    ></el-alert>
                    <div class="pt-2 justify-between flex">
                        <el-button @click="toEmpty()">清空</el-button
                        ><span>
                            <!-- <el-button type="primary">打折</el-button> -->
                            <el-button type="primary" @click="submit()">出单</el-button></span
                        >
                    </div>
                </el-card>
            </div>
            <div
                class="p-2 md:w-3/4 w-full md:h-full h-auto float-left flex-wrap"
                v-loading="orderLoading"
            >
                <div class="w-full h-auto">
                    <el-scrollbar
                        ><div class="flex">
                            <el-button
                                size="large"
                                :type="buttonType == 'all' ? 'primary' : ''"
                                @click="clickSortButton('all')"
                                text
                                bg
                                >全部商品</el-button
                            >
                            <el-button
                                v-for="button in dishCate"
                                :key="button.name"
                                size="large"
                                :type="buttonType == button.name ? 'primary' : ''"
                                @click="clickSortButton(button.name)"
                                text
                                bg
                                >{{ button.name }}</el-button
                            >
                        </div></el-scrollbar
                    >
                    <div class="justify-end flex">
                        <el-input
                            v-model="search"
                            class="md:w-40 w-1/2 m-2"
                            placeholder="搜索菜品名字"
                            :suffix-icon="Search"
                        />
                    </div>
                </div>
                <div class="w-full md:h-5/6 h-auto inline-block">
                    <!-- 菜单内容 -->
                    <el-scrollbar height="100%">
                        <div
                            v-for="item in dishList"
                            :key="item.id"
                            class="float-left md:w-40 w-1/2 md:h-38 h-auto p-1"
                        >
                            <a href="#" @click="addGoods(item)"
                                ><el-card shadow="never" :body-style="{ padding: '0px' }">
                                    <el-image
                                        style="width: 100%; height: 100px"
                                        :src="item.image"
                                        fit="cover"
                                    />
                                    <div class="text-2xs font-semibold p-1">
                                        <p>{{ item.title }}</p>
                                        <p style="color: coral">
                                            {{ item.summary + '元/份' }}
                                        </p>
                                    </div>
                                </el-card></a
                            >
                        </div>
                    </el-scrollbar>
                </div>
            </div>
        </el-drawer>
    </div>
</template>

<script setup lang="ts">
import { ElScrollbar } from 'element-plus'
import { Search } from '@element-plus/icons-vue'
import goodsItem from './goodsItem.vue'
import {
    dishAdd,
    dishCateAll,
    dishDec,
    dishDel,
    dishInc,
    dishListAll,
    toEmptyy,
    orderSubmit
} from '@/api/order'
import feedback from '@/utils/feedback'
// const route = useRoute()
const innerRef = ref<HTMLDivElement>()
const dishCate = ref<any[]>([])
const dishList = ref<any[]>([])
let dishListall: any[] = []
const orderLoading = ref(false)
const scrollbarRef = ref<InstanceType<typeof ElScrollbar>>()
const search = ref('')
const emit = defineEmits(['init'])
const buttonType = ref('all')
const showOrderConsole = ref(false)
const data = reactive<any>({
    deskName: '',
    deskCap: 0,
    currentNum: 0,
    selectGoods: []
})
const orderData = reactive<any>({
    priceSum: 0,
    numSum: 0
})
const params = reactive({
    remark: '', //订单备注
    number: '' //订单id
})
const submit = () => {
    //出单
    feedback.loading('正在出单...')
    if (data.selectGoods.length == 0) {
        feedback.alert('未点菜品！')
    }
    orderSubmit(params).then(() => {
        data.selectGoods.length = 0
        orderData.priceSum = 0
        orderData.numSum = 0
        emit('init')
        feedback.closeLoading()
        feedback.notifySuccess('出单成功')
    })
}
const open = (item: any, num?: number, orderNumber?: any) => {
    showOrderConsole.value = true
    data.deskName = item.name
    data.deskCap = item.num
    data.currentNum = item.userNum ? item.userNum : num
    params.number = item.ordersId ? item.ordersId : orderNumber
}

const addGoods = (item: any) => {
    orderLoading.value = true
    const tempGoods = data.selectGoods.filter((element: any) => {
        return element.id == item.id
    })
    if (tempGoods.length == 0) {
        item.num = 1
        dishAdd({
            orderId: params.number,
            dishId: item.id
        }).then((res) => {
            //拿到orders_dish的id
            item.ordersDishId = res
            data.selectGoods.push(item)
            feedback.msgSuccess('成功添加商品' + item.title)
            orderLoading.value = false
            console.log(item)
        })
    } else {
        dishInc({ id: item.ordersDishId })
        data.selectGoods[data.selectGoods.indexOf(tempGoods[0])].num++
        orderLoading.value = false
    }

    orderData.numSum++
    orderData.priceSum += Number(item.summary)
    nextTick(() => {
        scrollbarRef.value!.setScrollTop(innerRef.value!.clientHeight)
    })
}
const clickSortButton = (name: any) => {
    buttonType.value = name
    if (name == 'all') {
        dishList.value = dishListall
    } else {
        dishList.value = dishListall.filter((ele) => {
            return ele.category == name
        })
    }
}
const toEmpty = () => {
    if (data.selectGoods.length != 0) {
        data.selectGoods.length = 0
        orderData.priceSum = 0
        orderData.numSum = 0
        toEmptyy({ id: params.number })
    }
}
const beforeClose = () => {
    if ((data.selectGoods, length != 0)) {
        feedback.confirm('所点菜品信息将不被保存，确认关闭？').then(() => {
            toEmpty()
        })
    }
    showOrderConsole.value = false
}
const add = (item: any) => {
    addGoods(item)
}
const reduce = (item: any) => {
    orderLoading.value = true
    const tempGoods = data.selectGoods.filter((element: any) => {
        return element.id == item.id
    })
    const t = data.selectGoods.indexOf(tempGoods[0])
    const n = data.selectGoods[t].num
    if (n > 1) {
        dishDec({ id: item.ordersDishId }).then(() => {
            data.selectGoods[t].num--
            orderLoading.value = false
        })
    } else {
        dishDel({ id: item.ordersDishId }).then(() => {
            data.selectGoods.splice(t, 1)
            orderLoading.value = false
        })
    }
    orderData.numSum--
    orderData.priceSum -= item.summary
    orderLoading.value = false
}
onMounted(() => {
    dishCateAll().then((res) => {
        dishCate.value = res
    })
    dishListAll().then((res) => {
        dishList.value = res
        dishListall = res
    })
})
defineExpose({
    open
})
</script>
<style></style>
