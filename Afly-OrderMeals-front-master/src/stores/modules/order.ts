import { orderDeskList, dishCateAll } from '@/api/order'
import { defineStore } from 'pinia'

export interface OrderState {
    deskList: any[]
    dishCate: any[]
}
const useOrderStore = defineStore({
    id: 'order',
    state: (): OrderState => ({
        deskList: [],
        dishCate: []
    }),
    getters: {
        getDeskList(): any[] {
            return this.deskList
        },
        getDishCate(): any[] {
            return this.dishCate
        }
    },
    actions: {
        init() {
            orderDeskList().then((res) => {
                this.deskList = res
            })
            dishCateAll().then((res) => {
                this.dishCate = res
            })
        },
        addDeskList(res: any) {
            this.deskList = res
        }
    }
})
export default useOrderStore
