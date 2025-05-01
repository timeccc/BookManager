<template>
    <el-row style="margin-top: 10px;">
        <!-- 条件搜索 -->
        <div class="word-search" v-if="tableData.length !== 0">
            <div class="item">
                <i class="el-icon-search"></i>
                <input type="text" placeholder="消息体" v-model="rssNotificationQueryDto.content">
                <span class="search-text" @click="fetchFreshData">搜索</span>
            </div>
        </div>
        <div class="read-bar" v-if="tableData.length !== 0">
            <div class="read" @click="readDeal">
                <i class="el-icon-check"></i> 全部已读
            </div>
        </div>
        <el-row style="margin: 10px 0;box-sizing: border-box;">
            <el-row v-if="tableData.length === 0">
                <el-empty description="暂无通知" style="margin-top: 200px;"></el-empty>
            </el-row>
            <div v-else class="notification-container">
                <div class="notification-table">
                    <div class="save-book header">
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
                            <span :class="['status-tag', rss.isRead ? 'read' : 'unread']">
                                <i :class="rss.isRead ? 'el-icon-check' : 'el-icon-message'"></i>
                                {{ rss.isRead ? '已读' : '未读' }}
                            </span>
                        </div>
                        <div>
                            {{ rss.createTime }}
                        </div>
                        <div class="action-buttons">
                            <span class="action-btn delete" @click="handleDelete(rss)">
                                <i class="el-icon-delete"></i> 删除
                            </span>
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

.read-bar {
    display: flex;
    justify-content: center;
    margin-bottom: 8px;
    margin-top: 5px;
}

.read {
    background: linear-gradient(90deg, #36d1c4 0%, #5b86e5 100%);
    color: #fff;
    border-radius: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 6px 20px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(91,134,229,0.10);
    transition: background 0.2s, box-shadow 0.2s, transform 0.2s;
    
    i {
        margin-right: 5px;
        font-size: 12px;
    }
}

.read:hover {
    background: linear-gradient(90deg, #2bc0b6 0%, #3a7bd5 100%);
    box-shadow: 0 4px 12px rgba(91,134,229,0.16);
    transform: translateY(-1px) scale(1.02);
}

.notification-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 20px 0;
}

.notification-table {
    width: 90%;
    max-width: 1200px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    background: #fff;
}

.save-book {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #f0f0f0;
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
        display: inline-flex;
        align-items: center;
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.2s;
        font-weight: 600;
        
        i {
            margin-right: 5px;
        }
        
        &.delete {
            background: linear-gradient(90deg, #ff758c 0%, #ff7eb3 100%);
            color: #fff;
            border: none;
            box-shadow: 0 2px 8px rgba(255,117,140,0.10);
            
            &:hover {
                background: linear-gradient(90deg, #ff5e62 0%, #ff9966 100%);
                transform: scale(1.06);
            }
        }
    }
}

.save-book:hover {
    background-color: #f9f9f9;
}

.save-book.header {
    background-color: #f5f7fa;
    border-bottom: 1px solid #ebeef5;
    
    &:hover {
        background-color: #f5f7fa;
    }
}

.status-tag {
    display: inline-flex;
    align-items: center;
    min-width: 48px;
    padding: 4px 12px;
    border-radius: 16px;
    font-size: 13px;
    font-weight: 600;
    text-align: center;
    box-shadow: 0 2px 8px rgba(91,134,229,0.06);
    
    i {
        margin-right: 5px;
        font-size: 12px;
    }
}

.status-tag.unread {
    background: linear-gradient(90deg, #36d1c4 0%, #5b86e5 100%);
    color: #fff;
}

.status-tag.read {
    background: #f2f6fc;
    color: #5b86e5;
    border: 1px solid #dbeafe;
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
}

::v-deep .el-pager li.active {
    background-color: #ff5722;
    color: white;
}

::v-deep .el-pager li:hover:not(.active) {
    background-color: rgba(255, 87, 34, 0.1);
}

.el-empty {
    margin: 100px 0;
    transition: all 0.3s;
    
    ::v-deep .el-empty__image {
        opacity: 0.8;
    }
    
    ::v-deep .el-empty__description {
        color: #909399;
        font-size: 16px;
    }
}
</style>