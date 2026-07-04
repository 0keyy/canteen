<template>
  <view class="integral-page">
    <scroll-view class="integral-scroll" scroll-y :show-scrollbar="false">
      <!-- 顶部积分头部 -->
      <view class="integral-header">
        <view class="back-btn" @tap="goBack">
          <text class="back-arrow">‹</text>
        </view>
        <view class="integral-header-top">
          <view class="integral-score-wrap">
            <text class="integral-score-num">{{ userScore }}</text>
            <text class="integral-score-text">积分</text>
            <text class="integral-score-desc">积分换好礼，别忘记使用哦</text>
          </view>
          <view class="integral-header-avatar">
            <image class="avatar-box" :src="staticImgPrefix + '/static/新版小唐.png'" mode="aspectFill"></image>
          </view>
        </view>
      </view>

      <!-- 抽奖、签到横幅 -->
      <view class="integral-banner-wrap">
        <view class="banner-item banner-draw" @tap="goDrawPage">
          <text class="banner-title">积分抽奖</text>
          <text class="banner-desc">赢取优惠券</text>
          <text class="banner-arrow">&rsaquo;</text>
        </view>
        <view class="banner-item banner-sign">
          <text class="banner-title">每日签到</text>
          <text class="banner-desc">每天有惊喜</text>
          <text class="banner-arrow">&rsaquo;</text>
        </view>
      </view>

      <!-- 商品列表 两栏布局 -->
      <view class="goods-grid">
        <view
          v-for="goods in goodsList"
          :key="goods.id"
          class="goods-card"
          @tap="goGoodsDetail(goods)"
        >
          <!-- 后端无图片显示灰色占位 -->
          <view class="goods-img-wrap">
            <image v-if="goods.img" class="goods-img" :src="goods.img" mode="aspectFill"></image>
            <view v-else class="goods-empty-placeholder"></view>
          </view>
          <view class="goods-name">{{ goods.name }}</view>
          <view class="goods-bottom">
            <text class="goods-point">{{ goods.point }} 积分</text>
            <text class="goods-sold">已兑{{ goods.sold }}份</text>
          </view>
        </view>
      </view>

      <view class="page-bottom-space"></view>
    </scroll-view>
  </view>
</template>

<script>
// 引入用户信息接口、积分商品接口
import { authApi } from '../../api/index'
import { getIntegralGoodsList } from '../../api/integral'
import { STATIC_IMAGE_PREFIX } from '../../utils/image'
export default {
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      userScore: 0,
      // 兜底本地商品（后端接口异常时展示）
      defaultGoods: [
        {
          id: 1,
          img: "",
          name: '【堂食专享】可口可乐',
          point: 10,
          sold: 0
        },
        {
          id: 2,
          img: "",
          name: '【堂食专享】苦菊拌干豆腐丝',
          point: 150,
          sold: 0
        },
        {
          id: 3,
          img: "",
          name: '【堂食专享】老醋三样',
          point: 200,
          sold: 0
        },
        {
          id: 4,
          img: "",
          name: '【堂食专享】番茄莎莎酱',
          point: 150,
          sold: 0
        }
      ],
      goodsList: []
    }
  },
  onLoad() {
    // 初始化先赋值本地兜底数据，避免空数组渲染报错
    this.goodsList = this.defaultGoods
    this.getUserScore()
    this.getGoodsList()
  },
  onShow() {
    this.getUserScore()
    this.getGoodsList()
  },
  methods: {
    // 返回上一页
    goBack() {
      uni.navigateBack()
    },
    // 跳转积分抽奖页
    goDrawPage() {
      uni.navigateTo({ url: '/pages/integralDraw/index' })
    },
    // 获取用户当前积分（从用户信息接口拿）
    async getUserScore() {
      try {
        const res = await authApi.profile()
        if (res && res.code === 200 && res.data && res.data.point != null) {
          this.userScore = res.data.point
        }
      } catch (err) {
        this.userScore = 0
      }
    },
    // 请求后端：获取积分兑换商品列表
    async getGoodsList() {
      try {
        const res = await getIntegralGoodsList()
        // 多层判空，杜绝null/undefined渲染崩溃
        if (res && res.code === 200 && Array.isArray(res.data)) {
          this.goodsList = res.data
        }
      } catch (err) {
        // 接口失败自动使用本地模拟数据，不弹报错
        this.goodsList = this.defaultGoods
        console.log('积分商品接口暂未开发', err)
      }
    },
    // 商品详情弹窗预留
    goGoodsDetail(item) {
      uni.showToast({ title: '商品详情开发中', icon: 'none' })
    }
  }
}
</script>

<style lang="scss" scoped>
.integral-page {
  min-height: 100vh;
  background: #f7f7f7;
  display: flex;
  flex-direction: column;

  .integral-scroll {
    flex: 1;
    padding-bottom: 40rpx;
  }

  // 顶部渐变头部
  .integral-header {
    position: relative;
    background: linear-gradient(180deg, #ffc8c8 0%, #fff0f0 100%);
    padding: calc(60rpx + env(safe-area-inset-top)) 32rpx 24rpx;
    border-radius: 0 0 32rpx 32rpx;

    .back-btn {
      position: absolute;
      left: 20rpx;
      top: calc(env(safe-area-inset-top) + 26rpx);
      z-index: 10;
      width: 60rpx;
      height: 60rpx;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-top: 30rpx;
    
      .back-arrow {
        font-size: 80rpx;
        color: #222;
        font-weight: 400;
        line-height: 1;
      }
    }
	
	.integral-header-avatar {
	  margin-top: -80rpx;
	  margin-right: 20px;
	}

    .integral-header-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 32rpx;
      margin-top: 70rpx;
    }
    .integral-score-wrap { flex: 1; padding-left: 18rpx;}
    .integral-score-num { font-size: 60rpx; font-weight: bold; color: #222; }
    .integral-score-text { font-size: 28rpx; color: #666; margin-left: 8rpx; }
    .integral-score-desc { font-size: 24rpx; color: #999; margin-top: 8rpx; display: block; }
    .avatar-box {
      width: 180rpx;
      height: 250rpx;
      border-radius: 0;
      overflow: visible;
    }
  }

  // 签到抽奖横幅
  .integral-banner-wrap {
    display: flex;
    gap: 20rpx;
    padding: 24rpx 32rpx;
    .banner-item {
      flex: 1;
      height: 160rpx;
      border-radius: 20rpx;
      padding: 32rpx 24rpx;
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: center;
      &.banner-draw {
        background-image: linear-gradient(135deg, rgba(255,154,158,0.85), rgba(250,208,196,0.85));
        background-size: 100% 100%;
        background-repeat: no-repeat;
      }
      &.banner-sign {
        background-image: linear-gradient(135deg, rgba(255,209,209,0.85), rgba(255,184,184,0.85));
        background-size: 100% 100%;
        background-repeat: no-repeat;
      }
    }
    .banner-title { font-size: 34rpx; font-weight: bold; color: #fff; }
    .banner-desc { font-size: 24rpx; color: rgba(255,255,255,0.9); margin-top: 8rpx; }
    .banner-arrow { position: absolute; right: 24rpx; top: 50%; transform: translateY(-50%); font-size: 36rpx; color: #fff; }
  }
  
  // 商品两栏网格
  .goods-grid {
    padding: 0 32rpx;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 24rpx;
  }
  .goods-card {
    background: #fff;
    border-radius: 20rpx;
    overflow: hidden;
  }

  // 图片外层容器
  .goods-img-wrap {
    width: 100%;
    height: 280rpx;
    overflow: hidden;
  }
  // 无图灰色占位（和首页、抽奖页统一）
  .goods-empty-placeholder {
    width: 100%;
    height: 100%;
    background: #eeeeee;
  }
  .goods-img {
    width: 100%;
    height: 100%;
  }

  .goods-name { font-size: 26rpx; color: #222; padding: 16rpx 16rpx 8rpx; }
  .goods-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 16rpx 20rpx;
  }
  .goods-point { font-size: 28rpx; color: #d63031; font-weight: 600; }
  .goods-sold { font-size: 22rpx; color: #999; }

  .page-bottom-space { height: 40rpx; }
}
</style>