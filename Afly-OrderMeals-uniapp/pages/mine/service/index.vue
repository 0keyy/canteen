<template>
  <view class="service-page">
    <!-- 聊天区域 -->
    <scroll-view
      class="service-page__chat"
      scroll-y
      :show-scrollbar="false"
      :scroll-top="scrollTop"
      @scroll="onScroll"
    >
      <view class="service-page__chat-inner" id="chat-inner">
        <!-- 时间标签 -->
        <view class="service-page__time">
          <text>{{ currentTime }}</text>
        </view>

        <!-- 消息列表 -->
        <view
          v-for="(msg, index) in messageList"
          :key="msg.id || index"
          class="service-page__msg-wrap"
          :class="msg.sender === 'user' ? 'service-page__msg-wrap--right' : 'service-page__msg-wrap--left'"
        >
          <!-- 客服消息 -->
          <template v-if="msg.sender === 'service'">
            <text class="service-page__sender-name">粮兴坊客服</text>
            <view v-if="msg.type === 'guess'" class="service-page__guess-card service-page__guess-card--left">
              <view class="service-page__card-arrow"></view>
              <view class="service-page__guess-title">猜你想问</view>
              <view
                v-for="(item, idx) in msg.guessList"
                :key="idx"
                class="service-page__guess-item"
                @tap="onQuestionTap(item)"
              >
                <text class="service-page__guess-index">{{ idx + 1 }}.</text>
                <text class="service-page__guess-text">{{ item }}</text>
              </view>
            </view>
            <view v-else class="service-page__bubble service-page__bubble--white">
              <view class="service-page__bubble-arrow"></view>
              <text v-if="msg.type === 'text'" class="service-page__bubble-text">{{ msg.content }}</text>
              <image
                v-else-if="msg.type === 'image'"
                class="service-page__bubble-image"
                :src="msg.content"
                mode="aspectFit"
                @tap="previewImage(msg.content)"
              />
            </view>
          </template>

          <!-- 用户消息 -->
          <template v-else>
            <view class="service-page__bubble service-page__bubble--green">
              <text v-if="msg.type === 'text'" class="service-page__bubble-text">{{ msg.content }}</text>
              <image
                v-else-if="msg.type === 'image'"
                class="service-page__bubble-image"
                :src="msg.content"
                mode="aspectFit"
                @tap="previewImage(msg.content)"
              />
            </view>
          </template>
        </view>
      </view>
    </scroll-view>

    <!-- 底部输入区域 -->
    <view class="service-page__input-bar">
      <view class="service-page__input-wrap">
        <input
          class="service-page__input"
          :value="inputText"
          placeholder="请描述您的问题"
          placeholder-class="service-page__input-placeholder"
          confirm-type="send"
          @input="onInput"
          @confirm="onSend"
        />
      </view>
      <view class="service-page__input-btn" @tap="onVoiceTap">
        <image :src="staticImgPrefix + '/tabbar/语音 1.png'" mode="aspectFit" class="service-page__input-icon"></image>
      </view>
      <view class="service-page__input-btn" @tap="onMoreTap">
        <image :src="staticImgPrefix + '/tabbar/增加添加加号 1.png'" mode="aspectFit" class="service-page__input-icon"></image>
      </view>
    </view>
  </view>
</template>

<script>
import { STATIC_IMAGE_PREFIX } from '../../../utils/image'
import { chatApi } from '../../../api/index'

function formatChatTime() {
  const now = new Date()
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  return '今天 ' + hours + ':' + minutes
}

function genId() {
  return Date.now() + '_' + Math.floor(Math.random() * 1000)
}

export default {
  data() {
    return {
      staticImgPrefix: STATIC_IMAGE_PREFIX,
      inputText: '',
      currentTime: formatChatTime(),
      messageList: [],
      scrollTop: 0,
      chatInnerHeight: 0,
      // WebSocket 实例（预留）
      ws: null,
      // 轮询定时器（预留）
      pollTimer: null,
      // 是否连接中
      isConnected: false
    }
  },
  onLoad() {
    this.initChat()
  },
  onUnload() {
    this.disconnect()
  },
  methods: {
    // ========== 初始化聊天 ==========
    async initChat() {
      // 1. 加载历史消息（预留接口）
      // await this.loadHistory()

      // 2. 显示欢迎消息 + 猜你想问
      this.showWelcomeMessage()

      // 3. 建立 WebSocket 连接（预留）
      // this.connectWebSocket()

      // 4. 启动轮询（预留，作为 WebSocket 降级方案）
      // this.startPolling()
    },

    // 显示欢迎消息（mock 数据）
    showWelcomeMessage() {
      this.messageList.push({
        id: genId(),
        sender: 'service',
        type: 'text',
        content: '您好，我是粮兴坊客服，请问有什么可以帮您？',
        time: Date.now(),
        showName: true
      })
      this.messageList.push({
        id: genId(),
        sender: 'service',
        type: 'guess',
        guessList: [
          '修改订单信息/备注信息',
          '取消订单/退款',
          '会员注册',
          '少餐/错修',
          '如何查找门店联系方式'
        ],
        time: Date.now(),
        showName: false
      })
      this.scrollToBottom()
    },

    // ========== 加载历史记录（预留接口）==========
    async loadHistory() {
      try {
        const res = await chatApi.history({ page: 1, pageSize: 20 })
        const list = Array.isArray(res) ? res : (res.list || res.data || [])
        if (list.length > 0) {
          this.messageList = list.map(item => ({
            id: item.id || genId(),
            sender: item.senderType === 1 ? 'user' : 'service',
            type: item.msgType || 'text',
            content: item.content,
            time: item.createTime || Date.now(),
            showName: item.senderType !== 1
          }))
          this.scrollToBottom()
        }
      } catch (e) {
        console.log('[chat] 加载历史记录失败:', e)
      }
    },

    // ========== 发送消息 ==========
    onSend() {
      const content = this.inputText.trim()
      if (!content) return

      // 1. 本地添加用户消息
      const userMsg = {
        id: genId(),
        sender: 'user',
        type: 'text',
        content: content,
        time: Date.now()
      }
      this.messageList.push(userMsg)
      this.inputText = ''
      this.scrollToBottom()

      // 2. 调用发送接口（预留）
      // this.sendToServer(userMsg)

      // 3. 模拟客服回复（mock，后期删除）
      this.mockServiceReply(content)
    },

    // 发送消息到服务器（预留）
    async sendToServer(msg) {
      try {
        await chatApi.send({
          content: msg.content,
          type: msg.type,
          // extra: {} // 扩展字段
        })
      } catch (e) {
        console.log('[chat] 发送失败:', e)
        uni.showToast({ title: '发送失败，请重试', icon: 'none' })
      }
    },

    // 模拟客服回复（mock 数据，后期对接后端后删除）
    mockServiceReply(userContent) {
      setTimeout(() => {
        const replies = [
          '收到您的问题，请稍等，正在为您查询...',
          '好的，已记录您的问题，客服会尽快处理。',
          '关于您的问题，可以拨打我们的服务热线：400-xxx-xxxx',
          '您可以在"我的订单"中查看订单详情并申请退款。',
          '请问还有其他可以帮助您的吗？'
        ]
        const randomReply = replies[Math.floor(Math.random() * replies.length)]
        this.messageList.push({
          id: genId(),
          sender: 'service',
          type: 'text',
          content: randomReply,
          time: Date.now(),
          showName: true
        })
        this.scrollToBottom()
      }, 1000)
    },

    // ========== 接收消息（预留 WebSocket/polling 回调）==========
    onReceiveMessage(msgData) {
      // msgData 结构：{ id, senderType, msgType, content, createTime }
      this.messageList.push({
        id: msgData.id || genId(),
        sender: msgData.senderType === 1 ? 'user' : 'service',
        type: msgData.msgType || 'text',
        content: msgData.content,
        time: msgData.createTime || Date.now(),
        showName: msgData.senderType !== 1
      })
      this.scrollToBottom()
    },

    // ========== WebSocket 连接（预留）==========
    connectWebSocket() {
      // const token = uni.getStorageSync('token')
      // this.ws = uni.connectSocket({
      //   url: 'wss://backend.zhongtang-group.com/ws/chat?token=' + token,
      //   success: () => {
      //     console.log('[chat] WebSocket 连接成功')
      //     this.isConnected = true
      //   }
      // })
      // this.ws.onMessage((res) => {
      //   const msg = JSON.parse(res.data)
      //   this.onReceiveMessage(msg)
      // })
      // this.ws.onClose(() => {
      //   this.isConnected = false
      //   // 自动重连
      //   setTimeout(() => this.connectWebSocket(), 3000)
      // })
    },

    // ========== 轮询获取消息（预留降级方案）==========
    startPolling() {
      // this.pollTimer = setInterval(async () => {
      //   try {
      //     const res = await chatApi.history({ page: 1, pageSize: 10 })
      //     // 处理新消息...
      //   } catch (e) {}
      // }, 5000)
    },

    // ========== 断开连接 ==========
    disconnect() {
      // if (this.ws) {
      //   this.ws.close()
      //   this.ws = null
      // }
      // if (this.pollTimer) {
      //   clearInterval(this.pollTimer)
      //   this.pollTimer = null
      // }
      // this.isConnected = false
    },

    // ========== 界面交互 ==========
    onInput(e) {
      this.inputText = e.detail.value
    },

    onQuestionTap(question) {
      // 将问题作为用户消息发送
      this.inputText = question
      this.onSend()
    },

    scrollToBottom() {
      this.$nextTick(() => {
        const query = uni.createSelectorQuery().in(this)
        query.select('#chat-inner').boundingClientRect((rect) => {
          if (rect) {
            this.scrollTop = rect.height + 100
          }
        }).exec()
      })
    },

    onScroll() {
      // 可以在这里做滚动监听，比如显示"有新消息"提示
    },

    previewImage(url) {
      uni.previewImage({ urls: [url] })
    },

    onVoiceTap() {
      uni.showToast({ title: '语音功能开发中', icon: 'none' })
      // 预留：调用 chatApi.upload 上传语音文件
    },

    onMoreTap() {
      uni.showToast({ title: '更多功能开发中', icon: 'none' })
      // 预留：图片选择 -> chatApi.upload
    }
  }
}
</script>

<style lang="scss" scoped>
.service-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  background: #e0e0e0;

  /* ===== 聊天区域 ===== */
  &__chat {
    flex: 1;
    overflow: hidden;

    &-inner {
      padding: 24rpx;
    }
  }

  /* 时间标签 */
  &__time {
    display: flex;
    justify-content: center;
    margin-bottom: 32rpx;

    text {
      font-size: 22rpx;
      color: #fff;
      background: #959595;
      padding: 6rpx 16rpx;
      border-radius: 24rpx;
    }
  }

  /* 消息行 */
  &__msg-wrap {
    display: flex;
    flex-direction: column;
    margin-bottom: 24rpx;

    &--left {
      align-items: flex-start;
    }

    &--right {
      align-items: flex-end;
    }
  }

  &__sender-name {
    font-size: 22rpx;
    color: #999999;
    margin-bottom: 8rpx;
  }

  /* 消息气泡 */
  &__bubble {
    position: relative;
    padding: 20rpx 24rpx;
    border-radius: 16rpx;
    max-width: 75%;

    &--white {
      background: #ffffff;
    }

    &--green {
      background: #95ec69;
    }
  }

  &__bubble-arrow {
    position: absolute;
    left: -12rpx;
    top: 20rpx;
    width: 0;
    height: 0;
    border-top: 12rpx solid transparent;
    border-bottom: 12rpx solid transparent;
    border-right: 14rpx solid #ffffff;
  }

  &__bubble-text {
    font-size: 24rpx;
    color: #333333;
    line-height: 1.5;
    word-break: break-all;
  }

  &__bubble-image {
    max-width: 300rpx;
    max-height: 300rpx;
    border-radius: 12rpx;
    display: block;
  }

  /* 猜你想问卡片 */
  &__guess-card {
    position: relative;
    width: 90%;
    background: #ffffff;
    border-radius: 24rpx;
    padding: 28rpx;

    &--left {
      align-self: flex-start;
    }
  }

  &__card-arrow {
    position: absolute;
    left: -12rpx;
    top: 20rpx;
    width: 0;
    height: 0;
    border-top: 12rpx solid transparent;
    border-bottom: 12rpx solid transparent;
    border-right: 14rpx solid #ffffff;
  }

  &__guess-title {
    font-size: 30rpx;
    font-weight: 600;
    color: #333333;
    margin-bottom: 16rpx;
  }

  &__guess-item {
    display: flex;
    align-items: center;
    padding: 14rpx 0;

    &:active {
      opacity: 0.7;
    }
  }

  &__guess-index {
    font-size: 28rpx;
    color: #666666;
    margin-right: 8rpx;
  }

  &__guess-text {
    font-size: 28rpx;
    color: #333333;
  }

  /* 猜你想问（旧的气泡内样式，保留兼容） */
  &__guess-in-msg {
    .service-page__guess-title {
      font-size: 30rpx;
      font-weight: 600;
      color: #333333;
      margin-bottom: 16rpx;
    }

    .service-page__guess-item {
      display: flex;
      align-items: center;
      padding: 14rpx 0;
	  width: 800rpx;

      &:active {
        opacity: 0.7;
      }
    }

    .service-page__guess-index {
      font-size: 28rpx;
      color: #666666;
      margin-right: 8rpx;
    }

    .service-page__guess-text {
      font-size: 28rpx;
      color: #333333;
    }
  }

  /* ===== 底部输入栏 ===== */
  &__input-bar {
    display: flex;
    align-items: center;
    padding: 20rpx 24rpx;
    padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
    background: #ffffff;
    border-top: 1rpx solid #eeeeee;
    flex-shrink: 0;
  }

  &__input-wrap {
    flex: 1;
    height: 72rpx;
    background: #e0e0e0;
    border-radius: 36rpx;
    display: flex;
    align-items: center;
    padding: 0 24rpx;
  }

  &__input {
    flex: 1;
    height: 72rpx;
    font-size: 28rpx;
    color: #333333;
  }

  &__input-placeholder {
    font-size: 28rpx;
    color: #999999;
  }

  &__input-btn {
    width: 64rpx;
    height: 64rpx;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-left: 16rpx;

    &:active {
      opacity: 0.7;
    }
  }

  &__input-icon {
    width: 44rpx;
    height: 44rpx;
    display: block;
  }
}
</style>