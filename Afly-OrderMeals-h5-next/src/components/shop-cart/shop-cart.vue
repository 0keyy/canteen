<template>
  <div class="cart">
    <ShopCartList
      :open="listOpen"
      :foods="foods"
      :disabled="disabled"
      @add="(...args) => $emit('add', ...args)"
      @decrease="$emit('decrease', $event)"
      @empty="confirmation = 'empty'"
      @close="listOpen = false"
    />
    <div class="shopcart">
      <div class="content">
        <button type="button" class="content-left" aria-label="查看购物车" :aria-expanded="listOpen" @click="toggleList">
          <div class="logo-wrapper">
            <div class="logo" :class="{ highlight: totalCount > 0 }">
              <i class="icon-shopping_cart" :class="{ highlight: totalCount > 0 }"></i>
            </div>
            <div v-if="totalCount > 0" class="num"><Bubble :num="totalCount" /></div>
          </div>
          <div class="price" :class="{ highlight: totalPrice > 0 }">￥{{ totalPrice }}</div>
        </button>
        <button
          type="button"
          class="pay"
          :class="{ enough: canOrder }"
          :disabled="disabled || !canOrder"
          @click="confirmation = 'submit'"
        >
          {{ totalCount > 0 ? '下单' : '请添加菜品' }}
        </button>
      </div>
      <div class="ball-container" aria-hidden="true">
        <TransitionGroup :css="false" @enter="animateDrop" @after-enter="removeBall">
          <div
            v-for="ball in balls"
            :key="ball.id"
            class="ball"
            :data-id="ball.id"
            :data-x="ball.x"
            :data-y="ball.y"
          ><div class="inner"></div></div>
        </TransitionGroup>
      </div>
    </div>

    <OrderDialog v-if="confirmation === 'submit'" title="确定下单？">
      <form id="order-confirm" @submit.prevent="confirmOrder">
        <p>当前订单金额为{{ totalPrice }}元</p>
        <input v-model="remark" placeholder="订单备注（选填）" aria-label="订单备注">
      </form>
      <template #actions>
        <button type="button" @click="confirmation = ''">取消</button>
        <button type="submit" form="order-confirm" :disabled="disabled || !canOrder">确定</button>
      </template>
    </OrderDialog>
    <OrderDialog v-else-if="confirmation === 'empty'" title="清空购物车？">
      <template #actions>
        <button type="button" @click="confirmation = ''">取消</button>
        <button type="button" :disabled="disabled" @click="confirmEmpty">确定</button>
      </template>
    </OrderDialog>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import Bubble from 'components/bubble/bubble.vue'
import OrderDialog from 'components/order-dialog/order-dialog.vue'
import ShopCartList from 'components/shop-cart-list/shop-cart-list.vue'

const props = defineProps({
  foods: { type: Array, required: true },
  minPrice: { type: Number, default: 0 },
  disabled: Boolean
})
const emit = defineEmits(['add', 'decrease', 'empty', 'submit'])

const totalCount = computed(() => props.foods.reduce((total, food) => total + food.count, 0))
const totalPrice = computed(() => props.foods.reduce((total, food) => total + food.price * food.count, 0))
const canOrder = computed(() => totalCount.value > 0 && totalPrice.value >= props.minPrice)
const listOpen = ref(false)
const confirmation = ref('')
const remark = ref('')
const balls = ref([])
let nextBallId = 0

watch(totalCount, (count) => {
  if (!count) listOpen.value = false
})

function toggleList() {
  if (totalCount.value > 0) listOpen.value = !listOpen.value
}

function confirmEmpty() {
  confirmation.value = ''
  emit('empty')
}

function confirmOrder() {
  if (props.disabled || !canOrder.value) return
  confirmation.value = ''
  emit('submit', remark.value)
}

function drop(rect) {
  balls.value.push({ id: nextBallId++, x: rect.left - 32, y: rect.top - window.innerHeight + 22 })
}

function animateDrop(element, done) {
  const { x, y } = element.dataset
  element.firstElementChild.animate(
    [{ transform: `translateX(${x}px)` }, { transform: 'translateX(0)' }],
    { duration: 400, easing: 'linear' }
  )
  const animation = element.animate(
    [{ transform: `translateY(${y}px)` }, { transform: 'translateY(0)' }],
    { duration: 400, easing: 'cubic-bezier(0.49, -0.29, 0.75, 0.41)' }
  )
  animation.finished.then(done, done)
}

function removeBall(element) {
  balls.value = balls.value.filter((ball) => ball.id !== Number(element.dataset.id))
}

defineExpose({ drop })
</script>

<style lang="sass" scoped>
  @use "common/stylus/variable" as *

  .cart, .shopcart
    height: 100%
  .shopcart
    position: relative
    .content
      display: flex
      background: $color-background
      font-size: 0
      color: $color-light-grey
      .content-left
        flex: 1
        height: 48px
        padding: 0
        border: 0
        background: none
        color: inherit
        font-size: 0
        text-align: left
        .logo-wrapper
          display: inline-block
          vertical-align: top
          position: relative
          top: -10px
          margin: 0 12px
          padding: 6px
          width: 56px
          height: 56px
          box-sizing: border-box
          border-radius: 50%
          background: $color-background
          .logo
            width: 100%
            height: 100%
            border-radius: 50%
            text-align: center
            background: $color-dark-grey
            &.highlight
              background: $color-blue
            .icon-shopping_cart
              line-height: 44px
              font-size: $fontsize-large-xxx
              color: $color-light-grey
              &.highlight
                color: $color-white
          .num
            position: absolute
            top: 0
            right: 0
        .price
          display: inline-block
          vertical-align: top
          margin-top: 12px
          line-height: 24px
          padding-right: 12px
          box-sizing: border-box
          border-right: 1px solid rgba(255, 255, 255, 0.1)
          font-weight: 700
          font-size: $fontsize-large
          &.highlight
            color: $color-white
        .desc
          display: inline-block
          vertical-align: top
          margin: 12px 0 0 12px
          line-height: 24px
          font-size: $fontsize-small-s
      .pay
        flex: 0 0 105px
        height: 48px
        padding: 0
        border: 0
        background: $color-dark-grey
        color: inherit
        font-weight: 700
        font-size: $fontsize-small
        &.enough
          background: $color-green
          color: $color-white
    .ball-container
      .ball
        position: fixed
        left: 32px
        bottom: 22px
        z-index: 200
        pointer-events: none
        .inner
          width: 16px
          height: 16px
          border-radius: 50%
          background: $color-blue
</style>
