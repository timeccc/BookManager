<template>
    <div class="main">
        <span style="margin-left: 20px;">
            <span class="operation-span" @click="operation">
                <i v-if="!showFlag" class="el-icon-s-fold i-folder"></i>
                <i v-else class="el-icon-s-unfold i-folder"></i>
            </span>
        </span>
        <span>
            <span class="operation-span-tag">
                &nbsp;&nbsp;{{ tag == '' ? '元数据' : tag }}
            </span>
        </span>
        <span class="user-block">
            <el-dropdown class="user-dropdown">
                <span class="el-dropdown-link" style="display: flex; align-items: center;">
                    <el-avatar :size="35" :src="userInfo.url" style="margin-top: 0;"></el-avatar>
                    <span class="userName" style="margin-left: 5px;font-size: 16px;">{{ userInfo.name }}</span>
                    <i class="el-icon-arrow-down el-icon--right" style="margin-left: 5px;"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item icon="el-icon-user-solid" @click.native="userCenterPanel">个人资料</el-dropdown-item>
                    <el-dropdown-item icon="el-icon-s-fold" @click.native="loginOut">退出登录</el-dropdown-item>
                </el-dropdown-menu>
            </el-dropdown>
        </span>
    </div>
</template>
<script>
export default {
    name: "LevelHeader",
    data() {
        return {
            showFlag: sessionStorage.getItem('flag') === 'true',
        };
    },
    props: {
        tag: {
            type: String,
            required: true,
            default: ''
        },
        userInfo: {
            type: Object,
            required: true,
            default: {}
        },
        bag: {
            type: String,
            default: ''
        },
    },
    methods: {
        // 个人中心，传回父组件处理
        userCenterPanel() {
            this.$emit('eventListener', 'center');
        },
        // 退出登录，传回父组件处理
        loginOut() {
            this.$emit('eventListener', 'loginOut');
        },
        operation() {
            this.showFlag = !this.showFlag;
            sessionStorage.setItem('flag', this.showFlag);
            this.$emit('selectOperation', this.showFlag);
        },
    }
};
</script>
<style scoped lang="scss">
.main {
    padding: 26px 30px 26px 0;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    width: 100%;
    position: relative;
    background-color: rgb(255, 255, 255);
    color: #666;

    .operation-span-tag {
        padding: 9px 10px;
        border-radius: 3px;
        font-size: 22px;
        font-family:'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
        user-select: none;
        margin-top: 15px;
    }

    .operation-span:hover {
        background-color: rgb(248, 248, 248);
    }

    .operation-span {
        margin-top: 20px;
        padding: 6px;
        border-radius: 3px;
        user-select: none;

        i {
            margin: 5px;
            font-size: 20px;
            color: #333;
        }
    }

    span {
        color: #333;
    }

    .user-block {
        position: absolute;
        right: 50px;

        .userName {
            display: inline-block;
            vertical-align: middle;
            font-size: 14px;
            cursor: pointer;
            user-select: none;
        }
    }
}
</style>