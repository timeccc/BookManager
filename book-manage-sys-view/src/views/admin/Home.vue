<template>
    <div class="admin-layout">
        <!-- 左侧导航 -->
        <div class="sidebar" :class="{'sidebar-collapsed': flag}">
            <div class="logo-container">
                <Logo name="书海智控台" :flag="flag" :bag="colorLogo" />
            </div>
            <div class="menu-wrapper">
                <AdminMenu :flag="flag" :routes="adminRoutes" :bag="bagMenu" @select="handleRouteSelect" />
            </div>
        </div>

        <!-- 右侧内容区 -->
        <div class="main-container">
            <div class="header">
                <LevelHeader 
                    @eventListener="eventListener" 
                    @selectOperation="selectOperation" 
                    :tag="tag"
                    :userInfo="userInfo" 
                />
            </div>
            <div class="content">
                <router-view></router-view>
            </div>
        </div>

        <!-- 个人中心弹窗 -->
        <el-dialog 
            :visible.sync="dialogOperaion" 
            width="380px" 
            custom-class="user-center-dialog"
            :show-close="true">
            <div class="user-center-header">
                <h3>个人中心</h3>
            </div>
            <div class="user-center-body">
                <div class="form-item">
                    <label class="form-label">
                        <i class="el-icon-user-solid"></i>
                        <span>头像</span>
                    </label>
                    <div class="avatar-wrapper">
                        <el-upload 
                            class="avatar-uploader" 
                            action="/api/book-manage-sys-api/v1.0/file/upload"
                            :show-file-list="false" 
                            :on-success="handleAvatarSuccess">
                            <img v-if="userInfo.url" :src="userInfo.url" class="user-avatar">
                            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                        </el-upload>
                    </div>
                </div>
                <div class="form-item">
                    <label class="form-label">
                        <i class="el-icon-user"></i>
                        <span>用户名</span>
                    </label>
                    <el-input v-model="userInfo.name" placeholder="请输入用户名"></el-input>
                </div>
                <div class="form-item">
                    <label class="form-label">
                        <i class="el-icon-message"></i>
                        <span>邮箱</span>
                    </label>
                    <el-input v-model="userInfo.email" placeholder="请输入邮箱"></el-input>
                </div>
            </div>
            <div slot="footer" class="user-center-footer">
                <el-button @click="dialogOperaion = false">取 消</el-button>
                <el-button type="primary" @click="updateUserInfo">确认修改</el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
import request from "@/utils/request.js";
import router from "@/router/index";
import { clearToken } from "@/utils/storage"
import AdminMenu from '@/components/VerticalMenu.vue';
import Logo from '@/components/Logo.vue';
import LevelHeader from '@/components/LevelHeader.vue';

export default {
    name: "AdminHome",
    components: {
        Logo,
        LevelHeader,
        AdminMenu
    },
    data() {
        return {
            adminRoutes: [],
            userInfo: {
                id: null,
                url: '',
                name: '',
                role: null,
                email: ''
            },
            flag: false,
            tag: '仪表盘',
            colorLogo: '#333',
            bagMenu: 'transparent',
            dialogOperaion: false
        };
    },
    created() {
        // 获取路由
        let menus = router.options.routes.find(route => route.path == '/admin');
        if (menus) {
            this.adminRoutes = menus.children;
        }
        
        // 初始化数据
        this.tokenCheckLoad();
        this.loadSidebarState();
        
        // 初始化标题
        this.updatePageTitle();
    },
    
    watch: {
        '$route'() {
            this.updatePageTitle();
        }
    },

    methods: {
        // 更新页面标题
        updatePageTitle() {
            const currentPath = this.$route.path;
            const currentRoute = this.adminRoutes.find(route => route.path === currentPath);
            if (currentRoute) {
                this.tag = currentRoute.name;
            }
        },
        
        // 加载侧边栏状态
        loadSidebarState() {
            this.flag = sessionStorage.getItem('flag') === 'true';
        },
        
        // 处理头像上传成功
        handleAvatarSuccess(res) {
            if (res.code !== 200) {
                this.$message.error('头像上传失败');
                return;
            }
            
            this.$message.success('头像上传成功');
            this.userInfo.url = res.data;
        },
        
        // 更新用户信息
        async updateUserInfo() {
            try {
                const userUpdateDTO = {
                    userAvatar: this.userInfo.url,
                    userName: this.userInfo.name,
                    userEmail: this.userInfo.email
                };
                
                const response = await this.$axios.put('/user/update', userUpdateDTO);
                const { data } = response;
                
                if (data.code === 200) {
                    this.dialogOperaion = false;
                    this.tokenCheckLoad();
                    
                    this.$swal.fire({
                        title: '修改成功',
                        text: data.msg,
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1000
                    });
                }
            } catch (error) {
                this.dialogOperaion = false;
                
                this.$swal.fire({
                    title: '修改失败',
                    text: error.message || '发生未知错误',
                    icon: 'error',
                    showConfirmButton: false,
                    timer: 2000
                });
                
                console.error('修改个人信息异常:', error);
            }
        },
        
        // 处理头部事件
        eventListener(event) {
            if (event === 'center') {
                this.dialogOperaion = true;
            } else if (event === 'loginOut') {
                this.loginOut();
            }
        },
        
        // 退出登录
        async loginOut() {
            const confirmed = await this.$swalConfirm({
                title: '确认退出登录?',
                text: '退出后需重新登录',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '确认',
                cancelButtonText: '取消',
                confirmButtonColor: '#409EFF',
                cancelButtonColor: '#909399'
            });
            
            if (confirmed) {
                this.$swal.fire({
                    title: '退出成功',
                    text: '正在返回登录页面...',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: 1000
                });
                
                setTimeout(() => {
                    clearToken();
                    this.$router.push("/login");
                }, 1000);
            }
        },
        
        // 切换侧边栏
        selectOperation(flag) {
            this.flag = flag;
            sessionStorage.setItem('flag', flag);
        },
        
        // 选择菜单项
        handleRouteSelect(path) {
            if (this.$route.path === path) return;
            
            const route = this.adminRoutes.find(item => item.path === path);
            if (route) {
                this.tag = route.name;
                this.$router.push(path);
            }
        },
        
        // 验证token并加载用户信息
        async tokenCheckLoad() {
            try {
                const res = await request.get('user/auth');
                
                // 处理错误
                if (res.data.code === 400) {
                    this.$message.error(res.data.msg);
                    this.$router.push('/login');
                    return;
                }
                
                // 设置用户信息
                const { id, userAvatar: url, userName: name, userRole: role, userEmail: email } = res.data.data;
                this.userInfo = { id, url, name, role, email };
                
                // 验证用户角色
                if (role !== 1) {
                    this.$message.warning('您没有管理员权限，正在跳转...');
                    this.$router.push('/user');
                }
            } catch (error) {
                console.error('获取用户信息失败:', error);
                this.$message.error('认证失败，请重新登录');
                this.$router.push('/login');
            }
        }
    }
};
</script>

<style scoped lang="scss">
// 主布局
.admin-layout {
    display: flex;
    height: 100vh;
    background-color: #f6f8fc;
    overflow: hidden;
}

// 侧边栏
.sidebar {
    width: 240px;
    background-color: #ffffff;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
    display: flex;
    flex-direction: column;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    z-index: 1000;
    flex-shrink: 0;
    border-radius: 0 20px 20px 0;
    margin-right: 14px;
    position: relative;
}

.sidebar-collapsed {
    width: 90px;
}

.logo-container {
    height: 70px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid rgba(0, 0, 0, 0.04);
    padding: 0 16px;
}

.menu-wrapper {
    flex: 1;
    overflow-y: auto;
    padding: 8px 0;
    
    &::-webkit-scrollbar {
        width: 0;
    }
    
    &::-webkit-scrollbar-track {
        background: transparent;
    }
    
    &::-webkit-scrollbar-thumb {
        background-color: transparent;
    }
}

// 主内容区
.main-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    padding: 16px 20px;
    background-color: #f6f8fc;
    border-radius: 20px 0 0 20px;
    margin-left: -14px;
    transition: all 0.3s ease;
}

.header {
    height: 70px;
    background-color: #ffffff;
    border-radius: 16px;
    margin-bottom: 16px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    display: flex;
    align-items: center;
}

.content {
    flex: 1;
    background-color: #ffffff;
    border-radius: 16px;
    padding: 24px;
    overflow-y: auto;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
    
    &::-webkit-scrollbar {
        width: 6px;
    }
    
    &::-webkit-scrollbar-track {
        background: #f0f2f5;
        border-radius: 3px;
    }
    
    &::-webkit-scrollbar-thumb {
        background-color: rgba(0, 0, 0, 0.1);
        border-radius: 3px;
        
        &:hover {
            background-color: rgba(0, 0, 0, 0.2);
        }
    }
}

// 用户中心弹窗
.user-center-dialog {
    border-radius: 12px;
    overflow: hidden;
    
    ::v-deep .el-dialog__body {
        padding: 0;
    }
    
    ::v-deep .el-dialog__header {
        padding: 0;
    }
    
    ::v-deep .el-dialog__headerbtn {
        z-index: 10;
    }
}

.user-center-header {
    background: linear-gradient(135deg, #f0f7ff, #e0eeff);
    padding: 24px;
    position: relative;
    
    h3 {
        margin: 0;
        font-size: 18px;
        color: #303133;
        font-weight: 600;
        position: relative;
        padding-left: 14px;
        
        &:before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 18px;
            background-color: #409EFF;
            border-radius: 4px;
        }
    }
}

.user-center-body {
    padding: 24px;
}

.form-item {
    margin-bottom: 20px;
    
    &:last-child {
        margin-bottom: 0;
    }
}

.form-label {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    
    i {
        font-size: 16px;
        color: #409EFF;
        margin-right: 8px;
    }
    
    span {
        font-size: 14px;
        color: #606266;
        font-weight: 500;
    }
}

.avatar-wrapper {
    display: flex;
    justify-content: center;
    margin: 16px 0;
}

.user-avatar {
    width: 90px;
    height: 90px;
    border-radius: 50%;
    object-fit: cover;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    border: 3px solid #fff;
}

.avatar-uploader-icon {
    font-size: 26px;
    width: 90px;
    height: 90px;
    line-height: 90px;
    text-align: center;
    border: 2px dashed #d9d9d9;
    border-radius: 50%;
    color: #8c939d;
    
    &:hover {
        border-color: #409EFF;
        color: #409EFF;
    }
}

.user-center-footer {
    padding: 16px 24px;
    background-color: #f5f7fa;
    text-align: right;
    
    .el-button {
        padding: 10px 22px;
        font-size: 14px;
        border-radius: 8px;
    }
}
</style>