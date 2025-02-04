<template>
    <div>
        <ul class="nav">
            <li>
                <Logo />
            </li>
            <li v-if="!item.isHidden" :style="{
                fontSize: selectedIndex === index ? '18px' : '14px',
                color: selectedIndex === index ? '#1c1c1c' : 'rgb(102 102 102)'
            }" class="funItem" v-for="(item, index) in menus" :key="index" @click="menuClick(`${item.path}`, index)">
                <span>
                    <i :class="item.icon"></i>
                    <span>&nbsp; {{ item.name }}</span>
                </span>
            </li>
            <li>
                <el-row>
                    <el-col :span="18">
                        <input class="search-input" placeholder="搜索..." @keyup.enter="search" v-model="filterText" />
                    </el-col>
                    <el-col :span="6">
                        <span @click="search"
                            style="background-color: #000;color: #f1f1f1;border-radius: 5px;padding: 5px 10px;width: 100%;box-sizing: border-box;">
                            搜索
                        </span>
                    </el-col>
                </el-row>
            </li>
            <li style="position: absolute;right: 330px;">
                <span @click="healthDataRecord" style="margin:14px 10px;">
                    <i class="el-icon-edit-outline"></i>
                    指标记录
                </span>
            </li>
            <li style="position: absolute;right: 300px;">
                <el-badge style="margin-left: 5px;font-size: 16px;" v-if="noReadMsg !== 0" :value="noReadMsg">
                    <span class="message-span" @click="messageCenter">
                        <i class="el-icon-bell"></i>
                    </span>
                </el-badge>
                <span style="margin-left: 5px;font-size: 16px;" v-else class="message-span" @click="messageCenter">
                    <i class="el-icon-bell"></i>
                </span>
            </li>
            <li>
                <span class="user-block">
                    <el-dropdown class="user-dropdown">
                        <span class="el-dropdown-link" style="display: flex; align-items: center;">
                            <el-avatar :size="35" :src="userInfo.url" style="margin-top: 0;"></el-avatar>
                            <span class="userName" style="margin-left: 5px;font-size: 16px;">{{ userInfo.name }}</span>
                            <i class="el-icon-arrow-down el-icon--right" style="margin-left: 5px;"></i>
                        </span>
                        <el-dropdown-menu slot="dropdown">
                            <el-dropdown-item icon="el-icon-user"
                                @click.native="userCenterPanel">个人中心</el-dropdown-item>
                            <el-dropdown-item icon="el-icon-warning-outline"
                                @click.native="resetPwd">修改密码</el-dropdown-item>
                            <el-dropdown-item icon="el-icon-back" @click.native="loginOut">退出登录</el-dropdown-item>
                        </el-dropdown-menu>
                    </el-dropdown>
                </span>
            </li>
        </ul>
    </div>
</template>
<script>
import { clearToken } from "@/utils/storage.js";
import Logo from '@/components/Logo.vue';
export default {
    name: "UserMenu",
    components: {
        Logo
    },
    data() {
        return {
            selectedIndex: 0,
            messagePath: '/message',
            loginPath: '/login',
            sysName: '健康有道',
            defaultPath: '/news-record',
            filterText: '',
            noReadMsg: 0,
        }
    },
    props: {
        // 路由菜单数据
        menus: {
            type: Array,
            required: true
        },
        // 用户信息数据
        userInfo: {
            type: Object,
            required: true
        }
    },
    mounted() {
        this.pathToDo(this.defaultPath);
        this.loadMsgCount();
    },
    methods: {
        // 搜索关键词，返回父组件处理
        search() {
            // 如果当前是搜索页面了，更新关键词即可
            if (this.$route.path === '/search-detail') {
                sessionStorage.setItem('keyWord', this.filterText);
                return;
            }
            // 将关键词存起来
            sessionStorage.setItem('keyWord', this.filterText);
            this.$emit('eventListener', 'search-detail');
        },
        // 个人中心，传回父组件处理
        userCenterPanel() {
            this.$emit('eventListener', 'center');
        },
        // 重置密码，传回父组件处理
        resetPwd() {
            this.$emit('eventListener', 'resetPwd');
        },
        // 退出登录，传回父组件处理
        loginOut() {
            this.$emit('eventListener', 'loginOut');
        },
        // 记录饮食，传回父组件处理
        dietRecord() {
            this.$emit('eventListener', 'dietRecord');
        },
        // 记录个人健康指标，传回父组件处理
        healthDataRecord() {
            this.$emit('eventListener', 'healthDataRecord');
        },
        // 退出登录，传回父组件处理
        loginOut() {
            this.$emit('eventListener', 'loginOut');
        },
        async loadMsgCount() {
            const userInfo = sessionStorage.getItem('userInfo');
            const userInfoEntity = JSON.parse(userInfo);
            const messageQueryDto = { userId: userInfoEntity.id, isRead: false }
            const response = await this.$axios.post(`/message/query`, messageQueryDto);
            const { data } = response;
            if(data.code === 200){
                this.noReadMsg = data.data.length;
            }
        },
        // 不是存量路由，则跳转
        pathToDo(path) {
            if (this.$route.path !== path) {
                this.$router.push(path);
            }
        },
        //路由跳转
        menuClick(path, index) {
            this.selectedIndex = index;
            this.pathToDo(path);
        },
        // 消息中心
        messageCenter() {
            this.selectedIndex = null;
            this.pathToDo(this.messagePath);
        },
        // 退出登录
        async out() {
            const confirmed = await this.$swalConfirm({
                title: '是否退出登录',
                text: `退出后将重新登录，才能使用系统功能`,
                icon: 'warning',
            });
            if (confirmed) {
                this.$swal.fire({
                    title: '退出登录',
                    text: '您已成功退出登录。',
                    icon: 'success', // 使用'success'图标表示操作成功
                    showConfirmButton: false, // 隐藏确认按钮，使得弹窗只展示信息后自动关闭
                    timer: 1300, // 自动关闭弹窗的延迟时间，这里是2秒
                });
                setTimeout(() => {
                    clearToken();
                    this.$router.push('/loginPath');
                }, 1300)
            } else {
                console.log('用户取消了退出操作');
            }
        },
    }
}
</script>
<style scoped lang="scss">
.nav {
    padding: 12px 160px;
    height: 70px;
    line-height: 70px;
    list-style: none;
    border-bottom: 1px solid #f1f1f1;
    margin: 0;

    li {
        float: left;
        height: 70px;
        line-height: 70px;
        font-weight: 400;
        padding: 0 20px;
        user-select: none;
        color: rgb(102, 102, 102);
        font-size: 14px;
        transition: all 0.5s;

        i {
            color: rgb(102, 102, 102);
        }

        .message-span {
            padding: 5px;
            border-radius: 5px;

            i {
                font-size: 16px;
            }
        }

        .message-span:hover {
            background-color: rgb(240, 240, 240);
        }

        .search-input {
            outline: none;
            width: 100%;
            font-size: 14px;
            height: 35px;
            line-height: 35px;
            font-size: 16px;
            padding: 2px 30px;
            border-radius: 5px;
            transition: all 0.5s;
            border: 1px solid rgb(76, 77, 11);
            border-radius: 5px;
        }

        .search-button {
            background-color: #000;
            font-size: 16px;
            cursor: pointer;
            height: 30px;
            line-height: 30px;
        }

        .serch-input:focus {
            border: 1px solid rgb(188, 229, 247);
        }

    }
}

.user-block {
    position: absolute;
    right: 200px;

    .userName {
        display: inline-block;
        vertical-align: middle;
        font-size: 14px;
        cursor: pointer;
        user-select: none;
    }
}

.info-block {
    position: fixed;
    right: 10px;
    float: right;
    display: flex;
    align-items: center;
    flex-wrap: wrap;

    .search {
        display: flex;
        align-items: center;
        flex-wrap: wrap;

        span {
            font-size: 12px;
            padding: 0 8px;
        }

    }

    i {
        padding: 6px;
        border-radius: 3px;
        font-size: 20px;
    }

    i:hover {
        background-color: rgb(230, 230, 230);
    }

    .user-name {
        padding: 0 10px;
        color: #252933;
        font-weight: 400;
        margin: 0 10px;
        font-size: 14px;
    }

    .login-out {
        margin: 0 20px;
        width: 20px;
        height: 20px;
        padding: 6px;
        background-color: none !important;
        border-radius: 3px;
    }

    .login-out:hover {
        background-color: rgb(230, 230, 230);
    }
}
</style>