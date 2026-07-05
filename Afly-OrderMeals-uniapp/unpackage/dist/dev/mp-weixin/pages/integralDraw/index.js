"use strict";
const common_vendor = require("../../common/vendor.js");
const api_integral = require("../../api/integral.js");
const common_assets = require("../../common/assets.js");
const _sfc_main = {
  data() {
    return {
      // 后端返回奖品数组
      prizeList: [],
      // 兜底本地默认文字奖品（接口异常时显示）
      defaultPrize: [
        { id: 1, numText: "15积分", descText: "15积分券" },
        { id: 2, numText: "立减3元", descText: "3元优惠券" },
        { id: 3, numText: "满20减5", descText: "5元满减券" },
        { id: 4, numText: "10积分", descText: "10积分券" },
        { id: 5, numText: "立减1元", descText: "1元优惠券" },
        { id: 6, numText: "立减1元", descText: "1元优惠券" },
        { id: 7, numText: "5积分", descText: "5积分券" },
        { id: 8, numText: "满20减3", descText: "3元满减券" }
      ],
      activeIdx: 0,
      // 当前高亮下标 0~7
      timer: null,
      // 滚动定时器
      isRunning: false,
      // 是否正在抽奖动画
      speed: 80
      // 滚动速度，数字越小滚动越快
    };
  },
  onLoad() {
    this.getPrizeData();
  },
  onUnload() {
    if (this.timer)
      clearInterval(this.timer);
  },
  methods: {
    // 1、请求后端奖品列表接口
    async getPrizeData() {
      try {
        const res = await api_integral.getDrawPrizeList();
        if (res.code === 200 && Array.isArray(res.data) && res.data.length === 8) {
          this.prizeList = res.data;
        } else {
          this.prizeList = this.defaultPrize;
        }
      } catch (err) {
        this.prizeList = this.defaultPrize;
      }
    },
    // 返回上一页（积分商城）
    goBack() {
      common_vendor.index.navigateBack();
    },
    // 开启九宫格循环高亮滚动动画
    startScroll() {
      this.timer = setInterval(() => {
        this.activeIdx += 1;
        if (this.activeIdx > 7)
          this.activeIdx = 0;
      }, this.speed);
    },
    // 减速停止动画，定格到后端返回的中奖下标
    stopScroll(winIndex) {
      clearInterval(this.timer);
      let slowSpeed = this.speed;
      const slowTimer = setInterval(() => {
        slowSpeed += 3;
        clearInterval(this.timer);
        this.timer = setInterval(() => {
          this.activeIdx += 1;
          if (this.activeIdx > 7)
            this.activeIdx = 0;
        }, slowSpeed);
        if (this.activeIdx === winIndex) {
          clearInterval(this.timer);
          clearInterval(slowTimer);
          this.isRunning = false;
          common_vendor.index.showModal({
            title: "恭喜中奖",
            content: `您抽到：${this.prizeList[winIndex].descText}`,
            confirmText: "确定"
          });
        }
      }, 150);
    },
    // 点击中间【抽】按钮主逻辑
    async handleDraw() {
      if (this.isRunning)
        return;
      this.isRunning = true;
      this.startScroll();
      try {
        const res = await api_integral.startDrawApi();
        if (res.code === 200) {
          setTimeout(() => {
            this.stopScroll(res.winIndex);
          }, 2200);
        } else {
          clearInterval(this.timer);
          this.isRunning = false;
          common_vendor.index.showToast({ title: res.msg || "抽奖失败", icon: "none" });
        }
      } catch (e) {
        clearInterval(this.timer);
        this.isRunning = false;
        common_vendor.index.showToast({ title: "网络异常", icon: "none" });
      }
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_assets._imports_0$10,
    b: common_vendor.o((...args) => $options.goBack && $options.goBack(...args)),
    c: common_assets._imports_1$2,
    d: common_vendor.f($data.prizeList.slice(0, 3), (item, idx, i0) => {
      return {
        a: common_vendor.t(item.numText),
        b: common_vendor.t(item.descText),
        c: item.id || idx
      };
    }),
    e: $data.activeIdx === 0 ? 1 : "",
    f: common_vendor.f($data.prizeList.slice(3, 4), (item, idx, i0) => {
      return {
        a: common_vendor.t(item.numText),
        b: common_vendor.t(item.descText),
        c: item.id || idx
      };
    }),
    g: $data.activeIdx === 3 ? 1 : "",
    h: common_vendor.t($data.isRunning ? "抽奖中" : "抽"),
    i: common_vendor.o((...args) => $options.handleDraw && $options.handleDraw(...args)),
    j: $data.isRunning ? 1 : "",
    k: common_vendor.f($data.prizeList.slice(4, 5), (item, idx, i0) => {
      return {
        a: common_vendor.t(item.numText),
        b: common_vendor.t(item.descText),
        c: item.id || idx
      };
    }),
    l: $data.activeIdx === 4 ? 1 : "",
    m: common_vendor.f($data.prizeList.slice(5, 8), (item, idx, i0) => {
      return {
        a: common_vendor.t(item.numText),
        b: common_vendor.t(item.descText),
        c: $data.activeIdx === idx + 5 ? 1 : "",
        d: item.id || idx
      };
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-84fa3ceb"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/integralDraw/index.js.map
