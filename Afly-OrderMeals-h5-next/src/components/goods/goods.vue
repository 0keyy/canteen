<template>
  <div class="goods">
    <div class="scroll-nav-wrapper">
      <cube-scroll-nav :side=true :data="goods" :options="scrollOptions" v-if="goods.length">
        <template slot="bar" slot-scope="props">
          <cube-scroll-nav-bar direction="vertical" :labels="props.labels" :txts="barTxts" :current="props.current">
            <template slot-scope="props">
              <div class="text">
                <!-- <support-ico
                  v-if="props.txt.type>=1"
                  :size=3
                  :type="props.txt.type"
                ></support-ico> -->
                <span>{{ props.txt.name }}</span>
                <span class="num" v-if="props.txt.count">
                  <bubble :num="props.txt.count"></bubble>
                </span>
              </div>
            </template>
          </cube-scroll-nav-bar>
        </template>
        <cube-scroll-nav-panel v-for="good in goods" :key="good.name" :label="good.name" :title="good.name">
          <ul>
            <li @click="selectFood(food)" v-for="food in good.foods" :key="food.name" class="food-item">
              <div class="icon">
                <img width="57" height="57" :src="'http://qiniu.89kj.top' + food.image">
              </div>
              <div class="content">
                <h2 class="name">{{ food.title }}</h2>
                <!-- <p class="desc">{{food.description}}</p> -->
                <!-- <div class="extra">
                  <span class="count">月售{{food.sellCount}}份</span><span>好评率{{food.rating}}%</span>
                </div> -->
                <div class="price">
                  <span class="now">￥{{ food.price }}</span>
                  <!-- <span class="old" v-show="food.oldPrice">￥{{food.oldPrice}}</span> -->
                </div>
                <div class="cart-control-wrapper">
                  <cart-control @add="onAdd" :oid="oid" :food="food"></cart-control>
                </div>
              </div>
            </li>
          </ul>
        </cube-scroll-nav-panel>
      </cube-scroll-nav>
    </div>
    <div class="shop-cart-wrapper">
      <shop-cart ref="shopCart" :select-foods="selectFoods" :delivery-price="seller.deliveryPrice"
        :min-price="seller.minPrice"></shop-cart>
    </div>
  </div>
</template>

<script>
import { getGoods } from 'api'
import CartControl from 'components/cart-control/cart-control'
import ShopCart from 'components/shop-cart/shop-cart'
import Food from 'components/food/food'
import SupportIco from 'components/support-ico/support-ico'
import Bubble from 'components/bubble/bubble'
import { socketClient } from '../../socket'

export default {
  name: 'goods',
  props: {
    data: {
      type: Object,
      default() {
        return {}
      }
    }
  },
  data() {
    return {
      oid: '',
      goods: [],
      selectedFood: {},
      scrollOptions: {
        click: false,
        directionLockThreshold: 0
      }
    }
  },
  computed: {
    seller() {
      return this.data.seller
    },
    selectFoods() {
      let foods = []
      this.goods.forEach((good) => {
        good.foods.forEach((food) => {
          if (food.count) {
            foods.push(food)
          }
        })
      })
      return foods
    },
    barTxts() {
      let ret = []
      this.goods.forEach((good) => {
        const { type, name, foods } = good
        let count = 0
        foods.forEach((food) => {
          count += food.count || 0
        })
        ret.push({
          type,
          name,
          count
        })
      })
      return ret
    }
  },
  created() {
    this.onMessage() // 开启消息监听（依赖 App 中 socketClient.init；无桌号参数时无连接，需跳过）
  },
  methods: {
    onMessage() {
      const sock = socketClient.socket
      if (!(sock instanceof WebSocket)) {
        return
      }
      sock.onmessage = (message) => {
        console.log('收到消息2' + message.data)
        const msg = JSON.parse(message.data)
        if (msg.type === 'sub') {
          this.$createDialog({
                type: 'alert',
                title: '下单成功',
                content: '商家正在努力备菜中',
                icon: 'cubeic-alert',
                confirmBtn: {
                  text: '继续点餐',
                  active: true,
                  disabled: false,
                  href: 'javascript:;'
                },
                $events: {
                  confirm: () => {
                    location.reload()
                  }
                }
              }).show()
              return
        }
        this.goods.forEach((good) => {
          good.foods.forEach((food) => {
              if (food.id == msg.dishId) {
                this.$set(food, 'count', msg.count)
                this.$set(food, 'odid', msg.id)
              }
          })
        })
      }
    },
    fetch(res) {
      let foods = res.dish || []
      console.log(this.data)
      this.oid = res.oid || res
      if (!this.fetched) {
        this.fetched = true
        getGoods({
          aid: this.data.seller.id
        }).then((goods) => {
          this.goods = goods
          this.goods.forEach((good) => {
            good.foods.forEach((food) => {
              foods.forEach((i) => {
                if (food.id == i.dishId) {
                  this.$set(food, 'count', i.count)
                  this.$set(food, 'odid', i.id)
                }
              })
            })
          })
        })
      }
    },
    selectFood(food) {
      this.selectedFood = food
      this._showFood()
      this._showShopCartSticky()
    },
    onAdd(target) {
      this.$refs.shopCart.drop(target)
    },
    _showFood() {
      this.foodComp = this.foodComp || this.$createFood({
        $props: {
          food: 'selectedFood'
        },
        $events: {
          add: (target) => {
            this.shopCartStickyComp.drop(target)
          },
          leave: () => {
            this._hideShopCartSticky()
          }
        }
      })
      this.foodComp.show()
    },
    _showShopCartSticky() {
      this.shopCartStickyComp = this.shopCartStickyComp || this.$createShopCartSticky({
        $props: {
          selectFoods: 'selectFoods',
          deliveryPrice: this.seller.deliveryPrice,
          minPrice: this.seller.minPrice,
          fold: true
        }
      })
      this.shopCartStickyComp.show()
    },
    _hideShopCartSticky() {
      this.shopCartStickyComp.hide()
    }
  },
  components: {
    Bubble,
    SupportIco,
    CartControl,
    ShopCart,
    Food
  }
}
</script>

<style lang="stylus" scoped>
  @import "~common/stylus/mixin"
  @import "~common/stylus/variable"
  .goods
    position: relative
    text-align: left
    height: 100%
    .scroll-nav-wrapper
      position: absolute
      width: 100%
      top: 0
      left: 0
      bottom: 48px
    >>> .cube-scroll-nav-bar
      width: 80px
      white-space: normal
      overflow: hidden
    >>> .cube-scroll-nav-bar-item
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
      .support-ico
        display: inline-block
        vertical-align: top
        margin-right: 4px
    >>> .cube-scroll-nav-bar-item_active
      background: $color-white
      color: $color-dark-grey
    >>> .cube-scroll-nav-panel-title
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
        border-none()
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
