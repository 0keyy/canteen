<template>
    <div class="workbench">
        <div class="md:flex">
            <el-card class="!border-none mb-4 md:mr-4" shadow="never">
                <template #header>
                    <span class="card-title">店铺信息</span>
                </template>
                <div class="w-40">
                    <div class="flex leading-9">
                        <div class="w-20 flex-none">店铺名称：</div>
                        <span v-text="workbenchData.shopName"></span>
                    </div>
                    <div class="flex leading-9">
                        <div class="w-20 flex-none">运营状态：</div>
                        <span
                            v-text="workbenchData.shopStatus == 1 ? '正在营业' : '暂停营业'"
                        ></span>
                    </div>
                    <div class="flex leading-9">
                        <!-- <div class="w-20 felx-none">运营状态</div> -->
                        <div>
                            <el-button
                                :icon="SwitchButton"
                                :type="workbenchData.shopStatus == 1 ? 'danger' : 'success'"
                                size="small"
                                @click="changeStatus()"
                            >
                                {{ workbenchData.shopStatus == 1 ? '停止营业' : '开始营业' }}
                            </el-button>

                            <!-- <a
                                class="ml-3"
                                :href="workbenchData.version.channel.gitee"
                                target="_blank"
                            >
                                <el-button type="danger" size="small">Gitee</el-button>
                            </a> -->
                        </div>
                    </div>
                </div>
            </el-card>
            <el-card class="!border-none mb-4 flex-1" shadow="never">
                <template #header>
                    <div>
                        <span class="card-title">昨日数据</span>
                        <!-- <span class="text-tx-secondary text-xs ml-4">
                            更新时间：{{ workbenchData.today.time }}
                        </span> -->
                    </div>
                </template>

                <div class="flex flex-wrap">
                    <div class="w-1/2 md:w-1/4">
                        <div class="leading-10">到店人次</div>
                        <div class="text-6xl">{{ workbenchData.today.todayVisits }}</div>
                        <!-- <div class="text-tx-secondary text-xs">
                            总访问量：{{ workbenchData.today.totalVisits }}
                        </div> -->
                    </div>
                    <div class="w-1/2 md:w-1/4">
                        <div class="leading-10">销售额(元)</div>
                        <div class="text-6xl">{{ workbenchData.today.todaySales }}</div>
                        <!-- <div class="text-tx-secondary text-xs">
                            总销售额：{{ workbenchData.today.totalSales }}
                        </div> -->
                    </div>
                    <div class="w-1/2 md:w-1/4">
                        <div class="leading-10">订单量(笔)</div>
                        <div class="text-6xl">{{ workbenchData.today.todayOrder }}</div>
                        <!-- <div class="text-tx-secondary text-xs">
                            总订单量：{{ workbenchData.today.totalOrder }}
                        </div> -->
                    </div>
                    <div class="w-1/2 md:w-1/4">
                        <div class="leading-10">新到店人数</div>
                        <div class="text-6xl">{{ workbenchData.today.todayUsers }}</div>
                        <!-- <div class="text-tx-secondary text-xs">
                            总访用户：{{ workbenchData.today.totalUsers }}
                        </div> -->
                    </div>
                </div>
            </el-card>
        </div>
        <!-- <div class="function mb-4">
            <el-card class="flex-1 !border-none" shadow="never">
                <template #header>
                    <span>常用功能</span>
                </template>
                <div class="flex flex-wrap">
                    <div
                        v-for="item in workbenchData.menu"
                        class="md:w-[12.5%] w-1/4 flex flex-col items-center"
                        :key="item"
                    >
                        <router-link :to="item.url" class="mb-3 flex flex-col items-center">
                            <img width="40" height="40" :src="item.image" />
                            <div class="mt-2">{{ item.name }}</div>
                        </router-link>
                    </div>
                </div>
            </el-card>
        </div> -->
        <div class="md:flex">
            <el-card class="flex-1 !border-none md:mr-4 mb-4" shadow="never">
                <template #header>
                    <span>销售额趋势图</span>
                </template>
                <div>
                    <v-charts
                        style="height: 350px"
                        :option="workbenchData.visitorOption"
                        :autoresize="true"
                    />
                </div>
            </el-card>
            <el-card class="!border-none mb-4" shadow="never">
                <template #header>
                    <span>昨日被点菜品排行榜</span>
                </template>
                <div>
                    <v-charts
                        style="height: 350px; width: 450px"
                        :option="workbenchData.listOption"
                        :autoresize="true"
                    />
                    <!-- <div v-for="(item, index) in workbenchData.support" :key="index">
                        <div
                            class="flex items-center pb-10 pt-10"
                            :class="{
                                'border-b border-br': index == 0
                            }"
                        >
                            <img width="120" height="120" class="flex-none" :src="item.image" />
                            <div class="ml-2">
                                <div>{{ item.title }}</div>
                                <div class="text-tx-regular text-xs mt-4">{{ item.desc }}</div>
                            </div>
                        </div>
                    </div> -->
                </div>
            </el-card>
        </div>
    </div>
</template>

<script lang="ts" setup name="workbench">
import { getWorkbench } from '@/api/app'
import vCharts from 'vue-echarts'
import { SwitchButton } from '@element-plus/icons-vue'
import menu_admin from './image/menu_admin.png'
import menu_role from './image/menu_role.png'
import menu_dept from './image/menu_dept.png'
import menu_dict from './image/menu_dict.png'
import menu_generator from './image/menu_generator.png'
import menu_file from './image/menu_file.png'
import menu_auth from './image/menu_auth.png'
import menu_web from './image/menu_web.png'
import oa_code from './image/oa_code.png'
import service_code from './image/service_code.png'
import { getShopConfig, changeShopStatus } from '@/api/shop'
// 表单数据
const workbenchData: any = reactive({
    shopId: '',
    shopName: '',
    shopStatus: '',
    version: {
        version: '', // 版本号
        website: '', // 官网
        based: '',
        channel: {
            gitee: '',
            website: ''
        }
    },
    support: [
        {
            image: oa_code,
            title: '官方公众号',
            desc: '关注官方公众号'
        },
        {
            image: service_code,
            title: '添加企业客服微信',
            desc: '想了解更多请添加客服'
        }
    ],
    today: {}, // 今日数据
    menu: [
        {
            name: '管理员',
            image: menu_admin,
            url: '/permission/admin'
        },
        {
            name: '角色管理',
            image: menu_role,
            url: '/permission/role'
        },
        {
            name: '部门管理',
            image: menu_dept,
            url: '/organization/department'
        },
        {
            name: '字典管理',
            image: menu_dict,
            url: '/dev_tools/dict'
        },
        {
            name: '代码生成器',
            image: menu_generator,
            url: '/dev_tools/code'
        },
        {
            name: '素材中心',
            image: menu_file,
            url: '/material/index'
        },
        {
            name: '菜单权限',
            image: menu_auth,
            url: '/permission/menu'
        },
        {
            name: '网站信息',
            image: menu_web,
            url: '/setting/website/information'
        }
    ], // 常用功能
    visitor: [], // 访问量
    article: [], // 文章阅读量

    visitorOption: {
        xAxis: {
            type: 'category',
            data: [0]
        },
        yAxis: {
            type: 'value'
        },
        legend: {
            data: ['销售额']
        },
        itemStyle: {
            // 点的颜色。
            color: 'red'
        },
        tooltip: {
            trigger: 'axis'
        },
        series: [
            {
                name: '销售额',
                data: [0],
                type: 'line',
                smooth: true
            }
        ]
    },
    listOption: {
        xAxis: {
            show: false
        },
        grid: {
            left: 100
        },
        yAxis: {
            type: 'category',
            data: [
                '西红柿炒鸡蛋',
                '梅菜扣肉',
                '黄瓜变蛋',
                '蛋炒饭',
                '爆炒虾尾',
                '香辣虾',
                '爆炒鱿鱼'
            ],
            axisLine: {
                show: false
            },
            offset: 90,
            inverse: true,
            axisTick: {
                show: false
            },
            width: 50,
            axisLabel: {
                show: true,
                formatter: (value: any, index: any) => {
                    let rankNo = 'noraml'
                    switch (index) {
                        case 0:
                            rankNo = 'no1'
                            break
                        case 1:
                            rankNo = 'no2'
                            break
                        case 2:
                            rankNo = 'no3'
                            break
                    }
                    return `{${rankNo}|${index + 1}} {labelName|${value}}`
                },
                align: 'left',
                rich: {
                    no1: {
                        backgroundColor: '#ff0000',
                        color: '#fff',
                        padding: [2, 5, 2, 5]
                    },
                    no2: {
                        backgroundColor: '#ff8510',
                        color: 'yellow',
                        padding: [2, 5, 2, 5]
                    },
                    no3: {
                        backgroundColor: 'green',
                        color: '#fff',
                        padding: [2, 5, 2, 5]
                    },
                    labelName: {
                        fontWeight: 'bold',
                        textAlign: 'left',
                        width: '90px',
                        overflow: 'break'
                    },
                    noraml: {
                        backgroundColor: '#ccc',
                        color: '#fff',
                        width: '40px',
                        padding: [2, 5, 2, 5]
                    }
                }
            }
        },
        series: [
            {
                data: [33, 26, 25, 15, 12, 9, 9],
                type: 'bar',
                label: {
                    show: true,
                    position: 'right'
                },
                color: '#009982',
                barWidth: '30px'
            }
        ]
    }
})

// 获取工作台主页数据
const getData = async () => {
    const res = await getWorkbench()
    workbenchData.version = res.version
    workbenchData.today = res.today
    workbenchData.visitor = res.visitor

    // 清空echarts 数据
    workbenchData.visitorOption.xAxis.data = []
    workbenchData.visitorOption.series[0].data = []

    // 写入从后台拿来的数据
    workbenchData.visitorOption.xAxis.data = res.visitor.date
    workbenchData.visitorOption.series[0].data = res.visitor.list
}
const shopInfo = () => {
    getShopConfig().then((res) => {
        workbenchData.shopId = res.id
        workbenchData.shopName = res.name
        workbenchData.shopStatus = res.status
    })
}
const changeStatus = () => {
    if (workbenchData.shopStatus == 1) {
        workbenchData.shopStatus = 0
    } else {
        workbenchData.shopStatus = 1
    }
    changeShopStatus({ id: workbenchData.shopId, status: workbenchData.shopStatus })
}
shopInfo()
getData()
</script>

<style lang="scss" scoped></style>
