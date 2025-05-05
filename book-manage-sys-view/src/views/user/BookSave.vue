<template>
    <div class="book-save-view-container">
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <i class="el-icon-search"></i>
                <input type="text" placeholder="书籍ID" v-model="bookSaveQueryDto.bookId">
                <span class="search-text" @click="fetchFreshData">搜索</span>
            </div>
        </div>
        <el-row v-if="tableData.length === 0">
            <el-empty description="暂无收藏书籍"></el-empty>
        </el-row>
        <div v-else class="book-save-container">
            <div class="book-save-table">
                <div class="save-book header">
                    <div class="title">书籍名</div>
                    <div class="title">作者</div>
                    <div class="title">馆藏数</div>
                    <div class="title">书籍所在</div>
                    <div class="title">功能操作</div>
                </div>
                <div class="save-book" v-for="(save, index) in tableData" :key="index">
                    <div>
                        {{ save.bookName }}
                    </div>
                    <div>
                        {{ save.author }}
                    </div>
                    <div>
                        {{ save.num }}
                    </div>
                    <div>
                        {{ parseLocation(save) }}
                    </div>
                    <div class="action-buttons">
                        <button class="action-btn borrow" @click="handleEdit(save)">
                            <i class="el-icon-reading"></i> 借书
                        </button>
                        <button class="action-btn cancel" @click="handleDelete(save)">
                            <i class="el-icon-star-off"></i> 取消收藏
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="pager" v-if="tableData.length !== 0">
            <div>
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    :current-page.sync="current" :page-size="size" layout="total, prev, pager, next"
                    :total="totalCount">
                </el-pagination>
            </div>
        </div>
        <el-dialog :show-close="false" :visible.sync="dialogOperation" width="400px" custom-class="borrow-dialog">
            <div class="dialog-header">
                <h3 class="dialog-title">借阅信息</h3>
            </div>
            <div class="dialog-content">
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-goods"></i> 借书数量</label>
                    <el-input-number style="width: 100%;" size="small" v-model="data.deadlineNum" :min="1" :max="10"
                        label="数量" controls-position="right"></el-input-number>
                </div>
                <div class="form-group">
                    <label class="form-label"><i class="el-icon-date"></i> 归还日期</label>
                    <el-date-picker style="width: 100%;" size="small" v-model="data.returnTime" type="date"
                        placeholder="选择归还日期" value-format="yyyy-MM-dd">
                    </el-date-picker>
                </div>
                <div class="borrow-notice">
                    <i class="el-icon-info-circle"></i>
                    <span>请在选定日期前归还图书</span>
                </div>
            </div>
            <div class="dialog-footer">
                <el-button class="cancel-btn" size="small" @click="cannel()">取消操作</el-button>
                <el-button class="confirm-btn" type="primary" size="small" @click="addOperation">确定借书</el-button>
            </div>
        </el-dialog>
    </div>
</template>

<script>
export default {
    components: {
    },
    data() {
        return {
            data: {},
            current: 1,
            cover: null,
            size: 10,
            totalCount: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            bookSaveQueryDto: {}, // 搜索条件
            options: [],
            bookshelfOptions: [],
            bookOrderHistorys: [],
            searchTime: []
        };
    },
    created() {
        this.fetchFreshData();
        this.fetchCategory();
        this.fetchBookshelf();
    },
    methods: {
        cannel() {
            this.data = {};
            this.dialogOperation = false;
            this.isOperation = false;
        },
        // 借书操作
        async addOperation() {
            try {
                if (this.data.deadlineNum === undefined || this.data.returnTime === undefined) {
                    this.$notify({
                        duration: 1000,
                        title: '操作反馈',
                        message: '请填入信息',
                        type: 'info'
                    });
                    return;
                }
                const response = await this.$axios.post('/bookOrderHistory/save', this.data);
                if (response.data.code === 200) {
                    this.fetchFreshData();
                    this.data = {};
                    this.dialogOperation = false;
                    this.$notify({
                        title: '借书结果',
                        message: '借书成功，请及时归还',
                        type: 'success'
                    });
                } else {
                    this.$notify({
                        title: '借书结果',
                        message: response.data.msg,
                        type: 'error'
                    });
                }
            } catch (error) {
                this.$notify({
                    title: '借书结果',
                    message: error,
                    type: 'error'
                });
            }
        },

        parseLocation(data) {
            return data.floor + '-' + data.area + '-' + data.frame;
        },
        bookshelfConfig(item) {
            return item.floor + "-" + item.area + "-" + item.frame;
        },
        fetchBookshelf() {
            this.$axios.post('bookshelf/query', {}).then(res => {
                if (res.data.code === 200) {
                    this.bookshelfOptions = res.data.data;
                }
            })
        },
        fetchCategory() {
            this.$axios.post('category/query', {}).then(res => {
                if (res.data.code === 200) {
                    this.options = res.data.data;
                }
            })
        },

        resetQueryCondition() {
            this.bookSaveQueryDto = {};
            this.fetchFreshData();
        },

        // 查询用户的预约记录
        getBookOrderHistory() {
            this.$axios.post('bookOrderHistory/queryUser', {}).then(res => {
                if (res.data.code === 200) {
                    this.bookOrderHistorys = res.data.data;
                }
            })
        },

        // 信息新增
        async returnOperation() {
            try {
                // 发之前，组装数据
                const bookOrderHsitory = {
                    id: this.data.id,
                    isReturn: true
                }
                const response = await this.$axios.put('/bookSave/update', bookOrderHsitory);
                if (response.data.code === 200) {
                    this.fetchFreshData();
                    this.data = {};
                    this.dialogOperation = false;
                    this.$notify({
                        title: '还书结果',
                        message: '还书成功',
                        type: 'success'
                    });
                } else {
                    this.$notify({
                        title: '还书结果',
                        message: response.data.msg,
                        type: 'error'
                    });
                }
            } catch (error) {
                this.$notify({
                    title: '还书结果',
                    message: error,
                    type: 'error'
                });
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
                // 请求参数
                const params = {
                    current: this.current,
                    size: this.size,
                    ...this.bookSaveQueryDto
                };
                const response = await this.$axios.post('/bookSave/queryUser', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalCount = data.total;
            } catch (error) {
                console.error('借阅历史信息异常:', error);
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
            this.size = val;
            this.current = 1;
            this.fetchFreshData();
        },
        handleCurrentChange(val) {
            this.current = val;
            this.fetchFreshData();
        },
        messagePush(row) {
            this.data = { ...row };
        },
        handleEdit(row) {
            this.dialogOperation = true;
            this.data = { ...row };
        },
        handleDelete(row) {
            this.batchDelete(row);
        },
        // 批量删除数据
        async batchDelete(save) {
            const confirmed = await this.$swalConfirm({
                title: '取消收藏？',
                text: `操作不可回复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = [save.id];
                    const response = await this.$axios.post(`/bookSave/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$notify({
                            duration: 1000,
                            title: '取消收藏操作',
                            message: '取消收藏成功',
                            type: 'success'
                        });
                        this.fetchFreshData();
                    }
                } catch (e) {
                    this.$notify({
                        duration: 3000,
                        title: '取消收藏操作',
                        message: error,
                        type: 'error'
                    });
                    console.error(`取消收藏异常：`, e);
                }
            }
        },
    },
};
</script>
<style scoped lang="scss">
.book-save-view-container {
    padding: 10px;
    border-radius: 16px;
    background-color: transparent;
    backdrop-filter: none;
    box-shadow: none;
}

.word-search {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;

    .item {
        padding: 10px 20px;
        width: 500px;
        background-color: rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(10px);
        border-radius: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-sizing: border-box;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        border: 1px solid rgba(255, 255, 255, 0.3);
        transition: all 0.3s ease;

        &:hover, &:focus-within {
            box-shadow: 0 6px 16px rgba(255, 87, 34, 0.12);
            border-color: rgba(255, 87, 34, 0.2);
        }

        input {
            flex: 1;
            border: none;
            background-color: transparent;
            outline: none;
            font-size: 16px;
            color: #333;
            margin: 0 15px;
            height: 24px;
        }

        i {
            font-size: 18px;
            color: #ff5722;
        }

        .search-text {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 20px;
            background-color: #ff5722;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            
            &:hover {
                background-color: #f4511e;
                transform: translateY(-1px);
            }
        }
    }
}

.book-save-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
}

.book-save-table {
    width: 90%;
    max-width: 1200px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    background-color: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(8px);
}

.save-book {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid rgba(240, 240, 240, 0.5);
    transition: all 0.3s ease;
    
    &:last-child {
        border-bottom: none;
    }

    div {
        padding: 16px 20px;
        flex: 1;
        min-width: 120px;
        color: #333;
        font-size: 14px;
        
        &:last-child {
            flex: 1;
            min-width: 200px;
            display: flex;
            justify-content: flex-start;
        }
    }

    .title {
        font-weight: 600;
        color: #555;
    }

    .action-buttons {
        display: flex;
        gap: 10px;
        justify-content: flex-start;
    }

    .action-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 3px 8px !important;
        border-radius: 12px !important;
        font-size: 11px !important;
        cursor: pointer;
        transition: all 0.3s ease;
        min-width: 60px !important;
        height: auto !important;
        border: 1px solid transparent;
        width: auto !important;
        
        i {
            margin-right: 3px;
            font-size: 11px !important;
        }
        
        &.borrow {
            background-color: rgba(255, 87, 34, 0.08);
            color: #ff5722;
            border-color: rgba(255, 87, 34, 0.2);
            
            &:hover {
                background-color: rgba(255, 87, 34, 0.12);
                transform: translateY(-1px);
                box-shadow: 0 2px 5px rgba(255, 87, 34, 0.15);
            }
        }
        
        &.cancel {
            background-color: rgba(64, 158, 255, 0.08);
            color: #409eff;
            border-color: rgba(64, 158, 255, 0.2);
            
            &:hover {
                background-color: rgba(64, 158, 255, 0.12);
                transform: translateY(-1px);
                box-shadow: 0 2px 5px rgba(64, 158, 255, 0.15);
            }
        }
    }
}

.save-book:hover {
    background-color: rgba(249, 249, 249, 0.5);
}

.save-book.header {
    background-color: rgba(245, 247, 250, 0.6);
    border-bottom: 1px solid rgba(235, 238, 245, 0.5);
    
    &:hover {
        background-color: rgba(245, 247, 250, 0.6);
    }
}

.pager {
    display: flex;
    margin: 30px 0;
    justify-content: center;
    align-items: center;
}

.borrow-dialog {
    ::v-deep .el-dialog {
        border-radius: 16px;
        overflow: hidden;
        background-color: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    }
    
    ::v-deep .el-dialog__header {
        display: none;
    }
    
    ::v-deep .el-dialog__body {
        padding: 0;
    }
}

.dialog-header {
    background-color: rgba(249, 249, 249, 0.7);
    padding: 14px 20px;
    border-bottom: 1px solid rgba(235, 238, 245, 0.5);
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
        background-color: #ff5722;
    }
}

.dialog-content {
    padding: 16px 20px;
}

.dialog-footer {
    padding: 10px 20px 16px;
    text-align: right;
    border-top: 1px solid rgba(235, 238, 245, 0.5);
    background-color: rgba(249, 249, 249, 0.3);
}

.form-group {
    margin-bottom: 16px;
}

.form-label {
    font-size: 14px;
    color: #606266;
    margin-bottom: 8px;
    font-weight: 500;
    display: block;
    
    i {
        margin-right: 5px;
        color: #ff5722;
    }
}

.borrow-notice {
    background-color: rgba(255, 248, 230, 0.8);
    border-radius: 4px;
    padding: 10px 12px;
    font-size: 12px;
    color: #e6a23c;
    display: flex;
    align-items: flex-start;
    margin-top: 16px;
    
    i {
        margin-right: 6px;
        margin-top: 2px;
    }
    
    span {
        line-height: 1.4;
    }
}

.cancel-btn, .confirm-btn {
    padding: 7px 16px;
    font-size: 13px;
    border-radius: 20px;
    
    &:focus {
        outline: none;
    }
}

.cancel-btn {
    background-color: rgba(245, 247, 250, 0.8);
    color: #606266;
    border: 1px solid rgba(220, 223, 230, 0.7);
    
    &:hover {
        color: #409EFF;
        border-color: rgba(198, 226, 255, 0.7);
        background-color: rgba(236, 245, 255, 0.8);
    }
}

.confirm-btn {
    background-color: #ff5722;
    color: white;
    border: none;
    box-shadow: 0 2px 6px rgba(255, 87, 34, 0.2);
    
    &:hover {
        background-color: #f4511e;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(255, 87, 34, 0.3);
    }
}

/* 分页组件样式 */
::v-deep .el-pagination {
    padding: 15px 0;
    text-align: center;
}

::v-deep .el-pagination .btn-prev,
::v-deep .el-pagination .btn-next,
::v-deep .el-pager li {
    border-radius: 8px;
    transition: all 0.3s ease;
    background-color: rgba(255, 255, 255, 0.7);
}

::v-deep .el-pager li.active {
    background-color: #ff5722;
    color: white;
}
</style>