<!-- 网站信息 -->
<template>
    <div class="website-information">
        <el-form ref="formRef" :model="formData" label-width="120px">
            <el-card shadow="never" class="!border-none">
                <div class="text-xl font-medium mb-[20px]">店铺设置</div>
                <el-form-item label="店铺名称" prop="name">
                    <div class="w-80">
                        <el-input
                            v-model="formData.name"
                            placeholder="请输入店铺名称"
                            maxlength="30"
                            show-word-limit
                        ></el-input>
                    </div>
                </el-form-item>
                <el-form-item label="店铺简介" prop="intro">
                    <div class="w-80">
                        <el-input
                            v-model="formData.intro"
                            :rows="5"
                            type="textarea"
                            placeholder="请输入店铺介绍"
                            maxlength="100"
                            show-word-limit
                        ></el-input>
                    </div>
                </el-form-item>
                <el-form-item label="店铺公告" prop="notice">
                    <div class="w-80">
                        <el-input
                            v-model="formData.notice"
                            :rows="5"
                            type="textarea"
                            placeholder="请输入店铺公告"
                            maxlength="100"
                            show-word-limit
                        ></el-input>
                    </div>
                </el-form-item>
                <el-form-item label="店铺图片" prop="image">
                    <div>
                        <material-picker v-model="formData.image" :limit="1" />
                        <div class="form-tips">建议尺寸：100*100像素，支持jpg，jpeg，png格式</div>
                    </div>
                </el-form-item>
                <el-form-item label="预支付" prop="prePay">
                    <el-switch v-model="formData.prePay" :active-value="1" :inactive-value="0" />
                </el-form-item>
                <el-form-item label="店铺状态" prop="status">
                    <el-switch v-model="formData.status" :active-value="1" :inactive-value="0" />
                </el-form-item>
            </el-card>
            <el-card shadow="never" class="!border-none mt-4">
                <div class="text-xl font-medium mb-[20px]">外卖设置</div>
                <el-form-item label="开启外卖" prop="deliveryEnable">
                    <el-switch v-model="formData.deliveryEnable" :active-value="1" :inactive-value="0" />
                    <div class="form-tips">开启后，小程序首页将显示「外卖配送」入口</div>
                </el-form-item>
                <template v-if="formData.deliveryEnable === 1">
                    <el-form-item label="配送费(元)" prop="deliveryFee">
                        <div class="w-80">
                            <el-input-number
                                v-model="formData.deliveryFee"
                                :precision="2"
                                :min="0"
                                :max="9999"
                                controls-position="right"
                            />
                        </div>
                    </el-form-item>
                    <el-form-item label="起送价(元)" prop="minOrderAmount">
                        <div class="w-80">
                            <el-input-number
                                v-model="formData.minOrderAmount"
                                :precision="2"
                                :min="0"
                                :max="9999"
                                controls-position="right"
                            />
                        </div>
                    </el-form-item>
                    <el-form-item label="配送半径(km)" prop="deliveryRadius">
                        <div class="w-80">
                            <el-input-number
                                v-model="formData.deliveryRadius"
                                :precision="2"
                                :min="0"
                                :max="100"
                                controls-position="right"
                            />
                        </div>
                    </el-form-item>
                </template>
            </el-card>
            <!-- <el-card shadow="never" class="!border-none mt-4">
                <div class="text-xl font-medium mb-[20px]">前台设置</div>
                <el-form-item label="商城名称" prop="shopName">
                    <div class="w-80">
                        <el-input
                            v-model="formData.shopName"
                            placeholder="请输入店铺/商城名称"
                            maxlength="30"
                            show-word-limit
                        ></el-input>
                    </div>
                </el-form-item>
                <el-form-item label="商城LOGO" prop="shopLogo">
                    <div>
                        <material-picker v-model="formData.shopLogo" :limit="1" />
                        <div class="form-tips">建议尺寸：100*100px，支持jpg，jpeg，png格式</div>
                    </div>
                </el-form-item>
            </el-card>
            <el-card shadow="never" class="!border-none mt-4">
                <div class="text-xl font-medium mb-[20px]">PC端设置</div>
                <el-form-item label="PC端LOGO" prop="pcLogo">
                    <div>
                        <material-picker v-model="formData.pcLogo" :limit="1" />
                        <div class="form-tips">建议尺寸：120*28px，支持jpg，jpeg，png格式</div>
                    </div>
                </el-form-item>
                <el-form-item label="网站标题" prop="pcTitle">
                    <div class="w-80">
                        <el-input
                            v-model.trim="formData.pcTitle"
                            placeholder="请输入PC端网站标题"
                            maxlength="30"
                            show-word-limit
                        />
                    </div>
                </el-form-item>
                <el-form-item label="网站图标" prop="pcIco">
                    <div>
                        <material-picker v-model="formData.pcIco" :limit="1" />
                        <div class="form-tips">建议尺寸：100*100像素，支持jpg，jpeg，png格式</div>
                    </div>
                </el-form-item>
                <el-form-item label="网站描述" prop="pcDesc">
                    <div class="w-80">
                        <el-input v-model.trim="formData.pcDesc" placeholder="请输入PC端网站描述" />
                    </div>
                </el-form-item>
                <el-form-item label="网站关键词" prop="pcKeywords">
                    <div class="w-80">
                        <el-input
                            v-model.trim="formData.pcKeywords"
                            placeholder="请输入PC端网站关键词"
                        />
                    </div>
                </el-form-item>
            </el-card> -->
        </el-form>
        <footer-btns v-perms="['setting:website:save']">
            <el-button type="primary" @click="handleSubmit">保存</el-button>
        </footer-btns>
    </div>
</template>

<script lang="ts" setup name="webInformation">
import { getShopConfig, saveShopConfig } from '@/api/shop'
import feedback from '@/utils/feedback'
import type { FormInstance } from 'element-plus'
const formRef = ref<FormInstance>()
// 表单数据
const formData = reactive({
    id: '',
    name: '', // 店铺名称
    intro: '',
    notice: '',
    image: '',
    status: '',
    prePay: '',
    deliveryEnable: 0,
    deliveryFee: 0,
    minOrderAmount: 0,
    deliveryRadius: 5
})

// 表单验证
// const rules = {
//     name: [
//         {
//             required: true,
//             message: '请输入网站名称',
//             trigger: ['blur']
//         }
//     ],
//     favicon: [
//         {
//             required: true,
//             message: '请选择网站图标',
//             trigger: ['change']
//         }
//     ],
//     logo: [
//         {
//             required: true,
//             message: '请选择网站logo',
//             trigger: ['change']
//         }
//     ],
//     backdrop: [
//         {
//             required: true,
//             message: '请选择登录页广告图',
//             trigger: ['change']
//         }
//     ],
//     shopName: [
//         {
//             required: true,
//             message: '请输入店铺/商城名称',
//             trigger: ['blur']
//         }
//     ],
//     shopLogo: [
//         {
//             required: true,
//             message: '请选择商城LOGO',
//             trigger: ['change']
//         }
//     ],
//     pcLogo: [
//         {
//             required: true,
//             message: '请选择PC端LOGO',
//             trigger: ['change']
//         }
//     ],
//     pcTitle: [
//         {
//             required: true,
//             message: '请输入PC端网站标题',
//             trigger: ['blur']
//         }
//     ],
//     pcIco: [
//         {
//             required: true,
//             message: '请选择PC端网站图标',
//             trigger: ['change']
//         }
//     ]
// }

// 获取店铺信息
const getData = async () => {
    const data = await getShopConfig()
    for (const key in formData) {
        //@ts-ignore
        formData[key] = data[key]
    }
    if (formData.deliveryEnable === '' || formData.deliveryEnable == null) {
        formData.deliveryEnable = 0
    }
    if (formData.deliveryFee == null) formData.deliveryFee = 0
    if (formData.minOrderAmount == null) formData.minOrderAmount = 0
    if (formData.deliveryRadius == null) formData.deliveryRadius = 5
}

// 保存店铺信息
const handleSubmit = async () => {
    // await formRef.value?.validate()
    await saveShopConfig(formData)
    feedback.msgSuccess('操作成功')
    getData()
}

getData()
</script>

<style lang="scss" scoped></style>
