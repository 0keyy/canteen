<template>
  <view class="profile-page">
    <scroll-view class="profile-page__scroll" scroll-y :show-scrollbar="false">
      <view class="profile-page__hero" :style="heroPaddingStyle">
        <view class="profile-page__user-row">
          <view class="profile-page__avatar-wrap" @tap="showAvatarPicker = true">
            <image class="profile-page__avatar" :src="avatarSrc" mode="aspectFill" />
            <view class="profile-page__avatar-edit">
              <text class="profile-page__avatar-edit-text">换</text>
            </view>
          </view>
          <view class="profile-page__user-info">
            <view class="profile-page__name-row">
              <text class="profile-page__nickname">{{ nickname || '未登录用户' }}</text>
              <text v-if="companyVerified" class="profile-page__level-tag profile-page__level-tag--verified">已认证</text>
              <text v-else class="profile-page__level-tag">默认等级</text>
            </view>
            <text class="profile-page__mobile">{{ mobile || '请登录后查看' }}</text>
            <text v-if="companyVerified && companyDeptName" class="profile-page__company">{{ companyDeptName }}</text>
          </view>
          <view class="profile-page__qr-btn" @tap="onFeatureTap('会员码')">
            <!-- 替换成自己的二维码图标，路径换成你的图片地址 -->
            <image class="profile-page__qr-img" src="/static/tabbar/二维码图标.png" mode="aspectFit"></image>
          </view>
        </view>

        <view class="profile-page__stats">
          <view class="profile-page__stat-item">
            <text class="profile-page__stat-value">{{ balance }}</text>
            <text class="profile-page__stat-label">余额</text>
          </view>
          <!-- 新增积分项 -->
          <view class="profile-page__stat-item">
            <text class="profile-page__stat-value">{{ pointCount }}</text>
            <text class="profile-page__stat-label">积分</text>
          </view>
          <view class="profile-page__stat-item">
            <text class="profile-page__stat-value">{{ couponCount }}</text>
            <text class="profile-page__stat-label">优惠券</text>
          </view>
        </view>

        <view class="profile-page__vip-card">
          <view class="profile-page__vip-top">
            <view>
              <text class="profile-page__vip-title">SVIP 1</text>
              <text class="profile-page__vip-desc">再获得1000个成长值升级为青铜</text>
            </view>
            <view class="profile-page__vip-crown"></view>
          </view>
          <view class="profile-page__vip-progress">
            <view class="profile-page__vip-progress-bar"></view>
          </view>
          <text class="profile-page__vip-progress-text">0/1000</text>
        </view>
      </view>

      <view class="profile-page__sections">
        <view class="profile-page__card">
          <text class="profile-page__card-title">我的订单</text>
          <view class="profile-page__grid">
            <view
              v-for="item in primaryActions"
              :key="item.title"
              class="profile-page__grid-item"
              @tap="onActionTap(item)"
            >
              <view class="profile-page__grid-icon profile-page__grid-icon--primary">
                <view :class="['profile-page__action-icon', `profile-page__action-icon--${item.icon}`]"></view>
              </view>
              <text class="profile-page__grid-label">{{ item.title }}</text>
            </view>
          </view>
        </view>

        <view class="profile-page__card profile-page__card--grid">
          <view
            v-for="item in secondaryActions"
            :key="item.title"
            class="profile-page__grid-item"
            @tap="onActionTap(item)"
          >
            <view class="profile-page__grid-icon">
              <image
                v-if="item.iconImg"
                class="profile-page__action-img"
                :src="item.iconImg"
                mode="aspectFit"
              />
              <view v-else :class="['profile-page__action-icon', `profile-page__action-icon--${item.icon}`]"></view>
            </view>
            <text class="profile-page__grid-label">{{ item.title }}</text>
          </view>
        </view>

        <view class="profile-page__footer">
          <text class="profile-page__footer-text">小程序餐饮系统 点击了解详情</text>
        </view>

        <view class="profile-page__bottom-space"></view>
      </view>
    </scroll-view>

    <!-- 头像选择弹窗 -->
    <view class="profile-page__avatar-mask" v-if="showAvatarPicker" @tap="showAvatarPicker = false">
      <view class="profile-page__avatar-picker" @tap.stop>
        <text class="profile-page__avatar-picker-title">选择头像</text>
        <view class="profile-page__avatar-options">
          <view
            class="profile-page__avatar-option"
            :class="{ 'profile-page__avatar-option--active': avatarKey === '1' }"
            @tap="selectAvatar('1')"
          >
            <image class="profile-page__avatar-option-img" src="/static/1.png" mode="aspectFill" />
          </view>
          <view
            class="profile-page__avatar-option"
            :class="{ 'profile-page__avatar-option--active': avatarKey === '2' }"
            @tap="selectAvatar('2')"
          >
            <image class="profile-page__avatar-option-img" src="/static/2.png" mode="aspectFill" />
          </view>
        </view>
        <text class="profile-page__avatar-picker-close" @tap="showAvatarPicker = false">取消</text>
      </view>
    </view>

    <!-- 客服电话选择面板 -->
    <view class="profile-page__service-mask" v-if="showServicePicker" @tap="showServicePicker = false">
      <view class="profile-page__service-picker" @tap.stop>
        <text class="profile-page__service-title">联系客服</text>
        <view class="profile-page__service-list">
          <view
            v-for="(item, index) in servicePhones"
            :key="index"
            class="profile-page__service-item"
            @tap="makeCall(item.phone)"
          >
            <view class="profile-page__service-icon"></view>
            <view class="profile-page__service-info">
              <text class="profile-page__service-name">{{ item.name || '客服热线' }}</text>
              <text class="profile-page__service-phone">{{ item.phone }}</text>
            </view>
            <text class="profile-page__service-arrow">›</text>
          </view>
        </view>
        <view class="profile-page__service-cancel" @tap="showServicePicker = false">取消</view>
      </view>
    </view>

    <view class="app-tab-bar">
      <view
        v-for="(item, index) in tabbarList"
        :key="index"
        class="app-tab-item"
        :class="{ 'app-tab-item--active': tabbarSelected === index }"
        @tap.stop="switchTabbar(item, index)"
      >
        <view class="app-tab-icon-wrap">
          <image
            class="app-tab-icon"
            :src="tabbarSelected === index ? item.selected : item.unselected"
            mode="aspectFit"
          />
        </view>
        <text
          class="app-tab-text"
          :style="{ color: tabbarSelected === index ? tabbarSelectedColor : tabbarDefaultColor }"
        >
          {{ item.name }}
        </text>
      </view>
    </view>
  </view>
  <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
</template>

<script>
import { authApi, couponApi, serviceApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'
import PageLoading from '../../components/page-loading/page-loading.vue'

const PRIMARY_ACTIONS = [
  { title: '我的订单', icon: 'orders' },
  { title: '地址管理', icon: 'address' },
  { title: '联系客服', icon: 'service' },
  { title: '会员码', icon: 'code' }
]

const SECONDARY_ACTIONS = [
  { title: '公司认证', icon: 'check', iconImg: '/static/tabbar/公司认证.png' },
  { title: '充值中心', icon: 'wallet', iconImg: '/static/tabbar/充值 1.png' },
  { title: '积分商城', icon: 'coins', iconImg: '/static/tabbar/积分商城.png' },
  { title: '优惠券包', icon: 'ticket', iconImg: '/static/tabbar/卡券 1.png' },
  { title: '会员日', icon: 'crown', iconImg: '/static/tabbar/名词 1.png' },
  { title: '退出登录', icon: 'logout', iconImg: '/static/tabbar/退出 1.png' }
]

export default {
  mixins: [tabbarPageMixin],
  components: {
    PageLoading
  },
  data() {
    return {
      navMetrics: getNavMetrics(),
      nickname: '',
      mobile: '',
      companyVerified: false,
      companyDeptName: '',
      balance: 0,
      couponCount: 0,
      pointCount: 0,
      primaryActions: PRIMARY_ACTIONS,
      secondaryActions: SECONDARY_ACTIONS,
      avatarKey: '',
      showAvatarPicker: false,
      showServicePicker: false,
      servicePhones: [{ phone: '400-800-1234', name: '客服热线' }],
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` }
    },
    avatarSrc() {
      if (this.avatarKey) return `/static/${this.avatarKey}.png`
      return '/static/1.png'
    }
  },
  onShow() {
    this.navMetrics = getNavMetrics()
    this.setupTabbar(3)
    this.nickname = uni.getStorageSync('nickname')
    this.mobile = uni.getStorageSync('mobile')
    this.avatarKey = uni.getStorageSync('avatarKey') || '1'
    this.loadProfile()
  },
  methods: {
    async loadProfile() {
      try {
        const profile = await authApi.profile()
        if (profile) {
          this.nickname = profile.nickname || this.nickname
          this.mobile = profile.mobile || this.mobile
          this.companyVerified = !!profile.companyVerified
          this.companyDeptName = profile.companyDeptName || ''
          // 核心：后端返回最新余额直接赋值给页面展示变量
          this.balance = profile.balance != null ? profile.balance : 0
          this.pointCount = profile.point ?? 0
          // 同步存入本地缓存备用
          uni.setStorageSync('balance', this.balance)
          uni.setStorageSync('companyVerified', this.companyVerified)
          uni.setStorageSync('companyDeptName', this.companyDeptName)
        }
      } catch (e) {
        // 接口失败就读缓存兜底
        this.balance = uni.getStorageSync('balance') || 0
        this.companyVerified = !!uni.getStorageSync('companyVerified')
        this.companyDeptName = uni.getStorageSync('companyDeptName') || ''
      }
    
      // 加载优惠券数量
      try {
        const myCoupons = await couponApi.myCoupons(1) || []
        this.couponCount = myCoupons.length
      } catch (e) {
        this.couponCount = 0
      }
    },
    onActionTap(item) {
      if (item.title === '我的订单') {
        this.goWithLoading('/pages/order/list', 'switchTab')
        return
      }
      if (item.title === '地址管理') {
        this.goWithLoading('/pages/address/list')
        return
      }
      if (item.title === '联系客服') {
        this.callService()
        return
      }
      if (item.title === '会员码') {
        this.goWithLoading('/pages/mine/memberCode/index')
        return
      }
      if (item.title === '公司认证') {
        this.goWithLoading('/pages/mine/company-auth')
        return
      }
      if (item.title === '优惠券包') {
        this.goWithLoading('/pages/coupon/wallet')
        return
      }
      if (item.title === '充值中心') {
        this.goWithLoading('/pages/coupon/recharge')
        return
      }
      if (item.title === '积分商城') {
        this.goWithLoading('/pages/integralShop/index')
        return
      }
      if (item.title === '会员日') {
        this.goWithLoading('/pages/mine/memberDay/index')
        return
      }
      if (item.title === '退出登录') {
        this.logout()
        return
      }
      this.onFeatureTap(item.title)
    },
    onFeatureTap(title) {
      if (title === '会员码') {
        this.goWithLoading('/pages/mine/memberCode/index')
        return
      }
      uni.showToast({ title: `${title}功能开发中`, icon: 'none' })
    },
    goWithLoading(url, type = 'navigateTo', tip = '加载中...') {
      this.pageLoadingTip = tip
      this.pageLoading = true
      setTimeout(() => {
        if (type === 'switchTab') {
          uni.switchTab({ url })
        } else if (type === 'reLaunch') {
          uni.reLaunch({ url })
        } else if (type === 'redirectTo') {
          uni.redirectTo({ url })
        } else {
          uni.navigateTo({ url })
        }
        setTimeout(() => {
          this.pageLoading = false
        }, 500)
      }, 100)
    },
    async callService() {
      try {
        const data = await serviceApi.hotline()
        if (data && Array.isArray(data.list) && data.list.length) {
          this.servicePhones = data.list
        } else if (data && data.phone) {
          this.servicePhones = [{ phone: data.phone, name: data.name || '客服热线' }]
        }
      } catch (e) {}
      this.showServicePicker = true
    },
    makeCall(phone) {
      if (!phone) return
      this.showServicePicker = false
      setTimeout(() => {
        uni.makePhoneCall({
          phoneNumber: phone,
          fail: (err) => {
            if (err.errMsg && err.errMsg.includes('cancel')) return
            uni.showToast({ title: '拨打失败', icon: 'none' })
          }
        })
      }, 200)
    },
    selectAvatar(key) {
      this.avatarKey = key
      uni.setStorageSync('avatarKey', key)
      this.showAvatarPicker = false
    },
    async logout() {
      try {
        await authApi.logout()
      } catch (e) {}
      uni.clearStorageSync()
      this.goWithLoading('/pages/login/index', 'reLaunch')
    }
  }
}
</script>

<style lang="scss" scoped>
.profile-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #fff9f3;

  &__scroll {
    flex: 1;
    height: 0;
  }

  &__hero {
      padding: 0 32rpx 32rpx;
      background: linear-gradient(135deg, rgba(177, 10, 15, 0.15) 0%, rgba(255, 139, 26, 0.1) 40%, #fff9f3 100%);
  }

  &__user-row {
    display: flex;
    align-items: center;
    gap: 24rpx;
  }

  &__avatar-wrap {
    position: relative;
    flex-shrink: 0;
  }

  &__avatar {
    width: 112rpx;
    height: 112rpx;
    border-radius: 50%;
    border: 4rpx solid #C41E3A;
    box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.08);
    display: block;
  }

  &__avatar-edit {
    position: absolute;
    bottom: 0;
    right: -4rpx;
    width: 36rpx;
    height: 36rpx;
    border-radius: 50%;
    background: #C41E3A;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2rpx solid #ffffff;
  }

  &__avatar-edit-text {
    font-size: 18rpx;
    color: #ffffff;
    font-weight: 600;
    line-height: 1;
  }

  &__avatar-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 2000;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  &__avatar-picker {
    width: 560rpx;
    background: #ffffff;
    border-radius: 24rpx;
    padding: 40rpx 32rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  &__avatar-picker-title {
    font-size: 32rpx;
    font-weight: 900;
    color: #333333;
    margin-bottom: 32rpx;
  }

  &__avatar-options {
    display: flex;
    gap: 40rpx;
    margin-bottom: 32rpx;
  }

  &__avatar-option {
    width: 160rpx;
    height: 160rpx;
    border-radius: 50%;
    overflow: hidden;
    border: 4rpx solid transparent;
    transition: border-color 0.24s;

    &--active {
      border-color: #C41E3A;
    }
  }

  &__avatar-option-img {
    width: 100%;
    height: 100%;
    display: block;
  }

  &__avatar-picker-close {
    font-size: 28rpx;
    color: #999999;
    padding: 12rpx 48rpx;
  }

  &__service-mask {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: flex-end;
    justify-content: center;
    z-index: 1000;
  }

  &__service-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 24rpx 24rpx 0 0;
    padding: 32rpx 0 24rpx;
    padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  }

  &__service-title {
    display: block;
    font-size: 32rpx;
    font-weight: 600;
    color: #111111;
    text-align: center;
    margin-bottom: 16rpx;
  }

  &__service-list {
    padding: 12rpx 0;
  }

  &__service-item {
    display: flex;
    align-items: center;
    padding: 24rpx 32rpx;

    &:active {
      background: #F5F5F5;
    }
  }

  &__service-icon {
    width: 56rpx;
    height: 56rpx;
    border-radius: 50%;
    background: #FFF0F0;
    position: relative;
    margin-right: 24rpx;
    flex-shrink: 0;

    &::before {
      content: '';
      position: absolute;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%);
      width: 28rpx;
      height: 28rpx;
      border: 3rpx solid #C41E3A;
      border-radius: 6rpx;
    }

    &::after {
      content: '';
      position: absolute;
      left: 50%;
      top: 50%;
      transform: translate(-50%, -50%) rotate(45deg);
      width: 20rpx;
      height: 20rpx;
      border-left: 3rpx solid #C41E3A;
      border-bottom: 3rpx solid #C41E3A;
    }
  }

  &__service-info {
    flex: 1;
    min-width: 0;
  }

  &__service-name {
    display: block;
    font-size: 28rpx;
    color: #333333;
    font-weight: 500;
  }

  &__service-phone {
    display: block;
    font-size: 24rpx;
    color: #999999;
    margin-top: 6rpx;
  }

  &__service-arrow {
    font-size: 36rpx;
    color: #CCCCCC;
    font-weight: 400;
    line-height: 1;
    margin-left: 16rpx;
  }

  &__service-cancel {
    font-size: 28rpx;
    color: #999999;
    text-align: center;
    padding: 20rpx 0 0;
    border-top: 1rpx solid #F0F0F0;
    margin-top: 12rpx;
  }

  &__user-info {
    flex: 1;
    min-width: 0;
  }

  &__name-row {
    display: flex;
    align-items: center;
    gap: 12rpx;
    flex-wrap: wrap;
  }

  &__nickname {
    font-size: 32rpx;
    font-weight: 900;
    color: #333333;
  }

  &__level-tag {
    padding: 4rpx 16rpx;
    border-radius: 999rpx;
    background: rgba(177, 10, 15, 0.1);
    font-size: 20rpx;
    color: #C41E3A;

    &--verified {
      background: rgba(34, 139, 34, 0.12);
      color: #228B22;
    }
  }

  &__company {
    display: block;
    margin-top: 4rpx;
    font-size: 22rpx;
    color: #999999;
  }

  &__mobile {
    display: block;
    margin-top: 6rpx;
    font-size: 24rpx;
    color: #999999;
  }

  &__qr-btn {
    width: 80rpx;
    height: 80rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  
  &__qr-img {
    width: 44rpx;
    height: 44rpx;
    display: block;
  }

  &__stats {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16rpx;
      margin-top: 32rpx;
      text-align: center;
    }
  
    &__stat-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }
  
    &__stat-value {
      display: block;
      font-size: 36rpx;
      font-weight: 900;
      color: #333333;
    }
  
    &__stat-label {
      display: block;
      margin-top: 4rpx;
      font-size: 24rpx;
      font-weight: 600;
      color: #999999;
    }

  &__vip-card {
    margin-top: 35rpx;
    margin-bottom: 10rpx;
    padding: 24rpx;
    border-radius: 24rpx;
    background: linear-gradient(135deg, #d9c8b8 0%, #e9ddcf 100%);
    box-shadow: 0 4rpx 14rpx rgba(160, 130, 100, 0.15);
  }
  &__vip-top {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
  }
  &__vip-title {
    display: block;
    font-size: 32rpx;
    font-weight: 900;
    color: #5c422e;
  }
  &__vip-desc {
    display: block;
    margin-top: 4rpx;
    font-size: 22rpx;
    color: rgba(92, 66, 46, 0.7);
  }
  &__vip-crown {
    width: 64rpx;
    height: 64rpx;
    position: relative;
    &::before {
      content: '♛';
      font-size: 64rpx;
      color: #b88c64;
      line-height: 1;
    }
  }
  &__vip-progress {
    margin-top: 24rpx;
    height: 12rpx;
    border-radius: 999rpx;
    background: rgba(92, 66, 46, 0.1);
    overflow: hidden;
  }
  &__vip-progress-bar {
    width: 18%;
    height: 100%;
    border-radius: 999rpx;
    background: #b88c64;
  }
  &__vip-progress-text {
    display: block;
    margin-top: 4rpx;
    text-align: right;
    font-size: 20rpx;
    color: rgba(92, 66, 46, 0.65);
  }

  &__sections {
    padding: 30rpx 20rpx 0;
  }

  &__card {
    background: #ffffff;
    border-radius: 24rpx;
    padding: 24rpx;
    box-shadow: 0 2rpx 8rpx rgba(0,0,0,0.08);
    margin-bottom: 30rpx;

    &--grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 20rpx;
    }
  }

  &__card-title {
    display: block;
    font-size: 32rpx;
    font-weight: 900;
    color: #333333;
    margin-bottom: 24rpx;
  }

  &__grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 20rpx;
  }

  &__grid-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 12rpx;
    transition: transform 0.24s;

    &:active {
      transform: scale(0.95);
    }
  }

  &__grid-icon {
    width: 80rpx;
    height: 80rpx;
    border-radius: 24rpx;
    background: rgba(177, 10, 15, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;

    &--primary {
      background: rgba(177, 10, 15, 0.1);
    }
  }

  &__grid-label {
    font-size: 22rpx;
    font-weight: 600;
    color: #333333;
    text-align: center;
  }

  &__action-icon {
    width: 36rpx;
    height: 36rpx;
    position: relative;

    &--orders {
      border: 3rpx solid #C41E3A;
      border-radius: 4rpx;

      &::before {
        content: '';
        position: absolute;
        top: 8rpx;
        left: 6rpx;
        right: 6rpx;
        height: 3rpx;
        background: #C41E3A;
        box-shadow: 0 8rpx 0 #C41E3A;
      }
    }

    &--address {
      border: 3rpx solid #C41E3A;
      border-radius: 50% 50% 50% 0;
      transform: rotate(-45deg);
    }

    &--service {
      border: 3rpx solid #C41E3A;
      border-radius: 50%;

      &::before {
        content: '';
        position: absolute;
        bottom: 6rpx;
        left: 50%;
        transform: translateX(-50%);
        width: 16rpx;
        height: 10rpx;
        border: 3rpx solid #C41E3A;
        border-top: none;
        border-radius: 0 0 12rpx 12rpx;
      }
    }

    &--code {
      border: 3rpx solid #C41E3A;
      border-radius: 4rpx;
    }

    &--wallet {
      border: 3rpx solid #C41E3A;
      border-radius: 8rpx;
    }

    &--check,
    &--coins,
    &--star,
    &--ticket,
    &--crown,
    &--logout {
      border: 3rpx solid #C41E3A;
      border-radius: 50%;
    }
  }

  &__action-img {
    width: 36rpx;
    height: 36rpx;
    display: block;
  }

  &__footer {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 32rpx 0 16rpx;
  }

  &__footer-text {
    font-size: 24rpx;
    color: #999999;
    line-height: 1.6;
    text-align: center;
  }

  &__footer-sub {
    font-size: 24rpx;
    color: #999999;
  }

  &__bottom-space {
    height: 120rpx;
  }
}
</style>