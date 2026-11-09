<template>
	<view class="lottery-page">
		<view class="lottery-page__header" :style="headerStyle">
			<view class="lottery-page__header-bg">
				<image :src="staticImgPrefix + '/白logo.png'" mode="aspectFit" class="lottery-page__header-bg-logo" />
			</view>
			<view class="lottery-page__nav-bar">
				<view class="lottery-page__back-btn" @tap="goBack">
					<image class="lottery-page__back-icon" :src="staticImgPrefix + '/tabbar/返回 2.png'" mode="aspectFit" />
				</view>
				<view class="lottery-page__nav-placeholder"></view>
			</view>
			<view class="lottery-page__header-body">
				<view class="lottery-page__title-wrap">
					<text class="lottery-page__title">粮兴坊</text>
					<text class="lottery-page__subtitle">积分抽奖</text>
				</view>
				<image class="lottery-page__character" :src="staticImgPrefix + '/走路小唐.png'" mode="aspectFit" />
			</view>
		</view>

		<view class="lottery-page__content">
			<view class="lottery-page__card">
				<view class="lottery-page__card-decor">
				</view>
				<view class="lottery-page__grid">
					<view v-for="(prize, index) in prizeList" :key="index" class="lottery-page__grid-item"
						:class="{ 'lottery-page__grid-item--active': activeIndex === index, 'lottery-page__grid-item--center': index === 4 }">
						<view v-if="index === 4" class="lottery-page__draw-btn" @tap="handleDraw">
							<view class="lottery-page__draw-top">
								<text class="lottery-page__draw-text">抽</text>
							</view>
							<view class="lottery-page__draw-bottom">
								<text class="lottery-page__draw-sub">消耗10积分</text>
							</view>
						</view>
						<template v-else>
							<view class="lottery-page__prize-top">
								<view class="lottery-page__prize-text">
									<text class="lottery-page__prize-value">{{ prize.value }}</text>
									<text class="lottery-page__prize-unit">{{ prize.unit }}</text>
								</view>

							</view>
							<view class="lottery-page__prize-bottom">
								<text class="lottery-page__prize-name">{{ prize.name }}</text>
							</view>
						</template>
					</view>
				</view>
			</view>

			<view class="lottery-page__info-row">
				<text class="lottery-page__info-text">当前积分：{{ userPoints }}</text>
			</view>
		</view>

		<view class="lottery-page__modal" v-if="showModal" @tap="closeModal">
			<view class="lottery-page__modal-content" @tap.stop>
				<view class="lottery-page__modal-icon">🎉</view>
				<text class="lottery-page__modal-title">恭喜获得</text>
				<text class="lottery-page__modal-prize">{{ modalPrize }}</text>
				<view class="lottery-page__modal-btn" @tap="closeModal">
					<text class="lottery-page__modal-btn-text">确定</text>
				</view>
			</view>
		</view>
	</view>
</template>

<script setup>
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import {
lotteryApi
} from '../../api/index'
import {
STATIC_IMAGE_PREFIX
} from '../../utils/image'
import {
getNavMetrics
} from '../../utils/navbar'

const staticImgPrefix = ref(STATIC_IMAGE_PREFIX)
const navMetrics = ref(getNavMetrics())
const userPoints = ref(0)
const prizeList = ref([])
const activeIndex = ref(-1)
const isDrawing = ref(false)
const showModal = ref(false)
const modalPrize = ref('')

const headerStyle = computed(() => {
  return {
    paddingTop: `${navMetrics.value.statusBarHeight}px`
  }
})

onShow(() => {
  navMetrics.value = getNavMetrics()
  loadLotteryInfo()
})

function goBack() {
  uni.navigateBack()
}

async function loadLotteryInfo() {
  try {
    const data = await lotteryApi.info()
    if (data) {
      userPoints.value = data.points || 0
    }
  } catch (e) {
    userPoints.value = 0
  }
  loadPrizes()
}

async function loadPrizes() {
  try {
    const data = await lotteryApi.prizes()
    if (Array.isArray(data)) {
      prizeList.value = data
    } else {
      prizeList.value = getMockPrizes()
    }
  } catch (e) {
    prizeList.value = getMockPrizes()
  }
}

function getMockPrizes() {
  return [{
      value: '15',
      unit: '积分',
      name: '15积分'
    },
    {
      value: '立减3',
      unit: '元',
      name: '3元优惠券'
    },
    {
      value: '满20减',
      unit: '5元',
      name: '5元满减券'
    },
    {
      value: '10',
      unit: '积分',
      name: '10积分'
    },
    {
      value: '',
      unit: '',
      name: ''
    },
    {
      value: '立减1',
      unit: '元',
      name: '1元优惠券'
    },
    {
      value: '立减1',
      unit: '元',
      name: '1元优惠券'
    },
    {
      value: '5',
      unit: '积分',
      name: '5积分'
    },
    {
      value: '满20减',
      unit: '3元',
      name: '3元满减券'
    }
  ]
}

async function handleDraw() {
  if (isDrawing.value) return
  if (userPoints.value < 10) {
    uni.showToast({
      title: '积分不足',
      icon: 'none'
    })
    return
  }

  isDrawing.value = true
  activeIndex.value = 0

  const order = [0, 1, 2, 5, 8, 7, 6, 3]
  let step = 0
  const totalSteps = order.length * 2 + Math.floor(Math.random() * order.length)

  const timer = setInterval(() => {
    step++
    if (step > totalSteps) {
      clearInterval(timer)
      const finalIndex = order[(totalSteps - 1) % order.length]
      activeIndex.value = finalIndex
      handleDrawResult(finalIndex)
    } else {
      const idx = order[(step - 1) % order.length]
      activeIndex.value = idx
    }
  }, 80)
}

async function handleDrawResult(index) {
  const prize = prizeList.value[index]
  try {
    const data = await lotteryApi.draw()
    if (data && data.prize) {
      modalPrize.value = data.prize
    } else {
      modalPrize.value = `${prize.value}${prize.unit} - ${prize.name}`
    }
  } catch (e) {
    modalPrize.value = `${prize.value}${prize.unit} - ${prize.name}`
  }

  setTimeout(() => {
    showModal.value = true
    isDrawing.value = false
    loadLotteryInfo()
  }, 500)
}

function closeModal() {
  showModal.value = false
  activeIndex.value = -1
}
</script>

<style lang="scss" scoped>
	$brand-red: #b20300;
	$light-red: #FFB4B4;
	$bg-pink: #FFD4D4;

	.lottery-page {
		min-height: 100vh;
		background: linear-gradient(180deg, #ffdada 0%, #f88785 75%);
		position: relative;

		&__header {

			position: relative;
			padding-bottom: 40rpx;
			z-index: 1;
			overflow: hidden;
		}

		&__header-bg {
			position: absolute;
			right: 360rpx;
			bottom: 25rpx;
			width: 400rpx;
			height: 400rpx;
			pointer-events: none;
		}

		&__header-bg-logo {
			width: 100%;
			height: 100%;
			opacity: 0.4;
		}

		&__nav-bar {
			display: flex;
			align-items: center;
			height: 88rpx;
			padding: 0 32rpx;
		}

		&__nav-placeholder {
			flex: 1;
		}

		&__back-btn {
			width: 64rpx;
			height: 64rpx;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-shrink: 0;
		}

		&__back-icon {
			width: 44rpx;
			height: 44rpx;
		}

		&__header-body {
			display: flex;
			align-items: flex-end;
			padding: 20rpx 32rpx 0;
			position: relative;
			z-index: 2;
		}

		&__title-wrap {
			flex: 1;
			padding-bottom: 40rpx;
		}

		&__title {
			font-size: 72rpx;
			font-weight: 700;
			color: #c82d24;
			display: block;
			line-height: 1.2;
		}

		&__subtitle {
			font-size: 72rpx;
			font-weight: 700;
			color: #850000;
			display: block;
			line-height: 1.2;
		}

		&__character {
			width: 240rpx;
			height: 240rpx;
			flex-shrink: 0;
			margin-bottom: -20rpx;
		}

		&__content {
			padding: 0 32rpx 32rpx;
			margin-top: -40rpx;
			position: relative;
			z-index: 2;
		}

		&__card {
			background: $brand-red;
			padding: 60rpx 32rpx 48rpx;
			box-shadow: 0 8rpx 30rpx rgba(178, 3, 0, 0.3);
			position: relative;
		}

		&__card-decor {
			position: absolute;
			top: -8rpx;
			left: 0;
			right: 0;
			display: flex;
			justify-content: space-between;
			padding: 0 40rpx;
			pointer-events: none;
		}

		&__gift-icon {
			font-size: 48rpx;
			filter: drop-shadow(0 2rpx 4rpx rgba(0, 0, 0, 0.2));

			&--right {
				transform: scaleX(-1);
			}
		}

		&__grid {
			display: grid;
			grid-template-columns: repeat(3, 1fr);
			gap: 24rpx;
		}

		&__grid-item {
			border-radius: 20rpx;
			display: flex;
			flex-direction: column;
			overflow: hidden;
			transition: all 0.2s ease;
			border: 3rpx solid transparent;

			&--active {
				border-color: #FFD700;
				transform: scale(1.05);
				box-shadow: 0 4rpx 16rpx rgba(255, 215, 0, 0.5);
			}

	
		}

		&__prize-top {
			background: #FFE8E8;
			display: flex;
			align-items: baseline;
			justify-content: center;
			padding: 36rpx 8rpx;
			border-radius: 16rpx;
		}
		
		&__prize-text {
			width: 100%;
			text-align: center;
			border-radius: 5rpx;
			display: inline-block;
			background: #ffd6d6;
			line-height: 80rpx;
		}

		&__prize-value {
			font-size: 40rpx;
			font-weight: 700;
			color: $brand-red;
			line-height: 1;

		}

		&__prize-unit {
			font-size: 28rpx;
			color: $brand-red;
			margin-left: 4rpx;
			line-height: 1;

		}

		&__prize-bottom {
			background: #531f1f;
			text-align: center;
			padding: 12rpx 8rpx;
			border-radius: 0 0 16rpx 16rpx;
		}

		&__prize-name {
			font-size: 18rpx;
			color: #FFFFFF;
			line-height: 1.2;
		}

		&__draw-btn {
			width: 100%;
			display: flex;
			flex-direction: column;
			align-items: center;
			justify-content: center;
			border-radius: 16rpx;
			background: #ffffff;
			padding: 24rpx 8rpx;
			gap: 8rpx;
		}

		&__draw-top {
			display: flex;
			align-items: center;
			justify-content: center;
		}

		&__draw-text {
			font-size: 80rpx;
			font-weight: 500;
			color: #850000;
			line-height: 1.45;
		}

		&__draw-bottom {
			text-align: center;
		}

		&__draw-sub {
			font-size: 20rpx;
			color: #9b9b9b;
			line-height: 1;
		}

		&__info-row {
			margin-top: 32rpx;
			text-align: center;
		}

		&__info-text {
			font-size: 28rpx;
			color: #666666;
		}

		&__modal {
			position: fixed;
			top: 0;
			left: 0;
			right: 0;
			bottom: 0;
			background: rgba(0, 0, 0, 0.6);
			display: flex;
			align-items: center;
			justify-content: center;
			z-index: 100;
		}

		&__modal-content {
			background: #FFFFFF;
			border-radius: 24rpx;
			padding: 48rpx 40rpx;
			margin: 0 60rpx;
			text-align: center;
		}

		&__modal-icon {
			font-size: 80rpx;
			margin-bottom: 24rpx;
		}

		&__modal-title {
			font-size: 32rpx;
			font-weight: 600;
			color: #333333;
			display: block;
			margin-bottom: 24rpx;
		}

		&__modal-prize {
			font-size: 36rpx;
			font-weight: 700;
			color: $brand-red;
			display: block;
			margin-bottom: 40rpx;
		}

		&__modal-btn {
			background: $brand-red;
			border-radius: 36rpx;
			padding: 20rpx 0;
		}

		&__modal-btn-text {
			font-size: 28rpx;
			font-weight: 600;
			color: #FFFFFF;
		}
	}
</style>