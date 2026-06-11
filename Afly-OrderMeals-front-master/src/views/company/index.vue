<template>
    <div class="company-manage">
<!--        <el-card class="company-manage__hero !border-none" shadow="never">-->
<!--            <div class="company-manage__hero-main">-->
<!--                <div>-->
<!--                    <div class="company-manage__hero-title">认证与积分管理</div>-->
<!--                    <div class="company-manage__hero-desc">-->
<!--                        管理小程序用户公司认证信息，并按若依角色标准发放积分余额。-->
<!--                    </div>-->
<!--                </div>-->
<!--                <div class="company-manage__rules">-->
<!--                    <div class="company-manage__rule-item company-manage__rule-item&#45;&#45;high">-->
<!--                        <span class="company-manage__rule-value">500</span>-->
<!--                        <span class="company-manage__rule-label">总监及以上</span>-->
<!--                    </div>-->
<!--                    <div class="company-manage__rule-item">-->
<!--                        <span class="company-manage__rule-value">200</span>-->
<!--                        <span class="company-manage__rule-label">其他角色</span>-->
<!--                    </div>-->
<!--                </div>-->
<!--            </div>-->
<!--        </el-card>-->

        <el-card class="!border-none mt-4" shadow="never">
            <el-tabs v-model="activeTab">
                <el-tab-pane label="认证管理" name="auth" />
                <el-tab-pane label="积分发放明细" name="points" />
            </el-tabs>

            <template v-if="activeTab === 'auth'">
                <div class="company-manage__toolbar">
                    <el-alert
                        class="company-manage__alert"
                        type="info"
                        :closable="false"
                        show-icon
                        title="发放规则：根据若依账号角色自动计算，总监/副总监/管理员等高级角色 500 积分，其余角色 200 积分。"
                    />
                    <el-button type="primary" :loading="grantAllLoading" @click="handleGrantAll">
                        全部认证用户发放积分
                    </el-button>
                </div>

                <el-form :inline="true" class="company-manage__search mb-[-16px]">
                    <el-form-item label="部门">
                        <el-input v-model="authParams.deptName" class="w-[180px]" clearable placeholder="部门名称" />
                    </el-form-item>
                    <el-form-item label="若依账号">
                        <el-input v-model="authParams.userName" class="w-[160px]" clearable placeholder="用户名" />
                    </el-form-item>
                    <el-form-item label="姓名">
                        <el-input v-model="authParams.nickName" class="w-[160px]" clearable placeholder="姓名" />
                    </el-form-item>
                    <el-form-item label="手机号">
                        <el-input v-model="authParams.mobile" class="w-[160px]" clearable placeholder="手机号" />
                    </el-form-item>
                    <el-form-item label="认证时间">
                        <el-date-picker
                            v-model="authTimeRange"
                            type="datetimerange"
                            range-separator="-"
                            start-placeholder="开始"
                            end-placeholder="结束"
                            @change="setAuthTime"
                        />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="resetAuthPage">查询</el-button>
                        <el-button @click="resetAuthParams">重置</el-button>
                    </el-form-item>
                </el-form>
            </template>

            <el-form v-else :inline="true" class="company-manage__search mb-[-16px]">
                <el-form-item label="用户ID">
                    <el-input v-model="pointsParams.userId" class="w-[120px]" clearable placeholder="用户ID" />
                </el-form-item>
                <el-form-item label="手机号">
                    <el-input v-model="pointsParams.mobile" class="w-[160px]" clearable placeholder="手机号" />
                </el-form-item>
                <el-form-item label="来源">
                    <el-select v-model="pointsParams.source" class="w-[150px]" clearable placeholder="全部">
                        <el-option label="首次认证" :value="1" />
                        <el-option label="月度发放" :value="2" />
                        <el-option label="订单扣减" :value="3" />
                        <el-option label="手工发放" :value="4" />
                    </el-select>
                </el-form-item>
                <el-form-item label="月份">
                    <el-input v-model="pointsParams.grantMonth" class="w-[140px]" clearable placeholder="yyyy-MM" />
                </el-form-item>
                <el-form-item label="变动时间">
                    <el-date-picker
                        v-model="pointsTimeRange"
                        type="datetimerange"
                        range-separator="-"
                        start-placeholder="开始"
                        end-placeholder="结束"
                        @change="setPointsTime"
                    />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetPointsPage">查询</el-button>
                    <el-button @click="resetPointsParams">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <el-card v-if="activeTab === 'auth'" class="!border-none mt-4" shadow="never">
            <el-table v-loading="authPager.loading" :data="authPager.lists" stripe>
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="company-manage__user-cell">
                            <div class="company-manage__user-name">{{ row.nickName || row.nickname || '-' }}</div>
                            <div class="company-manage__user-sub">ID {{ row.userId }} · {{ row.mobile || '无手机号' }}</div>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="部门" prop="deptName" min-width="140" show-overflow-tooltip />
                <el-table-column label="星枢账号" prop="userName" width="120" />
                <el-table-column label="当前余额" width="110" align="center">
                    <template #default="{ row }">
                        <el-tag type="warning" effect="plain">{{ row.balance ?? 0 }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="认证时间" prop="authTime" width="170" />
                <el-table-column label="操作" width="120" fixed="right" align="center">
                    <template #default="{ row }">
                        <el-button
                            type="primary"
                            link
                            :loading="grantingUserId === row.userId"
                            @click="handleGrantOne(row)"
                        >
                            发放积分
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="authPager" @change="getAuthLists" />
            </div>
        </el-card>

        <el-card v-else class="!border-none mt-4" shadow="never">
            <el-table v-loading="pointsPager.loading" :data="pointsPager.lists" stripe>
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="company-manage__user-cell">
                            <div class="company-manage__user-name">{{ row.nickname || '-' }}</div>
                            <div class="company-manage__user-sub">ID {{ row.userId }} · {{ row.mobile || '无手机号' }}</div>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="变动积分" width="100" align="center">
                    <template #default="{ row }">
                        <span :class="row.changeAmount >= 0 ? 'text-success' : 'text-danger'">
                            {{ row.changeAmount >= 0 ? '+' : '' }}{{ row.changeAmount }}
                        </span>
                    </template>
                </el-table-column>
                <el-table-column label="变动后余额" prop="balanceAfter" width="110" align="center" />
                <el-table-column label="来源" width="100" align="center">
                    <template #default="{ row }">
                        <el-tag size="small" :type="sourceTagType(row.source)">{{ row.sourceText }}</el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="月份/备注" prop="grantMonth" min-width="130" show-overflow-tooltip />
                <el-table-column label="订单ID" prop="orderId" width="90" align="center">
                    <template #default="{ row }">{{ row.orderId || '-' }}</template>
                </el-table-column>
                <el-table-column label="角色" prop="ruoyiRoleName" min-width="120" show-overflow-tooltip />
                <el-table-column label="变动时间" prop="createTime" width="170" />
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="pointsPager" @change="getPointsLists" />
            </div>
        </el-card>
    </div>
</template>

<script setup lang="ts">
import { companyAuthList, companyGrantPoints, companyGrantPointsAll, companyPointsLogList } from '@/api/company'
import { usePaging } from '@/hooks/usePaging'
import feedback from '@/utils/feedback'

const activeTab = ref('auth')
const authTimeRange = ref()
const pointsTimeRange = ref()
const grantAllLoading = ref(false)
const grantingUserId = ref<number | null>(null)

const authParams = reactive({
    deptName: '',
    userName: '',
    nickName: '',
    mobile: '',
    authTime: ''
})

const pointsParams = reactive({
    userId: '',
    mobile: '',
    source: '',
    grantMonth: '',
    createTime: ''
})

const { pager: authPager, getLists: getAuthLists, resetPage: resetAuthPage, resetParams: resetAuthParams } = usePaging({
    fetchFun: companyAuthList,
    params: authParams
})

const { pager: pointsPager, getLists: getPointsLists, resetPage: resetPointsPage, resetParams: resetPointsParams } = usePaging({
    fetchFun: companyPointsLogList,
    params: pointsParams
})

const sourceTagType = (source: number) => {
    if (source === 3) return 'danger'
    if (source === 4) return 'success'
    if (source === 2) return 'warning'
    return 'info'
}

const setAuthTime = (range: Date[] | null) => {
    if (!range || range.length !== 2) {
        authParams.authTime = ''
        return
    }
    authParams.authTime = `${Math.round(range[0].getTime() / 1000)},${Math.round(range[1].getTime() / 1000)}`
}

const setPointsTime = (range: Date[] | null) => {
    if (!range || range.length !== 2) {
        pointsParams.createTime = ''
        return
    }
    pointsParams.createTime = `${Math.round(range[0].getTime() / 1000)},${Math.round(range[1].getTime() / 1000)}`
}

const handleGrantOne = async (row: { userId: number; nickName?: string; deptName?: string }) => {
    await feedback.confirm(
        `确定为「${row.nickName || row.deptName || row.userId}」发放积分吗？\n系统将按若依角色自动发放（总监及以上 500，其他 200）。`
    )
    grantingUserId.value = row.userId
    try {
        const result = await companyGrantPoints(row.userId)
        feedback.notifySuccess(`发放成功：+${result.amount}，当前余额 ${result.balanceAfter}`)
        getAuthLists()
    } finally {
        grantingUserId.value = null
    }
}

const handleGrantAll = async () => {
    await feedback.confirm(
        '确定为全部已认证用户发放积分吗？\n每位用户按若依角色发放（总监及以上 500，其他 200）。'
    )
    grantAllLoading.value = true
    try {
        const result = await companyGrantPointsAll()
        feedback.notifySuccess(
            `批量发放完成：共 ${result.totalUsers} 人，成功 ${result.successCount} 人，合计 +${result.totalAmount} 积分`
        )
        getAuthLists()
    } finally {
        grantAllLoading.value = false
    }
}

watch(activeTab, (tab) => {
    if (tab === 'auth') {
        getAuthLists()
    } else {
        getPointsLists()
    }
})

getAuthLists()
</script>

<style scoped>
.company-manage__hero {
    background: linear-gradient(135deg, #fff7f7 0%, #ffffff 100%);
}

.company-manage__hero-main {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 24px;
}

.company-manage__hero-title {
    font-size: 22px;
    font-weight: 700;
    color: #303133;
}

.company-manage__hero-desc {
    margin-top: 8px;
    font-size: 14px;
    color: #909399;
}

.company-manage__rules {
    display: flex;
    gap: 16px;
}

.company-manage__rule-item {
    min-width: 120px;
    padding: 16px 20px;
    border-radius: 12px;
    background: #f5f7fa;
    text-align: center;
}

.company-manage__rule-item--high {
    background: rgba(245, 108, 108, 0.08);
}

.company-manage__rule-value {
    display: block;
    font-size: 28px;
    font-weight: 700;
    color: #303133;
    line-height: 1.2;
}

.company-manage__rule-item--high .company-manage__rule-value {
    color: #f56c6c;
}

.company-manage__rule-label {
    display: block;
    margin-top: 6px;
    font-size: 13px;
    color: #909399;
}

.company-manage__toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 16px;
}

.company-manage__alert {
    flex: 1;
}

.company-manage__search {
    margin-top: 4px;
}

.company-manage__user-cell {
    line-height: 1.4;
}

.company-manage__user-name {
    font-weight: 600;
    color: #303133;
}

.company-manage__user-sub {
    margin-top: 4px;
    font-size: 12px;
    color: #909399;
}

.text-success {
    color: #67c23a;
    font-weight: 600;
}

.text-danger {
    color: #f56c6c;
    font-weight: 600;
}
</style>
