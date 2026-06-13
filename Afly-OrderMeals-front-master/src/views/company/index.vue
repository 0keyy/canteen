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
                <el-tab-pane label="挂账配置" name="creditConfig" />
                <el-tab-pane label="挂账扣减明细" name="creditLog" />
                <el-tab-pane label="月挂账账户" name="creditStats" />
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
                    <el-button type="primary" @click="handleGrantAll">
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

            <template v-else-if="activeTab === 'creditConfig'">
                <div class="company-manage__toolbar">
                    <el-alert
                        class="company-manage__alert"
                        type="info"
                        :closable="false"
                        show-icon
                        title="按若依职级(role_id)设置月挂账上限。用户拥有多个角色时，取已启用配置中上限最高的职级。"
                    />
                    <div class="company-manage__credit-switch">
                        <span>挂账支付</span>
                        <el-switch
                            v-model="creditConfigForm.creditEnable"
                            :active-value="1"
                            :inactive-value="0"
                        />
                    </div>
                    <el-button type="primary" :loading="creditConfigSaving" @click="saveCreditConfig">
                        保存配置
                    </el-button>
                </div>
            </template>

            <el-form v-else-if="activeTab === 'creditLog'" :inline="true" class="company-manage__search mb-[-16px]">
                <el-form-item label="用户ID">
                    <el-input v-model="creditLogParams.userId" class="w-[120px]" clearable placeholder="用户ID" />
                </el-form-item>
                <el-form-item label="手机号">
                    <el-input v-model="creditLogParams.mobile" class="w-[160px]" clearable placeholder="手机号" />
                </el-form-item>
                <el-form-item label="月份">
                    <el-input v-model="creditLogParams.creditMonth" class="w-[140px]" clearable placeholder="yyyy-MM" />
                </el-form-item>
                <el-form-item label="挂账时间">
                    <el-date-picker
                        v-model="creditLogTimeRange"
                        type="datetimerange"
                        range-separator="-"
                        start-placeholder="开始"
                        end-placeholder="结束"
                        @change="setCreditLogTime"
                    />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetCreditLogPage">查询</el-button>
                    <el-button @click="resetCreditLogParams">重置</el-button>
                    <el-button :loading="creditLogSyncing" @click="handleCreditLogSync">重建挂账数据</el-button>
                </el-form-item>
            </el-form>

            <el-form v-else-if="activeTab === 'creditStats'" :inline="true" class="company-manage__search mb-[-16px]">
                <el-form-item label="用户ID">
                    <el-input v-model="creditStatsParams.userId" class="w-[120px]" clearable placeholder="用户ID" />
                </el-form-item>
                <el-form-item label="手机号">
                    <el-input v-model="creditStatsParams.mobile" class="w-[160px]" clearable placeholder="手机号" />
                </el-form-item>
                <el-form-item label="姓名">
                    <el-input v-model="creditStatsParams.nickName" class="w-[160px]" clearable placeholder="姓名" />
                </el-form-item>
                <el-form-item label="部门">
                    <el-input v-model="creditStatsParams.deptName" class="w-[180px]" clearable placeholder="部门名称" />
                </el-form-item>
                <el-form-item label="月份">
                    <el-input v-model="creditStatsParams.creditMonth" class="w-[140px]" clearable placeholder="yyyy-MM" />
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="resetCreditStatsPage">查询</el-button>
                    <el-button @click="resetCreditStatsParams">重置</el-button>
                </el-form-item>
            </el-form>

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

        <el-card v-else-if="activeTab === 'creditConfig'" class="!border-none mt-4" shadow="never">
            <el-table v-loading="creditConfigLoading" :data="creditConfigForm.roleConfigs" stripe>
                <el-table-column label="角色ID" prop="roleId" width="90" align="center" />
                <el-table-column label="职级名称" prop="roleName" min-width="140" show-overflow-tooltip />
                <el-table-column label="权限标识" prop="roleKey" min-width="120" show-overflow-tooltip />
                <el-table-column label="月挂账上限(元)" width="180" align="center">
                    <template #default="{ row }">
                        <el-input-number
                            v-model="row.monthlyLimit"
                            :min="0"
                            :max="999999"
                            :step="100"
                            :precision="2"
                            controls-position="right"
                        />
                    </template>
                </el-table-column>
                <el-table-column label="启用" width="90" align="center">
                    <template #default="{ row }">
                        <el-switch v-model="row.isEnable" :active-value="1" :inactive-value="0" />
                    </template>
                </el-table-column>
            </el-table>
        </el-card>

        <el-card v-else-if="activeTab === 'creditLog'" class="!border-none mt-4" shadow="never">
            <el-table v-loading="creditLogPager.loading" :data="creditLogPager.lists" stripe>
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="company-manage__user-cell">
                            <div class="company-manage__user-name">{{ row.nickName || row.nickname || '-' }}</div>
                            <div class="company-manage__user-sub">ID {{ row.userId }} · {{ row.mobile || '无手机号' }}</div>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="部门" prop="deptName" min-width="120" show-overflow-tooltip />
                <el-table-column label="变动金额" width="100" align="center">
                    <template #default="{ row }">
                        <span class="text-danger">{{ formatCreditChange(row.changeAmount, row.amount) }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="变动后已用" prop="usedAfter" width="110" align="center" />
                <el-table-column label="变动后剩余" width="110" align="center">
                    <template #default="{ row }">
                        <el-tag :type="Number(row.remainAfter) > 0 ? 'success' : 'danger'" effect="plain">
                            {{ row.remainAfter ?? 0 }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="月上限" prop="monthlyLimit" width="100" align="center" />
                <el-table-column label="月份" prop="creditMonth" width="100" align="center" />
                <el-table-column label="订单号" prop="orderNumber" min-width="150" show-overflow-tooltip />
                <el-table-column label="订单ID" prop="orderId" width="90" align="center" />
                <el-table-column label="计额职级" prop="ruoyiRoleName" min-width="120" show-overflow-tooltip />
                <el-table-column label="扣减时间" prop="createTime" width="170" />
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="creditLogPager" @change="getCreditLogLists" />
            </div>
        </el-card>

        <el-card v-else-if="activeTab === 'creditStats'" class="!border-none mt-4" shadow="never">
            <el-table v-loading="creditStatsPager.loading" :data="creditStatsPager.lists" stripe>
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="company-manage__user-cell">
                            <div class="company-manage__user-name">{{ row.nickName || row.nickname || '-' }}</div>
                            <div class="company-manage__user-sub">ID {{ row.userId }} · {{ row.mobile || '无手机号' }}</div>
                        </div>
                    </template>
                </el-table-column>
                <el-table-column label="部门" prop="deptName" min-width="120" show-overflow-tooltip />
                <el-table-column label="月份" prop="creditMonth" width="100" align="center" />
                <el-table-column label="月挂账上限" prop="monthlyLimit" width="110" align="center" />
                <el-table-column label="已用额度" width="110" align="center">
                    <template #default="{ row }">
                        <span class="text-danger">{{ row.totalAmount }}</span>
                    </template>
                </el-table-column>
                <el-table-column label="剩余额度" width="110" align="center">
                    <template #default="{ row }">
                        <el-tag :type="row.remainAmount > 0 ? 'success' : 'danger'" effect="plain">
                            {{ row.remainAmount }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column label="挂账笔数" prop="orderCount" width="90" align="center" />
                <el-table-column label="计额职级" prop="ruoyiRoleName" min-width="120" show-overflow-tooltip />
            </el-table>
            <div class="flex justify-end mt-4">
                <pagination v-model="creditStatsPager" @change="getCreditStatsLists" />
            </div>
        </el-card>

        <el-card v-else-if="activeTab === 'points'" class="!border-none mt-4" shadow="never">
            <el-table v-loading="pointsPager.loading" :data="pointsPager.lists" stripe>
                <el-table-column label="用户" min-width="160">
                    <template #default="{ row }">
                        <div class="company-manage__user-cell">
                            <div class="company-manage__user-name">{{ row.nickName || row.nickname || '-' }}</div>
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

        <el-dialog
            v-model="grantDialogVisible"
            :title="grantScope === 'batch' ? '批量发放积分' : '发放积分'"
            width="440px"
            @closed="resetGrantForm"
        >
            <div v-if="grantScope === 'single' && grantTarget" class="company-manage__grant-user">
                用户：{{ grantTarget.nickName || grantTarget.nickname || grantTarget.deptName || grantTarget.userId }}
                <span class="company-manage__grant-user-sub">（ID {{ grantTarget.userId }}）</span>
            </div>
            <div v-else class="company-manage__grant-user">
                将为全部已认证用户发放积分
            </div>
            <el-radio-group v-model="grantForm.mode" class="company-manage__grant-mode">
                <el-radio label="auto">按角色自动发放（总监及以上 500，其他 200）</el-radio>
                <el-radio label="custom">自定义积分</el-radio>
            </el-radio-group>
            <div v-if="grantForm.mode === 'custom'" class="company-manage__grant-custom">
                <span class="company-manage__grant-label">
                    {{ grantScope === 'batch' ? '每人积分' : '积分数量' }}
                </span>
                <el-input-number v-model="grantForm.amount" :min="1" :max="999999" :step="1" step-strictly />
            </div>
            <template #footer>
                <el-button @click="grantDialogVisible = false">取消</el-button>
                <el-button type="primary" :loading="grantSubmitLoading" @click="submitGrant">
                    {{ grantScope === 'batch' ? '确认批量发放' : '确认发放' }}
                </el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup lang="ts">
import { companyAuthList, companyGrantPoints, companyGrantPointsAll, companyPointsLogList } from '@/api/company'
import { creditConfigDetail, creditConfigSave, creditLogList, creditLogSync, creditMonthlyStats } from '@/api/credit'
import { usePaging } from '@/hooks/usePaging'
import feedback from '@/utils/feedback'

const activeTab = ref('auth')
const authTimeRange = ref()
const pointsTimeRange = ref()
const creditLogTimeRange = ref()
const creditConfigLoading = ref(false)
const creditConfigSaving = ref(false)
const creditLogSyncing = ref(false)
const creditConfigForm = reactive({
    creditEnable: 0,
    roleConfigs: [] as Array<{
        roleId: number
        roleName: string
        roleKey: string
        monthlyLimit: number
        isEnable: number
    }>
})
const grantingUserId = ref<number | null>(null)
const grantDialogVisible = ref(false)
const grantSubmitLoading = ref(false)
const grantScope = ref<'single' | 'batch'>('single')
const grantTarget = ref<{ userId: number; nickName?: string; nickname?: string; deptName?: string } | null>(null)
const grantForm = reactive({
    mode: 'auto' as 'auto' | 'custom',
    amount: 200
})

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

const creditLogParams = reactive({
    userId: '',
    mobile: '',
    creditMonth: '',
    createTime: ''
})

const creditStatsParams = reactive({
    userId: '',
    mobile: '',
    nickName: '',
    deptName: '',
    creditMonth: ''
})

const { pager: authPager, getLists: getAuthLists, resetPage: resetAuthPage, resetParams: resetAuthParams } = usePaging({
    fetchFun: companyAuthList,
    params: authParams
})

const { pager: pointsPager, getLists: getPointsLists, resetPage: resetPointsPage, resetParams: resetPointsParams } = usePaging({
    fetchFun: companyPointsLogList,
    params: pointsParams
})

const {
    pager: creditLogPager,
    getLists: getCreditLogLists,
    resetPage: resetCreditLogPage,
    resetParams: resetCreditLogParams
} = usePaging({
    fetchFun: creditLogList,
    params: creditLogParams
})

const {
    pager: creditStatsPager,
    getLists: getCreditStatsLists,
    resetPage: resetCreditStatsPage,
    resetParams: resetCreditStatsParams
} = usePaging({
    fetchFun: creditMonthlyStats,
    params: creditStatsParams
})

const sourceTagType = (source: number) => {
    if (source === 3) return 'danger'
    if (source === 4) return 'success'
    if (source === 2) return 'warning'
    return 'info'
}

const formatCreditChange = (changeAmount?: number | string, amount?: number | string) => {
    if (changeAmount !== undefined && changeAmount !== null && changeAmount !== '') {
        const val = Number(changeAmount)
        if (!Number.isNaN(val)) {
            return val > 0 ? `+${val}` : `${val}`
        }
    }
    if (amount !== undefined && amount !== null && amount !== '') {
        return `-${amount}`
    }
    return '-'
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

const setCreditLogTime = (range: Date[] | null) => {
    if (!range || range.length !== 2) {
        creditLogParams.createTime = ''
        return
    }
    creditLogParams.createTime = `${Math.round(range[0].getTime() / 1000)},${Math.round(range[1].getTime() / 1000)}`
}

const loadCreditConfig = async () => {
    creditConfigLoading.value = true
    try {
        const detail = await creditConfigDetail()
        creditConfigForm.creditEnable = detail.creditEnable ?? 0
        creditConfigForm.roleConfigs = (detail.roleConfigs || []).map((item: any) => ({
            roleId: item.roleId,
            roleName: item.roleName,
            roleKey: item.roleKey,
            monthlyLimit: Number(item.monthlyLimit || 0),
            isEnable: item.isEnable ?? 0
        }))
    } finally {
        creditConfigLoading.value = false
    }
}

const saveCreditConfig = async () => {
    creditConfigSaving.value = true
    try {
        await creditConfigSave({
            creditEnable: creditConfigForm.creditEnable,
            roleConfigs: creditConfigForm.roleConfigs.map((item) => ({
                roleId: item.roleId,
                roleName: item.roleName,
                monthlyLimit: item.monthlyLimit,
                isEnable: item.isEnable
            }))
        })
        feedback.notifySuccess('挂账配置已保存')
    } finally {
        creditConfigSaving.value = false
    }
}

const handleCreditLogSync = async () => {
    creditLogSyncing.value = true
    try {
        const count = await creditLogSync()
        feedback.notifySuccess(`重建完成，共 ${count} 条挂账扣减记录`)
        getCreditLogLists()
    } finally {
        creditLogSyncing.value = false
    }
}

const handleGrantOne = (row: { userId: number; nickName?: string; nickname?: string; deptName?: string }) => {
    grantScope.value = 'single'
    grantTarget.value = row
    grantForm.mode = 'auto'
    grantForm.amount = 200
    grantDialogVisible.value = true
}

const handleGrantAll = () => {
    grantScope.value = 'batch'
    grantTarget.value = null
    grantForm.mode = 'auto'
    grantForm.amount = 200
    grantDialogVisible.value = true
}

const resetGrantForm = () => {
    grantScope.value = 'single'
    grantTarget.value = null
    grantForm.mode = 'auto'
    grantForm.amount = 200
}

const getGrantAmount = () => (grantForm.mode === 'custom' ? grantForm.amount : undefined)

const submitGrant = async () => {
    if (grantForm.mode === 'custom' && (!grantForm.amount || grantForm.amount < 1)) {
        feedback.msgError('请输入大于 0 的积分数量')
        return
    }

    const amount = getGrantAmount()
    grantSubmitLoading.value = true

    if (grantScope.value === 'batch') {
        try {
            const result = await companyGrantPointsAll(amount)
            feedback.notifySuccess(
                `批量发放完成：共 ${result.totalUsers} 人，成功 ${result.successCount} 人，合计 +${result.totalAmount} 积分`
            )
            grantDialogVisible.value = false
            getAuthLists()
        } finally {
            grantSubmitLoading.value = false
        }
        return
    }

    if (!grantTarget.value) {
        grantSubmitLoading.value = false
        return
    }

    const userId = grantTarget.value.userId
    grantingUserId.value = userId
    try {
        const result = await companyGrantPoints(userId, amount)
        feedback.notifySuccess(`发放成功：+${result.amount}，当前余额 ${result.balanceAfter}`)
        grantDialogVisible.value = false
        getAuthLists()
    } finally {
        grantingUserId.value = null
        grantSubmitLoading.value = false
    }
}

watch(activeTab, (tab) => {
    if (tab === 'auth') {
        getAuthLists()
    } else if (tab === 'points') {
        getPointsLists()
    } else if (tab === 'creditConfig') {
        loadCreditConfig()
    } else if (tab === 'creditLog') {
        getCreditLogLists()
    } else if (tab === 'creditStats') {
        getCreditStatsLists()
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

.company-manage__grant-user {
    margin-bottom: 16px;
    font-size: 15px;
    font-weight: 600;
    color: #303133;
}

.company-manage__grant-user-sub {
    margin-left: 4px;
    font-size: 13px;
    font-weight: 400;
    color: #909399;
}

.company-manage__grant-mode {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
}

.company-manage__grant-custom {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-top: 16px;
}

.company-manage__grant-label {
    font-size: 14px;
    color: #606266;
}

.company-manage__credit-switch {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: #606266;
    white-space: nowrap;
}
</style>
