<template>
  <view class="address-page">
    <scroll-view class="address-page__scroll" scroll-y :show-scrollbar="false">
      <view v-for="item in list" :key="item.id" class="address-card" @click="choose(item)">
        <view class="address-card__top">
          <text class="address-card__name">{{ item.contactName }}</text>
          <text class="address-card__mobile">{{ item.contactMobile }}</text>
          <text v-if="item.isDefault === 1" class="address-card__tag">默认</text>
        </view>
        <text class="address-card__detail">{{ item.fullAddress }}</text>
        <view class="address-card__actions">
          <view class="address-card__action" @click.stop="edit(item)">
            <text class="address-card__action-text">编辑</text>
          </view>
          <view class="address-card__action address-card__action--danger" @click.stop="remove(item.id)">
            <text class="address-card__action-text">删除</text>
          </view>
        </view>
      </view>

      <view class="address-page__empty" v-if="list.length === 0">
        <image class="address-page__empty-emoji" src="/static/tabbar/暂无收货地址.png" mode=""></image>
        <text class="address-page__empty-text">暂无收货地址</text>
      </view>

      <view class="address-page__bottom-space"></view>
    </scroll-view>

    <view class="address-page__footer safe-area-bottom">
      <button class="address-page__add-btn" @click="edit()">新增地址</button>
    </view>
    <page-loading :visible="pageLoading" :tip="pageLoadingTip"></page-loading>
  </view>
</template>

<script>
import { addressApi } from '../../api/index'
import PageLoading from '../../components/page-loading/page-loading.vue'

export default {
  components: { PageLoading },
  data() {
    return {
      list: [],
      selectMode: false,
      pageLoading: false,
      pageLoadingTip: '加载中...'
    }
  },
  onLoad(options) {
    this.selectMode = options.select === '1'
  },
  onShow() {
    this.loadList()
  },
  methods: {
    async loadList() {
      this.list = await addressApi.list()
    },
    choose(item) {
      if (!this.selectMode) return
      uni.setStorageSync('diningMode', 3)
      uni.setStorageSync('addressId', item.id)
      this.goWithLoading('/pages/menu/index', 'switchTab')
    },
    edit(item) {
      const id = item?.id || ''
      this.goWithLoading(`/pages/address/edit?id=${id}`)
    },
    async remove(id) {
      await addressApi.delete(id)
      this.loadList()
    },
    goWithLoading(url, type = 'navigateTo', tip = '加载中...') {
      this.pageLoadingTip = tip
      this.pageLoading = true
      setTimeout(() => {
        if (type === 'switchTab') { uni.switchTab({ url }) }
        else if (type === 'reLaunch') { uni.reLaunch({ url }) }
        else if (type === 'redirectTo') { uni.redirectTo({ url }) }
        else if (type === 'navigateBack') { uni.navigateBack() }
        else { uni.navigateTo({ url }) }
        setTimeout(() => { this.pageLoading = false }, 500)
      }, 100)
    }
  }
}
</script>

<style lang="scss" scoped>
.address-page {
  min-height: 100vh;
  background: $bg-page;
  display: flex;
  flex-direction: column;

  &__scroll {
    flex: 1;
    padding-top: 8rpx;
  }

  &__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 120rpx 0;
  }

  &__empty-emoji {
	width: 80rpx;
	height: 80rpx;
    margin-bottom: 24rpx;
  }

  &__empty-text {
    font-size: 28rpx;
    color: #999999;
  }

  &__footer {
    background: $bg-surface;
    padding: 16rpx 24rpx;
    border-top: 1rpx solid $divider-color;
  }

  &__add-btn {
    background: #a01e1e;
    color: $text-white;
    border-radius: $radius-btn;
    font-size: 30rpx;
    font-weight: bold;

    &:active {
      background: $brand-primary-press;
    }
  }

  &__bottom-space {
    height: 120rpx;
  }
}

.address-card {
  background: $bg-surface;
  border-radius: $radius-card;
  padding: 28rpx;
  margin: 16rpx 24rpx;
  box-shadow: $shadow-card;

  &:active {
    opacity: 0.9;
  }

  &__top {
    display: flex;
    align-items: center;
    gap: 16rpx;
  }

  &__name {
    font-size: 30rpx;
    font-weight: bold;
    color: #333333;
  }

  &__mobile {
    font-size: 26rpx;
    color: #666666;
  }

  &__tag {
    background: $bg-category-active;
    color: $brand-primary;
    font-size: 20rpx;
    padding: 4rpx 12rpx;
    border-radius: 8rpx;
  }

  &__detail {
    display: block;
    margin-top: 16rpx;
    font-size: 26rpx;
    color: #666666;
    line-height: 1.5;
  }

  &__actions {
    display: flex;
    gap: 24rpx;
    margin-top: 20rpx;
    padding-top: 20rpx;
    border-top: 1rpx solid #F0F0F0;
  }

  &__action-text {
    font-size: 24rpx;
    color: #999999;
  }

  &__action--danger .address-card__action-text {
    color: $text-price;
  }
}
</style>
