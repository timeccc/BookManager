<template>
    <el-row class="common-container">
        <el-row style="padding: 10px 16px;">
            <el-row>
                <span class="top-bar">公告标题</span>
                <el-input size="small" style="width: 188px;" v-model="noticeQueryDto.name" placeholder="输入处" clearable
                    @clear="handleFilterClear">
                </el-input>
                <span class="top-bar">发布时间</span>
                <el-date-picker size="small" style="width: 240px;" v-model="searchTime"
                    type="daterange" value-format="yyyy-MM-dd" range-separator="-" 
                    start-placeholder="起始日期" end-placeholder="结束日期">
                </el-date-picker>
                <el-button size="small" class="customer"
                    style="margin-left: 10px;background-color: #3a8ee6;color: #ffffff;border: none;font-weight: 500;box-shadow: 0 2px 6px rgba(58, 142, 230, 0.3);" type="primary"
                    @click="handleFilter">立即查询</el-button>
                <el-button size="small"
                    style="background-color: #67c23a;color: #ffffff;border: none;font-weight: 500;box-shadow: 0 2px 6px rgba(103, 194, 58, 0.3);" class="customer"
                    type="info" @click="addNotice">新增公告</el-button>
            </el-row>
        </el-row>
        <el-row style="margin: 10px 16px;">
            <el-table :data="tableData" class="custom-table">
                <el-table-column prop="name"  label="公告"></el-table-column>
                <el-table-column prop="createTime" width="188" label="发布时间"></el-table-column>
                <el-table-column label="操作" width="160" align="center">
                    <template slot-scope="scope">
                        <el-tag type="primary" size="small" @click.native="handleEdit(scope.row)" class="action-tag edit-tag" style="min-width: 42px; margin-right: 8px;">
                            修改
                        </el-tag>
                        <el-tag type="danger" size="small" @click.native="handleDelete(scope.row)" class="action-tag delete-tag" style="min-width: 42px;">
                            删除
                        </el-tag>
                    </template>
                </el-table-column>
            </el-table>
            <el-pagination style="margin: 20px 0;float: right;" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[8, 20]"
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
            filterText: '',
            currentPage: 1,
            pageSize: 8,
            totalItems: 0,
            tableData: [],
            searchTime: [],
            selectedRows: [],
            noticeQueryDto: {},
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        // 公告新增
        addNotice() {
            sessionStorage.setItem('noticeOperation', 'save');
            this.$router.push('/createNotice');
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
                title: '删除公告数据',
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
                    const response = await this.$axios.post(`notice/batchDelete`, ids);
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
                    console.error(`公告信息删除异常：`, e);
                }
            }
        },
        resetQueryCondition() {
            this.noticeQueryDto = {};
            this.searchTime = [];
            this.fetchFreshData();
        },
        clearFormData() {
            this.data = {};
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
                    ...this.noticeQueryDto
                };
                const response = await this.$axios.post('notice/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询公告信息异常:', error);
            }
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
            sessionStorage.setItem('noticeInfo', JSON.stringify(row));
            sessionStorage.setItem('noticeOperation', 'update');
            this.$router.push('/createNotice');
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
            }
        }
    }
}

// 分页样式美化
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