<template>
  <div class="menu-side" :class="{ 'menu-side-narrow': isCollapsed }">
    <!-- 顶部Logo区域 -->
    <div class="logo-container">
      <img src="/Logo2.png" class="logo-image">
      <div class="logo-text">悦读空间</div>
      <div class="collapse-btn" @click="toggleCollapse">
        <i :class="isCollapsed ? 'el-icon-s-unfold' : 'el-icon-s-fold'"></i>
      </div>
    </div>
    
    <!-- 导航菜单区域 -->
    <div class="navigation-container">
      <div class="nav-group">
        <div v-for="(route, index) in routes" 
          :key="index"
          v-if="route.show !== false"
          class="item-route" 
          :class="{'active-route': currentRouteName === route.name}"
          @click="handleRouteClick(route)">
          <div class="active-indicator" v-if="currentRouteName === route.name"></div>
          <div class="item-content">
            <i :class="route.icon"></i>
            <span class="route-text">{{ route.name }}</span>
          </div>
          <el-tooltip 
            v-if="isCollapsed" 
            :content="route.name" 
            placement="right" 
            :open-delay="300">
            <span class="tooltip-trigger"></span>
          </el-tooltip>
        </div>
      </div>
      
      <!-- 底部用户信息区域 -->
      <div class="user-section">
        <div class="divider"></div>
        <div class="item-route user-info-item" @click="goToUserCenter">
          <div class="item-content">
            <img :src="userInfo.url || '/assets/default-avatar.png'" class="user-avatar">
            <div class="user-details">
              <span class="username">{{ userInfo.name || '用户' }}</span>
              <span class="user-role">{{ userInfo.role === 1 ? '管理员' : '读者' }}</span>
            </div>
          </div>
          <el-tooltip 
            v-if="isCollapsed" 
            :content="userInfo.name || '用户'" 
            placement="right"
            :open-delay="300">
            <span class="tooltip-trigger"></span>
          </el-tooltip>
        </div>
        <div class="item-route logout-item" @click="handleLogout">
          <div class="item-content">
            <i class="el-icon-switch-button"></i>
            <span class="route-text">退出登录</span>
          </div>
          <el-tooltip 
            v-if="isCollapsed" 
            content="退出登录" 
            placement="right"
            :open-delay="300">
            <span class="tooltip-trigger"></span>
          </el-tooltip>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserNavigation',
  props: {
    routes: Array,
    currentRouteName: {
      type: String,
      default: ''
    },
    userInfo: Object,
    isCollapsed: Boolean,
    userCenterPath: {
      type: Object,
      default: () => ({ name: '个人中心', path: '/mySelf' })
    }
  },
  methods: {
    handleRouteClick(route) {
      this.$emit('route-click', route);
    },
    goToUserCenter() {
      this.$emit('route-click', this.userCenterPath);
    },
    toggleCollapse() {
      this.$emit('toggle-collapse');
    },
    handleLogout() {
      this.$emit('logout');
    }
  }
}
</script>

<style scoped lang="scss">
.menu-side {
  width: 230px !important;
  min-width: 120px !important;
  height: 100vh;
  box-sizing: border-box;
  transition: width 0.4s cubic-bezier(0.25, 0.1, 0.25, 1);
  border-right: 1px solid rgba(0,0,0,0.05);
  background-color: white;
  box-shadow: 0 0 20px rgba(0,0,0,0.06);
  display: flex;
  flex-direction: column;
  border-radius: 0 16px 16px 0;
  overflow: hidden;
  position: relative;
  flex-shrink: 0;
  z-index: 1000;
}

.logo-container {
  display: flex;
  align-items: center;
  padding: 20px;
  padding-left: 30px;
  margin-bottom: 10px;
  position: relative;
  transition: padding 0.4s cubic-bezier(0.25, 0.1, 0.25, 1);
  
  .logo-image {
    width: 48px;
    height: 48px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(255, 87, 34, 0.2);
    transition: transform 0.3s ease;
    object-fit: cover;
    
    &:hover {
      transform: scale(1.05);
      box-shadow: 0 6px 16px rgba(255, 87, 34, 0.25);
    }
  }
  
  .logo-text {
    margin-left: 12px;
    font-size: 20px;
    color: #ff5722;
    font-weight: 600;
    letter-spacing: 1px;
    flex: 1;
    white-space: nowrap;
    overflow: hidden;
    font-family: '抖音美好体', '微软雅黑', sans-serif;
  }
  
  .collapse-btn {
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    width: 32px;
    height: 32px;
    border-radius: 8px;
    background-color: rgba(255, 87, 34, 0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.3s ease;
    color: #ff5722;
    
    &:hover {
      background-color: rgba(255, 87, 34, 0.15);
      transform: translateY(-50%) scale(1.05);
    }
    
    i {
      font-size: 18px;
    }
  }
}

.navigation-container {
  display: flex;
  flex-direction: column;
  padding: 10px 14px;
  overflow-y: auto;
  flex: 1;
  justify-content: space-between;
  
  &::-webkit-scrollbar {
    width: 4px;
  }
  
  &::-webkit-scrollbar-track {
    background: transparent;
  }
  
  &::-webkit-scrollbar-thumb {
    background-color: rgba(0, 0, 0, 0.1);
    border-radius: 10px;
  }
}

.nav-group {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.item-route {
  position: relative;
  padding: 12px 14px;
  margin: 4px 0;
  border-radius: 12px;
  cursor: pointer;
  transition: background-color 0.3s ease;
  height: 48px;
  box-sizing: border-box;
  width: 100%;
  text-align: center;
  display: flex;
  justify-content: center;
  
  .item-content {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    position: relative;
    z-index: 2;
    width: 100%;
  }
  
  &::after {
    content: '';
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    height: 100%;
    background-color: rgba(255, 87, 34, 0.08);
    border-radius: 12px;
    opacity: 0;
    transform: translate(-50%, -50%) scale(0.5);
    transition: transform 0.3s ease, opacity 0.3s ease;
    z-index: 1;
  }
  
  &:hover::after {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
  }
  
  &:active::after {
    background-color: rgba(255, 87, 34, 0.15);
  }
  
  i {
    font-size: 18px;
    color: #606266;
    transition: color 0.3s ease;
    display: inline-block;
    text-align: center;
  }

  .route-text {
    font-size: 15px;
    color: #606266;
    font-weight: 500;
    transition: color 0.3s ease;
    flex: 0 1 auto;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    text-align: center;
  }
  
  .tooltip-trigger {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 3;
  }
  
  .active-indicator {
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    width: 4px;
    background-color: #ff5722;
    border-radius: 0 4px 4px 0;
    transform: translateX(-4px);
    transition: transform 0.3s ease;
    z-index: 2;
  }
}

.active-route {
  background-color: rgba(255, 87, 34, 0.08);
  
  .active-indicator {
    transform: translateX(0);
  }
  
  i, .route-text {
    color: #ff5722;
    font-weight: 600;
  }
}

.user-section {
  margin-top: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.divider {
  height: 1px;
  background-color: rgba(0, 0, 0, 0.06);
  margin: 10px 0;
  width: 100%;
}

.user-info-item {
  background-color: rgba(0, 0, 0, 0.02);
  height: auto !important;
  padding-top: 8px !important;
  padding-bottom: 8px !important;
  
  .item-content {
    width: 100%;
    align-items: center;
  }
  
  .user-avatar {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    object-fit: cover;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    border: 2px solid #fff;
  }

  .user-details {
    display: flex;
    flex-direction: column;
    
    .username {
      font-weight: 600;
      font-size: 14px;
      color: #303133;
      line-height: 1.2;
      margin-bottom: 2px;
    }
    
    .user-role {
      font-size: 12px;
      color: #909399;
    }
  }
}

.logout-item {
  i {
    color: #f56c6c;
  }
  
  .route-text {
    color: #f56c6c;
  }
  
  &:hover::after {
    background-color: rgba(245, 108, 108, 0.08);
  }
  
  &:active::after {
    background-color: rgba(245, 108, 108, 0.15);
  }
}

.menu-side-narrow {
  width: 120px !important;

  .logo-container {
    justify-content: center;
    padding: 20px 0;
    position: relative;
    
    .logo-text {
      width: 0;
      margin-left: 0;
      opacity: 0;
      display: none;
    }
    
    .logo-image {
      margin: 0;
    }
    
    .collapse-btn {
      position: absolute;
      right: 0;
      top: 50%;
      transform: translateY(-50%);
    }
  }

  .item-route {
    padding: 12px 0;
    
    i {
      margin: 0 auto;
      font-size: 20px;
    }
    
    .route-text {
      width: 0;
      margin-left: 0;
      opacity: 0;
      display: none;
    }
  }
  
  .user-info-item {
    .user-details {
      width: 0;
      margin-left: 0;
      opacity: 0;
      display: none;
    }
    
    .user-avatar {
      width: 30px;
      height: 30px;
      border-radius: 8px;
      margin: 0 auto;
    }
  }
}

.nav-tooltip {
  padding: 8px 12px;
  border-radius: 8px;
  background-color: rgba(48, 49, 51, 0.9);
  border: none;
}
</style> 