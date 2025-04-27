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
</style>
