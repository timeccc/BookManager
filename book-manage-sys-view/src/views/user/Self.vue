<template>
    <div class="profile-container">
        <el-form :model="userInfo" ref="userForm" label-position="top" :rules="rules">
            <!-- 头像 -->
            <el-form-item label="头像" prop="userAvatar">
                <el-upload 
                    class="avatar-uploader" 
                    action="http://localhost:21090/api/book-manage-sys-api/v1.0/file/upload" 
                    :show-file-list="false"
                    :on-success="handleAvatarSuccess">
                    <img v-if="userAvatar" :src="userAvatar" class="avatar-image">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
            
            <!-- 昵称 -->
            <el-form-item label="昵称" prop="userName">
                <el-input 
                    v-model="userInfo.userName" 
                    placeholder="请输入昵称" 
                    maxlength="20"
                    show-word-limit>
                </el-input>
            </el-form-item>
            
            <!-- 邮箱 -->
            <el-form-item label="邮箱" prop="userEmail">
                <el-input 
                    v-model="userInfo.userEmail" 
                    placeholder="请输入邮箱"
                    maxlength="50"
                    show-word-limit>
                    <i slot="prefix" class="el-icon-message"></i>
                </el-input>
            </el-form-item>
            
            <!-- 账号状态信息 -->
            <el-card class="status-card">
                <div class="status-section">
                    <div class="status-header">
                        <span>账号状态</span>
                        <el-tooltip effect="dark" content="一经封号，不可登录，不可使用系统功能" placement="top">
                            <i class="el-icon-info"></i>
                        </el-tooltip>
                    </div>
                    <div class="status-value">
                        <span v-if="!userInfo.isLogin" class="status-normal">
                            <i class="el-icon-circle-check"></i> 正常
                        </span>
                        <span v-else class="status-banned">
                            <i class="el-icon-warning-outline"></i> 已被封禁
                        </span>
                    </div>
                </div>
                
                <el-divider></el-divider>
                
                <div class="status-section">
                    <div class="status-header">
                        <span>留言状态</span>
                        <el-tooltip effect="dark" content="禁言后，互动功能受限" placement="top">
                            <i class="el-icon-info"></i>
                        </el-tooltip>
                    </div>
                    <div class="status-value">
                        <span v-if="!userInfo.isWord" class="status-normal">
                            <i class="el-icon-circle-check"></i> 正常
                        </span>
                        <span v-else class="status-banned">
                            <i class="el-icon-warning-outline"></i> 已被禁言
                        </span>
                    </div>
                </div>
            </el-card>
            
            <!-- 提交按钮 -->
            <el-form-item>
                <el-button type="primary" @click="postInfo" :loading="loading">保存修改</el-button>
            </el-form-item>
        </el-form>
    </div>
</template>

<script>
export default {
    name: "Self",
    data() {
        return {
            userInfo: {},
            userAvatar: '',
            loading: false,
            rules: {
                userName: [
                    { required: true, message: '请输入昵称', trigger: 'blur' },
                    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
                ],
                userEmail: [
                    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
                    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
                ]
            }
        }
    },
    created() {
        this.auth();
    },
    methods: {
        // 提交个人信息修改
        async postInfo() {
            this.$refs.userForm.validate(async (valid) => {
                if (valid) {
                    this.loading = true;
                    try {
                        const { userName, userEmail } = this.userInfo;
                        const userUpdateDTO = {
                            userAvatar: this.userAvatar,
                            userName,
                            userEmail
                        }
                        const { data } = await this.$axios.put('/user/update', userUpdateDTO);
                        this.$notify({
                            position: 'top-right',
                            duration: 2000,
                            title: '个人信息',
                            message: data.code === 200 ? '修改成功' : '修改失败',
                            type: data.code === 200 ? 'success' : 'error'
                        });
                        // 更新数据
                        if (data.code === 200) {
                            this.auth();
                        }
                    } catch (error) {
                        this.$notify({
                            title: '提交失败',
                            message: error.message || '网络错误',
                            type: 'error'
                        });
                    } finally {
                        this.loading = false;
                    }
                }
            });
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
            try {
                const { data } = await this.$axios.get('/user/auth');
                if (data.code !== 200) { // Token校验异常
                    this.$router.push('/');
                } else {
                    this.userInfo = data.data;
                    this.userAvatar = data.data.userAvatar;
                }
            } catch (error) {
                this.$notify({
                    title: '获取用户信息失败',
                    message: error.message || '请检查网络连接',
                    type: 'error'
                });
            }
        },
    }
};
</script>

<style scoped lang="scss">
.profile-container {
    padding: 20px;
    max-width: 600px;
    margin: 0 auto;
    
    .avatar-uploader {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        width: 100px;
        height: 100px;
        display: flex;
        justify-content: center;
        align-items: center;
        
        &:hover {
            border-color: #ff5722;
        }
        
        .avatar-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar-uploader-icon {
            font-size: 28px;
            color: #8c939d;
            width: 100px;
            height: 100px;
            line-height: 100px;
            text-align: center;
        }
    }
    
    .status-card {
        margin-bottom: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        
        .status-section {
            padding: 10px 0;
            
            .status-header {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 15px;
                font-weight: 600;
                margin-bottom: 10px;
                
                i {
                    color: #909399;
                    cursor: help;
                }
            }
            
            .status-value {
                font-size: 14px;
                
                .status-normal {
                    color: #67c23a;
                    display: flex;
                    align-items: center;
                    gap: 5px;
                }
                
                .status-banned {
                    color: #f56c6c;
                    display: flex;
                    align-items: center;
                    gap: 5px;
                }
            }
        }
    }
    
    ::v-deep .el-form-item__label {
        line-height: 1.5;
        padding-bottom: 8px;
        font-size: 15px;
        font-weight: 500;
    }
    
    ::v-deep .el-input__inner {
        border-radius: 8px;
    }
    
    ::v-deep .el-form-item {
        margin-bottom: 25px;
    }
    
    ::v-deep .el-button {
        border-radius: 8px;
        padding: 12px 20px;
    }
}
</style>
