# 确认订单页去重 + 样式对齐 UI 图方案

## 问题
确认订单页面出现两个"确认订单"标题：
- 原生导航栏（pages.json 配置的 `navigationBarTitleText`）
- 自定义导航栏（confirm.vue 模板里的 `checkout__title`）

两个导航栏叠加，导致视觉上有两个标题。

## UI 图对照
UI 图顶部：左侧返回箭头 `<` + 中间"唐"字 logo + 右侧微信胶囊按钮
→ 应该使用**自定义导航栏**，隐藏原生导航栏。

## 修改文件
1. `pages.json` — 给 confirm 页加 `navigationStyle: "custom"` 隐藏原生导航栏
2. `pages/cart/confirm.vue` — 自定义导航栏中间标题换成 logo，调整样式

## 具体改动

### 1. pages.json
给 `pages/cart/confirm` 的 style 加 `"navigationStyle": "custom"`
→ 这是配置文件，不是 JS，不影响功能逻辑

### 2. confirm.vue 模板
- 中间 `checkout__title` 从文字"确认订单"改为图片 logo（"唐"字）
- 保留左侧返回按钮，功能不变
- 右侧 `nav-empty` 占位保留

使用现有项目里的 logo 图片（如果没有就先放文字占位，等用户提供）

### 3. confirm.vue 样式
- 自定义导航栏高度适配（加上状态栏高度）
- logo 尺寸调整
- 整体风格与 UI 图一致

## 保留内容
- 返回按钮功能（goBack）不变
- 所有 JS 逻辑不动
- 页面其他区域（地址、餐品、支付、底部栏）不动

## 风险
- `navigationStyle: "custom"` 是微信小程序标准配置，无兼容风险
- 只改配置和 CSS，不碰业务逻辑
