<template>
    <div class="menu-container">
        <UserNavigation 
            :routes="userRoutes" 
            :current-route-name="nowRoute.name" 
            :user-info="userInfo" 
            :is-collapsed="flag"
            :user-center-path="selfPath"
            @route-click="routerClick"
            @toggle-collapse="toggleSidebar"
            @logout="loginOut"
        />
        <div class="main" :class="{'main-expanded': flag}">
            <div class="page-header">
                <div class="header-title">
                    <i :class="nowRoute.icon" v-if="nowRoute.icon"></i>
                    <span>{{ nowRoute.name || '首页' }}</span>
                </div>
                <div class="header-actions">
                    <!-- 根据不同页面显示不同操作按钮 -->
                    <template v-if="nowRoute.path === '/main'">
                        <el-tooltip content="添加留言" placement="bottom" effect="light">
                            <div class="action-btn" @click="handleAction('add')">
                                <i class="el-icon-edit"></i>
                            </div>
                        </el-tooltip>
                    </template>
                    <el-tooltip content="刷新页面" placement="bottom" effect="light">
                        <div class="action-btn" @click="refreshPage">
                            <i class="el-icon-refresh"></i>
                        </div>
                    </el-tooltip>
                </div>
            </div>
            <div class="content-section">
                <router-view ref="currentView"></router-view>
            </div>
        </div>
    </div>
</template>
<script>
import request from "@/utils/request.js";
import router from "@/router/index";
import { clearToken } from "@/utils/storage"
import UserNavigation from '@/components/UserNavigation.vue';

export default {
    name: "UserHome",
    components: {
        UserNavigation
    },
    data() {
        return {
            selfPath: { name: '个人中心', path: '/mySelf' },
            userRoutes: [],
            userInfo: {
                id: null,
                url: '',
                name: '',
                role: null,
                email: ''
            },
            flag: false,
            nowRoute: {}
        };
    },
    created() {
        let menus = router.options.routes.filter(route => route.path == '/user')[0];
        this.userRoutes = menus.children;

        this.tokenCheckLoad();
        this.menuOperationHistory();
        
        // 初始化路由，如果当前路由不匹配任何菜单项，则使用第一个路由
        if (!this.updateCurrentRoute() && this.userRoutes.length > 0) {
            this.routerClick(this.userRoutes[0]);
        }
    },
    
    watch: {
        // 监听路由变化，自动更新标题
        '$route'() {
            this.updateCurrentRoute();
        }
    },

    methods: {
        // 根据当前页面处理特定操作
        handleAction(action) {
            // 根据不同页面执行不同操作
            if (this.nowRoute.path === '/main' && action === 'add') {
                // 调用留言页面的发表留言方法
                if (this.$refs.currentView && this.$refs.currentView.postWord) {
                    this.$refs.currentView.postWord();
                }
            } else if (action === 'refresh') {
                // 可以添加更多页面特定操作
                if (this.$refs.currentView && this.$refs.currentView.fetchFreshData) {
                    this.$refs.currentView.fetchFreshData();
                } else if (this.$refs.currentView && this.$refs.currentView.fetchReaderProposal) {
                    this.$refs.currentView.fetchReaderProposal();
                }
            }
        },
        toggleSidebar() {
            this.flag = !this.flag;
            sessionStorage.setItem('flag', this.flag);
        },
        refreshPage() {
            // 尝试调用子组件的刷新方法
            if (this.$refs.currentView) {
                if (this.$refs.currentView.fetchFreshData) {
                    this.$refs.currentView.fetchFreshData();
                } else if (this.$refs.currentView.fetchReaderProposal) {
                    this.$refs.currentView.fetchReaderProposal();
                } else {
                    // 如果子组件没有刷新方法，才进行路由刷新
                    const currentRoute = this.$route;
                    this.$router.replace('/refresh');
                    this.$nextTick(() => {
                        this.$router.replace(currentRoute.fullPath);
                    });
                }
            } else {
                // 如果没有获取到子组件，进行路由刷新
                const currentRoute = this.$route;
                this.$router.replace('/refresh');
                this.$nextTick(() => {
                    this.$router.replace(currentRoute.fullPath);
                });
            }
        },
        routerClick(route) {
            this.handleRouteSelect(route);
        },
        async loginOut() {
            const confirmed = await this.$swalConfirm({
                title: '退出登录？',
                text: `退出后需重新登录？`,
                icon: 'warning',
            });
            if (confirmed) {
                this.$swal.fire({
                    title: '退出登录成功',
                    text: '1s 后返回登录页面',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: 1000,
                });
                setTimeout(() => {
                    clearToken();
                    this.$router.push("/login");
                }, 1000)
            }
        },
        menuOperationHistory() {
            this.flag = sessionStorage.getItem('flag') === 'true';
        },
        handleRouteSelect(route) {
            if (this.nowRoute.name !== route.name) {
                this.nowRoute = route;
                this.$router.push(route.path);
            }
        },
        // Token检验
        async tokenCheckLoad() {
            try {
                const res = await request.get('user/auth');
                // 错误处理
                if (res.data.code === 400) {
                    this.$message.error(res.data.msg);
                    this.$router.push('/login');
                    return;
                }
                // 用户信息赋值
                const { id, userAvatar: url, userName: name, userRole: role, userEmail: email } = res.data.data;
                this.userInfo = { id, url, name, role, email };
                sessionStorage.setItem('userInfo', JSON.stringify(this.userInfo));
                sessionStorage.setItem('userId', this.userInfo.id);
                // 根据角色解析路由
                const rolePath = role === 1 ? '/admin' : '/user';
                const targetMenu = router.options.routes.find(route => route.path === rolePath);
                if (targetMenu) {
                    this.routers = targetMenu.children;
                } else {
                    console.warn(`未找到与角色对应的路由：${rolePath}`);
                }
            } catch (error) {
                console.error('获取用户认证信息时发生错误:', error);
                this.$message.error('认证信息加载失败，请重试！');
            }
        },
        // 根据当前路由路径更新 nowRoute 对象
        updateCurrentRoute() {
            const currentPath = this.$route.path;
            const matchedRoute = this.userRoutes.find(route => route.path === currentPath);
            if (matchedRoute) {
                this.nowRoute = matchedRoute;
                return true;
            }
            return false;
        }
    }
};
</script>
<style scoped lang="scss">
.menu-container {
    display: flex;
    height: 100vh;
    width: 100%;
    background-color: #f8f9fa;
    overflow: hidden;
}

.main {
    flex-grow: 1;
    overflow-x: hidden;
    background-color: #f8f9fa;
    border-radius: 16px 0 0 16px;
    margin-left: -16px;
    padding-left: 16px;
    transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
    display: flex;
    flex-direction: column;
    position: relative;
    min-width: 0; /* 确保main区域不会超出窗口 */
    
    .content-section {
        overflow-x: hidden;
        flex-grow: 1;
        padding: 20px;
        box-sizing: border-box;
        overflow-y: auto;
        width: 100%; /* 确保内容宽度充满 */
        
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
}

.main-expanded {
    margin-left: 0;
    border-radius: 0;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 20px 0 20px;
    
    .header-title {
        display: flex;
        align-items: center;
        font-size: 18px;
        font-weight: 600;
        color: #333;
        
        i {
            margin-right: 10px;
            font-size: 20px;
            color: #ff5722;
        }
    }
    
    .header-actions {
        display: flex;
        gap: 10px;
        
        .action-btn {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            
            i {
                font-size: 16px;
                color: #606266;
            }
            
            &:hover {
                background-color: rgba(255, 87, 34, 0.08);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                
                i {
                    color: #ff5722;
                }
            }
        }
    }
}
</style>