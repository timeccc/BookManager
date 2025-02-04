<template>
    <div class="container1">
        <!-- 头像 -->
        <div>
            <p>*头像</p>
            <el-upload class="avatar-uploader" action="http://localhost:21090/api/book-manage-sys-api/v1.0/file/upload" :show-file-list="false"
                :on-success="handleAvatarSuccess">
                <img v-if="userAvatar" :src="userAvatar" style="width: 88px;height: 88px;">
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
            </el-upload>
        </div>
        <!-- 昵称 -->
        <div>
            <p>*昵称</p>
            <input class="dialog-input" v-model="userInfo.userName" placeholder="请输入" />
        </div>
        <!-- 邮箱 -->
        <div>
            <p>*邮箱</p>
            <input class="dialog-input" v-model="userInfo.userEmail" placeholder="请输入" />
        </div>
        <!-- 账号状态 -->
        <div>
            <div>
                <p style="font-size: 16px;">
                    *账号状态
                    <el-tooltip class="item" effect="dark" content="一经封号，不可登录，不可使用系统功能" placement="right">
                        <i class="el-icon-info"></i>
                    </el-tooltip>
                </p>
                <div>
                    <span v-if="!userInfo.isLogin" style="font-size: 14px;color: rgb(27, 156, 53);"><i
                            style="margin-right: 6px;" class="el-icon-circle-check"></i>正常</span>
                    <span v-else
                        style="font-size: 14px;color: rgb(230, 63, 49);text-decoration: underline;text-decoration-style: dashed;">
                        <i style="margin-right: 6px;" class="el-icon-warning-outline"></i>已被封禁</span>
                </div>
            </div>
            <div>
                <p style="font-size: 16px;">
                    *留言状态
                    <el-tooltip class="item" effect="dark" content="禁言后，互动功能受限" placement="right">
                        <i class="el-icon-info"></i>
                    </el-tooltip>
                </p>
                <div>
                    <span v-if="!userInfo.isWord" style="font-size: 14px;color: rgb(27, 156, 53);">
                        <i style="margin-right: 6px;" class="el-icon-circle-check"></i>正常</span>
                    <span v-else
                        style="font-size: 14px;color: rgb(230, 63, 49);text-decoration: underline;text-decoration-style: dashed;">
                        <i style="margin-right: 6px;" class="el-icon-warning-outline"></i>已被封禁</span>
                </div>
            </div>
            <div style="margin-top: 20px;text-align: center;">
                <el-button type="primary" class="customer" size="mini" @click="postInfo" round>立即修改</el-button>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    name: "Self",
    data() {
        return {
            userInfo: {},
            userAvatar: '',
        }
    },
    created() {
        this.auth();
    },
    methods: {
        // 提交个人信息修改
        async postInfo() {
            const { userName, userEmail } = this.userInfo;
            const userUpdateDTO = {
                userAvatar: this.userAvatar,
                userName,
                userEmail
            }
            const { data } = await this.$axios.put('/user/update', userUpdateDTO);
            this.$notify({
                position: 'buttom-right',
                duration: 1000,
                title: '编辑个人信息',
                message: data.code === 200 ? '编辑成功' : '编辑失败',
                type: data.code === 200 ? 'success' : 'error'
            });
            // 返回首页
            if (data.code === 200) {
                this.auth();
            }
        },
        // 头像上传
        handleAvatarSuccess(res, file) {
            this.$notify({
                duration: 1500,
                title: '头像上传',
                message: res.code === 200 ? '上传成功' : '上传失败',
                type: res.code === 200 ? 'success' : 'error'
            });
            // 上传成功则更新用户头像
            if (res.code === 200) {
                this.userAvatar = res.data;
            }
        },
        // Token 检验 ,取得用户信息
        async auth() {
            const { data } = await this.$axios.get('/user/auth');
            if (data.code !== 200) { // Token校验异常
                this.$router.push('/');
            } else {
                this.userInfo = data.data;
                this.userAvatar = data.data.userAvatar;
            }
        },
    }
};
</script>
<style scoped lang="scss">
.container {
    width: 500px;
    margin: 0 auto;
    padding: 0;
}
</style>
