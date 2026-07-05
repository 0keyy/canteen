<template>
  <view class="edit-page">
    <view class="edit-page__header">
        <view class="edit-page__back-btn" @tap="goBack">
          <text class="edit-page__back-icon">‹</text>
        </view>
        <text class="edit-page__title">编辑地址</text>
        <view class="edit-page__header-right"></view>
      </view>
      <view class="edit-page__content" scroll-y :show-scrollbar="false">
      <view class="edit-page__address-card" @tap="selectAddress">
        <view class="edit-page__address-main">
          <text class="edit-page__address-name">{{ form.companyName || '请选择地址' }}</text>
          <text class="edit-page__address-detail">{{ form.address || '请选择详细地址' }}</text>
        </view>
        <text class="edit-page__address-change">更换地址</text>
      </view>

      <view class="edit-page__section">
        <view class="edit-page__form-item">
          <text class="edit-page__label">详细地址</text>
          <view class="edit-page__input-wrap">
            <input 
              v-model="form.detail" 
              class="edit-page__input" 
              placeholder="例：1幢101" 
              placeholder-class="edit-page__placeholder"
            />
          </view>
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">联系人</text>
          <view class="edit-page__contact-row">
            <input 
              v-model="form.contactName" 
              class="edit-page__input edit-page__input--name" 
              placeholder="请填写" 
              placeholder-class="edit-page__placeholder"
            />
            <view class="edit-page__gender-radio">
              <view 
                class="edit-page__radio-option" 
                :class="{ 'edit-page__radio-option--active': gender === '先生' }"
                @tap="selectGender('先生')"
              >
                <view class="edit-page__radio-dot"></view>
                <text class="edit-page__radio-text">先生</text>
              </view>
              <view 
                class="edit-page__radio-option" 
                :class="{ 'edit-page__radio-option--active': gender === '女士' }"
                @tap="selectGender('女士')"
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
            placeholder="请填写" 
            placeholder-class="edit-page__placeholder"
            maxlength="11"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">设置为默认</text>
          <switch 
            :checked="form.isDefault === 1" 
            color="#D00000" 
            @change="onDefaultChange" 
          />
        </view>
      </view>

      <view class="edit-page__bottom-space"></view>
    </view>

    <view class="edit-page__footer safe-area-bottom">
      <view class="edit-page__save-btn" @tap="save">
        <text class="edit-page__save-text">保存</text>
      </view>
    </view>
  </view>
</template>

<script>
import { addressApi } from '../../api/index'

export default {
  data() {
    return {
      form: {
        id: null,
        companyName: '',
        address: '',
        province: '',
        city: '',
        district: '',
        detail: '',
        contactName: '',
        contactMobile: '',
        isDefault: 0
      },
      gender: ''
    }
  },
  async onLoad(options) {
    if (options.id) {
      const detail = await addressApi.detail(Number(options.id))
      this.form = { ...detail }
      this.extractGender()
    }
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    extractGender() {
      if (this.form.contactName) {
        if (this.form.contactName.endsWith('先生')) {
          this.gender = '先生'
          this.form.contactName = this.form.contactName.replace('先生', '')
        } else if (this.form.contactName.endsWith('女士')) {
          this.gender = '女士'
          this.form.contactName = this.form.contactName.replace('女士', '')
        }
      }
    },
    selectGender(gender) {
      this.gender = gender
    },
    onDefaultChange(e) {
      this.form.isDefault = e.detail.value ? 1 : 0
    },
    selectAddress() {
      uni.showToast({ title: '地址选择功能开发中', icon: 'none' })
    },
    buildContactName() {
      if (this.form.contactName && this.gender) {
        return this.form.contactName + this.gender
      }
      return this.form.contactName
    },
    async save() {
      const originalName = this.form.contactName
      this.form.contactName = this.buildContactName()
      await addressApi.save(this.form)
      this.form.contactName = originalName
      uni.navigateBack()
    }
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

  &__address-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 28rpx;
    background: #FFFFFF;
    border: 1rpx solid #E8E8E8;
    border-radius: 16rpx;
    margin-bottom: 24rpx;
    margin-top: 32rpx;
	border: 2px solid #b6b5b5;
  }

  &__address-main {
    flex: 1;
    min-width: 0;
  }

  &__address-name {
    display: block;
    font-size: 32rpx;
    font-weight: 600;
    color: #333333;
    margin-bottom: 8rpx;
  }

  &__address-detail {
    display: block;
    font-size: 24rpx;
    color: #999999;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__address-change {
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

  &__input-wrap {
    flex: 1;
    text-align: left;
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
    justify-content: flex-end;
    flex: 1;
    gap: 16rpx;
  }

  &__gender-radio {
    display: flex;
    align-items: center;
    gap: 24rpx;
  }

  &__radio-option {
    display: flex;
    align-items: center;
    gap: 8rpx;
  }

  &__radio-dot {
    width: 28rpx;
    height: 28rpx;
    border: 2rpx solid #CCCCCC;
    border-radius: 50%;
    position: relative;
  }

  &__radio-option--active &__radio-dot {
    border-color: #a01e1e;

    &::after {
      content: '';
      position: absolute;
      left: 50%;
      top: 50%;
      width: 14rpx;
      height: 14rpx;
      background:#a01e1e;
      border-radius: 50%;
      transform: translate(-50%, -50%);
    }
  }

  &__radio-text {
    font-size: 26rpx;
    color: #666666;
  }

  &__radio-option--active &__radio-text {
    color: #333333;
  }

  &__footer {
    padding: 24rpx;
    flex-shrink: 0;
  }

  &__save-btn {
    background: #a01e1e;
    border-radius: 8rpx;
    padding: 26rpx;
    text-align: center;
	margin-bottom: 48rpx;

    &:active {
      opacity: 0.9;
    }
  }

  &__save-text {
    color: #FFFFFF;
    font-size: 32rpx;
    font-weight: 600;
  }

  &__bottom-space {
    height: 40rpx;
  }
}
</style>
