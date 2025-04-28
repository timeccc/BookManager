<template>
  <div id="app">
    <router-view />
  </div>
</template>

<style lang="scss">
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  overflow: hidden; /* 防止html和body层级出现滚动条 */
}

#app {
  height: 100%;
  background: linear-gradient(to right, #f5f7fa, #e4e8f1);
  overflow: hidden; /* 防止app容器层级出现滚动条 */
}

/* 在这里对导航栏做全局样式保证 */
.menu-side {
  width: 230px !important;
  flex-shrink: 0 !important;
}

.menu-side-narrow {
  width: 120px !important;
  flex-shrink: 0 !important;
}

/* 全局隐藏所有滚动条 */
::-webkit-scrollbar {
  display: none !important; /* Chrome, Safari */
  width: 0 !important;
  height: 0 !important;
}

/* Firefox */
* {
  scrollbar-width: none !important;
}

/* IE */
* {
  -ms-overflow-style: none !important;
}

/* 删除确认对话框全局样式 */
.custom-delete-popup {
  border-radius: 12px !important;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1) !important;
  overflow: hidden !important;
}

.custom-delete-title {
  font-size: 18px !important;
  font-weight: 600 !important;
  color: #303133 !important;
}

.custom-delete-content {
  font-size: 14px !important;
  color: #606266 !important;
  margin-top: 8px !important;
}

.custom-delete-icon {
  border: 2px solid #f56c6c !important;
  border-radius: 50% !important;
  padding: 10px !important;
  margin-bottom: 15px !important;
}

.custom-delete-confirm-button {
  padding: 10px 20px !important;
  border-radius: 20px !important;
  font-weight: 500 !important;
  transition: all 0.3s !important;
  font-size: 14px !important;
}

.custom-delete-confirm-button:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 5px 15px rgba(245, 108, 108, 0.4) !important;
}

.custom-delete-confirm-button:active {
  transform: translateY(0) !important;
}

.custom-delete-cancel-button {
  padding: 10px 20px !important;
  border-radius: 20px !important;
  font-weight: 500 !important;
  transition: all 0.3s !important;
  font-size: 14px !important;
}

.custom-delete-cancel-button:hover {
  background-color: #f5f7fa !important;
  color: #606266 !important;
}
</style>
