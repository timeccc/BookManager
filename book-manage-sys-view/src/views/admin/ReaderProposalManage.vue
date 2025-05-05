<template>
    <el-row class="proposal-container">
        <el-row class="search-area">
            <el-row>
                <span class="top-bar">反馈</span>
                <el-input size="small" style="width: 188px;margin-right: 10px;"
                    v-model="readingProposalQueryDto.content" placeholder="问题" clearable @clear="handleFilterClear">
                </el-input>
                <el-button type="primary" size="small" @click="handleFilter" class="no-icon" style="padding-left: 15px; padding-right: 15px;">立即查询</el-button>
            </el-row>
        </el-row>
        
        <!-- 卡片式布局替代表格 -->
        <el-row class="cards-container">
            <el-empty v-if="tableData.length === 0" description="暂无反馈数据"></el-empty>
            <el-col :xs="24" :sm="24" :md="24" :lg="12" :xl="8" v-for="(item, index) in tableData" :key="index" class="card-col">
                <div class="feedback-card" :class="getCardColorClass(index)">
                    <div class="card-header" :class="getHeaderColorClass(index)">
                        <div class="user-info">
                            <el-avatar :size="32" :src="item.userAvatar" class="avatar">
                                {{ item.userName ? item.userName.substring(0, 1) : 'U' }}
                            </el-avatar>
                            <span class="username">{{ item.userName }}</span>
                        </div>
                        <div class="card-status">
                            <span class="status-tag" :class="item.isPublish ? 'public-tag' : 'private-tag'">
                                {{ item.isPublish ? '公开' : '隐私' }}
                            </span>
                        </div>
                    </div>
                    
                    <div class="card-content">
                        <h4 class="section-title">反馈内容</h4>
                        <div class="content-text">{{ item.content }}</div>
                    </div>
                    
                    <div class="card-reply" v-if="item.replyContent">
                        <h4 class="section-title">回复内容</h4>
                        <div class="reply-container" :class="getReplyColorClass(index)">
                            <div class="reply-icon">
                                <i class="el-icon-s-comment"></i>
                            </div>
                            <div class="reply-text">{{ item.replyContent }}</div>
                        </div>
                    </div>
                    
                    <div class="card-footer">
                        <div class="time-info">
                            <div class="time-item">
                                <i class="el-icon-time"></i>
                                <span>反馈于: {{ item.createTime }}</span>
                            </div>
                            <div class="time-item" v-if="item.replyTime">
                                <i class="el-icon-chat-dot-round"></i>
                                <span>回复于: {{ item.replyTime }}</span>
                            </div>
                        </div>
                        <div class="card-actions">
                            <el-button v-if="item.replyTime === null" size="mini" type="success" plain 
                                class="action-btn" icon="el-icon-chat-line-round" @click="handleEdit(item)">回复</el-button>
                            <el-button size="mini" type="danger" plain class="action-btn" 
                                icon="el-icon-delete" @click="handleDelete(item)">删除</el-button>
                        </div>
                    </div>
                </div>
            </el-col>
        </el-row>
        
        <el-pagination class="pagination" @size-change="handleSizeChange"
            @current-change="handleCurrentChange" :current-page="currentPage" :page-sizes="[4, 8]"
            :page-size="pageSize" layout="total, sizes, prev, pager, next, jumper"
            :total="totalItems"></el-pagination>
            
        <el-dialog :visible.sync="dialogOperation" width="460px" custom-class="reply-dialog" :show-close="false">
            <div class="dialog-header">
                <div class="dialog-title-wrapper">
                    <i class="el-icon-s-comment dialog-icon"></i>
                    <span class="dialog-title">回复反馈</span>
                </div>
                <i class="el-icon-close close-btn" @click="dialogOperation = false"></i>
            </div>
            <div class="dialog-content">
                <div class="original-content">
                    <div class="content-label">原反馈内容：</div>
                    <div class="content-text">{{ data.content }}</div>
                </div>
                <div class="reply-area">
                    <div class="content-label">回复内容</div>
                    <el-input 
                        type="textarea" 
                        :rows="4" 
                        placeholder="请输入回复内容..." 
                        v-model="data.replyContent">
                    </el-input>
                    <div class="char-counter">{{ data.replyContent ? data.replyContent.length : 0 }}/500</div>
                </div>
            </div>
            <div class="dialog-footer">
                <el-button class="cancel-btn" size="small" @click="dialogOperation = false">取 消</el-button>
                <el-button class="confirm-btn" type="primary" size="small" @click="updateOperation">确 定</el-button>
            </div>
        </el-dialog>
    </el-row>
</template>

<script>
export default {
    data() {
        return {
            data: {},
            currentPage: 1,
            pageSize: 7,
            totalItems: 0,
            dialogOperation: false, // 开关
            tableData: [],
            selectedRows: [],
            readingProposalQueryDto: {}, // 搜索条件
        };
    },
    created() {
        this.fetchFreshData();
    },
    methods: {
        // 获取卡片颜色类名
        getCardColorClass(index) {
            const colorClasses = ['card-red', 'card-yellow', 'card-green', 'card-blue'];
            return colorClasses[index % 4];
        },
        
        // 获取卡片头部颜色类名
        getHeaderColorClass(index) {
            const headerClasses = ['header-red', 'header-yellow', 'header-green', 'header-blue'];
            return headerClasses[index % 4];
        },
        
        // 获取回复容器颜色类名
        getReplyColorClass(index) {
            const replyClasses = ['reply-red', 'reply-yellow', 'reply-green', 'reply-blue'];
            return replyClasses[index % 4];
        },
        // 批量删除数据
        async batchDelete() {
            if (!this.selectedRows.length) {
                this.$message(`未选中任何数据`);
                return;
            }
            const confirmed = await this.$swalConfirm({
                title: '删除反馈数据',
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
                    const response = await this.$axios.post(`/readerProposal/batchDelete`, ids);
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
                    console.error(`反馈信息删除异常：`, e);
                }
            }
        },
        // 修改信息
        async updateOperation() {
            try {
                const response = await this.$axios.put('/readerProposal/update', this.data);
                this.$swal.fire({
                    title: '回复成功',
                    text: response.data.msg,
                    icon: response.data.code === 200 ? 'success' : 'error',
                    showConfirmButton: false,
                    timer: 1000,
                });
                if (response.data.code === 200) {
                    this.closeDialog();
                    this.fetchFreshData();
                    this.clearFormData();
                }
            } catch (error) {
                console.error('提交表单时出错:', error);
                this.$message.error('提交失败，请稍后再试！');
            }
        },
        closeDialog() {
            this.dialogOperation = false;
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
                    ...this.readingProposalQueryDto
                };
                const response = await this.$axios.post('/readerProposal/query', params);
                const { data } = response;
                this.tableData = data.data;
                this.totalItems = data.total;
            } catch (error) {
                console.error('查询反馈信息异常:', error);
            }
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
        handleEdit(row) {
            this.dialogOperation = true;
            row.userPwd = null;
            this.data = { ...row }
        },
        handleDelete(row) {
            this.selectedRows.push(row);
            this.batchDelete();
        }
    },
};
</script>
<style scoped lang="scss">
.proposal-container {
    background-color: #FFFFFF;
    padding: 20px 0;
    border-radius: 16px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.search-area {
    padding: 15px 20px;
    margin: 0 15px;
    border-bottom: 1px solid #f5f5f5;
}

.top-bar {
    font-size: 14px;
    font-weight: 500;
    color: #606266;
    margin-right: 8px;
    line-height: 32px;
}

// 卡片容器
.cards-container {
    padding: 20px;
    display: flex;
    flex-wrap: wrap;
}

.card-col {
    padding: 10px;
    margin-bottom: 10px;
}

.feedback-card {
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    transition: all 0.2s ease;
    background: #fff;
    position: relative;
    height: 100%;
    
    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08);
    }
    
    &.card-red {
        border-top: 3px solid #ff6b6b;
        background-color: #fff8f8;
    }
    
    &.card-yellow {
        border-top: 3px solid #feca57;
        background-color: #fffcf5;
    }
    
    &.card-green {
        border-top: 3px solid #1dd1a1;
        background-color: #f6fffa;
    }
    
    &.card-blue {
        border-top: 3px solid #54a0ff;
        background-color: #f5faff;
    }
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px;
    border-bottom: 1px solid #eee;
    
    &.header-red {
        background-color: #ffefef;
        
        .user-info i {
            color: #ff6b6b;
        }
    }
    
    &.header-yellow {
        background-color: #fff8e8;
        
        .user-info i {
            color: #feca57;
        }
    }
    
    &.header-green {
        background-color: #ebfff5;
        
        .user-info i {
            color: #1dd1a1;
        }
    }
    
    &.header-blue {
        background-color: #ebf5ff;
        
        .user-info i {
            color: #54a0ff;
        }
    }
}

.user-info {
    display: flex;
    align-items: center;
    
    .avatar {
        margin-right: 10px;
        background-color: #fff;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        border: 2px solid #fff;
    }
    
    .username {
        font-weight: 600;
        color: #333;
    }
}

.status-tag {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 15px;
    font-size: 12px;
    font-weight: 500;
    
    &.public-tag {
        background-color: #e1f5fe;
        color: #039be5;
    }
    
    &.private-tag {
        background-color: #fff8e1;
        color: #ffb300;
    }
}

.card-content, .card-reply {
    padding: 15px;
    border-bottom: 1px solid #f0f0f0;
}

.section-title {
    font-size: 14px;
    font-weight: 600;
    color: #606266;
    margin: 0 0 10px 0;
}

.content-text {
    color: #303133;
    line-height: 1.5;
    word-break: break-word;
}

.reply-container {
    display: flex;
    padding: 12px;
    border-radius: 8px;
    margin-top: 5px;
    
    &.reply-red {
        background-color: #fff5f5;
        
        .reply-icon {
            color: #ff6b6b;
        }
    }
    
    &.reply-yellow {
        background-color: #fff9e6;
        
        .reply-icon {
            color: #feca57;
        }
    }
    
    &.reply-green {
        background-color: #e6fff2;
        
        .reply-icon {
            color: #1dd1a1;
        }
    }
    
    &.reply-blue {
        background-color: #e6f4ff;
        
        .reply-icon {
            color: #54a0ff;
        }
    }
}

.reply-icon {
    margin-right: 10px;
    font-size: 18px;
    align-self: flex-start;
    padding-top: 2px;
}

.reply-text {
    flex: 1;
    color: #303133;
    line-height: 1.6;
    word-break: break-word;
}

.card-footer {
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
}

.time-info {
    color: #909399;
    font-size: 12px;
}

.time-item {
    margin-bottom: 5px;
    display: flex;
    align-items: center;
    
    i {
        margin-right: 5px;
    }
}

.card-actions {
    display: flex;
    gap: 8px;
}

.action-btn {
    padding: 4px 8px;
    font-size: 10px;
    border-radius: 12px;
    transition: all 0.2s;
}

.pagination {
    margin: 15px 25px 15px 0;
    float: right;
}

// 对话框样式
.reply-dialog {
    ::v-deep .el-dialog {
        border-radius: 8px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        overflow: hidden;
    }
    
    ::v-deep .el-dialog__header,
    ::v-deep .el-dialog__body {
        padding: 0;
        margin: 0;
    }
    
    ::v-deep .el-dialog__headerbtn {
        display: none;
    }
}

.dialog-header {
    position: relative;
    padding: 16px 20px;
    background-color: #FF8C69;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.dialog-title-wrapper {
    display: flex;
    align-items: center;
}

.dialog-icon {
    color: white;
    font-size: 18px;
    margin-right: 8px;
}

.dialog-title {
    color: white;
    font-size: 16px;
    font-weight: 600;
}

.close-btn {
    color: white;
    cursor: pointer;
    font-size: 18px;
    opacity: 0.8;
    transition: opacity 0.2s;
    
    &:hover {
        opacity: 1;
    }
}

.dialog-content {
    padding: 20px;
    
    .original-content {
        background-color: #FFF8F0;
        border-radius: 6px;
        padding: 15px;
        margin-bottom: 16px;
        border-left: 3px solid #FF8C69;
    }
    
    .content-label {
        font-size: 14px;
        font-weight: 500;
        color: #666;
        margin-bottom: 8px;
    }
    
    .content-text {
        color: #333;
        font-size: 14px;
        line-height: 1.6;
    }
    
    .reply-area {
        position: relative;
        
        .char-counter {
            position: absolute;
            right: 5px;
            bottom: 5px;
            font-size: 12px;
            color: #999;
        }
    }
    
    ::v-deep .el-textarea__inner {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 10px;
        font-size: 14px;
        
        &:focus {
            border-color: #FF8C69;
            box-shadow: 0 0 0 2px rgba(255, 140, 105, 0.2);
        }
    }
}

.dialog-footer {
    padding: 10px 20px 20px;
    text-align: right;
    
    .cancel-btn {
        background-color: #f5f5f5;
        border-color: #ddd;
        color: #666;
        padding: 8px 15px;
        margin-right: 10px;
        font-size: 14px;
        
        &:hover {
            background-color: #e8e8e8;
            color: #333;
        }
    }
    
    .confirm-btn {
        background-color: #FF8C69;
        border-color: #FF7F50;
        color: white;
        padding: 8px 15px;
        font-size: 14px;
        
        &:hover {
            background-color: #FF7F50;
            border-color: #FF6347;
        }
    }
}

// 特别为删除按钮添加样式
::v-deep .el-button.action-btn[type="danger"] {
    padding: 3px 8px;
    font-size: 10px !important;
    border-radius: 12px;
    height: auto;
    line-height: 1.5;
}

::v-deep .el-button--mini {
    font-size: 10px;
}

// 隐藏按钮图标
.no-icon {
    ::v-deep i {
        display: none !important;
    }
}
</style>