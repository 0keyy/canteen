<template>
  <view class="rules-page">
    <scroll-view class="rules-page__content" scroll-y :show-scrollbar="false">
      <view v-if="loading" class="rules-page__empty">
        <text class="rules-page__empty-text">加载中...</text>
      </view>
      <view v-else class="rules-page__content-inner">
        <rich-text :nodes="rulesContent"></rich-text>
      </view>
      <view class="rules-page__bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
import { integralApi } from '../../api/index'

export default {
  data() {
    return {
      loading: false,
      rulesContent: ''
    }
  },
  onShow() {
    this.loadRules()
  },
  methods: {
    goBack() {
      uni.navigateBack()
    },
    async loadRules() {
      this.loading = true
      try {
        const res = await integralApi.rules()
        if (res && (res.code === 200 || res.code === 0)) {
          const data = res.data || res.result || res
          if (typeof data === 'string') {
            this.rulesContent = data
          } else if (data && typeof data === 'object') {
            this.rulesContent = data.content || data.text || data.rules || ''
          }
        }
      } catch (e) {
        console.log('[rules] 接口报错:', e)
      } finally {
        this.loading = false
        if (!this.rulesContent) {
          this.rulesContent = this.getDefaultRules()
        }
      }
    },
    getDefaultRules() {
      return `
        <div style="padding: 32rpx; font-size: 28rpx; color: #333333; line-height: 1.8;">
          <h3 style="font-size: 32rpx; font-weight: 600; color: #333333; margin-bottom: 20rpx;">一、积分获取规则</h3>
          <p style="margin-bottom: 16rpx;">1. 每日签到可获得积分，连续签到积分翻倍。</p>
          <p style="margin-bottom: 16rpx;">2. 每消费1元可获得1积分。</p>
          <p style="margin-bottom: 16rpx;">3. 邀请好友注册可获得积分奖励。</p>
          <p style="margin-bottom: 16rpx;">4. 参与活动可获得额外积分奖励。</p>
          <h3 style="font-size: 32rpx; font-weight: 600; color: #333333; margin-bottom: 20rpx; margin-top: 32rpx;">二、积分使用规则</h3>
          <p style="margin-bottom: 16rpx;">1. 积分可用于兑换积分商城商品。</p>
          <p style="margin-bottom: 16rpx;">2. 积分可用于抵扣消费金额。</p>
          <p style="margin-bottom: 16rpx;">3. 积分不可兑换现金。</p>
          <p style="margin-bottom: 16rpx;">4. 积分有效期为获得之日起一年内。</p>
          <h3 style="font-size: 32rpx; font-weight: 600; color: #333333; margin-bottom: 20rpx; margin-top: 32rpx;">三、积分查询</h3>
          <p style="margin-bottom: 16rpx;">1. 用户可在"我的"页面查看当前积分。</p>
          <p style="margin-bottom: 16rpx;">2. 用户可在"积分明细"页面查看积分变动记录。</p>
          <h3 style="font-size: 32rpx; font-weight: 600; color: #333333; margin-bottom: 20rpx; margin-top: 32rpx;">四、注意事项</h3>
          <p style="margin-bottom: 16rpx;">1. 如有违规获取积分行为，平台有权扣除相应积分。</p>
          <p style="margin-bottom: 16rpx;">2. 本规则最终解释权归平台所有。</p>
        </div>
      `
    }
  }
}
</script>

<style lang="scss" scoped>
.rules-page {
  min-height: 100vh;
  background: #ffffff;
  display: flex;
  flex-direction: column;



  &__content {
    flex: 1;
    background: #FFFFFF;
  }

  &__content-inner {
    padding: 0;
  }

  &__empty {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 100rpx 0;
  }

  &__empty-text {
    font-size: 28rpx;
    color: #999999;
  }

  &__bottom-space {
    height: 40rpx;
  }
}
</style>
