<template>
  <Transition name="fade">
    <div v-if="open" class="cart-overlay" @click.self="$emit('close')">
      <section class="cart-list" aria-label="购物车">
        <div class="list-header">
          <h2 class="title">购物车</h2>
          <button type="button" class="empty" :disabled="disabled" @click="$emit('empty')">清空</button>
        </div>
        <div class="list-content">
          <ul>
            <li v-for="food in foods" :key="food.id" class="food">
              <span class="name">{{ food.title }}</span>
              <div class="price">￥{{ food.price * food.count }}</div>
              <div class="cart-control-wrapper">
                <CartControl
                  :food="food"
                  :disabled="disabled"
                  @add="$emit('add', food, 1, $event)"
                  @decrease="$emit('decrease', food)"
                />
              </div>
            </li>
          </ul>
        </div>
      </section>
    </div>
  </Transition>
</template>

<script setup>
import CartControl from 'components/cart-control/cart-control.vue'

defineProps({
  open: Boolean,
  foods: { type: Array, required: true },
  disabled: Boolean
})
defineEmits(['add', 'decrease', 'empty', 'close'])
</script>

<style lang="sass" scoped>
  @use "common/stylus/variable" as *
  .cart-overlay
    position: fixed
    inset: 0 0 48px
    background: rgba(7, 17, 27, .6)
    &.fade-enter-active, &.fade-leave-active
      transition: opacity .3s ease-in-out
      .cart-list
        transition: transform .3s ease-in-out
    &.fade-enter-from, &.fade-leave-to
      opacity: 0
      .cart-list
        transform: translateY(100%)
  .cart-list
    position: absolute
    inset: auto 0 0
    .list-header
      height: 40px
      line-height: 40px
      padding: 0 18px
      background: $color-background-ssss
      .title
        float: left
        font-size: $fontsize-medium
        color: $color-dark-grey
      .empty
        float: right
        border: 0
        background: none
        line-height: inherit
        font-size: $fontsize-small
        color: $color-blue

    .list-content
      padding: 0 18px
      max-height: 217px
      overflow-y: auto
      background: $color-white
      .food
        position: relative
        padding: 12px 0
        box-sizing: border-box
        .name
          line-height: 24px
          font-size: $fontsize-medium
          color: $color-dark-grey
        .price
          position: absolute
          right: 90px
          bottom: 12px
          line-height: 24px
          font-weight: 700
          font-size: $fontsize-medium
          color: $color-red
        .cart-control-wrapper
          position: absolute
          right: 0
          bottom: 6px

</style>
