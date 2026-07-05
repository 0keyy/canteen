# 修复：提交订单后无法再添加商品到购物车

## 问题分析

### 根本原因

`cartHas` 接口在不同订单状态下返回**不同的字段名**：

| 场景 | 订单ID字段 | 菜品列表字段 | 菜品数量字段 |
|------|-----------|------------|------------|
| 未提交的购物车 | `oid` | `dish` | `count` |
| 已提交的订单 | `id` | `dishes` | `quantity` |

用户提交订单后，`cartHas` 返回已提交订单（用 `id`/`dishes`/`quantity`），但前端代码只读取 `oid`/`dish`/`count`。

### 具体故障链

1. 用户提交订单 → 后端订单状态变为 `status=4`（已完成）
2. 用户返回菜单页 → `bootstrap()` 调用 `initOrder()`
3. `initOrder()` 第 368 行：`if (has?.oid && ...)` → `has.oid` 是 `undefined`（后端返回的是 `has.id`），条件为 false
4. 第 372 行：`if (has?.oid)` → 同样 false
5. 走到 `cartCreate` → 后端可能返回已有订单的 ID（即已提交的订单），不是新购物车
6. `this.orderId` = 已提交订单的 ID
7. 用户点添加商品 → `dishAdd(orderId, dishId)` → 后端返回"购物车不可用"（已提交订单不能加菜）
8. 同时 `syncCart()` 第 417 行 `has?.oid` 也是 undefined，`cartMap` 被清空，购物车显示为空

### 之前的修复为何失败

我之前把 `has.oid` 全部改成 `has.id`、`has.dish` 改成 `has.dishes`。但这破坏了正常情况——未提交购物车时后端返回的是 `oid` 不是 `id`，导致正常加购也失败。

## 修复方案

核心思路：**同时兼容两种返回格式**，并判断订单是否已提交，已提交的订单不复用，重新创建购物车。

### 修改文件：`pages/menu/index.vue`

#### 1. `initOrder()` 方法

```javascript
async initOrder() {
  const has = await orderApi.cartHas(this.aid)
  // 兼容两种字段名：未提交购物车用 oid，已提交订单用 id
  const existingId = has?.oid ? Number(has.oid) : (has?.id ? Number(has.id) : null)
  const existingMode = has?.diningMode !== undefined ? Number(has.diningMode) : null
  // 判断订单是否已提交：有 submitTime 或 status > 0
  const isSubmitted = !!(has?.submitTime || (has?.status !== undefined && Number(has.status) > 0))
  
  if (existingId && existingMode === this.diningMode && !isSubmitted) {
    // 未提交的同模式购物车，直接复用
    this.orderId = existingId
    return
  }
  // 已提交或模式不同，需要创建新购物车
  const orderId = await orderApi.cartCreate({
    aid: this.aid,
    diningMode: this.diningMode,
    deskId: this.diningMode === 1 ? 1 : 0,
    userNum: 1,
    source: 2
  })
  this.orderId = Number(orderId)
  if (!this.orderId) {
    throw new Error('购物车创建失败')
  }
}
```

**关键变更：**
- `existingId` 同时读取 `has.oid` 和 `has.id`
- 新增 `isSubmitted` 判断：有 `submitTime` 或 `status > 0` 的订单不复用
- 已提交的订单直接走 `cartCreate` 创建新购物车
- 去掉 `toEmpty` 调用：已提交的订单不应该被清空（它是历史订单），只有模式不同的未提交购物车才需要清空

#### 2. `syncCart()` 方法

```javascript
async syncCart() {
  if (!this.orderId) {
    this.setCartMap({})
    return
  }
  const has = await orderApi.cartHas(this.aid)
  // 兼容两种字段名
  const hasId = has?.oid ? Number(has.oid) : (has?.id ? Number(has.id) : null)
  if (!hasId || hasId !== this.orderId) {
    this.setCartMap({})
    return
  }
  // 兼容两种菜品列表字段名：未提交用 dish，已提交用 dishes
  const items = has.dish || has.dishes || []
  const map = {}
  items.forEach((item) => {
    const dishId = Number(item.dishId)
    const food = this.findFood(dishId)
    const key = this.dishKey(dishId)
    // 兼容两种数量字段：未提交用 count，已提交用 quantity
    const count = Number(item.count || item.quantity) || 0
    const existing = map[key]
    if (existing) {
      existing.count += count
      return
    }
    map[key] = {
      odid: Number(item.id),
      dishId,
      count,
      price: food?.price || 0
    }
  })
  this.setCartMap(map)
}
```

**关键变更：**
- `hasId` 同时读取 `has.oid` 和 `has.id`
- `items` 同时读取 `has.dish` 和 `has.dishes`
- `count` 同时读取 `item.count` 和 `item.quantity`

### 不需要修改的文件

- `api/index.js` — 接口定义不变
- `utils/request.js` — 请求封装不变
- `pages/cart/confirm.vue` — 确认订单页逻辑不变

## 验证步骤

1. 首次进入菜单页 → 加载动画正常 → 可添加商品到购物车
2. 结算提交订单 → 支付成功
3. 返回菜单页 → 加载动画正常 → 能重新添加商品（不再提示"购物车不可用"）
4. 购物车商品数量和价格显示正确
5. 切换堂食/外卖模式正常
