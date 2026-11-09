<template>
  <div class="goods">
    <div class="scroll-nav-wrapper">
      <nav class="category-nav" aria-label="菜品分类">
        <button
          v-for="(group, index) in goods"
          :key="group.name"
          type="button"
          class="category-button"
          :class="{ active: index === activeCategory }"
          :aria-current="index === activeCategory ? 'true' : undefined"
          @click="scrollToCategory(index)"
        >
          <span class="text">
            {{ group.name }}
            <Bubble v-if="categoryCounts[index]" class="num" :num="categoryCounts[index]" />
          </span>
        </button>
      </nav>
      <div ref="menu" class="category-panels" @scroll.passive="updateActiveCategory">
        <section v-for="group in goods" :key="group.name" class="category-panel">
          <h2 class="category-title">{{ group.name }}</h2>
          <ul>
            <li v-for="food in group.foods" :key="food.id" class="food-item" @click="selectedFood = food">
              <div class="icon">
                <img width="57" height="57" :src="'http://qiniu.89kj.top' + food.image" alt="">
              </div>
              <div class="content">
                <h2 class="name">{{ food.title }}</h2>
                <div class="price"><span class="now">￥{{ food.price }}</span></div>
                <div class="cart-control-wrapper">
                  <CartControl
                    :food="food"
                    :disabled="disabled"
                    @add="changeQuantity(food, 1, $event)"
                    @decrease="changeQuantity(food, -1)"
                  />
                </div>
              </div>
            </li>
          </ul>
        </section>
      </div>
    </div>

    <Transition name="move">
      <Food
        v-if="selectedFood"
        :food="selectedFood"
        :disabled="disabled"
        @close="selectedFood = null"
        @add="changeQuantity(selectedFood, 1, $event)"
        @decrease="changeQuantity(selectedFood, -1)"
      />
    </Transition>

    <div class="shop-cart-wrapper">
      <ShopCart
        ref="shopCart"
        :foods="selectedFoods"
        :min-price="Number(seller.minPrice) || 0"
        :disabled="disabled"
        @add="changeQuantity"
        @decrease="changeQuantity($event, -1)"
        @empty="emptyCart"
        @submit="submitOrder"
      />
    </div>

    <OrderDialog v-if="submitted" key="submitted" title="下单成功">
      <p>商家正在努力备菜中</p>
      <template #actions><button type="button" @click="reload">继续点餐</button></template>
    </OrderDialog>
    <OrderDialog v-else-if="error" key="error" title="提示">
      <p>{{ error }}</p>
      <template #actions><button type="button" @click="error = ''">确定</button></template>
    </OrderDialog>
  </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { dishAdd, dishDec, dishDel, dishInc, submit, toEmpty } from 'api'
import { sendTableMessage } from '../../socket'
import Bubble from 'components/bubble/bubble.vue'
import CartControl from 'components/cart-control/cart-control.vue'
import Food from 'components/food/food.vue'
import OrderDialog from 'components/order-dialog/order-dialog.vue'
import ShopCart from 'components/shop-cart/shop-cart.vue'

const props = defineProps({
  catalog: { type: Array, required: true },
  order: Object,
  seller: { type: Object, required: true },
  socket: WebSocket
})

const goods = ref(props.catalog.map((group) => ({
  ...group,
  foods: group.foods.map((food) => ({ ...food, count: 0, odid: null }))
})))
const allFoods = computed(() => goods.value.flatMap((group) => group.foods))
const selectedFoods = computed(() => allFoods.value.filter((food) => food.count > 0))
const categoryCounts = computed(() => goods.value.map((group) =>
  group.foods.reduce((count, food) => count + food.count, 0)
))
const activeCategory = ref(0)
const menu = ref(null)
const selectedFood = ref(null)
const shopCart = ref(null)
const pending = ref(false)
const submitted = ref(false)
const error = ref('')
const disabled = computed(() => !props.order?.oid || pending.value || submitted.value)

watch(() => props.order, (order) => {
  const cart = new Map((order?.dish || []).map((item) => [String(item.dishId), item]))
  for (const food of allFoods.value) {
    const item = cart.get(String(food.id))
    food.count = Number(item?.count) || 0
    food.odid = item?.id ?? null
  }
}, { immediate: true })

watch(() => props.socket, (socket, _previous, onCleanup) => {
  if (!socket) return
  socket.addEventListener('message', receiveMessage)
  onCleanup(() => socket.removeEventListener('message', receiveMessage))
}, { immediate: true })

function receiveMessage(event) {
  let message
  try {
    message = JSON.parse(event.data)
  } catch {
    return
  }
  if (message?.type === 'sub') {
    submitted.value = true
    return
  }
  if (message?.dishId == null || message.count == null) return

  const food = allFoods.value.find((item) => String(item.id) === String(message.dishId))
  if (food) {
    food.count = Number(message.count) || 0
    food.odid = food.count ? message.id : null
  }
}

function scrollToCategory(index) {
  activeCategory.value = index
  menu.value.scrollTop = menu.value.children[index].offsetTop
}

function updateActiveCategory() {
  const { children, scrollTop, scrollHeight, clientHeight } = menu.value
  if (scrollTop > 0 && scrollTop + clientHeight >= scrollHeight - 1) {
    activeCategory.value = children.length - 1
    return
  }
  for (let index = children.length - 1; index >= 0; index--) {
    if (children[index].offsetTop <= scrollTop + 1) {
      activeCategory.value = index
      break
    }
  }
}

async function updateCart(action) {
  if (disabled.value) return
  pending.value = true
  try {
    await action()
  } catch (cause) {
    error.value = cause.message || '请求失败，请重试'
  } finally {
    pending.value = false
  }
}

function setQuantity(food, count, id) {
  food.count = count
  food.odid = count ? id : null
  sendTableMessage(props.socket, { id, dishId: food.id, count, type: '' })
}

function changeQuantity(food, difference, origin) {
  return updateCart(async () => {
    const count = food.count + difference
    let id = food.odid
    if (food.count === 0 && difference > 0) {
      id = await dishAdd({ dishId: food.id, orderId: props.order.oid })
    } else if (difference > 0) {
      await dishInc({ id })
    } else if (count > 0) {
      await dishDec({ id })
    } else {
      await dishDel({ id })
    }
    setQuantity(food, count, id)
    if (origin) shopCart.value?.drop(origin)
  })
}

function emptyCart() {
  return updateCart(async () => {
    await toEmpty({ id: props.order.oid })
    for (const food of selectedFoods.value) {
      setQuantity(food, 0, food.odid)
    }
  })
}

function submitOrder(remark) {
  return updateCart(async () => {
    await submit({ number: props.order.oid, remark })
    submitted.value = true
    sendTableMessage(props.socket, { type: 'sub' })
  })
}

function reload() {
  location.reload()
}
</script>

<style lang="sass" scoped>
  @use "common/stylus/mixin" as *
  @use "common/stylus/variable" as *
  .goods
    position: relative
    text-align: left
    height: 100%
    .scroll-nav-wrapper
      position: absolute
      display: flex
      width: 100%
      top: 0
      left: 0
      bottom: 48px
    .category-nav
      flex: 0 0 80px
      overflow-y: auto
      background: $color-background-ssss
    .category-panels
      position: relative
      flex: 1
      min-width: 0
      overflow-y: auto
    .category-button
      width: 100%
      border: 0
      text-align: left
      padding: 0 10px
      display: flex
      align-items: center
      height: 56px
      line-height: 14px
      font-size: $fontsize-small
      background: $color-background-ssss
      .text
        flex: 1
        position: relative
      .num
        position: absolute
        right: -8px
        top: -10px
    .category-button.active
      background: $color-white
      color: $color-dark-grey
    .category-title
      padding-left: 14px
      height: 26px
      line-height: 26px
      border-left: 2px solid $color-col-line
      font-size: $fontsize-small
      color: $color-grey
      background: $color-background-ssss
    .food-item
      display: flex
      margin: 18px
      padding-bottom: 18px
      position: relative
      &:last-child
        @include border-none()
        margin-bottom: 0
      .icon
        flex: 0 0 57px
        margin-right: 10px
      .content
        flex: 1
        .name
          margin: 2px 0 8px 0
          height: 14px
          line-height: 14px
          font-size: $fontsize-medium
          color: $color-dark-grey
        .desc, .extra
          line-height: 10px
          font-size: $fontsize-small-s
          color: $color-light-grey
        .desc
          line-height: 12px
          margin-bottom: 8px
        .extra
          .count
            margin-right: 12px
        .price
          font-weight: 700
          line-height: 24px
          .now
            margin-right: 8px
            font-size: $fontsize-medium
            color: $color-red
          .old
            text-decoration: line-through
            font-size: $fontsize-small-s
            color: $color-light-grey
      .cart-control-wrapper
        position: absolute
        right: 0
        bottom: 12px
    .shop-cart-wrapper
      position: absolute
      left: 0
      bottom: 0
      z-index: 50
      width: 100%
      height: 48px
</style>
