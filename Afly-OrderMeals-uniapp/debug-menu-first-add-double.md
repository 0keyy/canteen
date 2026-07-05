# Debug Session: menu-first-add-double
- **Status**: [OPEN]
- **Issue**: 点餐页第一次点击加号时，购物车会直接加入两个商品
- **Debug Server**: pending
- **Log File**: .dbg/trae-debug-log-menu-first-add-double.ndjson

## Reproduction Steps
1. 进入 `pages/menu/index`
2. 首次点击任意商品右侧 `+`
3. 观察购物车数量是否从 `0` 直接变成 `2`

## Hypotheses & Verification
| ID | Hypothesis | Likelihood | Effort | Evidence |
|----|------------|------------|--------|----------|
| A | 首次点击时 `addFood()` 被前端事件触发了两次 | High | Low | Pending |
| B | `addFood()` 执行一次，但后续 `syncCart()` 又把数量叠加了一次 | High | Low | Pending |
| C | 首次加购后误走了额外的加购分支，如重试或 `dishInc` | Med | Low | Pending |
| D | 后端 `dishAdd` 首次请求本身就返回或写入了双份数据 | Med | Med | Pending |
| E | 首次建单与首次加购存在竞态，导致一次点击产生两次写入 | Med | Med | Pending |

## Log Evidence
- Pending

## Verification Conclusion
- Pending
