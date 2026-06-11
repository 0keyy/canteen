"use strict";
function buildDeptTree(flatList) {
  if (!Array.isArray(flatList) || flatList.length === 0)
    return [];
  const map = {};
  flatList.forEach((item) => {
    map[String(item.deptId)] = {
      deptId: item.deptId,
      parentId: item.parentId,
      deptName: item.deptName,
      children: []
    };
  });
  const roots = [];
  flatList.forEach((item) => {
    const node = map[String(item.deptId)];
    const parentId = Number(item.parentId);
    if (!parentId || !map[String(parentId)]) {
      roots.push(node);
    } else {
      map[String(parentId)].children.push(node);
    }
  });
  return roots;
}
function flattenDeptTree(nodes, expandedIds, level = 0) {
  const list = [];
  if (!Array.isArray(nodes))
    return list;
  nodes.forEach((node) => {
    const hasChildren = Array.isArray(node.children) && node.children.length > 0;
    list.push({
      deptId: node.deptId,
      parentId: node.parentId,
      deptName: node.deptName,
      level,
      hasChildren
    });
    if (hasChildren && expandedIds[String(node.deptId)]) {
      list.push(...flattenDeptTree(node.children, expandedIds, level + 1));
    }
  });
  return list;
}
function collectAllExpanded(nodes, expanded = {}) {
  if (!Array.isArray(nodes))
    return expanded;
  nodes.forEach((node) => {
    if (node.children && node.children.length > 0) {
      expanded[String(node.deptId)] = true;
      collectAllExpanded(node.children, expanded);
    }
  });
  return expanded;
}
function findDeptById(flatList, deptId) {
  if (!deptId || !Array.isArray(flatList))
    return null;
  return flatList.find((item) => Number(item.deptId) === Number(deptId)) || null;
}
exports.buildDeptTree = buildDeptTree;
exports.collectAllExpanded = collectAllExpanded;
exports.findDeptById = findDeptById;
exports.flattenDeptTree = flattenDeptTree;
//# sourceMappingURL=../../.sourcemap/mp-weixin/utils/dept-tree.js.map
