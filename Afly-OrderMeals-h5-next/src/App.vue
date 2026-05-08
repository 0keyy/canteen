<template>
  <div id="app" @touchmove.prevent>
    <v-header :seller="seller"></v-header>
    <div class="tab-wrapper">
      <tab ref="tab" :tabs="tabs"></tab>
    </div>
  </div>
</template>

<script>
  import qs from 'query-string'
  import { getSeller } from 'api'
  import VHeader from 'components/v-header/v-header'
  import Goods from 'components/goods/goods'
  import Tab from 'components/tab/tab'
import { createOrders, getDesk, hasCurrentOrders } from './api'
import { socketClient } from './socket'

  /**
   * 解析店铺 id、桌台 did。
   * .env.development 只在 npm run serve 时生效；build 后在 localhost 打开时 NODE_ENV 仍是 production，
   * 因此用「本机访问」判断，在无参数时回落到环境变量或默认 1，避免一直弹「缺少参数」。
   */
  function getShopDeskIds() {
    const q = qs.parse(location.search || '')
    const envShop = process.env.VUE_APP_H5_SHOP_ID
    const envDesk = process.env.VUE_APP_H5_DESK_ID
    const defaultShop =
      envShop != null && String(envShop).trim() !== '' ? String(envShop) : '1'
    const defaultDesk =
      envDesk != null && String(envDesk).trim() !== '' ? String(envDesk) : '1'

    const hostname =
      typeof location !== 'undefined' ? location.hostname : ''
    const isLocalAccess =
      process.env.NODE_ENV === 'development' ||
      hostname === 'localhost' ||
      hostname === '127.0.0.1' ||
      hostname === '[::1]' ||
      hostname === '::1' ||
      /^192\.168\.\d{1,3}\.\d{1,3}$/.test(hostname)

    return {
      id: q.id || (isLocalAccess ? defaultShop : ''),
      did: q.did || (isLocalAccess ? defaultDesk : '')
    }
  }

  export default {
    data() {
      const { id, did } = getShopDeskIds()
      return {
        seller: {
          id
        },
        did,
        desk: {
          name: ''
        }
      }
    },
    computed: {
      tabs() {
        return [
          {
            label: '当前桌号：' + this.desk.name,
            component: Goods,
            data: {
              seller: this.seller
            }
          }
        ]
      },
      arr() {
        const arr = []
        for (var i = 1; i <= this.desk.num; i++) {
          const obj = {}
          obj.content = i.toString()
          arr.push(obj)
        }
        return arr
      }
    },
    created() {
      if (!this.seller.id || !this.did) {
        this.showAlert(
          '缺少店铺 id 与桌号 did。请在地址后加参数，例如：?id=1&did=2。本地开发也可在 .env.development 里配置 VUE_APP_H5_SHOP_ID、VUE_APP_H5_DESK_ID。'
        )
        return
      }
      this._getSeller()
      this.getDesk()
      this.initSocket()
    },
    methods: {
      initSocket() {
        socketClient.init(this.did)
      },
      showAlert(msg) {
        const text =
          typeof msg === 'string'
            ? msg
            : (msg && msg.message) ||
              '加载失败，请检查本机后端是否已启动（默认 8082）及网络'
        this.$createDialog({
          type: 'alert',
          title: '提示',
          content: text,
          icon: 'cubeic-alert',
          $events: {
            confirm: () => {}
          }
        }).show()
      },
      _getSeller() {
        getSeller({
          id: this.seller.id
        }).then((seller) => {
          this.seller = Object.assign({}, this.seller, seller)
        }).catch((e) => {
          this.showAlert(e)
        })
      },
      getDesk() {
        getDesk({
          did: this.did
        }).then((res) => {
          this.desk = res
          this.hasCurrOrders()
        }).catch((e) => {
          this.showAlert(e)
        })
      },
      hasCurrOrders() {
        hasCurrentOrders({ did: this.did })
          .then((res) => {
            if (res == null) {
              this.showPickerStyle()
            } else {
              this.$refs.tab.onChange(res)
              sessionStorage.setItem('oid', res.oid)
            }
          })
          .catch((e) => this.showAlert(e))
      },
      showPickerStyle() { // 人数选择
      this.$createActionSheet({
        title: '请选择就餐人数',
        maskClosable: false,
        cancelTxt: '-',
        pickerStyle: true,
        data: this.arr,
        $events: {
          select: (item, index) => {
            createOrders({
              aid: this.seller.id,
              deskId: this.desk.id,
              userNum: item.content,
              type: 1
            })
              .then((res) => {
                sessionStorage.setItem('oid', res)
                this.$refs.tab.onChange(res)
              })
              .catch((e) => this.showAlert(e))
          console.log(item, index)
          },
          cancel: () => {
            console.log(123)
          }
        }
      }).show()
    }
    },
    components: {
      Tab,
      VHeader
    }
  }
</script>

<style lang="stylus" scoped>
  #app
    .tab-wrapper
      position: fixed
      top: 136px
      left: 0
      right: 0
      bottom: 0
</style>
