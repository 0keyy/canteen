<template>
  <view v-if="showContent" class="page-loading" @tap.stop.prevent="() => {}">
    <view class="page-loading__content">
      <image class="page-loading__icon" src="/static/新版小唐.png" mode="aspectFit" />
      <view class="page-loading__bar">
        <view class="page-loading__bar-fill" :style="{ width: progress + '%' }"></view>
      </view>
      <text class="page-loading__tip" v-if="localTip">{{ localTip }}</text>
    </view>
  </view>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref, watch } from 'vue'
const MIN_DURATION = 300

defineOptions({ name: 'PageLoading' })

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  tip: {
    type: String,
    default: ''
  }
})

const showContent = ref(false)
const progress = ref(0)
const startTime = ref(0)
const progressTimer = ref(null)
const localTip = ref('')

onMounted(() => {
  localTip.value = props.tip
  uni.$on('__global_loading_show__', onGlobalShow)
  uni.$on('__global_loading_hide__', onGlobalHide)
})

onBeforeUnmount(() => {
  uni.$off('__global_loading_show__', onGlobalShow)
  uni.$off('__global_loading_hide__', onGlobalHide)
  clearTimers()
})

watch(() => props.visible, (val) => {
  if (val) {
    doShow()
  } else {
    doHide()
  }
})

watch(() => props.tip, (val) => {
  localTip.value = val
})

function doShow() {
  showContent.value = true
  progress.value = 0
  startTime.value = Date.now()
  startProgress()
}

function doHide() {
  const elapsed = Date.now() - startTime.value
  const remaining = MIN_DURATION - elapsed
  if (remaining > 0) {
    setTimeout(() => {
      finishProgress()
    }, remaining)
  } else {
    finishProgress()
  }
}

function startProgress() {
  clearTimers()
  let p = 0
  progressTimer.value = setInterval(() => {
    p += Math.random() * 15 + 5
    if (p >= 90) {
      p = 90
      clearInterval(progressTimer.value)
      progressTimer.value = null
    }
    progress.value = Math.min(p, 90)
  }, 200)
}

function finishProgress() {
  clearTimers()
  progress.value = 100
  setTimeout(() => {
    showContent.value = false
    progress.value = 0
  }, 150)
}

function clearTimers() {
  if (progressTimer.value) {
    clearInterval(progressTimer.value)
    progressTimer.value = null
  }
}

function onGlobalShow(tip) {
  if (tip) localTip.value = tip
  doShow()
}

function onGlobalHide() {
  doHide()
}
</script>

<style lang="scss" scoped>
.page-loading {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  background: #FAF5EE;
  display: flex;
  align-items: center;
  justify-content: center;

  &__content {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  &__icon {
    width: 160rpx;
    height: 160rpx;
    margin-bottom: 32rpx;
  }

  &__bar {
    width: 320rpx;
    height: 16rpx;
    background: #F0E6D8;
    border-radius: 999rpx;
    overflow: hidden;
  }

  &__bar-fill {
    height: 100%;
    background: linear-gradient(90deg, #D44047, #B7272D);
    border-radius: 999rpx;
    transition: width 0.3s ease;
  }

  &__tip {
    margin-top: 20rpx;
    font-size: 24rpx;
    color: #999999;
  }
}
</style>
