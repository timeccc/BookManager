<template>
    <el-row class="common-container">
        <el-row class="filter-row">
            <el-select style="width: 120px; margin-right: 10px;" @change="fetchFreshData" size="small"
                    v-model="userQueryDto.isLogin" placeholder="登录状态">
                    <el-option v-for="item in loginStatuList" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                </el-select>
            <el-select style="width: 120px; margin-right: 10px;" @change="fetchFreshData" size="small"
                    v-model="userQueryDto.isWord" placeholder="禁言状态">
                    <el-option v-for="item in wordStatuList" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                </el-select>
            <el-date-picker style="width: 240px; margin-right: 10px;" @change="fetchFreshData" size="small"
                    v-model="searchTime" type="daterange" range-separator="-" start-placeholder="注册开始"
                    end-placeholder="注册结束">
                </el-date-picker>
            <el-input size="small" style="width: 180px; margin-right: 5px;" v-model="userQueryDto.userName" placeholder="用户名" clearable
                    @clear="handleFilterClear">
            </el-input>
            <el-button size="small" @click="handleFilter" icon="el-icon-search"></el-button>
            <span class="new-user-btn" @click="add()">
                    新增用户
                </span>
        </el-row>
        <el-row class="table-container">
            <el-table :data="tableData" class="custom-table">
                <el-table-column prop="userAvatar" width="68" label="头像">
                    <template slot-scope="scope">
                        <el-avatar :size="25" :src="scope.row.userAvatar"></el-avatar>
                    </template>
                </el-table-column>
                <el-table-column prop="userName" label="名称"></el-table-column>
                <el-table-column prop="userAccount" width="128" label="账号"></el-table-column>
                <el-table-column prop="userEmail" width="168" label="邮箱"></el-table-column>
                <el-table-column prop="userRole" width="68" label="角色">
                    <template slot-scope="scope">
                        <span>{{ scope.row.userRole === 1 ? '管理员' : '用户' }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="isLogin" width="108" label="封号">
                    <template slot-scope="scope">
                        <i v-if="scope.row.isLogin" style="margin-right: 5px;color: #E6A23C;" class="el-icon-warning"></i>
                        <i v-else style="margin-right: 5px;color: #67C23A;" class="el-icon-success"></i>
                        <el-tooltip v-if="scope.row.isLogin" class="item" effect="dark"
                            content="账号一经封号，不可登录系统。经由管理员解禁后，方可登录" placement="bottom-end">
                            <span style="text-decoration: underline;text-decoration-style: dashed;">已封号</span>
                        </el-tooltip>
                        <span v-else>正常</span>
                    </template>
                </el-table-column>
                <el-table-column prop="isWord" width="108" label="禁言">
                    <template slot-scope="scope">
                        <i v-if="scope.row.isWord" style="margin-right: 5px;color: #E6A23C;" class="el-icon-warning"></i>
                        <i v-else style="margin-right: 5px;color: #67C23A;" class="el-icon-success"></i>
                        <el-tooltip v-if="scope.row.isWord" class="item" effect="dark"
                            content="账号一经禁言，不可评论互动。经由管理员解禁后，方可评论" placement="bottom-end">
                            <span style="text-decoration: underline;text-decoration-style: dashed;">已禁言</span>
                        </el-tooltip>
                        <span v-else>正常</span>
                    </template>
                </el-table-column>
                <el-table-column :sortable="true" prop="createTime" width="168" label="注册于"></el-table-column>
                <el-table-column label="操作" width="200" align="center">
                    <template slot-scope="scope">
                        <div class="action-buttons">
                            <el-tag type="warning" size="small" @click.native="handleStatus(scope.row)" class="action-tag status-tag">
                                账号状态
                            </el-tag>
                            <el-tag type="primary" size="small" @click.native="handleEdit(scope.row)" class="action-tag edit-tag">
                                编辑
                            </el-tag>
                            <el-tag type="danger" size="small" @click.native="handleDelete(scope.row)" class="action-tag delete-tag">
                                删除
                            </el-tag>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[10, 20]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <!-- 操作面板 -->
        <el-dialog :show-close="false" :visible.sync="dialogUserOperaion" width="460px" custom-class="user-dialog" top="20vh" append-to-body>
            <div class="dialog-wrapper">
                <div class="dialog-header">
                    <h3 class="dialog-title">用户信息</h3>
                </div>
                <div class="dialog-content">
                    <div class="user-form">
                        <div class="avatar-section">
                            <p class="form-label"><i class="el-icon-user"></i> 用户头像</p>
                            <el-upload 
                                class="avatar-uploader"
                                :action="uploadUrl" 
                                :show-file-list="false"
                                :on-success="handleAvatarSuccess">
                                <div class="avatar-container">
                                    <img v-if="userAvatar" :src="userAvatar" class="dialog-avatar">
                                    <div v-else class="avatar-placeholder">
                                        <i class="el-icon-plus"></i>
                                    </div>
                                    <div class="avatar-hover">
                                        <i class="el-icon-camera"></i>
                                        <span>更换头像</span>
                                    </div>
                                </div>
                            </el-upload>
                        </div>
                        <div class="form-section">
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label"><i class="el-icon-user-solid"></i> 用户名</label>
                                    <el-input v-model="data.userName" placeholder="请输入用户名" size="medium"></el-input>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="el-icon-medal"></i> 账号</label>
                                    <el-input v-model="data.userAccount" placeholder="请输入账号" size="medium"></el-input>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label"><i class="el-icon-message"></i> 邮箱</label>
                                    <el-input v-model="data.userEmail" placeholder="请输入邮箱" size="medium"></el-input>
                                </div>
                                <div class="form-group">
                                    <label class="form-label"><i class="el-icon-lock"></i> 密码</label>
                                    <el-input v-model="userPwd" type="password" placeholder="请输入密码" size="medium" show-password></el-input>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="dialog-footer">
                    <el-button class="cancel-btn" size="small" @click="cannel()">取消操作</el-button>
                    <el-button v-if="!isOperation" class="confirm-btn" type="primary" size="small" @click="addOperation()">确定新增</el-button>
                    <el-button v-else class="confirm-btn" type="primary" size="small" @click="updateOperation()">确定修改</el-button>
                </div>
            </div>
        </el-dialog>
        <el-dialog :show-close="false" :visible.sync="dialogStatusOperation" width="360px" custom-class="status-dialog" top="20vh" append-to-body>
            <div class="dialog-wrapper">
                <div class="dialog-header">
                    <h3 class="dialog-title">账号状态设置</h3>
                </div>
                <div class="dialog-content">
                    <div class="switch-item">
                        <div class="switch-label">
                            <i class="el-icon-lock"></i>
                            <span>封号状态</span>
                        </div>
                        <el-switch v-model="data.isLogin" active-text="封号" inactive-text="正常状态"></el-switch>
                    </div>
                    <div class="switch-item">
                        <div class="switch-label">
                            <i class="el-icon-turn-off"></i>
                            <span>禁言状态</span>
                        </div>
                        <el-switch v-model="data.isWord" active-text="禁言" inactive-text="正常状态"></el-switch>
                    </div>
                    <div class="switch-item">
                        <div class="switch-label">
                            <i class="el-icon-user"></i>
                            <span>用户角色</span>
                        </div>
                        <el-switch v-model="isAdmin" active-text="管理员" inactive-text="普通用户"></el-switch>
                    </div>
                </div>
                <div class="dialog-footer">
                    <el-button class="cancel-btn" size="small" @click="cannel()">取消操作</el-button>
                    <el-button class="confirm-btn" type="primary" size="small" @click="comfirmStatus()">确认设置</el-button>
                </div>
            </div>
        </el-dialog>
    </el-row>
</template>

<script>
import { getUploadUrl } from "@/utils/urlHelper.js";

export default {
    data() {
        return {
            uploadUrl: getUploadUrl(),
            userPwd: '',
            userAvatar: '',
            data: {},
            filterText: '',
            isAdmin: false, // 是否是管理员标志，初始值为false
            currentPage: 1,
            pageSize: 10,
            totalItems: 0,
            dialogStatusOperation: false,
            dialogUserOperaion: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            searchTime: [],
            selectedRows: [],
            status: null,
            userQueryDto: {}, // 搜索条件
            loginStatuList: [{ value: null, label: '全部' }, { value: 0, label: '正常' }, { value: 1, label: '封号' }],
            wordStatuList: [{ value: null, label: '全部' }, { value: 0, label: '正常' }, { value: 1, label: '禁言' }],
            rolesList: [{ value: null, label: '全部' }, { value: 2, label: '用户' }, { value: 1, label: '管理员' }]
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        cannel() {
            this.data = {};
            this.userAvatar = '';
            this.userPwd = '';
            this.dialogUserOperaion = false;
            this.dialogStatusOperation = false;
            this.isOperation = false;
            // 清理多余的遮罩层
            this.$nextTick(() => {
                const modals = document.querySelectorAll('.v-modal');
                if (modals.length > 1) {
                    for (let i = 1; i < modals.length; i++) {
                        modals[i].parentNode.removeChild(modals[i]);
                    }
                }
                // 移除body上的dialog样式
                document.body.classList.remove('el-popup-parent--hidden');
            });
        },
        comfirmStatus() {
            const userUpdateDto = {
                id: this.data.id,
                isLogin: this.data.isLogin,
                userRole: this.isAdmin ? 1 : 2,
                isWord: this.data.isWord
            }
            this.$axios.put(`/user/backUpdate`, userUpdateDto).then(res => {
                if (res.data.code === 200) {
                    this.$notify({
                        duration: 1500,
                        title: '信息修改',
                        message: '修改成功',
                        type: 'success'
                    });
                    this.cannel();
                    this.fetchFreshData();
                }
            }).catch(error => {
                console.log("修改状态异常：" + error);
            })
        },
        // 修改用户状态
        handleStatus(data) {
            // 设置用户角色
            this.isAdmin = data.userRole === 1;
            this.dialogStatusOperation = true;
            this.data = data;
        },
        // 头像上传回调函数
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
        // 批量删除数据
        async batchDelete() {
            if (!this.selectedRows.length) {
                this.$message(`未选中任何数据`);
                return;
            }
            const confirmed = await this.$swalConfirm({
                title: '删除用户数据',
                text: `删除后不可恢复，是否继续？`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                confirmButtonColor: '#f56c6c',
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
                iconColor: '#f56c6c',
                backdrop: `rgba(0,0,0,0.4)`,
                heightAuto: false,
                padding: '2em'
            });
            
            if (confirmed) {
                try {
                    let ids = this.selectedRows.map(entity => entity.id);
                    const response = await this.$axios.post(`/user/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$notify({
                            duration: 1000,
                            title: '信息删除',
                            message: '删除成功',
                            type: 'success'
                        });
                        this.fetchFreshData();
                        return;
                    }
                } catch (error) {
                    this.$message.error("用户信息删除异常：", error);
                    console.error(`用户信息删除异常：`, error);
                }
            }
        },
        // 修改信息
        async updateOperation() {
            if (this.userPwd !== '') {
                const pwd = this.$md5(this.$md5(this.userPwd));
                this.data.userPwd = pwd;
            } else {
                this.data.userPwd = null;
            }
            this.data.userAvatar = this.userAvatar;
            try {
                const response = await this.$axios.put('/user/backUpdate', this.data);
                if (response.data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '信息修改',
                        message: '修改成功',
                        type: 'success'
                    });
                    this.cannel();
                    this.fetchFreshData();
                }
            } catch (error) {
                console.error('修改出错:', error);
            }
        },
        // 信息新增
        async addOperation() {
            //  密码处理
            if (this.userPwd !== '') {
                this.data.userPwd = this.$md5(this.$md5(this.userPwd));
            } else {
                this.data.userPwd = null;
            }
            this.data.userAvatar = this.userAvatar;
            try {
                const response = await this.$axios.post('/user/insert', this.data);
                if (response.data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '信息新增',
                        message: '新增成功',
                        type: 'success'
                    });
                    this.cannel();
                    this.fetchFreshData();
                }else{
                    this.$notify({
                        duration: 1000,
                        title: '信息新增',
                        message: response.data.msg,
                        type: 'info'
                    });
                }
            } catch (error) {
                console.error('信息新增出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        async fetchFreshData() {
            try {
                this.tableData = [];
                let startTime = null;
                let endTime = null;
                if (this.searchTime != null && this.searchTime.length === 2) {
                    const [startDate, endDate] = await Promise.all(this.searchTime.map(date => date.toISOString()));
                    startTime = `${startDate.split('T')[0]}T00:00:00`;
                    endTime = `${endDate.split('T')[0]}T23:59:59`;
                }
                // 请求参数
                const params = {
                    current: this.currentPage,
                    size: this.pageSize,
                    key: this.filterText,
                    startTime: startTime,
                    endTime: endTime,
                    ...this.userQueryDto
                };
                const response = await this.$axios.post('/user/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                this.$message.error("查询用户信息异常:", error);
                console.error('查询用户信息异常:', error);
            }
        },
        add() {
            this.dialogUserOperaion = true;
        },
        handleFilter() {
            this.currentPage = 1;
            this.fetchFreshData();
        },
        handleFilterClear() {
            this.filterText = '';
            this.handleFilter();
        },
        handleSizeChange(val) {
            this.pageSize = val;
            this.currentPage = 1;
            this.fetchFreshData();
        },
        handleCurrentChange(val) {
            this.currentPage = val;
            this.fetchFreshData();
        },
        handleEdit(row) {
            this.dialogUserOperaion = true;
            this.isOperation = true;
            row.userPwd = null;
            this.userAvatar = row.userAvatar;
            this.data = { ...row }
        },
        handleDelete(row) {
            this.selectedRows.push(row);
            this.batchDelete();
        }
    },
};
</script>
<style scoped lang="scss">
.common-container {
    padding: 10px;
    border-radius: 16px;
    background-color: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(10px);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
}

.filter-row {
    display: flex;
    align-items: center;
    padding: 10px 16px;
    margin-bottom: 5px;
}

.table-container {
    margin: 10px 16px;
    border-top: none;
}

.new-user-btn {
    padding: 7px 20px;
    background-color: #409EFF;
    color: white;
    border-radius: 20px;
    cursor: pointer;
    transition: all 0.3s;
    margin-left: auto;
    font-size: 14px;
    box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
    
    &:hover {
        background-color: #66b1ff;
        transform: translateY(-1px);
    }
}

/* 按钮统一样式 */
.text-button {
    margin-right: 10px;
    cursor: pointer;
    font-size: 13px;
    display: inline-block;
    height: 20px;
    line-height: 20px;
    
    &:hover {
        text-decoration: underline;
    }
    
    &.status-btn {
        color: #E6A23C;
        
        &:hover {
            color: #f0b556;
        }
    }
    
    &.edit-btn {
        color: #409EFF;
        
        &:hover {
            color: #66b1ff;
        }
    }
    
    &.delete-btn {
        color: #F56C6C;
        
        &:hover {
            color: #ff8c8c;
        }
    }
}

/* 表格样式 */
.custom-table {
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 20px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
    border: none;
    
    ::v-deep .el-table__header-wrapper {
        th {
        background-color: #f5f7fa;
        color: #606266;
        font-weight: 600;
        padding: 12px 0;
        }
    }
    
    ::v-deep .el-table__body-wrapper {
        .el-table__row {
        transition: all 0.3s;
        
        &:hover {
            background-color: #f0f9ff !important;
        }
        
        td {
            padding: 10px 0;
            vertical-align: middle;
            height: 40px;
            line-height: 20px;
            border-bottom: 1px solid #ebeef5;
            }
        }
    }
    
    ::v-deep .el-table__empty-block {
        min-height: 60px;
    }
    
    ::v-deep .el-table__header, 
    ::v-deep .el-table__body {
        border: none;
    }
    
    &::before, 
    &::after,
    ::v-deep .el-table--border::after, 
    ::v-deep .el-table--group::after {
        display: none;
    }
}

/* 分页样式美化 */
::v-deep .el-pagination {
    .el-pagination__total {
        font-weight: 500;
    }
    
    .el-pagination__sizes {
        .el-input .el-input__inner {
        border-radius: 4px;
        transition: all 0.3s;
        
        &:hover, &:focus {
            border-color: #409EFF;
            }
        }
    }
    
    .el-pager li {
        border-radius: 4px;
        transition: all 0.3s;
        
        &:hover {
            color: #409EFF;
        }
        
        &.active {
            background-color: #409EFF;
            color: #fff;
        }
    }
    
    .btn-prev, .btn-next {
        border-radius: 4px;
        
        &:hover {
            color: #409EFF;
        }
    }
}

/* 用户信息对话框样式 */
.user-dialog, .status-dialog {
    ::v-deep .el-dialog {
        border-radius: 16px;
        overflow: hidden;
        background-color: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
        margin-top: 0 !important;
        position: relative;
        z-index: 3000 !important;
    }
    
    ::v-deep .v-modal {
        z-index: 2999 !important;
    }
}

.dialog-wrapper {
    display: flex;
    flex-direction: column;
    overflow: hidden;
    max-height: 80vh;
}

.dialog-header {
    background: linear-gradient(135deg, #e0eaff, #f2e6ff);
    padding: 16px 20px;
    position: relative;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.dialog-title {
    font-size: 18px;
    font-weight: 600;
    color: #333;
    margin: 0;
    position: relative;
    padding-left: 12px;
    
    &:before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 18px;
        background: linear-gradient(to bottom, #409EFF, #a18cd1);
        border-radius: 2px;
    }
}

.dialog-content {
    padding: 20px;
    background-color: white;
    overflow-y: auto;
}

.dialog-footer {
    padding: 16px 20px;
    background-color: rgba(245, 247, 250, 0.8);
    text-align: right;
    border-top: 1px solid rgba(0, 0, 0, 0.05);
}

.user-form {
    display: flex;
    flex-direction: column;
}

.avatar-section {
    width: 100%;
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.form-section {
    width: 100%;
}

.form-label {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
    font-weight: 500;
    color: #606266;
    
    i {
        margin-right: 5px;
        color: #409EFF;
    }
}

.form-row {
    display: flex;
    gap: 15px;
    margin-bottom: 15px;
}

.form-group {
    flex: 1;
}

.avatar-container {
    position: relative;
    width: 100px;
    height: 100px;
    border-radius: 50%;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    transition: all 0.3s;
    
    &:hover {
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
        
        .avatar-hover {
            opacity: 1;
        }
    }
}

.dialog-avatar {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.avatar-placeholder {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px dashed #d9d9d9;
    border-radius: 50%;
    background-color: #fafafa;
    
    i {
        font-size: 30px;
        color: #c0c4cc;
    }
}

.avatar-hover {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-color: rgba(0, 0, 0, 0.5);
    border-radius: 50%;
    opacity: 0;
    transition: opacity 0.3s;
    
    i {
        color: white;
        font-size: 20px;
        margin-bottom: 4px;
    }
    
    span {
        color: white;
        font-size: 12px;
    }
}

/* 按钮样式 */
.cancel-btn, .confirm-btn {
    padding: 8px 20px;
    border-radius: 20px;
    cursor: pointer;
    margin-left: 10px;
    font-size: 14px;
    transition: all 0.3s;
}

.cancel-btn {
    background-color: #f5f7fa;
    color: #606266;
    border: 1px solid #dcdfe6;

    &:hover {
        color: #409EFF;
        border-color: #c6e2ff;
        background-color: #ecf5ff;
        transform: translateY(-1px);
    }
}

.confirm-btn {
    background: linear-gradient(to right, #409EFF, #64b0ff);
    color: white;
    border: none;
    box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);

    &:hover {
        background: linear-gradient(to right, #48a6ff, #70baff);
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
    }
}

/* 状态对话框样式 */
.status-dialog {
    ::v-deep .el-switch__label {
        color: #606266;
        
        &.is-active {
            color: #409EFF;
        }
    }
}

.switch-item {
    margin-bottom: 20px;
    display: flex;
    flex-direction: column;
    
    &:last-child {
        margin-bottom: 0;
    }
}

.switch-label {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    font-weight: 500;
    
    i {
        font-size: 16px;
        margin-right: 8px;
        color: #409EFF;
    }
    
    span {
        color: #606266;
    }
}

/* 标签样式 */
.action-tag {
    cursor: pointer;
    transition: all 0.2s;
    margin: 0 4px;
    
    &:hover {
        opacity: 0.8;
        transform: scale(1.05);
    }
    
    &.status-tag {
        background-color: #fdf6ec;
        color: #E6A23C;
        border-color: #faecd8;
    }
    
    &.edit-tag {
        background-color: #ecf5ff;
        color: #409EFF;
        border-color: #d9ecff;
    }
    
    &.delete-tag {
        background-color: #fef0f0;
        color: #F56C6C;
        border-color: #fde2e2;
    }
}

.action-buttons {
    display: flex;
    justify-content: center;
    flex-wrap: nowrap;
}
</style>