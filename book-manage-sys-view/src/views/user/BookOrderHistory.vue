<template>
    <el-row class="history-container">
        <!-- 条件搜索 -->
        <div class="word-search">
            <div class="item">
                <i class="el-icon-search"></i>
                <input type="text" placeholder="搜索书籍ID" v-model="bookQueryDto.bookId">
                <span class="search-text" @click="fetchFreshData">搜索</span>
            </div>
        </div>
        <div class="books-wrapper">
            <el-row v-if="tableData.length === 0">
                <el-empty description="暂无书籍借阅历史" class="empty-data"></el-empty>
            </el-row>
            <el-row v-else class="books-grid">
                <el-col v-for="(book, index) in tableData" :key="index" :sm="12" :md="8" :lg="6" :xl="6">
                    <div class="book-card" :class="{'returned': book.isReturn}">
                        <div class="book-cover">
                            <img :src="book.bookCover" alt="">
                            <div class="book-status" :class="{'return-pending': !book.isReturn}">
                                {{ book.isReturn ? '已归还' : '待归还' }}
                            </div>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title" :title="book.bookName">{{ book.bookName }}</h3>
                            <div class="book-quantity">
                                借阅数量: <span>{{ book.deadlineNum }}</span> 本
                            </div>
                            <div class="book-dates">
                                <div class="date-item">
                                    <i class="el-icon-time"></i>
                                    <span>借阅: {{ book.createTime }}</span>
                                </div>
                                <div class="date-item">
                                    <i class="el-icon-date"></i>
                                    <span>归还: {{ book.returnTime }}</span>
                                </div>
                            </div>
                            <div class="book-actions">
                                <button v-if="!book.isReturn" class="action-btn return-btn" @click="handleReturn(book)">
                                    <i class="el-icon-refresh-left"></i><span>归还</span>
                                </button>
                                <button v-else class="action-btn delete-btn" @click="handleDelete(book)">
                                    <i class="el-icon-delete"></i><span>删除</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </el-col>
            </el-row>
        </div>
        <div class="pager" v-if="tableData.length !== 0">
            <el-pagination 
                @size-change="handleSizeChange" 
                @current-change="handleCurrentChange"
                :current-page.sync="current" 
                :page-size="size" 
                layout="total, prev, pager, next"
                :total="totalCount">
            </el-pagination>
        </div>
    </el-row>
</template>

<script>
export default {
    data() {
        return {
            deadlineNum: 1,
            data: {},
            current: 1,
            cover: null,
            size: 8,
            totalCount: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            bookQueryDto: {}, // 搜索条件
            options: [],
            bookshelfOptions: [],
            categoryItemSelected: null,
            categoryList: [],
            bookOrderHistorys: []
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        handleReturn(book) {
            const bookRssHistory = {
                id: book.id
            }
            this.$axios.put('/bookOrderHistory/update', bookRssHistory).then(res => {
                if (res.data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '还书操作',
                        message: '还书成功',
                        type: 'success'
                    });
                    this.fetchFreshData();
                }
            }).catch(error => {
                console.log("还书异常：", error);
            })
        },
        // 批量删除数据
        async batchDelete(orderHistory) {
            const confirmed = await this.$swalConfirm({
                title: '删除书籍预约历史数据',
                text: `删除后不可恢复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = [orderHistory.id];
                    const response = await this.$axios.post(`/bookOrderHistory/batchDelete`, ids);
                    const { data } = response;
                    if (data.code === 200) {
                        this.$notify({
                            duration: 1000,
                            title: '删除操作',
                            message: '删除成功',
                            type: 'success'
                        });
                        this.fetchFreshData();
                    }
                } catch (error) {
                    this.$notify({
                        duration: 2000,
                        title: '删除失败',
                        message: error,
                        type: 'error'
                    });
                    console.error(`书籍预约信息删除异常：`, error);
                }
            }
        },
        async fetchFreshData() {
            try {
                const params = {
                    current: this.current,
                    size: this.size,
                    ...this.bookQueryDto
                };
                const response = await this.$axios.post('/bookOrderHistory/queryUser', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalCount = data.total;
            } catch (error) {
                console.error('查询书籍借阅历史信息异常:', error);
            }
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
        handleDelete(row) {
            this.batchDelete(row);
        }
    },
};
</script>
<style scoped lang="scss">
.history-container {
    width: 100%;
    padding: 10px 20px 20px 20px;
    box-sizing: border-box;
    background-color: #fafafa;
}

.books-wrapper {
    max-width: 1200px;
    margin: 0 auto;
}

.books-grid {
    margin: 0 -12px;
}

.book-card {
    margin: 12px;
    background-color: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    height: 100%;
    min-height: 380px;
    display: flex;
    flex-direction: column;
    
    &:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    }
    
    &.returned {
        border-left: 4px solid #67c23a;
    }
    
    &:not(.returned) {
        border-left: 4px solid #e6a23c;
    }
}

.book-cover {
    position: relative;
    overflow: hidden;
    background-color: white;
    aspect-ratio: 1/1;
    display: flex;
    align-items: center;
    justify-content: center;
    
    img {
        width: auto;
        height: auto;
        max-width: 85%;
        max-height: 85%;
        object-fit: contain;
        transition: transform 0.5s ease;
    }
    
    &:hover img {
        transform: scale(1.1);
    }
    
    .book-status {
        position: absolute;
        top: 12px;
        right: 0;
        background-color: #67c23a;
        color: white;
        padding: 4px 12px;
        font-size: 12px;
        border-radius: 4px 0 0 4px;
        font-weight: 500;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        
        &.return-pending {
            background-color: #e6a23c;
        }
    }
}

.book-info {
    padding: 16px;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.book-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin: 0 0 12px 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.book-quantity {
    font-size: 14px;
    color: #606266;
    margin-bottom: 12px;
    
    span {
        font-weight: 600;
        color: #ff5722;
    }
}

.book-dates {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 16px;
}

.date-item {
    display: flex;
    align-items: center;
    font-size: 13px;
    color: #909399;
    
    i {
        margin-right: 6px;
        color: #909399;
    }
    
    span {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
}

.book-actions {
    margin-top: auto;
}

.action-btn {
    width: 100%;
    padding: 8px 0;
    border: none;
    border-radius: 20px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 500;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    height: 36px;
    
    i {
        margin-right: 6px;
        font-size: 14px;
    }
    
    span {
        font-size: 14px;
    }
    
    &.return-btn {
        background-color: #e6a23c;
        color: white;
        
        &:hover {
            background-color: darken(#e6a23c, 5%);
        }
    }
    
    &.delete-btn {
        background-color: #f56c6c;
        color: white;
        
        &:hover {
            background-color: darken(#f56c6c, 5%);
        }
    }
}

.empty-data {
    margin: 40px 0;
}

.pager {
    display: flex;
    justify-content: center;
    margin: 30px 0 10px;
}

// 搜索框样式
.word-search {
    display: flex;
    justify-content: center;
    margin-bottom: 15px;
    margin-top: -5px;

    .item {
        padding: 10px 20px;
        width: 500px;
        background-color: white;
        border-radius: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-sizing: border-box;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        border: 1px solid #eee;
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

// 响应式调整
@media (max-width: 768px) {
    .word-search .item {
        width: 90%;
    }
}
</style>