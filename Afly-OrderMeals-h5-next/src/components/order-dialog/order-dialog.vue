<template>
  <dialog ref="dialog" class="order-dialog" @cancel.prevent>
    <h2>{{ title }}</h2>
    <slot />
    <div class="actions"><slot name="actions" /></div>
  </dialog>
</template>

<script setup>
import { onMounted, ref } from 'vue'

defineProps({ title: { type: String, required: true } })

const dialog = ref(null)
onMounted(() => dialog.value.showModal())
</script>

<style scoped>
.order-dialog {
  box-sizing: border-box;
  width: min(88vw, 380px);
  padding: 20px;
  border: 0;
  border-radius: 8px;
  color: #333;
}
.order-dialog::backdrop {
  background: rgba(7, 17, 27, .6);
}
h2 {
  margin: 0 0 12px;
  font-size: 16px;
}
.actions {
  display: flex;
  justify-content: flex-end;
  gap: 8px;
  margin-top: 16px;
}
</style>
