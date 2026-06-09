const url = 'ws://192.168.2.17:8082/clientSocket/'
export let socketClient = {
    /** @type {WebSocket | null} 未 init 前为 null，禁止写成 ''，否则会被当成 string 误设 onmessage */
    socket: null,
    init: (did) => {
        if (did == null || did === '') {
            return
        }
        try {
            socketClient.socket = new WebSocket(url + did)
            socketClient.socket.onopen = () => {
                console.log('与服务器链接成功')
            }
            socketClient.socket.onmessage = (msg) => {
                console.log('收到消息：' + msg.data)
            }
        } catch (e) {
            console.error('WebSocket 创建失败', e)
            socketClient.socket = null
        }
    }
}
