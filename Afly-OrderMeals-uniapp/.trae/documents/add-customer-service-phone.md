# 联系客服拨打电话功能实现计划

## 1. 需求分析

用户需求：点击 mine.vue 页面的"联系客服"按钮，获取后台配置的客服电话并直接拨打。

当前状态：
- mine.vue 中已有"联系客服"按钮（在 PRIMARY_ACTIONS 中定义）
- 点击后走 `onFeatureTap(item.title)`，显示"功能开发中"提示
- 项目中没有客服热线相关的 API 接口

## 2. 实现方案

### 2.1 新增客服热线接口

**文件**: `api/index.js`

新增 `serviceApi` 模块：

```javascript
export const serviceApi = {
  hotline: () => get('/front/service/hotline')
}
```

**接口说明**:
- 请求地址: `GET /front/service/hotline`
- 返回字段示例:
```json
{
  "phone": "400-123-4567",    // 客服电话（必填）
  "name": "粮兴坊客服中心",    // 客服名称（可选）
  "workTime": "9:00-18:00"     // 服务时间（可选）
}
```

### 2.2 修改 mine.vue 点击逻辑

**文件**: `pages/mine/index.vue`

在 `onActionTap` 方法中添加"联系客服"的处理：

```javascript
if (item.title === '联系客服') {
  this.callService()
  return
}
```

新增 `callService` 方法：

```javascript
async callService() {
  try {
    const data = await serviceApi.hotline()
    if (data && data.phone) {
      uni.makePhoneCall({
        phoneNumber: data.phone,
        fail: (err) => {
          if (err.errMsg.includes('cancel')) return
          uni.showToast({ title: '拨打失败', icon: 'none' })
        }
      })
    } else {
      uni.showToast({ title: '暂未配置客服电话', icon: 'none' })
    }
  } catch (e) {
    uni.showToast({ title: e.message || '获取客服电话失败', icon: 'none' })
  }
}
```

## 3. 需要新增的接口文档（供后端开发参考）

### 3.1 客服热线接口

**接口路径**: `/front/service/hotline`

**请求方式**: GET

**请求参数**: 无

**返回示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "phone": "400-123-4567",
    "name": "粮兴坊客服中心",
    "workTime": "9:00-18:00"
  }
}
```

**字段说明**:
- `phone` (string, 必填): 客服电话号码，支持手机号、座机、400电话
- `name` (string, 可选): 客服中心名称，用于前端展示
- `workTime` (string, 可选): 服务时间段，用于前端展示

## 4. 涉及文件

1. `api/index.js` - 新增 serviceApi 接口定义
2. `pages/mine/index.vue` - 添加联系客服点击处理逻辑

## 5. 验证步骤

1. 点击"联系客服"按钮
2. 检查是否调用了 `/front/service/hotline` 接口
3. 接口返回客服电话后，检查是否弹出系统拨号界面
4. 接口返回空或报错时，检查是否显示对应提示信息