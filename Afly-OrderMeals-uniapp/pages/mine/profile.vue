<template>
  <view class="profile-page">
    <view class="profile-page__card">
      <view class="profile-page__avatar-row" @tap="chooseAvatar">
        <view class="profile-page__avatar-wrap">
          <image class="profile-page__avatar" :src="avatarUrl || defaultAvatar" mode="aspectFill" />
          <view class="profile-page__avatar-edit">
            <image class="profile-page__avatar-edit-img" :src="staticImgPrefix + '/tabbar/写 1.png'" mode="aspectFit" />
          </view>
        </view>
      </view>

      <view class="profile-page__divider"></view>

      <view class="profile-page__field" @tap="editNickname">
        <text class="profile-page__label">昵称</text>
        <text class="profile-page__value">{{ form.nickname || '未设置' }}</text>
      </view>

      <view class="profile-page__divider"></view>

      <view class="profile-page__field">
        <text class="profile-page__label">手机</text>
        <text class="profile-page__value">{{ maskedPhone || '未绑定' }}</text>
      </view>

      <view class="profile-page__divider"></view>

      <view class="profile-page__field">
        <text class="profile-page__label">性别</text>
        <view class="profile-page__gender-group">
          <view class="profile-page__gender-item" @tap="setGender(1)">
            <view class="profile-page__radio" :class="form.gender === 1 ? 'profile-page__radio--checked' : ''">
              <view v-if="form.gender === 1" class="profile-page__radio-inner"></view>
            </view>
            <text class="profile-page__gender-text">男</text>
          </view>
          <view class="profile-page__gender-item" @tap="setGender(2)">
            <view class="profile-page__radio" :class="form.gender === 2 ? 'profile-page__radio--checked' : ''">
              <view v-if="form.gender === 2" class="profile-page__radio-inner"></view>
            </view>
            <text class="profile-page__gender-text">女</text>
          </view>
        </view>
      </view>

      <view class="profile-page__divider"></view>

      <picker mode="date" :value="form.birthday || '2000-01-01'" start="1950-01-01" end="2026-12-31" @change="onBirthdayChange">
        <view class="profile-page__field">
          <text class="profile-page__label">生日</text>
          <text class="profile-page__value">{{ form.birthday || '请选择' }}</text>
        </view>
      </picker>
    </view>

    <!-- 头像选择弹窗 -->
    <view v-if="showAvatarModal" class="profile-page__modal-mask" @tap="showAvatarModal = false">
      <view class="profile-page__modal profile-page__modal--avatar" @tap.stop>
        <text class="profile-page__modal-title">选择头像</text>
        <view class="profile-page__avatar-grid">
          <view
            v-for="(item, idx) in defaultAvatars"
            :key="idx"
            class="profile-page__avatar-grid-item"
            :class="avatarUrl === item ? 'profile-page__avatar-grid-item--active' : ''"
            @tap="selectAvatar(item)"
          >
            <image class="profile-page__avatar-grid-img" :src="item" mode="aspectFill" />
            <view v-if="avatarUrl === item" class="profile-page__avatar-grid-check">
              <image class="profile-page__avatar-grid-check-icon" :src="staticImgPrefix + '/tabbar/对勾小 2.png'" mode="aspectFit" />
            </view>
          </view>
        </view>
        <view class="profile-page__modal-btns">
          <button class="profile-page__modal-btn profile-page__modal-btn--cancel" @tap="showAvatarModal = false">取消</button>
        </view>
      </view>
    </view>

    <view class="profile-page__btn-wrap">
      <button class="profile-page__save-btn" :loading="saving" @tap="saveProfile">保存</button>
    </view>

    <view v-if="showNicknameModal" class="profile-page__modal-mask" @tap="closeNicknameModal">
      <view class="profile-page__modal" @tap.stop>
        <text class="profile-page__modal-title">修改昵称</text>
        <input class="profile-page__modal-input" v-model="tempNickname" maxlength="20" placeholder="请输入昵称" focus="true" />
        <view class="profile-page__modal-btns">
          <button class="profile-page__modal-btn profile-page__modal-btn--cancel" @tap="closeNicknameModal">取消</button>
          <button class="profile-page__modal-btn profile-page__modal-btn--confirm" @tap="confirmNickname">确定</button>
        </view>
      </view>
    </view>

  </view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { authApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

const staticImgPrefix = ref(STATIC_IMAGE_PREFIX)
const defaultAvatar = ref(STATIC_IMAGE_PREFIX + '/2.png')
const defaultAvatars = ref([
  STATIC_IMAGE_PREFIX + '/2.png',
  STATIC_IMAGE_PREFIX + '/1.png',
  STATIC_IMAGE_PREFIX + '/3.png',
  STATIC_IMAGE_PREFIX + '/4.png'
])
const form = ref({
  nickname: '',
  gender: 0,
  birthday: ''
})
const avatarUrl = ref('')
const mobile = ref('')
const saving = ref(false)
const showNicknameModal = ref(false)
const showAvatarModal = ref(false)
const tempNickname = ref('')
const birthdayPickerVisible = ref(false)
const pickerDate = ref('2000-01-01')

const maskedPhone = computed(() => {
  if (!mobile.value) return ''
  const m = String(mobile.value)
  if (m.length >= 11) {
    return m.substring(0, 3) + '****' + m.substring(7)
  }
  return m
})

const genderText = computed(() => {
  if (form.value.gender === 1) return '男'
  if (form.value.gender === 2) return '女'
  return '请选择'
})

onLoad(() => {
  loadProfile()
})

function loadProfile() {
  authApi.profile().then(function(res) {
    form.value.nickname = res.nickname || res.userName || ''
    form.value.gender = res.gender || 0
    form.value.birthday = res.birthday || ''
    avatarUrl.value = res.avatar || res.headImg || ''
    mobile.value = res.mobile || res.phone || ''
    if (form.value.birthday) {
      pickerDate.value = form.value.birthday
    }
  }).catch(function() {
    form.value.nickname = uni.getStorageSync('nickname') || ''
    mobile.value = uni.getStorageSync('mobile') || ''
  })
}

function chooseAvatar() {
  showAvatarModal.value = true
}

function selectAvatar(url) {
  avatarUrl.value = url
  showAvatarModal.value = false
}

function editNickname() {
  tempNickname.value = form.value.nickname
  showNicknameModal.value = true
}

function closeNicknameModal() {
  showNicknameModal.value = false
}

function confirmNickname() {
  if (!tempNickname.value.trim()) {
    uni.showToast({ title: '昵称不能为空', icon: 'none' })
    return
  }
  form.value.nickname = tempNickname.value.trim()
  showNicknameModal.value = false
}

function setGender(g) {
  form.value.gender = g
}

function onBirthdayChange(e) {
  form.value.birthday = e.detail.value
}

function saveProfile() {
  uni.showToast({ title: '功能正在开发中', icon: 'none' })
}
</script>

<style lang="scss" scoped>
.profile-page {
  min-height: 100vh;
  background: #DEDEDE;
  display: flex;
  flex-direction: column;

  &__avatar-row {
    display: flex;
    justify-content: center;
    padding: 70rpx 0 34rpx;
  }

  &__avatar-wrap {
    position: relative;
  }

  &__avatar {
    width: 136rpx;
    height: 136rpx;
    border-radius: 50%;
    background: #F0F0F0;
    border: 4rpx solid #FFFFFF;
    box-shadow: none;
  }

  &__avatar-edit {
    position: absolute;
    right: 0;
    bottom: 0;
    width: 42rpx;
    height: 42rpx;
    background: transparent;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__avatar-edit-icon {
    font-size: 24rpx;
    color: #FFFFFF;
    font-weight: 500;
  }

  &__avatar-edit-img {
    width: 28rpx;
    height: 28rpx;
  }

  &__card {
    margin: 112rpx 30rpx 0;
    background: #FFFFFF;
    border-radius: 14rpx;
    padding: 0 52rpx 36rpx;
    box-shadow: none;
  }

  &__field {
    display: flex;
    align-items: center;
    padding: 28rpx 0;
  }

  &__label {
    font-size: 28rpx;
    color: #030303;
    font-weight: 500;
    flex-shrink: 0;
    width: 128rpx;
    margin-right: 0;
  }

  &__value {
    font-size: 28rpx;
    color: #030303;
  }

  &__arrow {
    font-size: 32rpx;
    color: #CCCCCC;
    line-height: 1;
  }

  &__arrow-icon {
    width: 28rpx;
    height: 28rpx;
    opacity: 0.4;
    margin-left: 8rpx;
  }

  &__divider {
    height: 1rpx;
    background: #CCCCCC;
    margin-left: 128rpx;
  }

  &__gender-group {
    display: flex;
    gap: 48rpx;
  }

  &__gender-item {
    display: flex;
    align-items: center;
    gap: 12rpx;
  }

  &__radio {
    width: 28rpx;
    height: 28rpx;
    border-radius: 50%;
    border: 2rpx solid #111111;
    display: flex;
    align-items: center;
    justify-content: center;

    &--checked {
      border-color: $brand-primary;
      background: $brand-primary;
    }
  }

  &__radio-inner {
    width: 12rpx;
    height: 12rpx;
    border-radius: 50%;
    background: #FFFFFF;
  }

  &__gender-text {
    font-size: 28rpx;
    color: #030303;
  }

  &__btn-wrap {
    margin-top: auto;
    padding: 24rpx 30rpx calc(env(safe-area-inset-bottom) + 26rpx);
	background: #ffffff;
  }

  &__save-btn {
    width: 100%;
    height: 76rpx;
    line-height: 76rpx;
    background: $brand-primary;
    color: #FFFFFF;
    font-size: 34rpx;
    font-weight: 600;
    border-radius: 999rpx;
    text-align: center;
    border: none;
    box-shadow: 0 8rpx 24rpx rgba(196, 30, 58, 0.3);
  }

  &__modal-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    animation: fadeIn 0.2s ease;
  }

  &__modal {
    width: 640rpx;
    background: #FFFFFF;
    border-radius: 28rpx;
    padding: 56rpx 48rpx 48rpx;
    animation: slideUp 0.25s ease;
  }

  &__modal-title {
    display: block;
    text-align: center;
    font-size: 34rpx;
    font-weight: 600;
    color: #030303;
    margin-bottom: 40rpx;
  }

  &__modal-input {
    width: 100%;
    height: 88rpx;
    border: 2rpx solid #E5E5E5;
    border-radius: 16rpx;
    padding: 0 28rpx;
    font-size: 30rpx;
    color: #030303;
    box-sizing: border-box;
  }

  &__modal-btns {
    display: flex;
    gap: 32rpx;
    margin-top: 40rpx;
  }

  &__modal-btn {
    flex: 1;
    height: 88rpx;
    line-height: 88rpx;
    font-size: 30rpx;
    font-weight: 500;
    border-radius: 999rpx;
    text-align: center;
    border: none;

    &--cancel {
      background: #F5F5F5;
      color: #666666;
    }

    &--confirm {
      background: linear-gradient(135deg, $brand-primary 0%, #E83A58 100%);
      color: #FFFFFF;
      box-shadow: 0 4rpx 16rpx rgba(196, 30, 58, 0.3);
    }
  }

  &__modal--avatar {
    width: 680rpx;
  }

  &__avatar-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 24rpx;
    justify-content: center;
  }

  &__avatar-grid-item {
    width: 140rpx;
    height: 140rpx;
    border-radius: 50%;
    position: relative;
    border: 4rpx solid transparent;
    transition: all 0.2s ease;

    &--active {
      border-color: $brand-primary;
      box-shadow: 0 4rpx 12rpx rgba(196, 30, 58, 0.3);
    }
  }

  &__avatar-grid-img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
  }

  &__avatar-grid-check {
    position: absolute;
    right: -4rpx;
    bottom: -4rpx;
    width: 40rpx;
    height: 40rpx;
    background: $brand-primary;
    border-radius: 50%;
    border: 3rpx solid #FFFFFF;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__avatar-grid-check-icon {
    width: 24rpx;
    height: 24rpx;
  }
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40rpx);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
