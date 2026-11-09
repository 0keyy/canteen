const SELLER_KEY = '__seller__'

function readSellers() {
  try {
    return JSON.parse(localStorage.getItem(SELLER_KEY)) || {}
  } catch {
    return {}
  }
}

export function saveToLocal(id, key, value) {
  const sellers = readSellers()
  sellers[id] = { ...sellers[id], [key]: value }
  localStorage.setItem(SELLER_KEY, JSON.stringify(sellers))
}

export function loadFromLocal(id, key, fallback) {
  return readSellers()[id]?.[key] ?? fallback
}
