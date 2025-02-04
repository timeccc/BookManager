<template>
    <el-row style="margin-top: 20px;">
        <!-- 条件搜索 -->
        <div class="word-search">
            <div class="item">
                <input type="text" placeholder="书籍ID" v-model="bookQueryDto.bookId">
                <i class="el-icon-search" @click="fetchFreshData"></i>
            </div>
        </div>
        <el-row style="margin: 10px 0;">
            <el-row v-if="tableData.length === 0">
                <el-empty description="暂无书籍借阅历史"></el-empty>
            </el-row>
            <el-row v-else>
                <div style="margin: 0 auto;width: 1200px;">
                    <el-col v-for="(book, index) in tableData" :key="index" :span="6">
                        <div class="item-book">
                            <div style="display: flex;justify-content: center;">
                                <img style="width: 100%;max-height: 380px;border-radius: 5px;" :src="book.bookCover"
                                    alt="">
                            </div>
                            <div style="padding: 10px 22px;">
                                <div style="color: rgb(51,51,51);font-size: 24px;font-weight: bold;margin-block: 4px;">
                                    <el-tooltip class="item" effect="dark" :content="book.bookName"
                                        placement="bottom-end">
                                        <div class="title">{{ book.bookName }}</div>
                                    </el-tooltip>
                                </div>
                                <div class="title" style="margin-block: 8px;">
                                    <el-tooltip v-if="!book.isReturn" class="item" effect="dark" content="请及时归还"
                                        placement="bottom-end">
                                        <span
                                            style="font-size: 14px;text-decoration: underline;text-decoration-style: dashed;">待归还</span>
                                    </el-tooltip>
                                    <span v-else style="font-size: 14px;">已归还</span>
                                </div>
                                <div style="margin-block: 6px;font-size: 12px;color: rgb(51,51,51);margin-block: 4px;">
                                    <div style="font-size: 12px;margin-top: 6px;">
                                        <div class="title">借阅【{{ book.deadlineNum }}】本</div>
                                    </div>
                                    <div>
                                        <el-tooltip class="item" effect="dark" :content="book.createTime"
                                            placement="bottom-end">
                                            <div class="title" style="margin-block: 10px;">
                                                <span style="margin-right: 5px;">借阅时间：{{ book.createTime }}</span>
                                            </div>
                                        </el-tooltip>

                                        <div class="title" style="margin-block: 10px;">
                                            <span style="margin-right: 5px;">归还时间：{{ book.returnTime }}</span>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <span class="edit-round" v-if="book.isReturn === false"
                                        @click="handleReturn(book)">还书</span>
                                    <span class="edit-round" v-else @click="handleDelete(book)">删除</span>
                                </div>
                            </div>
                        </div>
                    </el-col>
                </div>

            </el-row>
        </el-row>
        <div class="pager" v-if="tableData.length !== 0">
            <div>
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    :current-page.sync="current" :page-size="size" layout="total, prev, pager, next"
                    :total="totalCount">
                </el-pagination>
            </div>
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
            size: 10,
            totalItems: 0,
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
                    current: this.currentPage,
                    size: this.pageSize,
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
        }
    },
};
</script>
<style scoped lang="scss">
.item-book {
    border: 1px solid rgb(235, 235, 235);
    margin: 5px;
    border-radius: 5px;
    padding: 6px;
    box-sizing: border-box;
}

.title {
    width: 140px;
    overflow: hidden;
    /* 隐藏超出部分 */
    text-overflow: ellipsis;
    /* 使用省略号表示超出部分 */
    white-space: nowrap;
    /* 禁止换行 */
}

.pager {
    display: flex;
    margin-block: 20px;
    justify-content: center;
    align-items: center;
}

.category {
    font-size: 16px;
    color: rgb(114, 114, 114);
    cursor: pointer;
    display: inline-block;
    transition: all .2s;
    padding: 10px 20px;
    border-radius: 10px;
}

.word-search {
    display: flex;
    justify-content: center;

    .item {
        padding: 14px;
        width: 500px;
        background-color: rgb(247, 247, 247);
        border-radius: 10px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-sizing: border-box;

        input {
            border: none;
            background-color: rgb(247, 247, 247);
            outline: none;
            font-size: 16px;
        }

        i {
            padding: 6px;
            border-radius: 5px;
            cursor: pointer;
        }

        i:hover {
            background-color: rgb(241, 241, 241);
        }
    }

}
</style>