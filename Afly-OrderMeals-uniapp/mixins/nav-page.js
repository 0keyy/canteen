import { getNavMetrics } from '../utils/navbar'

export default {
  data() {
    return {
      navMetrics: getNavMetrics()
    }
  },
  methods: {
    updateNavMetrics() {
      this.navMetrics = getNavMetrics()
    }
  },
  onLoad() {
    this.updateNavMetrics()
  },
  onReady() {
    this.updateNavMetrics()
  }
}
