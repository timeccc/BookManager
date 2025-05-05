<template>
    <el-row class="common-container">
        <el-row class="filter-row">
            <span class="top-bar">借阅时间</span>
            <el-date-picker size="small" style="width: 240px;" v-model="searchTime" type="daterange"
                value-format="yyyy-MM-dd"
                range-separator="-" start-placeholder="起始日期" end-placeholder="结束日期">
            </el-date-picker>
            <el-button size="small" class="query-btn no-icon" type="primary"
                @click="handleFilter">立即查询</el-button>
        </el-row>
        <el-row class="table-container">
            <el-table :data="tableData" class="custom-table">
                <el-table-column prop="bookName" label="书籍名"></el-table-column>
                <el-table-column prop="userName" width="98" label="订阅者"></el-table-column>
                <el-table-column prop="deadlineNum" width="88" label="馆藏数"></el-table-column>
                <el-table-column prop="isReturn" width="130" label="是否归还">
                    <template slot-scope="scope">
                        <el-tag :type="scope.row.isReturn ? 'success' : 'warning'" size="small">
                            {{ scope.row.isReturn ? '已归还' : '未归还' }}
                        </el-tag>
                    </template>
                </el-table-column>
                <el-table-column prop="returnTime" width="168" label="归还时间"></el-table-column>
                <el-table-column prop="createTime" width="168" label="借阅时间"></el-table-column>
                <el-table-column label="操作" width="100" align="center">
                    <template slot-scope="scope">
                        <div class="action-buttons">
                            <el-tag type="danger" size="small" @click.native="handleDelete(scope.row)" class="action-tag delete-tag">
                                删除
                            </el-tag>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[5, 7]"
                :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
                :total="totalItems"></el-pagination>
        </el-row>
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
            tableData: [],
            selectedRows: [],
            bookOrderHistoryQueryDto: {}, // 搜索条件
            options: [],
            bookshelfOptions: [],
            searchTime: []
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
                title: '删除借阅记录数据',
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
                    const response = await this.$axios.post(`bookOrderHistory/batchDelete`, ids);
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
                    console.error(`借阅历史删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.searchTime = [];
            this.bookOrderHistoryQueryDto = {};
            this.fetchFreshData();
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
                    startTime = `${this.searchTime[0]}T00:00:00`;
                    endTime = `${this.searchTime[1]}T23:59:59`;
                }
                // 请求参数
                const params = {
                    current: this.currentPage,
                    size: this.pageSize,
                    startTime: startTime,
                    endTime: endTime,
                    ...this.bookOrderHistoryQueryDto
                };
                const response = await this.$axios.post('bookOrderHistory/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询借阅记录信息异常:', error);
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
            this.selectedRows = [];
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
    box-sizing: border-box;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.03);
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

.top-bar {
    color: #606266;
    font-size: 14px;
    margin-right: 8px;
    line-height: 32px;
    font-weight: 500;
}

.query-btn {
    margin-left: 10px;
    background-color: #3a8ee6;
    color: #ffffff;
    border: none;
    font-weight: 500;
    box-shadow: 0 2px 6px rgba(58, 142, 230, 0.3);
}

/* 添加表格样式 */
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

.action-buttons {
    display: flex;
    justify-content: center;
    flex-wrap: nowrap;
}

.action-tag {
    cursor: pointer;
    transition: all 0.2s;
    margin: 0 4px;
    
    &:hover {
        opacity: 0.8;
        transform: scale(1.05);
    }
    
    &.delete-tag {
        background-color: #fef0f0;
        color: #F56C6C;
        border-color: #fde2e2;
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

/* 隐藏按钮图标 */
.no-icon {
    ::v-deep i {
        display: none !important;
    }
}
</style>