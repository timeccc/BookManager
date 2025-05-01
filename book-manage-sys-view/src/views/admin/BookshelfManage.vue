<template>
    <el-row style="background-color: #FFFFFF;padding: 20px 0;border-radius: 5px;">
        <el-row style="padding: 10px;margin: 0 10px;">
            <el-row>
                <span class="top-bar">楼层</span>
                <el-input size="small" style="width: 188px;margin-right: 10px;" v-model="bookshelfQueryDto.floor"
                    placeholder="楼层" clearable @clear="handleFilterClear">
                </el-input>
                <el-button size="small" class="customer"
                    style="background-color: rgb(235, 237, 245);color: rgb(43, 121, 203);border: none;" type="primary"
                    @click="handleFilter">立即查询</el-button>
                <el-button size="small"
                    style="background-color: rgb(235, 237, 245);color: rgb(43, 121, 203);border: none;" class="customer"
                    type="info" @click="add()">新增书架</el-button>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 20px;">
            <el-table :data="tableData">
                <el-table-column prop="floor" label="书架所在楼层"></el-table-column>
                <el-table-column prop="area" width="188" label="书架所在区域"></el-table-column>
                <el-table-column prop="frame" width="148" label="书架名"></el-table-column>
                <el-table-column label="操作">
                    <template slot-scope="scope" width="120">
                        <span class="text-button" @click="handleEdit(scope.row)">编辑</span>
                        <span class="text-button" @click="handleDelete(scope.row)">删除</span>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[5, 7]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <el-dialog :visible.sync="dialogOperation" width="25%" custom-class="bookshelf-dialog">
            <div class="dialog-header">
                <h3 class="dialog-title">{{ !isOperation ? '新增书架' : '修改书架' }}</h3>
            </div>
            <div class="dialog-content">
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-office-building"></i> 书架所在楼层</label>
                    <el-input class="custom-input" v-model="data.floor" placeholder="请输入楼层"></el-input>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-location"></i> 书架所在区域</label>
                    <el-input class="custom-input" v-model="data.area" placeholder="请输入区域"></el-input>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-collection"></i> 书架名</label>
                    <el-input class="custom-input" v-model="data.frame" placeholder="请输入书架名称"></el-input>
                </div>
            </div>
            <div class="dialog-footer">
                <el-button class="cancel-btn" size="small" @click="dialogOperation = false">取消</el-button>
                <el-button class="confirm-btn" size="small" v-if="!isOperation" type="primary" @click="addOperation">新增</el-button>
                <el-button class="confirm-btn" size="small" v-else type="primary" @click="updateOperation">修改</el-button>
            </div>
        </el-dialog>
    </el-row>
</template>

<script>
export default {
    data() {
        return {
            data: {},
            currentPage: 1,
            cover: null,
            pageSize: 7,
            totalItems: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            bookshelfQueryDto: {}, // 搜索条件
            options: []
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        // 多选框选中
        handleSelectionChange(selection) {
            this.selectedRows = selection;
        },
        // 批量删除数据
        async batchDelete() {
            if (!this.selectedRows.length) {
                this.$message(`未选中任何数据`);
                return;
            }
            const confirmed = await this.$swalConfirm({
                title: '删除书架数据',
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
                    const response = await this.$axios.post(`bookshelf/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$swal.fire({
                            title: '删除成功',
                            text: response.data.msg,
                            icon: 'success',
                            showConfirmButton: false,
                            timer: 2000,
                        });
                        this.fetchFreshData();
                        return;
                    }
                } catch (e) {
                    this.$swal.fire({
                        title: '错误提示',
                        text: e,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 2000,
                    });
                    console.error(`书架信息删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.bookshelfQueryDto = {};
            this.fetchFreshData();
        },
        // 修改信息
        async updateOperation() {
            try {
                this.data.cover = this.cover;
                const response = await this.$axios.put('/bookshelf/update', this.data);
                this.$swal.fire({
                    title: '书架信息修改',
                    text: response.data.msg,
                    icon: response.data.code === 200 ? 'success' : 'error',
                    showConfirmButton: false,
                    timer: 1000,
                });
                if (response.data.code === 200) {
                    this.closeDialog();
                    this.fetchFreshData();
                    this.clearFormData();
                }
            } catch (error) {
                console.error('提交表单时出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        // 信息新增
        async addOperation() {
            try {
                this.data.cover = this.cover;
                const response = await this.$axios.post('/bookshelf/save', this.data);
                this.$message[response.data.code === 200 ? 'success' : 'error'](response.data.msg);
                if (response.data.code === 200) {
                    this.closeDialog();
                    this.fetchFreshData();
                    this.clearFormData();
                }
            } catch (error) {
                console.error('提交表单时出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        closeDialog() {
            this.dialogOperation = false;
        },
        clearFormData() {
            this.data = {};
            this.cover = null;
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
                    startTime: startTime,
                    endTime: endTime,
                    ...this.bookshelfQueryDto
                };
                const response = await this.$axios.post('/bookshelf/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询书架信息异常:', error);
            }
        },
        add() {
            this.dialogOperation = true;
        },
        handleFilter() {
            this.currentPage = 1;
            this.fetchFreshData();
        },
        handleFilterClear() {
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
        messagePush(row) {
            this.data = { ...row };
        },
        handleEdit(row) {
            this.dialogOperation = true;
            this.isOperation = true;
            this.data = { ...row };
            this.cover = row.cover;
        },
        handleDelete(row) {
            this.selectedRows.push(row);
            this.batchDelete();
        }
    },
};
</script>
<style scoped lang="scss">
.list-cover {
    width: 50px;
    height: 70px;
    border-radius: 5px;
}

/* 对话框样式 */
.bookshelf-dialog {
    border-radius: 8px;
    overflow: hidden;
    
    :deep(.el-dialog__header) {
        display: none;
    }
    
    :deep(.el-dialog__body) {
        padding: 0;
    }
    
    :deep(.el-dialog__footer) {
        display: none;
    }
}

.dialog-header {
    background-color: #f9f9f9;
    padding: 16px 20px;
    border-bottom: 1px solid #ebeef5;
}

.dialog-title {
    font-size: 16px;
    font-weight: 600;
    color: #303133;
    margin: 0;
    padding: 0;
    position: relative;
    display: inline-block;
    
    &:after {
        content: '';
        position: absolute;
        bottom: -6px;
        left: 0;
        width: 30px;
        height: 2px;
        background-color: #409EFF;
    }
}

.dialog-content {
    padding: 20px;
}

.dialog-footer {
    padding: 10px 20px 20px;
    text-align: right;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

.form-group {
    margin-bottom: 20px;
}

.form-label {
    font-size: 14px;
    color: #606266;
    margin-bottom: 8px;
    font-weight: 500;
    display: block;
    
    i {
        margin-right: 5px;
        color: #409EFF;
    }
}

.custom-input {
    :deep(.el-input__inner) {
        border-radius: 4px;
        transition: all 0.3s;
        height: 36px;
        
        &:hover, &:focus {
            border-color: #409EFF;
        }
    }
}

.cancel-btn, .confirm-btn {
    padding: 8px 20px;
    font-size: 13px;
    border-radius: 4px;
    transition: all 0.3s;
    
    &:focus {
        outline: none;
    }
}

.cancel-btn {
    background-color: #f5f7fa;
    color: #606266;
    border: 1px solid #dcdfe6;
    
    &:hover {
        color: #409EFF;
        border-color: #c6e2ff;
        background-color: #ecf5ff;
    }
}

.confirm-btn {
    background-color: #409EFF;
    color: white;
    border: none;
    box-shadow: 0 2px 6px rgba(64, 158, 255, 0.2);
    
    &:hover {
        background-color: #66b1ff;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(64, 158, 255, 0.3);
    }
}
</style>