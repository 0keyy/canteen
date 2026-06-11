/**
 * 将扁平部门列表构建为树
 * @param {Array<{deptId, parentId, deptName}>} flatList
 */
export function buildDeptTree(flatList) {
  if (!Array.isArray(flatList) || flatList.length === 0) return []

  const map = {}
  flatList.forEach((item) => {
    map[String(item.deptId)] = {
      deptId: item.deptId,
      parentId: item.parentId,
      deptName: item.deptName,
      children: []
    }
  })

  const roots = []
  flatList.forEach((item) => {
    const node = map[String(item.deptId)]
    const parentId = Number(item.parentId)
    if (!parentId || !map[String(parentId)]) {
      roots.push(node)
    } else {
      map[String(parentId)].children.push(node)
    }
  })

  return roots
}

/**
 * 按展开状态扁平化可见节点
 */
export function flattenDeptTree(nodes, expandedIds, level = 0) {
  const list = []
  if (!Array.isArray(nodes)) return list

  nodes.forEach((node) => {
    const hasChildren = Array.isArray(node.children) && node.children.length > 0
    list.push({
      deptId: node.deptId,
      parentId: node.parentId,
      deptName: node.deptName,
      level,
      hasChildren
    })
    if (hasChildren && expandedIds[String(node.deptId)]) {
      list.push(...flattenDeptTree(node.children, expandedIds, level + 1))
    }
  })
  return list
}

/** 默认展开所有有子节点的部门 */
export function collectAllExpanded(nodes, expanded = {}) {
  if (!Array.isArray(nodes)) return expanded
  nodes.forEach((node) => {
    if (node.children && node.children.length > 0) {
      expanded[String(node.deptId)] = true
      collectAllExpanded(node.children, expanded)
    }
  })
  return expanded
}

/** 收集默认展开的节点（有子节点的根级） */
export function collectDefaultExpanded(nodes) {
  const expanded = {}
  if (!Array.isArray(nodes)) return expanded
  nodes.forEach((node) => {
    if (node.children && node.children.length > 0) {
      expanded[String(node.deptId)] = true
    }
  })
  return expanded
}

export function findDeptById(flatList, deptId) {
  if (!deptId || !Array.isArray(flatList)) return null
  return flatList.find((item) => Number(item.deptId) === Number(deptId)) || null
}
