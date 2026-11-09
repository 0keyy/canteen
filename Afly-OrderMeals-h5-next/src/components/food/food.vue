<template>
  <div class="food">
    <div class="food-content">
      <div class="image-header">
        <img :src="'http://qiniu.89kj.top'+food.image">
        <button type="button" class="back" aria-label="返回菜单" @click="$emit('close')">
          <i class="icon-arrow_lift"></i>
        </button>
      </div>
      <div class="content">
        <h1 class="title">{{food.title}}</h1>
        <!-- <div class="detail">
          <span class="sell-count">月售{{food.sellCount}}份</span>
          <span class="rating">好评率{{food.rating}}%</span>
        </div> -->
        <div class="price">
          <span class="now">￥{{food.price}}</span>
        </div>
        <div class="cart-control-wrapper">
          <CartControl
            :food="food"
            :disabled="disabled"
            @add="$emit('add', $event)"
            @decrease="$emit('decrease')"
          />
        </div>
        <transition name="fade">
          <button
            v-show="!food.count"
            type="button"
            class="buy"
            :disabled="disabled"
            @click="$emit('add', $event.currentTarget.getBoundingClientRect())"
          >加入购物车</button>
        </transition>
      </div>
      <split v-show="food.intro"></split>
      <div class="info" v-show="food.intro">
        <h1 class="title">商品信息</h1>
        <p class="text">{{food.intro}}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import CartControl from 'components/cart-control/cart-control.vue'
import Split from 'components/split/split.vue'

defineProps({
  food: { type: Object, required: true },
  disabled: Boolean
})
defineEmits(['close', 'add', 'decrease'])
</script>

<style lang="sass" scoped>
  @use "common/stylus/variable" as *
  @use "common/stylus/mixin" as *

  .food
    position: fixed
    left: 0
    top: 0
    bottom: 48px
    z-index: 30
    width: 100%
    overflow-y: auto
    background: $color-white
    &.move-enter-active, &.move-leave-active
      transition: all 0.3s linear
    &.move-enter-from, &.move-leave-to
      transform: translate3d(100%, 0, 0)
    .image-header
      position: relative
      width: 100%
      height: 0
      padding-top: 100%
      img
        position: absolute
        top: 0
        left: 0
        width: 100%
        height: 100%
      .back
        position: absolute
        top: 10px
        left: 0
        padding: 0
        border: 0
        background: none
        .icon-arrow_lift
          display: block
          padding: 10px
          font-size: $fontsize-large-xx
          color: $color-white

    .content
      position: relative
      padding: 18px
      .title
        line-height: 14px
        margin-bottom: 8px
        font-size: $fontsize-medium
        font-weight: 700
        color: $color-dark-grey
      .detail
        margin-bottom: 18px
        line-height: 10px
        height: 10px
        .sell-count, .rating
          font-size: $fontsize-small-s
          color: $color-light-grey
        .sell-count
          margin-right: 12px
      .price
        line-height: 24px
        font-weight: 700
        .now
          margin-right: 8px
          font-size: 14px
          color: $color-red
        .old
          text-decoration: line-through
          font-size: $fontsize-small-s
          color: $color-light-grey
      .cart-control-wrapper
        position: absolute
        right: 12px
        bottom: 12px
      .buy
        position: absolute
        right: 18px
        bottom: 18px
        z-index: 10
        height: 24px
        line-height: 24px
        padding: 0 12px
        box-sizing: border-box
        border-radius: 12px
        font-size: $fontsize-small-s
        color: $color-white
        background: $color-blue
        border: 0
        opacity: 1
        &.fade-enter-active, &.fade-leave-active
          transition: all 0.3s
        &.fade-enter-from, &.fade-leave-to
          opacity: 0
          z-index: -1
    .info
      padding: 18px
      .title
        line-height: 14px
        margin-bottom: 6px
        font-size: $fontsize-medium
        color: $color-dark-grey
      .text
        line-height: 24px
        padding: 0 8px
        font-size: $fontsize-small
        color: $color-grey
    .rating
      padding-top: 18px
      .title
        line-height: 14px
        margin-left: 18px
        font-size: $fontsize-medium
        color: $color-dark-grey
      .rating-wrapper
        padding: 0 18px
        .rating-item
          position: relative
          padding: 16px 0
          &:last-child
            @include border-none()
          .user
            position: absolute
            right: 0
            top: 16px
            display: flex
            align-items: center
            line-height: 12px
            .name
              margin-right: 6px
              font-size: $fontsize-small-s
              color: $color-light-grey
            .avatar
              border-radius: 50%
          .time
            margin-bottom: 6px
            line-height: 12px
            font-size: $fontsize-small-s
            color: $color-light-grey
          .text
            line-height: 16px
            font-size: $fontsize-small
            color: $color-dark-grey
            .icon-thumb_up, .icon-thumb_down
              margin-right: 4px
              line-height: 16px
              font-size: $fontsize-small
            .icon-thumb_up
              color: $color-blue
            .icon-thumb_down
              color: $color-light-grey

        .no-rating
          padding: 16px 0
          font-size: $fontsize-small
          color: $color-light-grey
</style>
