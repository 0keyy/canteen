<template>
  <view class="edit-page">
    <!-- 自定义导航栏 -->
    <view class="edit-page__header">
      <view class="edit-page__nav">
        <view class="edit-page__back-btn" @click="goBack">
          <text class="edit-page__back-icon">‹</text>
        </view>
        <text class="edit-page__title">编辑地址</text>
        <view class="edit-page__nav-empty"></view>
      </view>
    </view>

    <scroll-view class="edit-page__content" scroll-y :show-scrollbar="false">
      <!-- 表单区域 -->
      <view class="edit-page__section">
        <view class="edit-page__form-item">
          <text class="edit-page__label">联系人</text>
          <view class="edit-page__contact-row">
            <input 
              v-model="form.contactName" 
              class="edit-page__input edit-page__input--name" 
              placeholder="请填写" 
              placeholder-class="edit-page__placeholder"
            />
            <view class="edit-page__gender-selector">
              <view 
                class="edit-page__gender-option" 
                :class="{ 'edit-page__gender-option--active': gender === '先生' }"
                @click="selectGender('先生')"
              >
                <text class="edit-page__gender-text">先生</text>
              </view>
              <view 
                class="edit-page__gender-option" 
                :class="{ 'edit-page__gender-option--active': gender === '女士' }"
                @click="selectGender('女士')"
              >
                <text class="edit-page__gender-text">女士</text>
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
          <text class="edit-page__label">省份</text>
          <input 
            v-model="form.province" 
            class="edit-page__input" 
            placeholder="请填写" 
            placeholder-class="edit-page__placeholder"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">城市</text>
          <input 
            v-model="form.city" 
            class="edit-page__input" 
            placeholder="请填写" 
            placeholder-class="edit-page__placeholder"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">区县</text>
          <input 
            v-model="form.district" 
            class="edit-page__input" 
            placeholder="请填写" 
            placeholder-class="edit-page__placeholder"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">详细地址</text>
          <input 
            v-model="form.detail" 
            class="edit-page__input" 
            placeholder="请填写" 
            placeholder-class="edit-page__placeholder"
          />
        </view>

        <view class="edit-page__form-item">
          <text class="edit-page__label">设为默认地址</text>
          <switch 
            :checked="form.isDefault === 1" 
            color="#C41E3A" 
            @change="onDefaultChange" 
          />
        </view>
      </view>

      <view class="edit-page__bottom-space"></view>
    </scroll-view>

    <!-- 底部保存按钮 -->
    <view class="edit-page__footer safe-area-bottom">
      <view class="edit-page__save-btn" @click="save">
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
        contactName: '',
        contactMobile: '',
        province: '',
        city: '',
        district: '',
        detail: '',
        isDefault: 0
      },
      gender: ''
    }
  },
  async onLoad(options) {
    if (options.id) {
      const detail = await addressApi.detail(Number(options.id))
      this.form = { ...detail }
      // 从联系人姓名中尝试提取性别称呼
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
  background: #FFF9F7;
  display: flex;
  flex-direction: column;

  &__header {
    background: linear-gradient(135deg, #FFE4E1 0%, #FFF5F5 100%);
    flex-shrink: 0;
    padding-top: var(--status-bar-height, 44rpx);
  }

  &__nav {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 88rpx;
    padding: 0 24rpx;
  }

  &__back-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__back-icon {
    font-size: 48rpx;
    color: #333333;
    font-weight: 300;
    line-height: 1;
  }

  &__title {
    font-size: 32rpx;
    font-weight: 600;
    color: #333333;
  }

  &__nav-empty {
    width: 64rpx;
  }

  &__content {
    flex: 1;
    padding: 24rpx 0;
  }

  &__section {
    background: #FFFFFF;
    margin: 16rpx 24rpx;
    border-radius: 24rpx;
    padding: 0;
    box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.04);
  }

  // 表单项
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
  }

  &__input {
    flex: 1;
    text-align: right;
    font-size: 28rpx;
    color: #333333;
    margin-left: 16rpx;

    &--name {
      flex: none;
      width: 200rpx;
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
  }

  &__gender-selector {
    display: flex;
    gap: 16rpx;
    margin-left: 16rpx;
  }

  &__gender-option {
    padding: 8rpx 20rpx;
    border: 1rpx solid #E8E8E8;
    border-radius: 999rpx;
    transition: all 0.2s;
  }

  &__gender-option--active {
    border-color: #C41E3A;
    background: #FFF5F5;
  }

  &__gender-text {
    font-size: 24rpx;
    color: #666666;

    .edit-page__gender-option--active & {
      color: #C41E3A;
    }
  }

  // 底部区域
  &__footer {
    background: #FFFFFF;
    padding: 24rpx 24rpx;
    box-shadow: 0 -4rpx 16rpx rgba(0, 0, 0, 0.05);
    flex-shrink: 0;
  }

  &__save-btn {
    background:#a01e1e;
    border-radius: 999rpx;
    padding: 28rpx;
    text-align: center;
    box-shadow: 0 8rpx 24rpx rgba(196, 30, 58, 0.3);

    &:active {
      opacity: 0.9;
    }
  }

  &__save-text {
    color: #FFFFFF;
    font-size: 32rpx;
    font-weight: 700;
  }

  &__bottom-space {
    height: 40rpx;
  }
}
</style>
