<template>
    <el-row class="common-container">
        <el-row style="padding: 10px 16px;">
            <el-row>
                <span class="top-bar">订阅时间</span>
                <el-date-picker size="small" style="width: 240px;" v-model="searchTime" type="daterange"
                    value-format="yyyy-MM-dd"
                    range-separator="-" start-placeholder="起始日期" end-placeholder="结束日期">
                </el-date-picker>
                <el-button size="small" class="customer"
                    style="margin-left: 10px;background-color: rgb(235, 237, 245);color: white;border: none;" type="primary"
                    @click="handleFilter">立即查询</el-button>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 16px;">
            <el-table :data="tableData" class="custom-table">
                <el-table-column prop="bookName" label="图书"></el-table-column>
                <el-table-column prop="num" width="68" label="馆藏数"></el-table-column>
                <el-table-column prop="author" width="118" label="作者"></el-table-column>
                <el-table-column prop="floor" width="148" label="馆藏区">
                    <template slot-scope="scope">
                        <span>{{ scope.row.floor + "-" + scope.row.area + "-" + scope.row.frame }}</span>
                    </template>
                </el-table-column>
                <el-table-column prop="userName" width="148" label="订阅者"></el-table-column>
                <el-table-column prop="createTime" width="168" label="订阅时间"></el-table-column>
                <el-table-column label="操作" width="90" align="center">
                    <template slot-scope="scope">
                        <el-tag type="danger" size="small" @click.native="handleDelete(scope.row)" class="delete-tag">
                            删除
                        </el-tag>
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
            bookRssHistoryQueryDto: {}, // 搜索条件
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
                title: '删除图书订阅数据',
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
                    const response = await this.$axios.post(`bookRssHistory/batchDelete`, ids);
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
                    console.error(`订阅记录删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.searchTime = [];
            this.bookRssHistoryQueryDto = {};
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
                    ...this.bookRssHistoryQueryDto
                };
                const response = await this.$axios.post('bookRssHistory/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询图书订阅信息异常:', error);
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

.top-bar {
    color: #606266;
    font-size: 14px;
    margin-right: 8px;
    line-height: 32px;
    font-weight: 500;
}

.delete-tag {
    cursor: pointer;
    transition: all 0.2s;
    
    &:hover {
        opacity: 0.8;
        transform: scale(1.05);
    }
}

.delete-btn {
    color: #F56C6C;
    font-size: 13px;
    cursor: pointer;
    display: inline-block;
    height: 20px;
    line-height: 20px;
    
    &:hover {
        color: #ff8c8c;
    }
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
                vertical-align: middle;
                height: 40px;
                line-height: 20px;
            }
        }
    }
}

.list-cover {
    width: 50px;
    height: 70px;
    border-radius: 5px;
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
</style>