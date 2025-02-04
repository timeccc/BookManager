<template>
    <div class="menu-container">
        <div class="menu-side" :class="{ 'menu-side-narrow': flag }">
            <div style="display: flex;align-items: center;">
                <Logo name="图书后台" style="padding: 0 40px;margin: 15px 0;" :flag="flag" :bag="colorLogo" />
            </div>
            <div style="margin-top: 12px;">
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
        <el-dialog :show-close="false" :visible.sync="dialogOperaion" width="26%">
            <div slot="title" style="padding: 25px 0 0 20px;">
                <span style="font-size: 18px;font-weight: 800;">个人中心</span>
            </div>
            <el-row style="padding: 10px 20px 20px 20px;">
                <el-row>
                    <p style="font-size: 12px;padding: 3px 0;margin-bottom: 10px;">
                        <span class="modelName">*头像</span>
                    </p>
                    <el-upload class="avatar-uploader" action="/api/book-manage-sys-api/v1.0/file/upload"
                        :show-file-list="false" :on-success="handleAvatarSuccess">
                        <img v-if="userInfo.url" :src="userInfo.url" style="width: 80px;height: 80px;">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-row>
                <el-row>
                    <p style="font-size: 12px;padding: 3px 0;">
                        <span class="modelName">*用户名</span>
                    </p>
                    <input class="input-title" v-model="userInfo.name" placeholder="用户名">
                </el-row>
                <el-row>
                    <p style="font-size: 12px;padding: 3px 0;">
                        <span class="modelName">*用户邮箱</span>
                    </p>
                    <input class="input-title" v-model="userInfo.email" placeholder="用户邮箱">
                </el-row>
            </el-row>
            <span slot="footer" class="dialog-footer">
                <el-button class="customer" size="small" style="background-color: rgb(241, 241, 241);border: none;"
                    @click="dialogOperaion = false">取 消</el-button>
                <el-button size="small" style="background-color: #15559a;border: none;" class="customer" type="info"
                    @click="updateUserInfo">修改</el-button>
            </span>
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
            colorLogo: '#1c1c1c',
            bagMenu: 'rgb(248,248,248)',
            dialogOperaion: false
        };
    },
    created() {
        let menus = router.options.routes.filter(route => route.path == '/admin')[0];
        this.adminRoutes = menus.children;
        this.tokenCheckLoad();
        this.menuOperationHistory();
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
                text: `推出后需重新登录？`,
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


    .menu-side {
        width: 253px;
        min-width: 95px;
        height: 100vh;
        padding-top: 10px;
        box-sizing: border-box;
        transition: width 0.3s ease;
        background-color: rgb(248, 248, 248);
    }

    .menu-side-narrow {
        width: 115px;
    }

    .main {
        flex-grow: 1;
        overflow-x: hidden;

        .header-section {
            max-width: 100%;
            padding: 0 15px 0 0;
        }

        .content-section {
            overflow-x: hidden;
            flex-grow: 1;
            padding: 0 15px;
            box-sizing: border-box;
            overflow-y: auto;
        }
    }



}
</style>