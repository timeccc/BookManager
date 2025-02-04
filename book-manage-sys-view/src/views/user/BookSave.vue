<template>
    <el-row style="margin-top: 20px;">
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <input type="text" placeholder="书籍ID" v-model="bookSaveQueryDto.bookId">
                <i class="el-icon-search" @click="fetchFreshData"></i>
            </div>
        </div>
        <el-row v-if="tableData.length === 0">
            <el-empty description="暂无收藏书籍"></el-empty>
        </el-row>
        <div v-else style="display: flex;justify-content: center;align-items: center;margin-block: 20px;">
            <div>
                <div class="save-book">
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
                    <div>
                        <span class="text-button" @click="handleEdit(save)">借书</span>
                        <span class="text-button" @click="handleDelete(save)">取消收藏</span>
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
        <el-dialog :show-close="false" :visible.sync="dialogOperation" width="24%">
            <div style="padding:20px 25px 25px 15px;">
                <div style="margin-bottom: 10px;">
                    <div class="point">借书数量</div>
                    <el-input-number style="width: 100%;" size="small" v-model="data.deadlineNum" :min="1" :max="10"
                        label="数量"></el-input-number>
                </div>
                <div>
                    <div class="point">归还日期</div>
                    <el-date-picker style="width: 100%;" size="small" v-model="data.returnTime" type="date"
                        placeholder="选择日期">
                    </el-date-picker>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <span class="channel-button" @click="cannel()">
                    取消操作
                </span>
                <span class="edit-button" @click="addOperation">
                    确定借书
                </span>
            </span>
        </el-dialog>
    </el-row>
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
                    size: this.pageSize,
                    ...this.size
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
.pager {
    display: flex;
    margin-block: 20px;
    justify-content: center;
    align-items: center;
}


.save-book:hover {
    background-color: rgb(248, 248, 248);
}

.save-book {
    display: flex;
    justify-content: left;
    align-items: center;

    div {
        min-width: 150px;
        padding: 30px;
    }

    .title {
        background-color: rgb(248, 248, 248);
    }
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