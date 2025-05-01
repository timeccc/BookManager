<template>
    <div class="menu-container">
        <div class="menu-side" :class="{ 'menu-side-narrow': flag }">
            <div style="display: flex;align-items: center;">
                <Logo name="书海智控台" style="padding: 0 20px 0 15px;margin: 18px 15px 15px 15px;" :flag="flag" :bag="colorLogo" />
            </div>
            <div style="margin-top: 18px;">
                <AdminMenu :flag="flag" :routes="adminRoutes" :bag="bagMenu" @select="handleRouteSelect" />
            </div>
        </div>
        <div class="main">
            <div class="header-section">
                <LevelHeader @eventListener="eventListener" @selectOperation="selectOperation" :tag="tag"
                    :userInfo="userInfo" />
            </div>
            <div class="content-section">
                <router-view></router-view>
            </div>
        </div>
        <!-- 个人中心 -->
        <el-dialog :show-close="false" :visible.sync="dialogOperaion" width="360px" custom-class="user-center-dialog">
            <div slot="title" class="user-center-title">
                <span>个人中心</span>
            </div>
            <div class="user-center-content">
                <div class="form-item">
                    <p class="form-label">
                        <i class="el-icon-user-solid"></i>
                        <span>头像</span>
                    </p>
                    <div class="avatar-wrapper">
                    <el-upload class="avatar-uploader" action="/api/book-manage-sys-api/v1.0/file/upload"
                        :show-file-list="false" :on-success="handleAvatarSuccess">
                            <img v-if="userInfo.url" :src="userInfo.url">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                    </div>
                </div>
                <div class="form-item">
                    <p class="form-label">
                        <i class="el-icon-user"></i>
                        <span>用户名</span>
                    </p>
                    <input class="input-title user-input" v-model="userInfo.name" placeholder="请输入用户名">
                </div>
                <div class="form-item">
                    <p class="form-label">
                        <i class="el-icon-message"></i>
                        <span>邮箱</span>
                    </p>
                    <input class="input-title user-input" v-model="userInfo.email" placeholder="请输入邮箱">
                </div>
            </div>
            <div slot="footer" class="user-center-footer">
                <el-button class="el-button--default" size="small" @click="dialogOperaion = false">取 消</el-button>
                <el-button class="el-button--primary" size="small" type="primary" @click="updateUserInfo">确认修改</el-button>
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
    name: "Admin",
    components: {
        Logo,
        LevelHeader,
        AdminMenu
    },
    data() {
        return {
            adminRoutes: [],
            activeIndex: '',
            userInfo: {
                id: null,
                url: '',
                name: '',
                role: null,
                email: ''
            },
            flag: false,
            tag: '可视化',
            bag: 'rgb(248,248,248)',
            colorLogo: '#333',
            bagMenu: 'transparent',
            dialogOperaion: false
        };
    },
    created() {
        let menus = router.options.routes.filter(route => route.path == '/admin')[0];
        this.adminRoutes = menus.children;
        this.tokenCheckLoad();
        this.menuOperationHistory();
        
        // 初始化时根据当前路径设置标签名称
        const currentPath = this.$route.path;
        const currentRoute = this.adminRoutes.find(route => route.path === currentPath);
        if (currentRoute) {
            this.tag = currentRoute.name;
        }
    },
    
    watch: {
        // 监听路由变化，自动更新标题
        '$route'(to) {
            // 根据路由路径查找对应的路由对象
            const currentRoute = this.adminRoutes.find(route => route.path === to.path);
            if (currentRoute) {
                this.tag = currentRoute.name;
            }
        }
    },

    methods: {
        async updateUserInfo() {
            try {
                const userUpdateDTO = {
                    userAvatar: this.userInfo.url,
                    userName: this.userInfo.name,
                    userEmail: this.userInfo.email
                }
                const resposne = await this.$axios.put(`/user/update`, userUpdateDTO);
                const { data } = resposne;
                if (data.code === 200) {
                    this.dialogOperaion = false;
                    this.tokenCheckLoad();
                    this.$swal.fire({
                        title: '修改个人信息',
                        text: data.msg,
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1000,
                    });
                }
            } catch (e) {
                this.dialogOperaion = false;
                this.$swal.fire({
                    title: '修改个人信息异常',
                    text: e,
                    icon: 'error',
                    showConfirmButton: false,
                    timer: 2000,
                });
                console.error(`修改个人信息异常:${e}`);
            }
        },
        handleAvatarSuccess(res, file) {
            if (res.code !== 200) {
                this.$message.error(`头像上传异常`);
                return;
            }
            this.$message.success(`头像上传成功`);
            this.userInfo.url = res.data;
        },
        eventListener(event) {
            // 个人中心
            if (event === 'center') {
                this.dialogOperaion = true;
            }
            // 退出登录
            if (event === 'loginOut') {
                this.loginOut();
            }
        },
        async loginOut() {
            const confirmed = await this.$swalConfirm({
                title: '退出登录？',
                text: '退出后需重新登录',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '确认退出',
                cancelButtonText: '取消',
                confirmButtonColor: '#ff5722',
                cancelButtonColor: '#909399',
                customClass: {
                    popup: 'custom-delete-popup',
                    confirmButton: 'custom-delete-confirm-button',
                    cancelButton: 'custom-delete-cancel-button',
                    title: 'custom-delete-title',
                    content: 'custom-delete-content',
                    icon: 'custom-delete-icon'
                },
                buttonsStyling: true,
                iconColor: '#ff5722',
                backdrop: `rgba(0,0,0,0.4)`,
                heightAuto: false,
                padding: '2em'
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
        selectOperation(flag) {
            this.flag = flag;
        },
        handleRouteSelect(index) {
            let ary = this.adminRoutes.filter(entity => entity.path == index);
            this.tag = ary[0].name;
            if (this.$router.currentRoute.fullPath == index) {
                return;
            }
            this.$router.push(index);
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
    }
};
</script>
<style scoped lang="scss">
.menu-container {
    display: flex;
    height: 100vh;
    width: 100%;
    background: linear-gradient(to right, #f5f7fa, #e4e8f1);

    .menu-side {
        width: 230px;
        min-width: 230px;
        height: 100vh;
        padding-top: 5px;
        padding-right: 0;
        padding-bottom: 20px;
        box-sizing: border-box;
        transition: width 0.3s ease;
        background-color: transparent;
        display: flex;
        flex-direction: column;
    }

    .menu-side-narrow {
        width: 100px;
        min-width: 100px;
    }

    .main {
        flex-grow: 1;
        overflow-x: hidden;
        background-color: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
        border-radius: 16px;
        margin: 25px 10px 10px 5px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.02);

        .header-section {
            max-width: 100%;
            padding: 0;
            margin-top: 0;
        }

        .content-section {
            overflow-x: hidden;
            flex-grow: 1;
            padding: 0 20px 20px;
            box-sizing: border-box;
            overflow-y: auto;
            position: relative;
            height: calc(100vh - 85px); /* 调整高度，考虑到增加的margin-top */
        }
    }
}

/* 个人中心对话框样式 */
::v-deep .user-center-dialog {
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);

    .el-dialog__header {
        padding: 0 !important;
    }

    .el-dialog__body {
        padding: 0 !important;
    }

    .el-dialog__headerbtn {
        top: 15px;
        right: 15px;
    }
}

.user-center-title {
    background: linear-gradient(to right, #f5f7fa, #e4e8f1);
    padding: 16px 20px;
    margin-bottom: 5px;
    border-bottom: 1px solid #eaedf2;

    span {
        font-size: 17px;
        font-weight: 600;
        color: #333;
        position: relative;
        padding-left: 12px;

        &:before {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 4px;
            height: 16px;
            background-color: #409EFF;
            border-radius: 4px;
        }
    }
}

.user-center-content {
    padding: 10px 25px 15px;
}

.form-item {
    margin-bottom: 20px;
}

.form-label {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
    
    i {
        color: #409EFF;
        margin-right: 6px;
        font-size: 15px;
    }
    
    span {
        font-size: 14px;
        color: #409EFF;
        font-weight: 500;
    }
}

.avatar-wrapper {
    display: flex;
    justify-content: center;
    margin: 5px 0 15px;
}

.user-input {
    width: 90%;
    height: 36px;
    border: 1px solid #dcdfe6;
    border-radius: 8px;
    padding: 0 15px;
    font-size: 14px;
    transition: all 0.3s;
    margin: 0 auto;
    display: block;

    &:focus {
        outline: none;
        border-color: #409EFF;
        box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
    }
}

.user-center-footer {
    display: flex;
    justify-content: center;
    padding: 10px 0 15px;
    border-top: 1px solid #f0f0f0;
    margin-top: 10px;
}
</style>