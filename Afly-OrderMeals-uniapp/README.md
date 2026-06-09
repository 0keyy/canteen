# Afly-OrderMeals-uniapp

点餐 UniApp 客户端，支持编译为微信小程序、支付宝小程序、App。

## 后端依赖

需先启动 `like-admin` 服务（默认端口 `8082`），并执行数据库迁移：

```bash
mysql -u like_admin -p like_admin < ../Afly-OrderMeals-backend-master/sql/migration_uniapp.sql
```

## 开发

```bash
npm install
npm run dev:mp-weixin
```

## 配置

- API 地址：[`utils/config.js`](utils/config.js)
- 微信小程序 AppID：[`manifest.json`](manifest.json) → `mp-weixin.appid`
- 默认店铺 ID：`utils/config.js` → `DEFAULT_SHOP_ID`

## 平台登录说明

| 平台 | 登录方式 |
|------|----------|
| 微信小程序 | `wx.login` + `getPhoneNumber` |
| 支付宝小程序 | `my.getAuthCode` + 手机号授权 |
| App | 短信验证码登录 |

## 支付说明

开发环境默认走 mock 支付（`/api/front/pay/mock/success`），生产环境需配置微信/支付宝商户参数。
