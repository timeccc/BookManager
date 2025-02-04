<template>
    <el-row style="margin-top: 20px;">
        <!-- 条件搜索 -->
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <input type="text" placeholder="消息体" v-model="rssNotificationQueryDto.content">
                <i class="el-icon-search" @click="fetchFreshData"></i>
            </div>
            <div class="read" @click="readDeal">
                全部已读
            </div>
        </div>
        <el-row style="margin: 10px 0;box-sizing: border-box;">
            <el-row v-if="tableData.length === 0">
                <el-empty description="暂无通知" style="margin-top: 200px;"></el-empty>
            </el-row>
            <div v-else style="display: flex;justify-content: center;align-items: center;margin-block: 20px;">
                <div>
                    <div class="save-book">
                        <div class="title">消息体</div>
                        <div class="title">是否已读</div>
                        <div class="title">推送时间</div>
                        <div class="title">功能操作</div>
                    </div>
                    <div class="save-book" v-for="(rss, index) in tableData" :key="index">
                        <div>
                            {{ rss.content }}
                        </div>
                        <div>
                            {{ rss.isRead ? '已读' : '未读' }}
                        </div>
                        <div>
                            {{ rss.createTime }}
                        </div>
                        <div>
                            <span class="text-button" @click="handleDelete(rss)">删除</span>
                        </div>
                    </div>
                </div>
            </div>
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
            data: {},
            current: 1,
            cover: null,
            size: 10,
            totalItems: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            rssNotificationQueryDto: {}, // 搜索条件
            options: [],
            bookshelfOptions: [],
            bookOrderHistorys: [],
            searchTime: []
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        readDeal() {
            this.$axios.post('/rssNotification/readDeal').then(res => {
                if (res.data.code === 200) {
                    this.$notify({
                        title: '结果',
                        message: '全部消息已经设置为已读',
                        type: 'success'
                    });
                    this.fetchFreshData();
                }
            })
        },
        async fetchFreshData() {
            try {
                this.tableData = [];
                // 请求参数
                const params = {
                    current: this.current,
                    size: this.size,
                    ...this.rssNotificationQueryDto
                };
                const response = await this.$axios.post('/rssNotification/queryUser', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalCount = data.total;
            } catch (error) {
                console.error('订阅通知信息异常:', error);
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
            this.selectedRows.push(row);
            this.batchDelete();
        },
        // 批量删除数据
        async batchDelete() {
            if (!this.selectedRows.length) {
                this.$message(`未选中任何数据`);
                return;
            }
            const confirmed = await this.$swalConfirm({
                title: '取消订阅？',
                text: `操作不可恢复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = this.selectedRows.map(entity => entity.id);
                    const response = await this.$axios.post(`/rssNotification/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$swal.fire({
                            title: '删除提示',
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
                    console.error(`删除异常：`, e);
                }
            }
        },
    },
};
</script>
<style scoped lang="scss">
.read {
    background-color: rgb(247, 247, 247);
    border-radius: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding-inline: 26px;
    margin-left: 10px;
    cursor: pointer;
}

.read:hover {
    background-color: rgb(242, 242, 242);
}

.save-book:hover {
    background-color: rgb(248, 248, 248);
}

.save-book {
    display: flex;
    justify-content: left;
    align-items: center;

    div {
        width: 200px;
        padding: 30px;
    }

    .title {
        background-color: rgb(248, 248, 248);
        width: 200px;
    }

}

.pager {
    display: flex;
    margin-block: 20px;
    justify-content: center;
    align-items: center;
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