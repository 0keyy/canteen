<template>
  <div class="cartcontrol" @click.stop>
    <Transition name="move">
      <button
        v-show="food.count > 0"
        type="button"
        class="cart-decrease"
        aria-label="减少菜品"
        :disabled="disabled"
        @click="$emit('decrease')"
      >
        <span class="inner icon-remove_circle_outline"></span>
      </button>
    </Transition>
    <div v-show="food.count > 0" class="cart-count">{{ food.count }}</div>
    <button
      type="button"
      class="cart-add icon-add_circle"
      aria-label="添加菜品"
      :disabled="disabled"
      @click="$emit('add', $event.currentTarget.getBoundingClientRect())"
    ></button>
  </div>
</template>

<script setup>
defineProps({
  food: { type: Object, required: true },
  disabled: Boolean
})
defineEmits(['add', 'decrease'])
</script>

<style lang="sass" scoped>
  @use "common/stylus/variable" as *

  .cartcontrol
    display: flex
    align-items: center
    button
      border: 0
      background: none
      padding: 6px
    .cart-decrease
      display: inline-block
      padding: 6px
      opacity: 1
      .inner
        display: inline-block
        line-height: 24px
        font-size: $fontsize-large-xxx
        color: $color-blue
        transition: all 0.4s linear
        transform: rotate(0)
      &.move-enter-active, &.move-leave-active
        transition: all 0.4s linear
      &.move-enter-from, &.move-leave-to
        opacity: 0
        transform: translate3d(24px, 0, 0)
        .inner
          transform: rotate(180deg)
    .cart-count
      width: 12px
      line-height: 24px
      text-align: center
      font-size: $fontsize-small-s
      color: $color-grey
    .cart-add
      display: inline-block
      padding: 6px
      line-height: 24px
      font-size: $fontsize-large-xxx
      color: $color-blue
</style>
