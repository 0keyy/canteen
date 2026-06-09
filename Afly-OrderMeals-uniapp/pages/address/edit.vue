<template>
  <view class="edit-page">
    <view class="edit-page__card">
      <input v-model="form.contactName" class="edit-page__input" placeholder="联系人" />
      <input v-model="form.contactMobile" class="edit-page__input" type="number" placeholder="手机号" />
      <input v-model="form.province" class="edit-page__input" placeholder="省份" />
      <input v-model="form.city" class="edit-page__input" placeholder="城市" />
      <input v-model="form.district" class="edit-page__input" placeholder="区县" />
      <input v-model="form.detail" class="edit-page__input" placeholder="详细地址" />
      <label class="edit-page__default-row">
        <switch :checked="form.isDefault === 1" color="#FF6B35" @change="onDefaultChange" />
        <text class="edit-page__default-text">设为默认地址</text>
      </label>
    </view>

    <view class="edit-page__footer safe-area-bottom">
      <button class="edit-page__save-btn" @click="save">保存</button>
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
      }
    }
  },
  async onLoad(options) {
    if (options.id) {
      const detail = await addressApi.detail(Number(options.id))
      this.form = { ...detail }
    }
  },
  methods: {
    onDefaultChange(e) {
      this.form.isDefault = e.detail.value ? 1 : 0
    },
    async save() {
      await addressApi.save(this.form)
      uni.navigateBack()
    }
  }
}
</script>

<style lang="scss" scoped>
.edit-page {
  min-height: 100vh;
  background: $bg-page;
  padding: 16rpx 0 120rpx;

  &__card {
    background: $bg-surface;
    border-radius: $radius-card;
    margin: 16rpx 24rpx;
    padding: 8rpx 28rpx 28rpx;
    box-shadow: $shadow-card;
  }

  &__input {
    padding: 28rpx 0;
    border-bottom: 1rpx solid #F0F0F0;
    font-size: 28rpx;
    color: #333333;
  }

  &__default-row {
    display: flex;
    align-items: center;
    gap: 16rpx;
    margin-top: 28rpx;
  }

  &__default-text {
    font-size: 28rpx;
    color: #333333;
  }

  &__footer {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    background: $bg-surface;
    padding: 16rpx 24rpx;
    border-top: 1rpx solid $divider-color;
  }

  &__save-btn {
    background: $brand-primary;
    color: $text-white;
    border-radius: $radius-btn;
    font-size: 30rpx;
    font-weight: bold;

    &:active {
      background: $brand-primary-press;
    }
  }
}
</style>
