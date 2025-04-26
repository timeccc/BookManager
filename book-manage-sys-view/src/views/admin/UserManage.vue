<template>
    <el-row class="common-container">
        <el-row style="padding: 10px 16px;">
            <el-row>
                <el-select style="width: 100px;margin-right: 5px;" @change="fetchFreshData" size="small"
                    v-model="userQueryDto.isLogin" placeholder="登录状态">
                    <el-option v-for="item in loginStatuList" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                </el-select>
                <el-select style="width: 100px;margin-right: 5px;" @change="fetchFreshData" size="small"
                    v-model="userQueryDto.isWord" placeholder="禁言状态">
                    <el-option v-for="item in wordStatuList" :key="item.value" :label="item.label" :value="item.value">
                    </el-option>
                </el-select>
                <el-date-picker style="width: 216px;margin-right: 5px;" @change="fetchFreshData" size="small"
                    v-model="searchTime" type="daterange" range-separator="至" start-placeholder="注册开始"
                    end-placeholder="注册结束">
                </el-date-picker>
                <el-input size="small" style="width: 166px;" v-model="userQueryDto.userName" placeholder="用户名" clearable
                    @clear="handleFilterClear">
                    <el-button slot="append" @click="handleFilter" icon="el-icon-search"></el-button>
                </el-input>
                <span style="float: right;" class="edit-button" @click="add()">
                    新增用户
                </span>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 16px;border-top: 1px solid rgb(245,245,245);">
            <el-table :stripe="true" :data="tableData" class="custom-table">
                <el-table-column prop="userAvatar" width="68" label="头像">
                    <template slot-scope="scope">
                        <el-avatar :size="25" :src="scope.row.userAvatar" style="margin-top: 10px;"></el-avatar>
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
                        <i v-if="scope.row.isLogin" style="margin-right: 5px;" class="el-icon-warning"></i>
                        <i v-else style="margin-right: 5px;color: rgb(253, 199, 50);" class="el-icon-success"></i>
                        <el-tooltip v-if="scope.row.isLogin" class="item" effect="dark"
                            content="账号一经封号，不可登录系统。经由管理员解禁后，方可登录" placement="bottom-end">
                            <span style="text-decoration: underline;text-decoration-style: dashed;">已封号</span>
                        </el-tooltip>
                        <span v-else>正常</span>
                    </template>
                </el-table-column>
                <el-table-column prop="isWord" width="108" label="禁言">
                    <template slot-scope="scope">
                        <i v-if="scope.row.isWord" style="margin-right: 5px;" class="el-icon-warning"></i>
                        <i v-else style="margin-right: 5px;color: rgb(253, 199, 50);" class="el-icon-success"></i>
                        <el-tooltip v-if="scope.row.isWord" class="item" effect="dark"
                            content="账号一经禁言，不可评论互动。经由管理员解禁后，方可评论" placement="bottom-end">
                            <span style="text-decoration: underline;text-decoration-style: dashed;">已禁言</span>
                        </el-tooltip>
                        <span v-else>正常</span>
                    </template>
                </el-table-column>
                <el-table-column :sortable="true" prop="createTime" width="168" label="注册于"></el-table-column>
                <el-table-column label="操作" width="170">
                    <template slot-scope="scope">
                        <span class="text-button" @click="handleStatus(scope.row)">账号状态</span>
                        <span class="text-button" @click="handleEdit(scope.row)">编辑</span>
                        <span class="text-button" @click="handleDelete(scope.row)">删除</span>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin:10px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[10, 20]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <!-- 操作面板 -->
        <el-dialog :show-close="false" :visible.sync="dialogUserOperaion" width="25%">
            <div style="padding:16px 20px;">
                <el-row>
                    <p>用户头像</p>
                    <el-upload class="avatar-uploader"
                        action="http://localhost:21090/api/book-manage-sys-api/v1.0/file/upload" :show-file-list="false"
                        :on-success="handleAvatarSuccess">
                        <img v-if="userAvatar" :src="userAvatar" class="dialog-avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-row>
                <el-row>
                    <span class="dialog-hover">用户名</span>
                    <input class="dialog-input" v-model="data.userName" placeholder="用户名" />
                    <span class="dialog-hover">账号</span>
                    <input class="dialog-input" v-model="data.userAccount" placeholder="账号" />
                    <span class="dialog-hover">邮箱</span>
                    <input class="dialog-input" v-model="data.userEmail" placeholder="邮箱" />
                    <span class="dialog-hover">密码</span>
                    <input class="dialog-input" v-model="userPwd" type="password" placeholder="密码" />
                </el-row>
            </div>
            <span slot="footer" class="dialog-footer" style="margin-top: 10px;">
                <span class="channel-button" @click="cannel()">
                    取消操作
                </span>
                <span v-if="!isOperation" class="edit-button" @click="addOperation()">
                    确定新增
                </span>
                <span v-else class="edit-button" @click="updateOperation()">
                    确定修改
                </span>
            </span>
        </el-dialog>
        <el-dialog :show-close="false" :visible.sync="dialogStatusOperation" width="18%">
            <div style="padding:30px 20px 0 20px;">
                <el-row>
                    <p>*封号状态</p>
                    <el-switch v-model="data.isLogin" active-text="封号" inactive-text="正常状态">
                    </el-switch>
                </el-row>
                <el-row style="margin: 20px 0;">
                    <p>*禁言状态</p>
                    <el-switch v-model="data.isWord" active-text="禁言" inactive-text="正常状态">
                    </el-switch>
                </el-row>
                <el-row style="margin: 20px 0;">
                    <p>*是否设置为管理员</p>
                    <el-switch v-model="isAdmin" active-text="管理员" inactive-text="普通用户">
                    </el-switch>
                </el-row>
            </div>
            <span slot="footer" class="dialog-footer">
                <span class="channel-button" @click="cannel()">
                    取消操作
                </span>
                <span class="edit-button" @click="comfirmStatus()">
                    确定设置
                </span>
            </span>
        </el-dialog>
    </el-row>
</template>

<script>
export default {
    data() {
        return {
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
    background-color: #FFFFFF;
    padding: 20px 0;
    border-radius: 16px;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    box-sizing: border-box;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.03);
}

.text-button {
    color: #409EFF;
    margin-right: 8px;
    cursor: pointer;
    font-size: 14px;
    
    &:hover {
        color: #66b1ff;
        text-decoration: underline;
    }
}

.edit-button {
    display: inline-block;
    padding: 7px 15px;
    background-color: #409EFF;
    color: white;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.3s;
    
    &:hover {
        background-color: #66b1ff;
    }
}

.channel-button {
    display: inline-block;
    padding: 7px 15px;
    background-color: #f2f6fc;
    color: #606266;
    border-radius: 4px;
    margin-right: 10px;
    cursor: pointer;
    
    &:hover {
        background-color: #edf2fc;
    }
}

.custom-table {
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 20px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}

.dialog-input {
    width: 100%;
    padding: 8px 10px;
    margin-bottom: 15px;
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    box-sizing: border-box;
    
    &:focus {
        outline: none;
        border-color: #409EFF;
    }
}

.dialog-hover {
    display: block;
    margin-bottom: 5px;
    font-size: 14px;
    color: #606266;
}

.dialog-avatar {
    width: 80px;
    height: 80px;
    display: block;
    margin-bottom: 15px;
    border-radius: 4px;
}

.avatar-uploader {
    margin-bottom: 15px;
}

.avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 80px;
    height: 80px;
    line-height: 80px;
    text-align: center;
    border: 1px dashed #d9d9d9;
    border-radius: 4px;
    cursor: pointer;
}
</style>