<template>
  <div class="cartcontrol">
    <transition name="move">
      <div class="cart-decrease" v-show="food.count > 0" @click.stop="decrease">
        <span class="inner icon-remove_circle_outline"></span>
      </div>
    </transition>
    <div class="cart-count" v-show="food.count > 0">{{ food.count }}</div>
    <div class="cart-add icon-add_circle" @click.stop="add"></div>
  </div>
</template>

<script>
import { dishAdd, dishDec, dishDel, dishInc } from '../../api'
import { socketClient } from '../../socket'

const EVENT_ADD = 'add'

export default {
  name: 'cart-control',
  data() {
    return {
      orderDishId: '',
      msg: {
        id: '',
        dishId: '',
        count: '',
        type: ''
      }
    }
  },
  props: {
    food: {
      type: Object
    },
    oid: {
      type: Number
    }
  },
  methods: {
    add(event) {
      if (!this.food.count) {
        this.$set(this.food, 'count', 1)
        console.log(this.oid)
        dishAdd({ dishId: this.food.id, orderId: this.oid }).then((res) => {
          this.orderDishId = res
          this.msg.id = res
          this.msg.dishId = this.food.id
          this.msg.count = 1
          socketClient.socket.send(JSON.stringify(this.msg))
        })
      } else {
        this.food.count++
        dishInc({ id: this.orderDishId || this.food.odid }).then(() => {
          this.msg.id = this.orderDishId || this.food.odid
          this.msg.dishId = this.food.id
          this.msg.count = this.food.count
          socketClient.socket.send(JSON.stringify(this.msg))
        })
      }
      this.$emit(EVENT_ADD, event.target)
    },
    decrease() {
      if (this.food.count > 1) {
        this.food.count--
        dishDec({ id: this.orderDishId || this.food.odid }).then(() => {
          this.msg.id = this.orderDishId || this.food.odid
          this.msg.dishId = this.food.id
          this.msg.count = this.food.count
          socketClient.socket.send(JSON.stringify(this.msg))
        })
      } else {
        this.food.count--
        dishDel({ id: this.orderDishId || this.food.odid }).then(() => {
          this.msg.id = this.orderDishId || this.food.odid
          this.msg.dishId = this.food.id
          this.msg.count = this.food.count
          socketClient.socket.send(JSON.stringify(this.msg))
        })
      }
    }
  }
}
</script>

<style lang="stylus" scoped>
  @import "~common/stylus/variable"

  .cartcontrol
    display: flex
    align-items: center
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
      &.move-enter, &.move-leave-active
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
