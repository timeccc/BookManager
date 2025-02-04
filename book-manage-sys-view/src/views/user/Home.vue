<template>
    <div class="menu-container">
        <div class="menu-side" :class="{ 'menu-side-narrow': flag }">
            <div style="display: flex;align-items: center;justify-content: center;">
                <!-- <Logo name="图书管理" style="padding: 0 40px;margin: 15px 0;" :flag="flag" :bag="colorLogo" /> -->
                <img src="/logo.jpg" style="width: 220px;height: 100px;">
            </div>
            <div>
                <div v-if="route.show" :style="{
                    fontWeight: nowRoute.name === route.name ? '800' : '',
                    backgroundColor: nowRoute.name === route.name ? 'rgb(247, 247, 247)' : ''
                }" class="item-route" @click="routerClick(route)" v-for="(route, index) in userRoutes" :key="index">
                    <i :style="{ fontWeight: nowRoute.name === route.name ? '800' : '' }" :class="route.icon"></i>
                    {{ route.name }}
                </div>
                <div class="item-route">
                    <div class="info" @click="routerClickSelf">
                        <img :src="userInfo.url">
                        {{ userInfo.name }}
                    </div>
                </div>
            </div>
        </div>
        <div class="main">
            <div class="content-section">
                <router-view></router-view>
            </div>
        </div>
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
            selfPath: { name: '个人中心', path: '/mySelf' },
            userRoutes: [],
            activeIndex: '',
            userInfo: {
                id: null,
                url: '',
                name: '',
                role: null,
                email: ''
            },
            flag: false,
            nowRoute: {},
            tag: '留言板',
            bag: 'rgb(255, 255, 255)',
            colorLogo: '#1c1c1c',
            bagMenu: 'rgb(255, 255, 255)',
            dialogOperaion: false
        };
    },
    created() {
        let menus = router.options.routes.filter(route => route.path == '/user')[0];
        this.userRoutes = menus.children;

        this.tokenCheckLoad();
        this.menuOperationHistory();
        this.routerClick(this.userRoutes[0]);
    },

    methods: {
        routerClickSelf(){
            this.routerClick(this.selfPath);
        },
        routerClick(route) {
            console.log(route);
            
            this.handleRouteSelect(route);
        },
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
    }
};
</script>
<style scoped lang="scss">
.menu-container {
    display: flex;
    height: 100vh;
    width: 100%;

    .item-route {
        padding: 20px;
        margin-inline: 20px;
        border-radius: 10px;
        cursor: pointer;
        margin-block: 4px;
        display: flex;
        justify-content: left;
        align-items: center;
        gap: 6px;

        i {
            font-size: 20px;
        }

        .info {
            display: flex;
            justify-content: left;
            align-items: center;
            gap: 6px;
            font-weight: 800;

            img {
                width: 30px;
                height: 30px;
                border-radius: 50%;
            }
        }

    }

    .item-route:hover {
        background-color: rgb(247, 247, 247);
    }

    .menu-side {
        width: 253px;
        min-width: 95px;
        height: 100vh;
        padding-top: 10px;
        box-sizing: border-box;
        transition: width 0.3s ease;
        border-right: 1px solid rgb(245, 245, 245);
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