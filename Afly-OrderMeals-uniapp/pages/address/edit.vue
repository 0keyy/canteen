<template>
  <view class="edit-page">
    <view class="edit-page__header">
      <view class="edit-page__back-btn" @tap="goBack">
        <text class="edit-page__back-icon">‹</text>
      </view>
      <text class="edit-page__title">编辑地址</text>
      <view class="edit-page__header-right"></view>
    </view>
    <scroll-view class="edit-page__content" scroll-y :show-scrollbar="false">
      <view class="edit-page__map-card" @tap="selectLocation">
        <view class="edit-page__map-main">
          <text class="edit-page__map-title">点击地图选择位置</text>
          <text v-if="fullAddress" class="edit-page__map-selected">
            {{ fullAddress }}
          </text>
          <text v-else class="edit-page__map-placeholder">请选择收货地址</text>
        </view>
        <text class="edit-page__map-change">更改</text>
      </view>

      <view class="edit-page__section">
        <view class="edit-page__form-item">
          <text class="edit-page__label">详细地址</text>
          <input
              v-model="form.detail"
              class="edit-page__input"
              placeholder="例：XX大厦1幢101室"
              placeholder-class="edit-page__placeholder"
              maxlength="50"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">联系人</text>
          <view class="edit-page__contact-row">
            <input
                v-model="form.contactName"
                class="edit-page__input edit-page__input--name"
                placeholder="请填写姓名"
                placeholder-class="edit-page__placeholder"
                maxlength="20"
            />
            <view class="edit-page__gender-radio">
              <view class="edit-page__radio-option"
                  :class="{ 'edit-page__radio-option--active': form.gender === '先生' }"
                  @tap="form.gender = '先生'"
              >
                <view class="edit-page__radio-dot"></view>
                <text class="edit-page__radio-text">先生</text>
              </view>
              <view
                  class="edit-page__radio-option"
                  :class="{ 'edit-page__radio-option--active': form.gender === '女士' }"
                  @tap="form.gender = '女士'"
              >
                <view class="edit-page__radio-dot"></view>
                <text class="edit-page__radio-text">女士</text>
              </view>
            </view>
          </view>
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">手机号</text>
          <input
              v-model="form.contactMobile"
              class="edit-page__input"
              type="number"
              placeholder="请填写手机号"
              placeholder-class="edit-page__placeholder"
              maxlength="11"
              @blur="validatePhone"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">设置为默认</text>
          <switch
              :checked="form.isDefault === 1"
              color="#D00000"
              @change="(e) => { form.isDefault = e.detail.value ? 1 : 0 }"
          />
        </view>
      </view>

      <view class="edit-page__bottom-space"></view>
    </scroll-view>

    <view class="edit-page__footer safe-area-bottom">
      <view class="edit-page__save-btn" @tap="save">
        <text class="edit-page__save-text">保存</text>
      </view>
    </view>
  </view>
</template>

<script setup>
import { reactive, computed } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { addressApi } from '../../api/index'

const form = reactive({
  id: null,
  province: '',
  city: '',
  district: '',
  address: '',
  detail: '',
  contactName: '',
  contactMobile: '',
  gender: '',
  label: 0,
  lat: '',
  lng: '',
  isDefault: 0
})

const fullAddress = computed(() => {
  // 编辑中实时显示：前端拼接
  return [form.province, form.city, form.district, form.address, form.detail]
    .filter(Boolean)
    .join(' ')
})

onLoad(async (options) => {
  if (options.id) {
    const detail = await addressApi.detail(Number(options.id))
    Object.assign(form, detail)
  } else {
    form.isDefault = 1
  }
})

function goBack() {
  uni.navigateBack()
}

function selectLocation() {
  uni.chooseLocation({
    success: (res) => {
      form.lat = String(res.latitude)
      form.lng = String(res.longitude)
      form.address = res.name
    },
    fail: (err) => {
      // 用户主动取消，不提示
      if (err.errMsg && err.errMsg.includes('cancel')) {
        uni.showToast({ title: '已取消', icon: 'none' })
        return
      }
      // 真正的错误才提示
      uni.showToast({ title: '无法打开地图，请重试', icon: 'none' })
    }
  })
}

const phoneRegex = /^1[3-9]\d{9}$/

async function save() {
  if (!form.address) {
    uni.showToast({ title: '请先选择地址', icon: 'none' })
    return
  }
  if (!form.contactName) {
    uni.showToast({ title: '请填写联系人姓名', icon: 'none' })
    return
  }
  if (!form.contactMobile || !phoneRegex.test(form.contactMobile)) {
    uni.showToast({ title: '请填写正确手机号', icon: 'none' })
    return
  }

  uni.showLoading({ title: '保存中...' })
  try {
    await addressApi.save(form)
    uni.hideLoading()
    uni.showToast({ title: '保存成功', icon: 'success' })
    setTimeout(() => {
      uni.navigateBack()
    }, 800)
  } catch (e) {
    uni.hideLoading()
    uni.showToast({ title: e || '保存失败', icon: 'none' })
  }
}

function validatePhone() {
  if (form.contactMobile && !phoneRegex.test(form.contactMobile)) {
    uni.showToast({ title: '手机号格式不正确', icon: 'none' })
  }
}
</script>

<style lang="scss" scoped>
.edit-page {
  min-height: 100vh;
  background: #FFFFFF;
  display: flex;
  flex-direction: column;

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 38rpx;
    padding: 60rpx 32rpx 24rpx;
    background: #FFFFFF;
  }

  &__back-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 80rpx;
    color: #333333;
    font-weight: 300;
    line-height: 1;
  }

  &__title {
    font-size: 34rpx;
    font-weight: 600;
    color: #333333;
  }

  &__header-right {
    width: 64rpx;
  }

  &__content {
    flex: 1;
    padding: 0 24rpx;
  }

  &__map-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx;
    background: #FFFFFF;
    border: 2rpx solid #b6b5b5;
    border-radius: 16rpx;
    margin-bottom: 24rpx;
    margin-top: 32rpx;
  }

  &__map-main {
    flex: 1;
    min-width: 0;
  }

  &__map-title {
    display: block;
    font-size: 26rpx;
    color: #666;
    margin-bottom: 8rpx;
  }

  &__map-selected {
    display: block;
    font-size: 28rpx;
    font-weight: 600;
    color: #333;
  }

  &__map-placeholder {
    display: block;
    font-size: 28rpx;
    color: #CCC;
  }

  &__map-change {
    font-size: 26rpx;
    color: #a01e1e;
    font-weight: 500;
    flex-shrink: 0;
    margin-left: 16rpx;
  }

  &__section {
    background: #FFFFFF;
    border-radius: 16rpx;
    border: 1rpx solid #F0F0F0;
    padding: 0;
  }

  &__form-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx 28rpx;
    border-bottom: 1rpx solid #F5F5F5;

    &:last-child {
      border-bottom: none;
    }
  }

  &__label {
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
    flex-shrink: 0;
    width: 140rpx;
  }

  &__input {
    flex: 1;
    text-align: left;
    font-size: 28rpx;
    color: #333333;

    &--name {
      flex: none;
      width: 300rpx;
      text-align: left;
    }
  }

  &__placeholder {
    color: #CCCCCC;
  }

  &__contact-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__gender-radio {
    display: flex;
    gap: 16rpx;
  }

  &__radio-option {
    display: flex;
    align-items: center;
    gap: 6rpx;
    padding: 6rpx 12rpx;
    border: 1rpx solid #DDD;
    border-radius: 999rpx;

    &--active {
      border-color: #a01e1e;
      background: #FFEBEB;
    }
  }

  &__radio-dot {
    width: 12rpx;
    height: 12rpx;
    border-radius: 50%;
    background: #fff;
    border: 1rpx solid #DDD;

    .edit-page__radio-option--active & {
      background: #a01e1e;
      border-color: #a01e1e;
    }
  }

  &__radio-text {
    font-size: 24rpx;
    color: #666;

    .edit-page__radio-option--active & {
      color: #a01e1e;
    }
  }

  &__bottom-space {
    height: 40rpx;
  }

  &__footer {
    padding: 24rpx;
    background: #fff;
  }

  &__save-btn {
    width: 100%;
    padding: 24rpx;
    background: #a01e1e;
    border-radius: 999rpx;
    text-align: center;
  }

  &__save-text {
    font-size: 30rpx;
    color: #fff;
    font-weight: 600;
  }
}
</style>
