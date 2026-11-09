# 多商户SaaS版扫码点餐系统（移动H5端）

### 介绍
（H5端）多商户SaaS版扫码点餐系统，支持后台点餐、多人同时在线点餐、购物车共享、餐桌状态实时监控，菜品管理、餐桌管理等众多功能。

| 项目  | 仓库地址 |
|-----|------------------------------------------------|
| 后端  | https://gitee.com/ah-f/Afly-OrderMeals-backend |
| 前端  | https://gitee.com/ah-f/Afly-OrderMeals-front   |
| H5端 | https://gitee.com/ah-f/Afly-OrderMeals-h5      |

 **更多项目介绍文档：** [项目介绍文档](https://gitee.com/ah-f/Afly-OrderMeals-backend)


### 本地开发

```bash
npm ci
npm run dev
```

H5 使用 Vue 3 和 Vite。打开 `http://localhost:8080/?id=1&did=1`，其中 `id` 是店铺 ID，`did` 是桌台 ID。无扫码参数时，开发环境读取 `.env.development` 中的默认值。可在 `.env.local` 中设置 `VITE_H5_BACKEND_URL`，让 Vite 将 `/api/fr` 和 `/clientSocket` 转发到实际后端。

`npm run build` 生成 `dist`。部署时请在 H5 站点同源转发 `/api/fr/` 和 `/clientSocket/`，并为后者启用 WebSocket Upgrade。
