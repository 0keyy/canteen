<template>
  <main class="ordering">
    <VHeader :seller="seller" />
    <div class="desk-label border-bottom-1px">当前桌号：{{ desk?.name }}</div>
    <Goods
      v-if="catalog"
      class="menu"
      :seller="seller"
      :catalog="catalog"
      :order="order"
      :socket="socket"
    />

    <OrderDialog v-if="error" key="error" title="提示">
      <p>{{ error }}</p>
      <template #actions>
        <button type="button" @click="error = ''">确定</button>
      </template>
    </OrderDialog>
    <OrderDialog v-else-if="desk && !order" key="people" title="请选择就餐人数">
      <form class="people" @submit.prevent="openOrder">
        <select v-model="people" aria-label="就餐人数">
          <option v-for="number in desk.num" :key="number" :value="number">
            {{ number }} 人
          </option>
        </select>
        <button type="submit" :disabled="opening || !desk.num">确定</button>
      </form>
    </OrderDialog>
  </main>
</template>

<script setup>
import { onMounted, onUnmounted, ref, shallowRef } from 'vue'
import { createOrders, getDesk, getGoods, getSeller, hasCurrentOrders } from './api'
import { connectTable } from './socket'
import Goods from 'components/goods/goods.vue'
import OrderDialog from 'components/order-dialog/order-dialog.vue'
import VHeader from 'components/v-header/v-header.vue'

const query = new URLSearchParams(location.search)
const local = import.meta.env.DEV || /^(localhost|127\.0\.0\.1|\[::1\]|192\.168\.\d{1,3}\.\d{1,3})$/.test(location.hostname)
const id = query.get('id') || (local ? import.meta.env.VITE_H5_SHOP_ID || '1' : '')
const did = query.get('did') || (local ? import.meta.env.VITE_H5_DESK_ID || '1' : '')

const seller = ref({ id })
const desk = ref(null)
const catalog = shallowRef(null)
const order = shallowRef(null)
const socket = shallowRef(null)
const people = ref(1)
const opening = ref(false)
const error = ref('')

function showError(cause) {
  error.value = cause.message || '加载失败，请检查后端连接'
}

onMounted(async () => {
  if (!id || !did) {
    error.value = '缺少店铺或桌号，请重新扫描桌台二维码。'
    return
  }

  socket.value = connectTable(did)
  getSeller({ id })
    .then((data) => { seller.value = { id, ...data } })
    .catch(showError)

  try {
    const [table, goods] = await Promise.all([getDesk({ did }), getGoods({ aid: id })])
    order.value = await hasCurrentOrders({ did })
    catalog.value = goods
    desk.value = { ...table, num: Number(table.num) || 0 }
  } catch (cause) {
    showError(cause)
  }
})

onUnmounted(() => socket.value?.close())

async function openOrder() {
  if (opening.value) return

  opening.value = true
  try {
    const oid = await createOrders({
      aid: id,
      deskId: desk.value.id,
      userNum: people.value,
      type: 1
    })
    // create 也会返回同桌用户刚创建的订单。
    order.value = await hasCurrentOrders({ did }) || { oid, dish: [] }
  } catch (cause) {
    showError(cause)
  } finally {
    opening.value = false
  }
}
</script>

<style scoped>
.ordering {
  display: flex;
  flex-direction: column;
  height: 100%;
}
.desk-label {
  padding: 10px 0;
  text-align: center;
}
.menu {
  flex: 1;
  min-height: 0;
}
.people {
  display: flex;
  justify-content: space-between;
  gap: 12px;
}
.people select {
  flex: 1;
}
</style>
