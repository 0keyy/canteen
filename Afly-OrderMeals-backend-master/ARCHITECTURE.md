# 🏗️ 后端架构索引 — 四端服务速查

> **一眼看出哪个包服务于哪个客户端**

---

## 架构总览

```
                    ┌──────────────────────────────┐
                    │     Nginx / 网关              │
                    └──────┬───────────┬───────────┘
                           │           │
              /api/front/** │           │ /** (其他所有)
                           ▼           ▼
                ┌─────────────┐  ┌──────────────────┐
                │ AppInterceptor│  │ AdminInterceptor │
                │  (SaToken     │  │  (SaToken        │
                │   UserRealm)  │  │   AdminRealm)    │
                └──────┬──────┘  └───────┬──────────┘
                       │                 │
          ┌────────────▼─────┐   ┌──────▼──────────────────┐
          │   小程序 Miniapp  │   │  后台管理 + H5 + 收银台   │
          │  /api/front/**   │   │  /api/** (非front)       │
          └──────────────────┘   └──────┬──────────────────┘
                                        │
                     ┌──────────────────┼──────────────────┐
                     │                  │                  │
                /api/fr/*        /api/order/*      其他 /api/**
                     │           /api/orders/*          │
                     ▼           /api/internal/*        ▼
               ┌──────────┐  ┌──────────────┐  ┌──────────────┐
               │    H5    │  │    收银台     │  │   后台管理    │
               │ (扫码点餐)│  │  POS/Cashier │  │   Admin Web  │
               └──────────┘  └──────────────┘  └──────────────┘
```

### 认证机制

| 客户端 | URL 前缀 | 拦截器 | ThreadLocal | 认证域 |
|--------|---------|--------|-------------|--------|
| 🟢 小程序 | `/api/front/**` | `LikeAppInterceptor` | `AppThreadLocal.getUserId()` | SaToken `StpUserUtil` |
| 🟡 H5 | `/api/fr/**` | `LikeAdminInterceptor`（无需登录） | 无 | 公开 |
| 🔵 收银台 | `/api/order/**`, `/api/orders/**`, `/api/internal/**` | `LikeAdminInterceptor` | `LikeAdminThreadLocal.getAdminId()` | SaToken `StpUtil` |
| 🔴 后台管理 | 其他 `/api/**` | `LikeAdminInterceptor` | `LikeAdminThreadLocal.getAdminId()` | SaToken `StpUtil` |

---

## 🟢 小程序端 (Miniapp) — `/api/front/**`

### Controllers
| 文件 | URL | 功能 |
|------|-----|------|
| `controller/app/AppAuthController.java` | `/api/front/auth` | 微信/支付宝登录、手机号授权 |
| `controller/app/AppAddressController.java` | `/api/front/address` | 收货地址CRUD |
| `controller/app/AppCompanyAuthController.java` | `/api/front/company` | 公司认证 |
| `controller/app/AppCouponController.java` | `/api/front/coupon` | 领券中心、我的券包、最优券计算、核销码 |
| `controller/app/AppDecorateController.java` | `/api/front/decorate` | 首页/点单页装修数据 |
| `controller/app/AppOrderController.java` | `/api/front/order` | 下单、订单列表/详情、支付 |
| `controller/app/AppPayController.java` | `/api/front/pay` | 微信/支付宝支付、退款 |

### Service Interfaces → `service/app/`
| 文件 | 功能 |
|------|------|
| `IAppAuthService.java` | 登录认证 |
| `IAppAddressService.java` | 地址管理 |
| `IAppCompanyAuthService.java` | 公司认证 |
| `IAppCouponService.java` | 优惠券（领取/券包/最优券/核销码）|
| `IAppOrderService.java` | 订单业务 |
| `IAppPayService.java` | 支付业务 |
| `IAggregatePayService.java` | 聚合支付 |
| `ICreditPayService.java` | 信用/积分支付 |
| `IUserPointsService.java` | 用户积分 |

### Service Implementations → `service/impl/app/`
| 文件 |
|------|
| `AppAuthServiceImpl.java`, `AppAddressServiceImpl.java`, `AppCompanyAuthServiceImpl.java` |
| `AppCouponServiceImpl.java`, `AppOrderServiceImpl.java`, `AppPayServiceImpl.java` |
| `AggregatePayServiceImpl.java`, `CreditPayServiceImpl.java`, `UserPointsServiceImpl.java` |

### Validates → `validate/app/`
```
validate/app/auth/       — 登录校验
validate/app/address/    — 地址校验
validate/app/order/      — 订单校验
validate/app/pay/        — 支付校验
validate/app/company/    — 公司认证校验
```

### VOs → `vo/app/`
```
vo/app/auth/       — 登录相关 VO
vo/app/address/    — 地址 VO
vo/app/order/      — 订单 VO
vo/app/pay/        — 支付 VO
vo/app/company/    — 公司认证 VO
```

---

## 🟡 H5 扫码点餐端 — `/api/fr/**`

> 公开接口，无需登录。用户扫描桌台二维码后访问的 H5 页面。

### Controllers
| 文件 | URL | 功能 |
|------|-----|------|
| `controller/front/FrontController.java` | `/api/fr` | H5 点餐首页数据 |

### Service
| 文件 | 功能 |
|------|------|
| `service/IFrontService.java` | H5 前端数据 |
| `service/impl/FrontServiceImpl.java` | 实现 |

---

## 🔵 收银台端 (Cashier) — `/api/order/**` + `/api/orders/**` + `/api/internal/**`

> POS 收银终端和厨房出餐管理。

### Controllers
| 文件 | URL | 功能 |
|------|-----|------|
| `controller/order/OrderController.java` | `/api/order` | 桌台管理、菜品选择、下单、结账 |
| `controller/orders/OrdersController.java` | `/api/orders` | 订单列表/详情、出餐叫号 |
| `controller/internal/InternalNotifyController.java` | `/api/internal` | Socket 通知推送 |

### Service
| 文件 | 功能 |
|------|------|
| `service/IOrderService.java` | 收银台订单 |
| `service/IOrdersServcice.java` | 订单管理 |
| `service/impl/OrderServiceImpl.java` | 实现 |
| `service/impl/OrdersServiceImpl.java` | 实现 |

### Socket（实时通信）
| 文件 | 功能 |
|------|------|
| `socket/` | WebSocket 实时通知（新订单提醒等） |

---

## 🔴 后台管理端 (Admin Web) — 其他所有 `/api/**`

> Vue3 + Element Plus 管理后台。

### 按功能域分组

#### 优惠券管理
| 文件 | URL |
|------|-----|
| `controller/coupon/CouponController.java` | `/api/coupon` |
| `controller/coupon/CouponRecordController.java` | `/api/coupon/record` |
| `service/ICouponTemplateService.java` + `ICouponVerifyService.java` + `ICouponRecordService.java` | |
| `service/impl/CouponTemplateServiceImpl.java` + `CouponVerifyServiceImpl.java` + `CouponRecordServiceImpl.java` | |
| `validate/coupon/` + `vo/coupon/` | |

#### 菜品/文章管理
| 文件 | URL |
|------|-----|
| `ArticleController.java` | `/api/article` |
| `ArtCateController.java` | `/api/article/cate` |
| `service/IArticleService.java` + `IArtCateService.java` | |
| `vo/article/` | |

#### 店铺配置
| 文件 | URL |
|------|-----|
| `controller/shop/ShopConfigController.java` | `/api/shop` |
| `controller/shop/PrinterController.java` | `/api/printer` |
| `service/IShopConfigService.java` + `IPrinterService.java` | |
| `validate/shop/` + `vo/shop/` | |

#### 页面装修
| 文件 | URL |
|------|-----|
| `controller/decorate/DecorateDataController.java` | `/api/decorate/data` |
| `controller/decorate/DecoratePagesController.java` | `/api/decorate/pages` |
| `controller/decorate/DecorateTabbarController.java` | `/api/decorate/tabbar` |
| `service/IDecorateDataService.java` + `IDecoratePageService.java` + `IDecorateTabbarService.java` | |
| `vo/decorate/` + `validate/` 内相关 | |

#### 渠道管理
| 文件 | URL |
|------|-----|
| `controller/channel/ChannelH5Controller.java` | `/api/channel/h5` |
| `controller/channel/ChannelMpController.java` | `/api/channel/mp` |
| `controller/channel/ChannelOaController.java` | `/api/channel/oa` |
| `controller/channel/ChannelOaMenuController.java` | `/api/channel/oaMenu` |
| `controller/channel/ChannelOaReplyDefaultController.java` | `/api/channel/oaReplyDefault` |
| `controller/channel/ChannelOaReplyFollowController.java` | `/api/channel/oaReplyFollow` |
| `controller/channel/ChannelOaReplyKeywordController.java` | `/api/channel/oaReplyKeyword` |
| `controller/channel/ChannelOpController.java` | `/api/channel/op` |
| `service/IChannel*.java` (8个) + `validate/channel/` + `vo/channel/` | |

#### 公司管理
| 文件 | URL |
|------|-----|
| `controller/company/CompanyManageController.java` | `/api/company` |
| `service/ICompanyManageService.java` + `ICreditManageService.java` | |
| `validate/company/` + `validate/credit/` + `vo/company/` + `vo/credit/` | |

#### 系统管理（用户/角色/权限/菜单/部门/岗位）
| 文件 | URL |
|------|-----|
| `controller/system/SystemLoginController.java` | `/api/system` |
| `controller/system/SystemAuthAdminController.java` | `/api/system/admin` |
| `controller/system/SystemAuthDeptController.java` | `/api/system/dept` |
| `controller/system/SystemAuthMenuController.java` | `/api/system/menu` |
| `controller/system/SystemAuthPostController.java` | `/api/system/post` |
| `controller/system/SystemAuthRoleController.java` | `/api/system/role` |
| `controller/system/SystemLogsController.java` | `/api/system/log` |
| `service/ISystem*.java` (7个) + `validate/system/` + `vo/system/` | |

#### 系统设置
| 文件 | URL |
|------|-----|
| `controller/setting/SettingCopyrightController.java` | `/api/setting/copyright` |
| `controller/setting/SettingDictDataController.java` | `/api/setting/dict/data` |
| `controller/setting/SettingDictTypeController.java` | `/api/setting/dict/type` |
| `controller/setting/SettingLoginController.java` | `/api/setting/login` |
| `controller/setting/SettingNoticeController.java` | `/api/setting/notice` |
| `controller/setting/SettingProtocolController.java` | `/api/setting/protocol` |
| `controller/setting/SettingSearchController.java` | `/api/setting/search` |
| `controller/setting/SettingSmsController.java` | `/api/setting/sms` |
| `controller/setting/SettingStorageController.java` | `/api/setting/storage` |
| `controller/setting/SettingUserController.java` | `/api/setting/user` |
| `controller/setting/SettingWebsiteController.java` | `/api/setting/website` |
| `service/ISetting*.java` (11个) + `validate/setting/` + `vo/setting/` | |

#### 监控
| 文件 | URL |
|------|-----|
| `controller/monitor/MonitorCacheController.java` | `/api/monitor` |
| `controller/monitor/MonitorServerController.java` | `/api/monitor` |

#### 通用/杂项
| 文件 | URL | 备注 |
|------|-----|------|
| `AlbumsController.java` | `/api/albums` | 相册管理 |
| `IndexController.java` | `/api/index` | 首页/控制台 |
| `UploadController.java` | `/api/upload` | 文件上传 |
| `UsersController.java` | `/api/user` | 用户管理 |

---

## 📦 公共模块 `like-common`

> 被所有端共享的实体、Mapper、工具类。

```
com.mdd.common
├── entity/
│   ├── coupon/     — 优惠券实体 (CouponTemplate, UserCoupon, CouponVerifyLog)
│   ├── orders/     — 订单实体 (Orders, OrdersDish)
│   ├── user/       — 用户实体 (User, UserAuth, UserAddress, UserCompany, UserPoints...)
│   ├── system/     — 系统实体 (SystemAuthAdmin, SystemAuthMenu, SystemAuthRole...)
│   ├── article/    — 文章/菜品实体 (Article, ArticleCategory)
│   ├── channel/    — 渠道实体
│   ├── decorate/   — 装修实体
│   └── setting/    — 设置实体
├── mapper/         — MyBatis Mapper 接口（一一对应 entity）
├── core/           — 核心类：AjaxResult, PageResult, IBaseMapper, 全局异常处理
├── config/         — GlobalConfig (tablePrefix="la_")
├── util/           — TimeUtils, StringUtils, UrlUtils
└── validator/      — 通用校验注解 (@IDMust, @IntegerContains)
```

---

## 🎯 快速定位指南

| 我要找... | 去这里 |
|-----------|--------|
| 小程序用户登录/支付/领券 | `controller/app/` + `service/app/` |
| 小程序下单/地址/公司认证 | `controller/app/` + `service/app/` |
| H5扫码点餐 | `controller/front/` |
| 收银台/POS下单 | `controller/order/` + `controller/orders/` |
| 后台优惠券管理 | `controller/coupon/` |
| 后台菜品管理 | `ArticleController` + `ArtCateController` |
| 后台店铺配置 | `controller/shop/` |
| 后台页面装修 | `controller/decorate/` |
| 后台渠道配置 | `controller/channel/` |
| 后台公司/信用管理 | `controller/company/` |
| 后台系统设置 | `controller/setting/` |
| 后台用户权限 | `controller/system/` |
| 后台监控 | `controller/monitor/` |
| 数据库实体定义 | `like-common/entity/` |
| 工具类/时间/字符串 | `like-common/util/` |
