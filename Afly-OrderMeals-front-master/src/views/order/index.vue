<template>
    <div class="order-index">
        <el-card shadow="never">
            <el-tabs v-model="activeName" @tab-change="tabChange">
                <el-tab-pane label="全部餐桌" name="all"></el-tab-pane>
                <el-tab-pane
                    v-for="item in areaList"
                    :key="item.id"
                    :label="item.name"
                    :name="item.name"
                ></el-tab-pane>
            </el-tabs>
            <div
                v-for="i in deskList"
                :key="i"
                class="p-1 flex-wrap float-left text-center md:w-28 h-28 w-1/3"
            >
                <a href="#" @click="order_(i)"
                    ><div
                        class="rounded w-full h-full pt-3 relative"
                        :style="
                            i.status == 2
                                ? 'background-color: rgba(243, 244, 246);color:rgba(75, 85, 99)'
                                : 'background-color: rgba(91,136,73);color:rgba(255, 255, 255)'
                        "
                    >
                        <p class="font-semibold text-xl">
                            {{ i.name }}
                        </p>
                        <el-tag round>{{
                            i.status == 2 ? '空闲' : i.status == 0 ? '点餐中' : '就餐中'
                        }}</el-tag>
                        <div class="text-xl font-semibold">
                            <!-- {{ i.status == 2 ? ' ' : '￥888.88' }} -->
                            {{ i.amount ? '￥' + i.amount.toFixed(2) : ' ' }}
                        </div>
                        <div
                            class="w-full"
                            :style="'background-color: rgba(255, 255, 255, 0.4);position: absolute;bottom: 0px;'"
                        >
                            {{ (i.userNum ? i.userNum : '0') + '/' + i.num }}
                        </div>
                    </div></a
                >
            </div>
        </el-card>
        <footer-btns v-perms="['setting:website:save']">
            <el-button icon="RefreshRight" :loading="isLoading" type="primary" @click="refresh()"
                >刷新桌台</el-button
            >
        </footer-btns>
        <el-dialog
            width="300px"
            v-model="dialogVisible"
            :show-close="false"
            center
            top="0px"
            :title="currentDeskStatus == 2 ? '选择就餐人数' : ''"
        >
            <div v-if="currentDeskStatus != 2">
                <el-button class="w-full" type="primary" plain @click="reorder()">
                    继续点餐
                </el-button>
                <br />
                <el-button
                    class="w-full mt-1"
                    plain
                    :disabled="currentDeskStatus == 2"
                    @click="checkout()"
                >
                    结账
                </el-button>
                <br />
            </div>
            <div v-if="currentDeskStatus == 2">
                <el-radio-group v-model="data.userNum" size="small">
                    <el-radio
                        class="!mr-1 mb-1"
                        v-for="item in currentDeskMaxNum"
                        :key="item"
                        :label="item"
                        border
                        :v-text="item"
                    ></el-radio>
                </el-radio-group>
                <el-button class="w-full" plain @click="order()">开始点餐</el-button>
            </div>
            <el-button class="w-full mt-1" plain @click="dialogVisible = false">关闭</el-button>
        </el-dialog>
    </div>
    <console @init="init()" ref="consoleRef"></console>
</template>
<script lang="ts" setup>
import { postAll } from '@/api/org/post'
import { orderDeskList, createOrders, orderCheckout } from '@/api/order'
import Console from './console.vue'
import { getOrdersCurrent } from '@/api/orders'
import feedback from '@/utils/feedback'
import useUserStore from '@/stores/modules/user'
const userStore = useUserStore()
console.log(userStore.userInfo.id + '开始链接客户端')
const socketClient = new WebSocket('ws://localhost:8082/backSocket/' + userStore.userInfo.id)
const activeName = ref<any>('all')
const dialogVisible = ref(false)
const isLoading = ref(false)
const currentDeskStatus = ref()
const currentDeskMaxNum = ref<number>()
const areaList = ref<any[]>([])
const deskList = ref<any[]>([])
let currentDesk: any = {}
let deskListAll: any[] = []
const consoleRef = ref<InstanceType<typeof Console>>()
const data = reactive({
    userNum: 1, //当前就餐人数
    deskId: null,
    type: 0 //后台点餐类型：0
})
const order_ = (i: any) => {
    dialogVisible.value = true
    currentDesk = i
    currentDeskStatus.value = i.status
    data.deskId = i.id
    currentDeskMaxNum.value = i.num
}
const order = () => {
    dialogVisible.value = false
    createOrders(data).then((res) => {
        consoleRef.value?.open(currentDesk, data.userNum, res)
        init()
    })
    // router.push({ path: '/order/console', query: { deskID: id } })
}
const reorder = () => {
    dialogVisible.value = false
    consoleRef.value?.open(currentDesk)
}
const refresh = () => {
    isLoading.value = true
    init()
}
const checkout = () => {
    //结账
    feedback.confirm('结账金额为' + currentDesk.amount + '，确定要结账吗？').then(() => {
        orderCheckout({ did: currentDesk.id }).then(() => {
            feedback.notifySuccess('成功结账' + currentDesk.amount + '元')
            dialogVisible.value = false
            init()
        })
    })
}
const tabChange = (name: any) => {
    if (name != 'all') {
        deskList.value = deskListAll.filter((ele: any) => {
            return ele.area == name
        })
    } else {
        deskList.value = deskListAll
    }
}
const init = async () => {
    await orderDeskList().then((res: any) => {
        deskList.value = res
        deskListAll = res
        getOrdersCurrent().then((res) => {
            deskList.value = deskList.value.map((item) => {
                res.forEach((element: any) => {
                    if (item.id == element.deskId) {
                        item.status = element.status
                        item.userNum = element.userNum
                        // item.amount = element.amount
                        item.ordersId = element.number
                        if (item.amount) {
                            item.amount += Number.parseFloat(element.amount)
                        } else {
                            item.amount = Number.parseFloat(element.amount)
                        }
                    }
                })

                return item
            })
        })
    })
    await postAll().then((res) => {
        areaList.value = res
    })
    socketClient.onopen = () => {
        console.log('websocket成功连接服务器')
    }
    socketClient.onmessage = (msg: any) => {
        console.log('收到消息：' + msg.data)
        const message = JSON.parse(msg.data)
    }
    isLoading.value = false
}
onMounted(() => {
    init()
})
</script>
