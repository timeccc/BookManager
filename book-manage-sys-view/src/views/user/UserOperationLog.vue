<template>
    <el-row style="margin-top: 20px;">
        <!-- 条件搜索 -->
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <input type="text" placeholder="操作" v-model="userOperationLogQueryDto.content">
                <i class="el-icon-search" @click="fetchFreshData"></i>
            </div>
        </div>
        <el-row style="margin: 10px 0;box-sizing: border-box;">
            <el-row v-if="tableData.length === 0">
                <el-empty description="暂无日志" style="margin-top: 200px;"></el-empty>
            </el-row>
            <div v-else style="display: flex;justify-content: center;align-items: center;margin-block: 20px;">
                <div>
                    <div class="save-book">
                        <div class="title">操作</div>
                        <div class="title">推送时间</div>
                        <div class="title">功能操作</div>
                    </div>
                    <div class="save-book" v-for="(rss, index) in tableData" :key="index">
                        <div>
                            {{ rss.content }}
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
            totalCount: 0,
            dialogOperation: false, // 开关
            isOperation: false, // 开关-标识新增或修改
            tableData: [],
            selectedRows: [],
            userOperationLogQueryDto: {}, // 搜索条件
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
        async fetchFreshData() {
            try {
                const response = await this.$axios.post('/userOperationLog/queryUser', this.userOperationLogQueryDto);
                const { data } = response;
                this.tableData = data.data;
                this.totalCount = data.total;
            } catch (error) {
                console.error('系统日志信息异常:', error);
            }
        },
        handleSizeChange(size) {
            this.userOperationLogQueryDto.current = 1;
            this.userOperationLogQueryDto.size = size;
            this.fetchFreshData();
        },
        handleCurrentChange(current) {
            this.userOperationLogQueryDto.current = current;
            this.userOperationLogQueryDto.size = 10;
            this.fetchFreshData();
        },
        handleDelete(row) {
            this.batchDelete(row);
        },
        // 批量删除数据
        async batchDelete(log) {
            const confirmed = await this.$swalConfirm({
                title: '取消系统日志？',
                text: `操作不可恢复，是否继续？`,
                icon: 'warning',
            });
            if (confirmed) {
                try {
                    let ids = [log.id];
                    const response = await this.$axios.post(`/userOperationLog/batchDelete`, ids);
                    if (response.data.code === 200) {
                        this.$notify({
                            duration: 1000,
                            title: '日志删除',
                            message: '删除成功',
                            type: 'success'
                        });
                        this.fetchFreshData();
                    }
                } catch (error) {
                    this.$notify({
                        title: '日志删除',
                        message: error,
                        type: 'error'
                    });
                    console.error(`删除异常：`, error);
                }
            }
        },
    },
};
</script>
<style scoped lang="scss">
.save-book:hover {
    background-color: rgb(248, 248, 248);
}

.save-book {
    display: flex;
    justify-content: left;
    align-items: center;

    div {
        width: 280px;
        padding: 30px;
    }

    .title {
        background-color: rgb(248, 248, 248);
        width: 280px;
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