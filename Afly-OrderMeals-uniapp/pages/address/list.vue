<!-- D:/develop/project/Afly-OrderMeals/Afly-OrderMeals-uniapp/pages/address/list.vue -->
<template>
  <view class="address-page">
    <scroll-view
        class="address-page__scroll"
        scroll-y
        :show-scrollbar="false"
        :refresher-enabled="true"
        :refresher-triggered="refreshing"
        @refresherrefresh="onRefresh"
    >
      <view
          v-for="item in list"
          :key="item.id"
          class="address-card"
          :class="{ 'address-card--default': item.isDefault === 1 }"
          @click="choose(item)"
      >
        <!-- 第一行：地址（最大） -->
        <view class="address-card__address-row">
          <text class="address-card__detail">{{ item.fullAddress }}</text>
        </view>

        <!-- 第二行：标签 + 姓名性别 + 手机号 + 默认徽章 -->
        <view class="address-card__meta">
          <text class="address-card__name">{{ item.contactName }}</text>
          <text v-if="item.gender" class="address-card__gender">{{ item.gender }}</text>
          <text class="address-card__mobile">{{ maskMobile(item.contactMobile) }}</text>
          <view v-if="item.isDefault === 1" class="address-card__badge">
            <text class="address-card__badge-text">默认</text>
          </view>
        </view>

        <!-- 操作栏 -->
        <view class="address-card__actions">
          <view
              v-if="item.isDefault !== 1"
              class="address-card__action"
              @click.stop="setDefault(item)"
          >
            <text class="address-card__action-label">设为默认</text>
          </view>
          <view class="address-card__action" @click.stop="edit(item)">
            <text class="address-card__action-label">编辑</text>
          </view>
          <view class="address-card__action address-card__action--danger" @click.stop="remove(item.id)">
            <text class="address-card__action-label">删除</text>
          </view>
        </view>
      </view>

      <!-- 空状态 -->
      <view v-if="list.length === 0" class="address-page__empty">
        <image class="address-page__empty-img" :src="emptyImg" mode="aspectFit" />
        <text class="address-page__empty-title">还没有收货地址</text>
        <text class="address-page__empty-desc">点击下方按钮添加新地址</text>
      </view>

      <view class="address-page__bottom-space" />
    </scroll-view>

    <!-- 底部按钮 -->
    <view class="address-page__footer safe-area-bottom">
      <button class="address-page__add-btn" @click="edit()">
        <text class="address-page__add-icon">＋</text>
        <text>新增收货地址</text>
      </button>
    </view>
  </view>
</template>

<script>
import { addressApi } from '../../api/index'
import { STATIC_IMAGE_PREFIX, resolveImageUrl } from '../../utils/image'

export default {
  data() {
    return {
      list: [],
      selectMode: false,
      refreshing: false,
      emptyImg: resolveImageUrl(STATIC_IMAGE_PREFIX + '/开心呢.png')
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
      try {
        this.list = await addressApi.list()
      } catch (e) {
        uni.showToast({ title: e || '加载失败', icon: 'none' })
      }
    },
    async onRefresh() {
      this.refreshing = true
      await this.loadList()
      this.refreshing = false
    },
    maskMobile(mobile) {
      if (!mobile) return ''
      const str = String(mobile)
      if (str.length >= 7) {
        return str.slice(0, 3) + '****' + str.slice(-4)
      }
      return str
    },
    choose(item) {
      if (!this.selectMode) return
      uni.setStorageSync('selectedAddress', JSON.stringify(item))
      uni.setStorageSync('addressId', item.id)
      uni.navigateBack()
    },
    edit(item) {
      const id = item?.id || ''
      uni.navigateTo({ url: `/pages/address/edit?id=${id}` })
    },
    async setDefault(item) {
      try {
        await addressApi.setDefault(item.id)
        this.loadList()
      } catch (e) {
        uni.showToast({ title: e || '操作失败', icon: 'none' })
      }
    },
    async remove(id) {
      const res = await new Promise((resolve) => {
        uni.showModal({
          title: '提示',
          content: '确定要删除这个地址吗？',
          success: resolve
        })
      })
      if (!res.confirm) return
      try {
        await addressApi.delete(id)
        uni.showToast({ title: '删除成功', icon: 'success' })
        this.loadList()
      } catch (e) {
        uni.showToast({ title: e || '删除失败', icon: 'none' })
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.address-page {
  min-height: 100vh;
  background: #F5F5F5;
  display: flex;
  flex-direction: column;

  &__scroll {
    flex: 1;
    padding-top: 16rpx;
  }

  &__empty {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 160rpx 0 80rpx;
  }

  &__empty-img {
    width: 240rpx;
    height: 240rpx;
    margin-bottom: 32rpx;
  }

  &__empty-title {
    font-size: 30rpx;
    font-weight: 500;
    color: #333333;
    margin-bottom: 12rpx;
  }

  &__empty-desc {
    font-size: 26rpx;
    color: #999999;
  }

  &__footer {
    background: $bg-surface;
    padding: 20rpx 32rpx;
    padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
    box-shadow: 0 -2rpx 16rpx rgba(0, 0, 0, 0.04);
  }

  &__add-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8rpx;
    height: 88rpx;
    background: linear-gradient(135deg, #a01e1e, #c0392b);
    color: $text-white;
    border-radius: 44rpx;
    font-size: 30rpx;
    font-weight: 500;
    border: none;

    &::after {
      border: none;
    }

    &:active {
      opacity: 0.85;
    }
  }

  &__add-icon {
    font-size: 36rpx;
    font-weight: 300;
    line-height: 1;
  }

  &__bottom-space {
    height: 40rpx;
  }
}

.address-card {
  background: $bg-surface;
  border-radius: 16rpx;
  padding: 28rpx 28rpx 20rpx;
  margin: 0 24rpx 16rpx;
  box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);
  position: relative;
  overflow: hidden;

  &--default {
    border: 2rpx solid rgba(160, 30, 30, 0.15);
  }

  &:active {
    background: #FAFAFA;
  }

  &__address-row {
    display: flex;
    align-items: flex-start;
  }

  &__detail {
    font-size: 32rpx;
    font-weight: 500;
    color: #1A1A1A;
    line-height: 1.5;
    flex: 1;
    word-break: break-word;
  }

  &__meta {
    display: flex;
    align-items: center;
    gap: 12rpx;
    flex-wrap: wrap;
    margin-top: 16rpx;
  }

  &__name {
    font-size: 26rpx;
    font-weight: 500;
    color: #1A1A1A;
  }

  &__gender {
    font-size: 24rpx;
    color: #666666;
  }

  &__mobile {
    font-size: 24rpx;
    color: #999999;
    letter-spacing: 1rpx;
  }

  &__badge {
    background: linear-gradient(135deg, #a01e1e, #c0392b);
    padding: 4rpx 12rpx;
    border-radius: 12rpx;
    flex-shrink: 0;

    &-text {
      font-size: 20rpx;
      color: #FFFFFF;
      font-weight: 500;
    }
  }

  &__actions {
    display: flex;
    justify-content: flex-end;
    gap: 16rpx;
    margin-top: 20rpx;
    padding-top: 20rpx;
    border-top: 1rpx solid #F5F5F5;
  }

  &__action {
    display: flex;
    align-items: center;
    padding: 12rpx 24rpx;
    border-radius: 32rpx;
    font-size: 24rpx;
    border: 1rpx solid #E8E8E8;
    background: #FFFFFF;
    color: #666666;
    transition: all 0.2s;

    &:active {
      background: #F5F5F5;
      transform: scale(0.96);
    }

    &--danger {
      border-color: rgba(232, 60, 60, 0.2);
      color: #E83C3C;
      background: rgba(232, 60, 60, 0.04);

      &:active {
        background: rgba(232, 60, 60, 0.1);
      }
    }

    &-label {
      font-size: 24rpx;
    }
  }
}
</style>
