export function connectTable(did) {
  const url = new URL('/clientSocket/' + encodeURIComponent(did), window.location.href)
  url.protocol = url.protocol === 'https:' ? 'wss:' : 'ws:'
  return new WebSocket(url)
}

export function sendTableMessage(socket, message) {
  if (socket?.readyState === WebSocket.OPEN) {
    socket.send(JSON.stringify(message))
  }
}
