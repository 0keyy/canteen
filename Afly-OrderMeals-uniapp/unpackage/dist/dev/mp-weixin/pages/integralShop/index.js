"use strict";
const common_vendor = require("../../common/vendor.js");
const api_index = require("../../api/index.js");
const api_integral = require("../../api/integral.js");
const utils_image = require("../../utils/image.js");
const _sfc_main = {
  data() {
    return {
      staticImgPrefix: utils_image.STATIC_IMAGE_PREFIX,
      userScore: 0,
      // 兜底本地商品（后端接口异常时展示）
      defaultGoods: [
        {
          id: 1,
          img: "",
          name: "【堂食专享】可口可乐",
          point: 10,
          sold: 0
        },
        {
          id: 2,
          img: "",
          name: "【堂食专享】苦菊拌干豆腐丝",
          point: 150,
          sold: 0
        },
        {
          id: 3,
          img: "",
          name: "【堂食专享】老醋三样",
          point: 200,
          sold: 0
        },
        {
          id: 4,
          img: "",
          name: "【堂食专享】番茄莎莎酱",
          point: 150,
          sold: 0
        }
      ],
      goodsList: []
    };
  },
  onLoad() {
    this.goodsList = this.defaultGoods;
    this.getUserScore();
    this.getGoodsList();
  },
  onShow() {
    this.getUserScore();
    this.getGoodsList();
  },
  methods: {
    // 返回上一页
    goBack() {
      common_vendor.index.navigateBack();
    },
    // 跳转积分抽奖页
    goDrawPage() {
      common_vendor.index.navigateTo({ url: "/pages/integralDraw/index" });
    },
    // 获取用户当前积分（从用户信息接口拿）
    async getUserScore() {
      try {
        const res = await api_index.authApi.profile();
        if (res && res.code === 200 && res.data && res.data.point != null) {
          this.userScore = res.data.point;
        }
      } catch (err) {
        this.userScore = 0;
      }
    },
    // 请求后端：获取积分兑换商品列表
    async getGoodsList() {
      try {
        const res = await api_integral.getIntegralGoodsList();
        if (res && res.code === 200 && Array.isArray(res.data)) {
          this.goodsList = res.data;
        }
      } catch (err) {
        this.goodsList = this.defaultGoods;
        common_vendor.index.__f__("log", "at pages/integralShop/index.vue:146", "积分商品接口暂未开发", err);
      }
    },
    // 商品详情弹窗预留
    goGoodsDetail(item) {
      common_vendor.index.showToast({ title: "商品详情开发中", icon: "none" });
    }
  }
};
function _sfc_render(_ctx, _cache, $props, $setup, $data, $options) {
  return {
    a: common_vendor.o((...args) => $options.goBack && $options.goBack(...args), "b4"),
    b: common_vendor.t($data.userScore),
    c: $data.staticImgPrefix + "/static/新版小唐.png",
    d: common_vendor.o((...args) => $options.goDrawPage && $options.goDrawPage(...args), "ab"),
    e: common_vendor.f($data.goodsList, (goods, k0, i0) => {
      return common_vendor.e({
        a: goods.img
      }, goods.img ? {
        b: goods.img
      } : {}, {
        c: common_vendor.t(goods.name),
        d: common_vendor.t(goods.point),
        e: common_vendor.t(goods.sold),
        f: goods.id,
        g: common_vendor.o(($event) => $options.goGoodsDetail(goods), goods.id)
      });
    })
  };
}
const MiniProgramPage = /* @__PURE__ */ common_vendor._export_sfc(_sfc_main, [["render", _sfc_render], ["__scopeId", "data-v-09a01d76"]]);
wx.createPage(MiniProgramPage);
//# sourceMappingURL=../../../.sourcemap/mp-weixin/pages/integralShop/index.js.map
