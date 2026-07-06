<template>
  <view class="profile-page">
    <scroll-view class="profile-page__scroll" scroll-y :show-scrollbar="false">
      <view class="profile-page__hero" :style="heroPaddingStyle">
        <view class="profile-page__hero-bg">
			<image :src="staticImgPrefix + '/白logo.png'" mode=""></image>
		</view>
		<!-- 用户信息 -->
        <view class="profile-page__user-row">
          <view class="profile-page__avatar-wrap" @tap="goProfile">
            <image class="profile-page__avatar" :src="avatarSrc" mode="aspectFill" />
          </view>
          <view class="profile-page__user-info">
            <view class="profile-page__name-row" @tap="goProfile">
              <text class="profile-page__nickname">{{ nickname || '未登录用户' }}</text>
              <text v-if="companyVerified" class="profile-page__level-tag profile-page__level-tag--verified">已认证</text>
              <text v-else class="profile-page__level-tag">默认等级</text>
            </view>
            <text class="profile-page__mobile">{{ mobile || '请登录后查看' }}</text>
            <text v-if="companyVerified && companyDeptName" class="profile-page__company">{{ companyDeptName }}</text>
          </view>
          <view class="profile-page__member-btn" @tap="goMemberCode">
            <image class="profile-page__member-img" :src="staticImgPrefix + '/tabbar/二维码图标.png'" mode="aspectFit"></image>
            <!-- <text class="profile-page__member-text">会员码</text> -->
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
            <text class="profile-page__stat-label">卡券</text>
          </view>
        </view>

        
      </view>

      <view class="profile-page__sections">
        <view class="profile-page__card">
          <view class="profile-page__card-header">
            <text class="profile-page__card-title">我的订单</text>
            <text class="profile-page__card-more" @tap="goOrderList">全部{{ '>' }}</text>
          </view>
          <view class="profile-page__grid">
            <view
              v-for="item in primaryActions"
              :key="item.title"
              class="profile-page__grid-item"
              @tap="onActionTap(item)"
            >
              <view class="profile-page__grid-icon profile-page__grid-icon--primary">
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
            <image class="profile-page__avatar-option-img" :src="staticImgPrefix + '/1.png'" mode="aspectFill" />
          </view>
          <view
            class="profile-page__avatar-option"
            :class="{ 'profile-page__avatar-option--active': avatarKey === '2' }"
            @tap="selectAvatar('2')"
          >
            <image class="profile-page__avatar-option-img" :src="staticImgPrefix + '/2.png'" mode="aspectFill" />
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

    <!-- 充值中心面板 -->
    <view class="profile-page__recharge-mask" v-if="showRechargePicker" @tap="showRechargePicker = false">
      <view class="profile-page__recharge-picker" @tap.stop>
        <view class="profile-page__recharge-header">
          <text class="profile-page__recharge-title">充值中心</text>
          <text class="profile-page__recharge-close" @tap="showRechargePicker = false">✕</text>
        </view>
        <view class="profile-page__recharge-balance">
          <text class="profile-page__recharge-balance-label">我的余额</text>
          <text class="profile-page__recharge-balance-value">¥{{ balance }}</text>
        </view>
        <view class="profile-page__recharge-grid">
          <view
            v-for="(item, index) in rechargeAmounts"
            :key="index"
            class="profile-page__recharge-item"
            :class="{ 'profile-page__recharge-item--active': !rechargeIsCustom && rechargeSelected === item }"
            @tap="selectRechargePreset(item)"
          >
            <text class="profile-page__recharge-amount-text">{{ item }}元</text>
          </view>
          <view
            class="profile-page__recharge-item profile-page__recharge-item--custom"
            :class="{ 'profile-page__recharge-item--active': rechargeIsCustom }"
            @tap="selectRechargeCustom"
          >
            <input
              v-if="rechargeIsCustom"
              class="profile-page__recharge-custom-input"
              type="digit"
              v-model="rechargeCustomAmount"
              placeholder="金额"
              :focus="rechargeIsCustom"
              @blur="onRechargeCustomBlur"
            />
            <text v-else class="profile-page__recharge-amount-text">自定义</text>
          </view>
        </view>
        <view class="profile-page__recharge-btn" @tap="doRecharge">
          <text class="profile-page__recharge-btn-text">充值</text>
        </view>
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
</template>

<script>
import { authApi, couponApi, serviceApi, walletApi, payApi } from '../../api/index'
import tabbarPageMixin from '../../mixins/tabbar-page'
import { getNavMetrics } from '../../utils/navbar'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'

const PRIMARY_ACTIONS = [
  { title: '待支付', icon: 'orders' ,iconImg: STATIC_IMAGE_PREFIX + '/tabbar/待支付 1.png'},
  { title: '待发货', icon: 'address',iconImg: STATIC_IMAGE_PREFIX + '/tabbar/待发货 1.png' },
  { title: '待收货', icon: 'service',iconImg: STATIC_IMAGE_PREFIX + '/tabbar/待收货 1.png' },
  { title: '退款售后', icon: 'code' ,iconImg: STATIC_IMAGE_PREFIX + '/tabbar/售后 1.png'}
]

const SECONDARY_ACTIONS = [
  { title: '公司认证', icon: 'company', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/公司认证.png' },
  { title: '我的订单', icon: 'check', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/全部订单 1.png' },
  { title: '地址管理', icon: 'wallet', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/地址管理 1.png' },
  { title: '客服中心', icon: 'coins', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/客服 1.png' },
  { title: '充值中心', icon: 'ticket', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/储值 1.png' },
  { title: '红包卡券', icon: 'crown', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/卡券 1.png' },
  { title: '签到中心', icon: 'logout', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/签到 1.png' },
  { title: '积分抽奖', icon: 'logout', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/抽奖 1.png' },
  { title: '安全退出', icon: 'logout', iconImg: STATIC_IMAGE_PREFIX + '/tabbar/退出 1.png' }
]

export default {
  mixins: [tabbarPageMixin],
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
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
      showRechargePicker: false,
      rechargeAmounts: [10, 20, 50, 100, 200, 500],
      rechargeSelected: 10,
      rechargeIsCustom: false,
      rechargeCustomAmount: ''
    }
  },
  computed: {
    heroPaddingStyle() {
      return { paddingTop: `${this.navMetrics.statusBarHeight + 8}px` }
    },
    avatarSrc() {
      if (this.avatarKey) return STATIC_IMAGE_PREFIX + `/${this.avatarKey}.png`
      return STATIC_IMAGE_PREFIX + '/1.png'
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
      if (item.title === '待支付') {
        uni.navigateTo({ url: '/pages/order/list?tab=1' })
        return
      }
      if (item.title === '待发货') {
        uni.navigateTo({ url: '/pages/order/list?tab=2' })
        return
      }
      if (item.title === '待收货') {
        uni.navigateTo({ url: '/pages/order/list?tab=3' })
        return
      }
      if (item.title === '退款售后') {
        uni.navigateTo({ url: '/pages/order/list?tab=4' })
        return
      }
      if (item.title === '我的订单') {
        uni.navigateTo({ url: '/pages/order/list' })
        return
      }
      if (item.title === '地址管理') {
        uni.navigateTo({ url: '/pages/address/list' })
        return
      }
      if (item.title === '联系客服') {
        this.callService()
        return
      }
      if (item.title === '会员码') {
        uni.navigateTo({ url: '/pages/mine/memberCode/index' })
        return
      }
      if (item.title === '公司认证') {
        uni.navigateTo({ url: '/pages/mine/company-auth' })
        return
      }
      if (item.title === '优惠券包' || item.title === '红包卡券') {
        uni.navigateTo({ url: '/pages/coupon/wallet' })
        return
      }
      if (item.title === '充值中心') {
        uni.navigateTo({ url: '/pages/coupon/recharge' })
        return
      }
      if (item.title === '签到中心') {
        uni.navigateTo({ url: '/pages/signin/index' })
        return
      }
      if (item.title === '积分抽奖') {
        uni.navigateTo({ url: '/pages/lottery/index' })
        return
      }
      if (item.title === '积分商城') {
        uni.navigateTo({ url: '/pages/integralShop/index' })
        return
      }
      if (item.title === '会员日') {
        uni.navigateTo({ url: '/pages/mine/memberDay/index' })
        return
      }
      if (item.title === '退出登录') {
        this.logout()
        return
      }
      this.onFeatureTap(item.title)
    },
    goOrderList() {
      uni.navigateTo({ url: '/pages/order/list' })
    },
    goMemberCode() {
      uni.navigateTo({ url: '/pages/mine/memberCode/index' })
    },
    onFeatureTap(title) {
      uni.showToast({ title: `${title}功能开发中`, icon: 'none' })
    },
    goProfile() {
      uni.navigateTo({ url: '/pages/mine/profile' })
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
    selectRechargePreset(amount) {
      this.rechargeIsCustom = false
      this.rechargeSelected = amount
    },
    selectRechargeCustom() {
      this.rechargeIsCustom = true
    },
    onRechargeCustomBlur() {
      if (!this.rechargeCustomAmount || parseFloat(this.rechargeCustomAmount) <= 0) {
        this.rechargeIsCustom = false
        this.rechargeCustomAmount = ''
      }
    },
    getRechargeAmount() {
      if (this.rechargeIsCustom) {
        const n = parseFloat(this.rechargeCustomAmount)
        return (!isNaN(n) && n > 0) ? n : 0
      }
      return this.rechargeSelected
    },
    async doRecharge() {
      const amount = this.getRechargeAmount()
      if (!amount || amount <= 0) {
        uni.showToast({ title: '请选择或输入充值金额', icon: 'none' })
        return
      }
      try {
        uni.showLoading({ title: '充值中...' })
        const res = await walletApi.rechargeCreate(amount)
        if (res && res.outTradeNo) {
          const payInfo = await payApi.create({
            outTradeNo: res.outTradeNo,
            payChannel: 'balance',
            payScene: 'mp'
          })
          if (payInfo.completed) {
            uni.showToast({ title: '充值成功', icon: 'success' })
            this.showRechargePicker = false
            this.loadProfile()
            return
          }
          if (payInfo.mockPay) {
            await payApi.mockSuccess(payInfo.outTradeNo)
            uni.showToast({ title: '充值成功', icon: 'success' })
            this.showRechargePicker = false
            this.loadProfile()
            return
          }
          uni.showToast({ title: '充值成功', icon: 'success' })
          this.showRechargePicker = false
          this.loadProfile()
        }
      } catch (e) {
        uni.showToast({ title: e.message || e || '充值失败', icon: 'none' })
      } finally {
        uni.hideLoading()
      }
    },
    async logout() {
      try {
        await authApi.logout()
      } catch (e) {}
      uni.clearStorageSync()
      uni.reLaunch({ url: '/pages/login/index' })
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
	  min-height: 380rpx;
      padding: 0 32rpx 100rpx;
      background: linear-gradient(180deg, #e63946 0%, #f8f8f8 100%);
      position: relative;
      overflow: hidden;
    }

    &__hero-bg {
      position: absolute;
      top:-50rpx;
	  right: 20rpx;
      width: 400rpx;
      height: 520rpx;
      opacity: 0.3;
      pointer-events: none;
    }

    &__hero-bg image {
      width: 100%;
      height: 100%;
      display: block;
    }

  &__user-row {
    display: flex;
    align-items: center;
    gap: 24rpx;
	padding-top: 100rpx;
  }

  &__avatar-wrap {
    position: relative;
    flex-shrink: 0;
  }

  &__avatar {
    width: 112rpx;
    height: 112rpx;
    border-radius: 50%;
    // border: 4rpx solid #C41E3A;
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

  /* 充值中心面板 */
  &__recharge-mask {
    position: fixed;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    display: flex;
    align-items: flex-end;
  }

  &__recharge-picker {
    width: 100%;
    background: #FFFFFF;
    border-radius: 32rpx 32rpx 0 0;
    padding: 32rpx;
    box-sizing: border-box;
    animation: slideUp 0.3s ease;
  }

  &__recharge-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 32rpx;
  }

  &__recharge-title {
    font-size: 32rpx;
    font-weight: 700;
    color: #333333;
  }

  &__recharge-close {
    font-size: 32rpx;
    color: #999999;
    padding: 8rpx;
  }

  &__recharge-balance {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 24rpx 0 32rpx;
    border-bottom: 1rpx solid #F0F0F0;
    margin-bottom: 32rpx;
  }

  &__recharge-balance-label {
    font-size: 24rpx;
    color: #999999;
    margin-bottom: 8rpx;
  }

  &__recharge-balance-value {
    font-size: 48rpx;
    font-weight: 700;
    color: #D00000;
  }

  &__recharge-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 20rpx;
  }

  &__recharge-item {
    width: calc((100% - 40rpx) / 3);
    height: 100rpx;
    border-radius: 12rpx;
    background: #F5F5F5;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2rpx solid transparent;
    box-sizing: border-box;

    &--active {
      background: #D00000;
      border-color: #D00000;
    }

    &--custom {
      position: relative;
    }
  }

  &__recharge-amount-text {
    font-size: 28rpx;
    font-weight: 600;
    color: #666666;
  }

  &__recharge-item--active &__recharge-amount-text {
    color: #FFFFFF;
  }

  &__recharge-custom-input {
    width: 100%;
    text-align: center;
    font-size: 28rpx;
    font-weight: 600;
    color: #FFFFFF;
  }

  &__recharge-btn {
    margin-top: 40rpx;
    height: 88rpx;
    border-radius: 44rpx;
    background: linear-gradient(135deg, #D00000 0%, #A01731 100%);
    display: flex;
    align-items: center;
    justify-content: center;

    &:active {
      opacity: 0.9;
    }
  }

  &__recharge-btn-text {
    font-size: 32rpx;
    font-weight: 600;
    color: #FFFFFF;
  }

  @keyframes slideUp {
    from { transform: translateY(100%); }
    to { transform: translateY(0); }
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
    color: #ffffff;
  }

  &__level-tag {
    padding: 4rpx 16rpx;
    border-radius: 999rpx;
    background: rgba(255, 255, 255, 0.25);
    font-size: 20rpx;
    color: #ffffff;

    &--verified {
      background: rgba(255, 255, 255, 0.3);
      color: #ffffff;
    }
  }

  &__mobile {
    display: block;
    margin-top: 6rpx;
    font-size: 24rpx;
    color: rgba(255, 255, 255, 0.85);
  }

  &__company {
    display: block;
    margin-top: 4rpx;
    font-size: 22rpx;
    color: rgba(255, 255, 255, 0.75);
  }

  &__member-btn {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    padding: 8rpx 16rpx;
  }
  
  &__member-img {
    width: 60rpx;
    height: 60rpx;
    display: block;
  }
  
  &__member-text {
    font-size: 20rpx;
    color: rgba(255, 255, 255, 0.85);
    margin-top: 4rpx;
  }

  &__stats {
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 90rpx 24rpx -100rpx;
      padding: 32rpx 0;
      background: #ffffff;
      border-radius: 20rpx;
      box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.1);
	  position: relative;
	  z-index: 10;
    }
  
    &__stat-item {

      flex: 1;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      position: relative;
	  border-right: 2px solid #c3c3c3;
	  
	  &:last-child {
	      border-right: none; 
	    }
      &:not(:last-child)::after {
        content: '';
        position: absolute;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 1rpx;
        height: 60rpx;
        background: #e8e8e8;
      }
    }
  
    &__stat-value {
	  line-height: 50rpx;
      display: block;
      font-size: 32rpx;
      font-weight: 900;
      color: #5f5f5f;
	  
    }
  
    &__stat-label {
	  line-height: 40rpx;
      display: block;
      margin-top: 6rpx;
      font-size: 26rpx;
      font-weight: 600;
      color: #838383;
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
    padding: 20rpx 20rpx 0;
	background: #f8f8f8;
    // margin-top: -16rpx;
  }

  &__card {
    background: #ffffff;
    border-radius: 16rpx;
    padding: 24rpx;
    box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.06);
	margin-top: 20rpx;
    margin-bottom: 20rpx;

    &--grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24rpx 12rpx;
    }
  }

  &__card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 24rpx;
  }

  &__card-title {
    font-size: 30rpx;
    font-weight: 700;
    color: #333333;
  }

  &__card-more {
    font-size: 24rpx;
    color: #999999;
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
    // background: rgba(177, 10, 15, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;


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
    width: 44rpx;
    height: 44rpx;
    display: block;
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