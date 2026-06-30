<template>
  <view v-if="innerVisible" class="page-loading">
    <view class="page-loading__inner">
      <view class="page-loading__runner">
        <image
          class="page-loading__runner-img"
          src="/static/走路小唐.png"
          mode="aspectFit"
        />
      </view>
      <view class="page-loading__track">
        <view class="page-loading__progress" :style="{ width: progress + '%' }"></view>
      </view>
      <text class="page-loading__text">{{ displayTip }}</text>
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
      default: '加载中...'
    }
  },
  data() {
    return {
      innerVisible: false,
      progress: 0,
      timer: null,
      showTime: 0,
      hideTimer: null,
      globalVisible: false,
      globalTip: '加载中...'
    }
  },
  computed: {
    displayTip() {
      return this.globalVisible ? this.globalTip : this.tip
    }
  },
  watch: {
    visible(val) {
      if (val) {
        this.doShow()
      } else if (!this.globalVisible) {
        this.tryHide()
      }
    }
  },
  created() {
    uni.$on('__global_loading_show__', (tip) => {
      this.globalTip = tip || '加载中...'
      this.globalVisible = true
      this.doShow()
    })
    uni.$on('__global_loading_hide__', () => {
      this.globalVisible = false
      if (!this.visible) {
        this.tryHide()
      }
    })
  },
  beforeDestroy() {
    uni.$off('__global_loading_show__')
    uni.$off('__global_loading_hide__')
  },
  methods: {
    doShow() {
      if (this.hideTimer) {
        clearTimeout(this.hideTimer)
        this.hideTimer = null
      }
      this.showTime = Date.now()
      this.innerVisible = true
      this.progress = 0
      this.startProgress()
    },
    tryHide() {
      const elapsed = Date.now() - this.showTime
      const remaining = MIN_DURATION - elapsed
      if (remaining > 0) {
        this.hideTimer = setTimeout(() => {
          this.doHide()
        }, remaining)
      } else {
        this.doHide()
      }
    },
    doHide() {
      this.progress = 80
      this.stopProgress()
      setTimeout(() => {
        this.innerVisible = false
      }, 100)
    },
    startProgress() {
      if (this.timer) clearInterval(this.timer)
      this.timer = setInterval(() => {
        if (this.progress < 85) {
          const step = Math.random() * 8 + 2
          this.progress = Math.min(this.progress + step, 85)
        }
      }, 150)
    },
    stopProgress() {
      if (this.timer) {
        clearInterval(this.timer)
        this.timer = null
      }
    }
  },
  beforeUnmount() {
    this.stopProgress()
    if (this.hideTimer) {
      clearTimeout(this.hideTimer)
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
  background: #FFFCF8;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;

  &__inner {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 80%;
  }

  &__runner {
    width: 200rpx;
    height: 200rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: bounce 0.6s ease-in-out infinite;
  }

  &__runner-img {
    width: 160rpx;
    height: 160rpx;
  }

  &__track {
    width: 100%;
    max-width: 480rpx;
    height: 12rpx;
    background: rgba(196, 30, 58, 0.1);
    border-radius: 999rpx;
    overflow: hidden;
    margin-top: 20rpx;
  }

  &__progress {
    height: 100%;
    background: linear-gradient(90deg, #FF6B5B 0%, #C41E3A 100%);
    border-radius: 999rpx;
    transition: width 0.2s ease;
  }

  &__text {
    margin-top: 24rpx;
    font-size: 26rpx;
    color: #999999;
  }
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20rpx);
  }
}
</style>
