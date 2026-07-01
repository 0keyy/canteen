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

<script>
const MIN_DURATION = 300

export default {
  name: 'PageLoading',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    tip: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      showContent: false,
      progress: 0,
      startTime: 0,
      progressTimer: null,
      localTip: ''
    }
  },
  watch: {
    visible(val) {
      if (val) {
        this.doShow()
      } else {
        this.doHide()
      }
    },
    tip(val) {
      this.localTip = val
    }
  },
  mounted() {
    this.localTip = this.tip
    uni.$on('__global_loading_show__', this.onGlobalShow)
    uni.$on('__global_loading_hide__', this.onGlobalHide)
  },
  beforeUnmount() {
    uni.$off('__global_loading_show__', this.onGlobalShow)
    uni.$off('__global_loading_hide__', this.onGlobalHide)
    this.clearTimers()
  },
  methods: {
    doShow() {
      this.showContent = true
      this.progress = 0
      this.startTime = Date.now()
      this.startProgress()
    },
    doHide() {
      const elapsed = Date.now() - this.startTime
      const remaining = MIN_DURATION - elapsed
      if (remaining > 0) {
        setTimeout(() => {
          this.finishProgress()
        }, remaining)
      } else {
        this.finishProgress()
      }
    },
    startProgress() {
      this.clearTimers()
      let p = 0
      this.progressTimer = setInterval(() => {
        p += Math.random() * 15 + 5
        if (p >= 90) {
          p = 90
          clearInterval(this.progressTimer)
          this.progressTimer = null
        }
        this.progress = Math.min(p, 90)
      }, 200)
    },
    finishProgress() {
      this.clearTimers()
      this.progress = 100
      setTimeout(() => {
        this.showContent = false
        this.progress = 0
      }, 150)
    },
    clearTimers() {
      if (this.progressTimer) {
        clearInterval(this.progressTimer)
        this.progressTimer = null
      }
    },
    onGlobalShow(tip) {
      if (tip) this.localTip = tip
      this.doShow()
    },
    onGlobalHide() {
      this.doHide()
    }
  }
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
