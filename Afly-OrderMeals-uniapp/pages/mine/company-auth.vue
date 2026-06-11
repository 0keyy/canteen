<template>
  <view class="company-auth-page" :class="{ 'company-auth-page--verified': verified }">
    <view v-if="verified" class="company-auth-page__card company-auth-page__card--success">
      <view class="company-auth-page__success-icon">✓</view>
      <text class="company-auth-page__success-title">已完成公司认证</text>
      <view class="company-auth-page__info-row">
        <text class="company-auth-page__label">所属部门</text>
        <text class="company-auth-page__value">{{ authInfo.deptName || '-' }}</text>
      </view>
      <view class="company-auth-page__info-row">
        <text class="company-auth-page__label">账号</text>
        <text class="company-auth-page__value">{{ authInfo.userName || '-' }}</text>
      </view>
      <view class="company-auth-page__info-row">
        <text class="company-auth-page__label">姓名</text>
        <text class="company-auth-page__value">{{ authInfo.nickName || '-' }}</text>
      </view>
    </view>

    <view v-else class="company-auth-page__card">
      <text class="company-auth-page__title">公司认证</text>
      <text class="company-auth-page__desc">请使用若依系统账号进行验证</text>

      <view class="company-auth-page__field">
        <text class="company-auth-page__field-label">所属部门</text>
        <dept-tree-picker
          v-model="form.deptId"
          :dept-list="deptList"
          placeholder="请选择部门"
          @change="onDeptSelect"
        />
      </view>

      <view class="company-auth-page__field">
        <text class="company-auth-page__field-label">用户名</text>
        <input
          v-model="form.username"
          class="company-auth-page__input"
          placeholder="请输入用户名"
          maxlength="30"
        />
      </view>

      <view class="company-auth-page__field">
        <text class="company-auth-page__field-label">密码</text>
        <input
          v-model="form.password"
          class="company-auth-page__input"
          type="password"
          placeholder="请输入密码"
          maxlength="50"
        />
      </view>
    </view>

    <view v-if="!verified" class="company-auth-page__footer safe-area-bottom">
      <button
        class="company-auth-page__submit-btn"
        :loading="submitting"
        @tap="submit"
      >
        提交认证
      </button>
    </view>
  </view>
</template>

<script>
import { companyApi } from '../../api/index'
import DeptTreePicker from '../../components/dept-tree-picker/dept-tree-picker.vue'

export default {
  components: { DeptTreePicker },
  data() {
    return {
      verified: false,
      authInfo: {},
      deptList: [],
      form: {
        deptId: null,
        username: '',
        password: ''
      },
      submitting: false
    }
  },
  async onLoad() {
    await this.loadData()
  },
  methods: {
    async loadData() {
      try {
        uni.showLoading({ title: '加载中', mask: true })
        const status = await companyApi.status()
        this.authInfo = status || {}
        this.verified = !!status?.verified
        if (!this.verified) {
          this.deptList = await companyApi.deptList() || []
        }
      } catch (e) {
        const message = typeof e === 'string' ? e : (e?.msg || e?.message || '加载失败')
        uni.showToast({ title: message, icon: 'none' })
      } finally {
        uni.hideLoading()
      }
    },
    onDeptSelect(dept) {
      this.form.deptId = dept ? dept.deptId : null
    },
    async submit() {
      if (this.verified) {
        uni.showToast({ title: '您已完成公司认证', icon: 'none' })
        return
      }
      if (this.form.deptId == null) {
        uni.showToast({ title: '请选择部门', icon: 'none' })
        return
      }
      if (!this.form.username.trim()) {
        uni.showToast({ title: '请输入用户名', icon: 'none' })
        return
      }
      if (!this.form.password) {
        uni.showToast({ title: '请输入密码', icon: 'none' })
        return
      }
      if (this.submitting) return
      this.submitting = true
      try {
        const result = await companyApi.auth({
          deptId: this.form.deptId,
          username: this.form.username.trim(),
          password: this.form.password
        })
        this.authInfo = result || {}
        this.verified = true
        this.form.password = ''
        uni.setStorageSync('companyVerified', true)
        uni.setStorageSync('companyDeptName', result?.deptName || '')
        const granted = result?.balanceGranted || 0
        uni.showToast({
          title: granted > 0 ? `认证成功，余额+${granted}` : '认证成功',
          icon: 'success'
        })
      } catch (e) {
        const message = typeof e === 'string' ? e : (e?.msg || e?.message || '认证失败')
        uni.showModal({
          title: '认证失败',
          content: message,
          showCancel: false
        })
      } finally {
        this.submitting = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.company-auth-page {
  min-height: 100vh;
  background: $bg-page;
  padding: 24rpx 24rpx 140rpx;

  &--verified {
    padding-bottom: 24rpx;
  }

  &__card {
    background: $bg-surface;
    border-radius: $radius-card;
    padding: 32rpx 28rpx;
    box-shadow: $shadow-card;

    &--success {
      text-align: center;
      padding-top: 48rpx;
    }
  }

  &__title {
    display: block;
    font-size: 36rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__desc {
    display: block;
    margin-top: 8rpx;
    margin-bottom: 32rpx;
    font-size: 24rpx;
    color: $text-secondary;
  }

  &__field {
    margin-bottom: 24rpx;
  }

  &__field-label {
    display: block;
    margin-bottom: 12rpx;
    font-size: 26rpx;
    font-weight: 600;
    color: $text-primary;
  }

  &__input {
    display: flex;
    align-items: center;
    min-height: 88rpx;
    padding: 0 24rpx;
    border-radius: $radius-card;
    background: $bg-gray;
    font-size: 28rpx;
    color: $text-primary;
    width: 100%;
    box-sizing: border-box;
  }

  &__placeholder {
    color: $text-secondary;
  }

  &__success-icon {
    width: 96rpx;
    height: 96rpx;
    margin: 0 auto 24rpx;
    border-radius: 50%;
    background: rgba(177, 10, 15, 0.1);
    color: $brand-primary;
    font-size: 48rpx;
    font-weight: 900;
    line-height: 96rpx;
    text-align: center;
  }

  &__success-title {
    display: block;
    margin-bottom: 32rpx;
    font-size: 34rpx;
    font-weight: 900;
    color: $text-primary;
  }

  &__info-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 20rpx 0;
    border-top: 1rpx solid #F0F0F0;
    text-align: left;
  }

  &__label {
    font-size: 26rpx;
    color: $text-secondary;
  }

  &__value {
    font-size: 28rpx;
    font-weight: 600;
    color: $text-primary;
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

  &__submit-btn {
    background: $brand-primary;
    color: $text-white;
    border-radius: $radius-btn;
    font-size: 30rpx;
    font-weight: bold;

    &:active {
      opacity: 0.9;
    }
  }
}
</style>
