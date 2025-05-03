<template>
    <el-row style="background-color: #FFFFFF;padding: 20px 0;border-radius: 5px;">
        <el-row style="padding: 10px;margin: 0 10px;">
            <el-row>
                <span class="top-bar">类别名</span>
                <el-input size="small" style="width: 188px;margin-right: 10px;" v-model="categoryQueryDto.name"
                    placeholder="书籍类别名" clearable @clear="handleFilterClear">
                </el-input>
                <el-button size="small" class="customer"
                    style="background-color: #3a8ee6;color: #ffffff;border: none;font-weight: 500;box-shadow: 0 2px 6px rgba(58, 142, 230, 0.3);" type="primary"
                    @click="handleFilter">立即查询</el-button>
                <el-button size="small"
                    style="background-color: #67c23a;color: #ffffff;border: none;font-weight: 500;box-shadow: 0 2px 6px rgba(103, 194, 58, 0.3);" class="customer"
                    type="info" @click="add()">新增类别</el-button>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 20px;">
            <el-table :data="tableData" class="custom-table">
                <el-table-column prop="name"  label="书籍类别名"></el-table-column>
                <el-table-column label="操作" width="160" align="center">
                    <template slot-scope="scope">
                        <el-tag type="primary" size="small" @click.native="handleEdit(scope.row)" class="action-tag edit-tag" style="min-width: 42px; margin-right: 8px;">
                            编辑
                        </el-tag>
                        <el-tag type="danger" size="small" @click.native="handleDelete(scope.row)" class="action-tag delete-tag" style="min-width: 42px;">
                            删除
                        </el-tag>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[10, 20]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
        <el-dialog :visible.sync="dialogOperation" width="25%" custom-class="category-dialog">
            <div class="dialog-header">
                <h3 class="dialog-title">{{ !isOperation ? '新增类别' : '修改类别' }}</h3>
            </div>
            <div class="dialog-content">
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-collection-tag"></i> 书籍类别名</label>
                    <el-input class="custom-input" v-model="data.name" placeholder="请输入书籍类别名称"></el-input>
                </div>
            </div>
            <div class="dialog-footer">
                <el-button class="cancel-btn" size="small" @click="cannel">取消</el-button>
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
            pageSize: 10,
            totalItems: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            categoryQueryDto: {}, // 搜索条件
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        // 取消
        cannel() {
            this.resetValue(false, false);
        },
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
                title: '删除书籍类别数据',
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
                    const response = await this.$axios.post(`category/batchDelete`, ids);
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
                    console.error(`类别信息删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.categoryQueryDto = {};
            this.fetchFreshData();
        },
        // 书籍类别修改
        updateOperation() {
            this.$axios.put('/category/update', this.data).then(res => {
                if (res.data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '类别修改',
                        message: '类别修改成功',
                        type: 'success'
                    });
                    this.resetValue(false, false);
                }
            }).catch(error => {
                this.$message.error('书籍修改异常：' + error);
                console.log('书籍修改异常：', error);
            })
        },
        resetValue(v1, v2) {
            this.isOperation = v1;
            this.dialogOperation = v2;
            this.data = {};
            this.fetchFreshData();
        },
        // 新增书籍类别
        addOperation() {
            this.$axios.post('/category/save', this.data).then(res => {
                if (res.data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '类别新增',
                        message: '类别新增成功',
                        type: 'success'
                    });
                    this.resetValue(false, false);
                }
            }).catch(error => {
                this.$message.error('书籍新增异常：' + error);
                console.log('书籍新增异常：', error);
            })
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
                    ...this.categoryQueryDto
                };
                const response = await this.$axios.post('/category/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询书籍类别信息异常:', error);
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
            row.userPwd = null;
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
.top-bar {
    color: #606266;
    font-size: 14px;
    margin-right: 8px;
    line-height: 32px;
    font-weight: 500;
}

.tag-tip {
    display: inline-block;
    padding: 5px 10px;
    border-radius: 5px;
    background-color: rgb(245, 245, 245);
    color: rgb(104, 118, 130);
}

.input-def {
    height: 40px;
    line-height: 40px;
    outline: none;
    border: none;
    font-size: 20px;
    color: rgb(102, 102, 102);
    font-weight: 900;
    width: 100%;
}

/* 对话框样式 */
.category-dialog {
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
    border-top: 1px solid #f0f0f0;
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

/* 添加表格样式 */
.custom-table {
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 20px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
    
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
            }
        }
    }
}

/* 添加文本按钮样式 */
.text-button {
    color: #409EFF;
    margin-right: 8px;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.3s;
    
    &:hover {
        color: #66b1ff;
        text-decoration: underline;
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

.action-tag {
    cursor: pointer;
    transition: all 0.2s;
    padding: 0 8px;
    line-height: 22px;
    color: #fff;
    display: inline-block;
    
    &:hover {
        opacity: 0.8;
        transform: scale(1.05);
    }
}

.edit-tag {
    background-color: #409EFF;
}

.delete-tag {
    background-color: #F56C6C;
}
</style>