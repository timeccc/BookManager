<template>
    <div class="book-rss-history-container">
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <i class="el-icon-search"></i>
                <input type="text" placeholder="书籍ID" v-model="bookRssHistoryQueryDto.bookId">
                <span class="search-text" @click="fetchFreshData">搜索</span>
            </div>
        </div>
        <el-row v-if="tableData.length === 0">
            <el-empty description="暂无订阅书籍"></el-empty>
        </el-row>
        <div v-else class="book-rss-container">
            <div class="book-rss-table">
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
                        <span class="action-btn cancel" @click="handleDelete(save)">取消订阅</span>
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
    </div>
</template>

<script>
export default {
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
            bookRssHistoryQueryDto: {}, // 搜索条件
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
                this.data.bookId = this.data.bookId;
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
            this.bookRssHistoryQueryDto = {};
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
                const response = await this.$axios.put('bookRssHistory/update', bookOrderHsitory);
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
                    size: this.pageSize,
                    ...this.size
                };
                const response = await this.$axios.post('bookRssHistory/queryUser', params);
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
            this.data = { ...row };
        },
        handleDelete(row) {
            this.batchDelete(row);
        },
        // 批量删除数据
        async batchDelete(save) {
            const confirmed = await this.$swalConfirm({
                title: '取消订阅？',
                text: `操作不可回复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = [save.id];
                    const response = await this.$axios.post(`bookRssHistory/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$notify({
                            duration: 1000,
                            title: '取消订阅操作',
                            message: '取消订阅成功',
                            type: 'success'
                        });
                        this.fetchFreshData();
                    }
                } catch (e) {
                    this.$notify({
                        duration: 3000,
                        title: '取消订阅操作',
                        message: error,
                        type: 'error'
                    });
                    console.error(`取消订阅异常：`, e);
                }
            }
        },
    },
};
</script>
<style scoped lang="scss">
.book-rss-history-container {
    width: 100%;
    padding: 10px 20px 20px 20px;
    box-sizing: border-box;
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

.book-rss-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
}

.book-rss-table {
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
        display: inline-block;
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.3s ease;
        
        &.cancel {
            background-color: rgba(103, 58, 183, 0.08);
            color: #673ab7;
            border: 1px solid rgba(103, 58, 183, 0.2);
            
            &:hover {
                background-color: rgba(103, 58, 183, 0.12);
                transform: translateY(-1px);
                box-shadow: 0 2px 6px rgba(103, 58, 183, 0.15);
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