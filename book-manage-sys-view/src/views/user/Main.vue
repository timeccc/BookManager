<template>
    <div>
        <el-row class="page-container">
            <!-- 搜索框 -->
            <div class="word-search">
                <div class="item">
                    <input type="text" placeholder="搜索用户留言" v-model="readerProposalQueryDto.content">
                    <i class="el-icon-search" @click="fetchReaderProposal"></i>
                </div>
            </div>
            
            <!-- 筛选标签 -->
            <div class="category-container">
                <span class="category" 
                      :class="{'active-category': tagSelected === tagItem}" 
                      @click="condition(tagItem)" 
                      v-for="(tagItem, index) in tags" 
                      :key="index">
                    {{ tagItem }}
                </span>
            </div>
            
            <!-- 留言内容区 -->
            <div class="content-section">
                <el-empty 
                    v-if="proposals.length === 0" 
                    description="暂无留言" 
                    :image-size="200">
                </el-empty>
                
                <div v-else class="card-list">
                    <el-card 
                        v-for="(proposal, index) in proposals" 
                        :key="index"
                        shadow="hover" 
                        class="message-card"
                        :class="getCardClass(index, proposal)">
                        
                        <!-- 卡片头部 -->
                        <div class="card-header">
                            <div class="user-info">
                                <el-avatar :src="proposal.userAvatar" :size="36"></el-avatar>
                                <div class="user-name">{{ proposal.userName }}</div>
                            </div>
                            <div class="message-actions">
                                <span class="message-time">{{ proposal.createTime }}</span>
                                <el-popconfirm 
                                    v-if="myContent(proposal)" 
                                    title="确定删除这条留言吗？" 
                                    @confirm="confirmDel(proposal)">
                                    <el-button slot="reference" type="danger" size="mini" icon="el-icon-delete" circle></el-button>
                                </el-popconfirm>
                            </div>
                        </div>
                        
                        <!-- 留言内容 -->
                        <div class="card-content">
                            {{ proposal.content }}
                        </div>
                        
                        <!-- 回复内容 -->
                        <div v-if="proposal.replyTime !== null" class="card-reply">
                            <div class="reply-header">
                                <i class="el-icon-chat-dot-square"></i>
                                <span>管理员回复</span>
                                <span class="reply-time">{{ proposal.replyTime }}</span>
                            </div>
                            <div class="reply-content">
                                {{ proposal.replyContent }}
                            </div>
                        </div>
                    </el-card>
                </div>
            </div>
            
            <!-- 分页控件 -->
            <div class="pager" v-if="proposals.length !== 0">
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

        <!-- 留言对话框 -->
        <el-dialog 
            title="发表留言" 
            :visible.sync="dialogWordOperation"
            :show-close="false"
            width="500px">
            <el-form :model="proposal" ref="proposalForm" label-width="80px">
                <el-form-item label="留言内容" prop="content" :rules="[
                    { required: true, message: '请输入留言内容', trigger: 'blur' },
                    { max: 250, message: '留言内容不能超过250字', trigger: 'blur' }
                ]">
                    <el-input 
                        type="textarea" 
                        :rows="6" 
                        placeholder="请输入留言内容，250字以内" 
                        v-model="proposal.content">
                    </el-input>
                </el-form-item>
                <el-form-item label="是否公开">
                    <el-radio-group v-model="publishItemSelected">
                        <el-radio v-for="(item, index) in publishList" :key="index" :label="item">
                            {{ item }}
                        </el-radio>
                    </el-radio-group>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <span class="channel-button" @click="cannel">
                    取消操作
                </span>
                <span class="edit-button" @click="postProposal">
                    发表留言
                </span>
            </span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    components: {
    },
    data() {
        return {
            proposal: {},
            tags: ['全部', '已回复', '未回复', '我的发布'],
            tagSelected: '全部',
            readerProposalQueryDto: {},
            proposals: [],
            totalCount: 5,
            size: 5,
            current: 1,
            queryUser: false,
            publishList: ['公开', '不公开'],
            publishItemSelected: '公开',
            dialogWordOperation: false,
            cardColors: ['blue-card', 'green-card', 'orange-card', 'purple-card', 'cyan-card']
        };
    },
    created() {
        this.fetchReaderProposal();
    },
    methods: {
        getCardClass(index, proposal) {
            // 根据索引或其他条件分配不同颜色
            let baseClass = this.cardColors[index % this.cardColors.length];
            
            // 为已回复和未回复的留言添加额外的类
            if (proposal.replyTime !== null) {
                return `${baseClass} replied`;
            }
            return baseClass;
        },
        publishChoose(publish) {
            this.publishItemSelected = publish;
        },
        postProposal() {
            this.$refs.proposalForm.validate(valid => {
                if (valid) {
                    this.$axios.post(`/readerProposal/save`, this.proposal).then(res => {
                        const { data } = res;
                        if (data.code === 200) {
                            this.$notify({
                                duration: 1000,
                                title: '留言',
                                message: '留言发表成功',
                                type: 'success'
                            });
                            this.paramCondition('我的发布');
                            this.cannel();
                        }
                    }).catch(error => {
                        this.$notify({
                            title: '留言发表',
                            message: error.message || '发表失败',
                            type: 'error'
                        });
                        console.log("留言发表异常：", error);
                    });
                }
            });
        },
        cannel() {
            this.dialogWordOperation = false;
            this.proposal = {};
            if (this.$refs.proposalForm) {
                this.$refs.proposalForm.resetFields();
            }
        },
        postWord() {
            this.dialogWordOperation = true;
        },
        myContent(proposal) {
            const userId = sessionStorage.getItem('userId');
            return proposal.userId === Number(userId);
        },
        confirmDel(proposal) {
            const ids = [proposal.id];
            this.$axios.post(`/readerProposal/batchDelete`, ids).then(res => {
                const { data } = res;
                if (data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '留言删除',
                        message: '留言删除成功',
                        type: 'success'
                    });
                    this.fetchReaderProposal();
                }
            }).catch(error => {
                this.$notify({
                    title: '留言删除',
                    message: error.message || '删除失败',
                    type: 'error'
                });
                console.log("删除留言异常：", error);
            });
        },
        handleSizeChange(size) {
            this.size = size;
            this.fetchReaderProposal();
        },
        handleCurrentChange(current) {
            this.current = current;
            this.fetchReaderProposal();
        },
        condition(tag) {
            this.tagSelected = tag;
            this.paramCondition(tag);
        },
        paramCondition(tag) {
            if (tag === '全部') {
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = null;
            } else if (tag === '已回复') {
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = true;
            } else if (tag === '未回复') {
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = false;
            } else if (tag === '我的发布') {
                this.queryUser = true;
            }
            this.fetchReaderProposal();
        },
        // 读者建议查询
        fetchReaderProposal() {
            this.readerProposalQueryDto.size = this.size;
            this.readerProposalQueryDto.current = this.current;
            this.$axios.post(`/readerProposal/${this.queryUser ? '/queryUser' : '/query'}`, this.readerProposalQueryDto).then(res => {
                const { data } = res;
                if (data.code === 200) {
                    this.proposals = data.data;
                    this.totalCount = data.total;
                }
            }).catch(error => {
                console.log("查询用户留言异常：", error);
            });
        },
        timeDeal() {
            this.proposals.map(proposal => proposal.createTime.substring(1, 5))
        }
    },
};
</script>
<style scoped lang="scss">
.page-container {
    background-color: white;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.03);
    margin-bottom: 20px;
}

.word-search {
    flex: 1;
    max-width: 500px;
    margin: 20px auto;
    
    .item {
        display: flex;
        align-items: center;
        background-color: #f8f9fa;
        border-radius: 10px;
        padding: 8px 16px;
        transition: all 0.3s ease;
        
        &:hover {
            background-color: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        input {
            flex: 1;
            border: none;
            outline: none;
            background: transparent;
            padding: 8px 0;
            font-size: 16px;
            color: #333;
            
            &::placeholder {
                color: #999;
            }
        }
        
        i {
            font-size: 18px;
            color: #666;
            cursor: pointer;
            padding: 8px;
            border-radius: 8px;
            transition: all 0.3s ease;
            
            &:hover {
                background-color: rgba(255, 87, 34, 0.08);
                color: #ff5722;
            }
        }
    }
}

.category-container {
    display: flex;
    flex-wrap: wrap;
    margin-bottom: 20px;
    gap: 10px;
}

.category {
    padding: 8px 16px;
    border-radius: 10px;
    background-color: #f8f9fa;
    color: #606266;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    
    &:hover {
        background-color: rgba(255, 87, 34, 0.08);
        color: #ff5722;
        transform: translateY(-2px);
    }
    
    &.active-category {
        background-color: rgba(255, 87, 34, 0.1);
        color: #ff5722;
        font-weight: 500;
    }
}

.content-section {
    min-height: 300px;
}

.card-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.message-card {
    border-radius: 10px;
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    
    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    }
    
    &.blue-card {
        border-left: 4px solid #409EFF;
    }
    
    &.green-card {
        border-left: 4px solid #67C23A;
    }
    
    &.orange-card {
        border-left: 4px solid #ff5722;
    }
    
    &.purple-card {
        border-left: 4px solid #915EFB;
    }
    
    &.cyan-card {
        border-left: 4px solid #5ECBFB;
    }
    
    &.replied {
        position: relative;
        
        &::after {
            content: '已回复';
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 8px;
            background-color: rgba(103, 194, 58, 0.1);
            color: #67C23A;
        }
    }
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
        
        .user-name {
            font-weight: 500;
            color: #333;
        }
    }
    
    .message-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        
        .message-time {
            color: #999;
            font-size: 12px;
        }
    }
}

.card-content {
    margin-bottom: 15px;
    line-height: 1.6;
    color: #333;
}

.card-reply {
    background-color: #f8f9fa;
    border-radius: 10px;
    padding: 12px;
    
    .reply-header {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 8px;
        color: #409EFF;
        font-weight: 500;
        
        i {
            font-size: 16px;
        }
        
        .reply-time {
            font-size: 12px;
            color: #999;
            margin-left: auto;
        }
    }
    
    .reply-content {
        color: #555;
        line-height: 1.6;
    }
}

.pager {
    margin-top: 20px;
    display: flex;
    justify-content: center;
}

.channel-button, .edit-button {
    padding: 8px 16px;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-weight: 500;
}

.channel-button {
    background-color: #f0f2f5;
    color: #606266;
    
    &:hover {
        background-color: #e0e2e5;
        transform: translateY(-2px);
    }
}

.edit-button {
    background-color: #ff5722;
    color: white;
    
    &:hover {
        background-color: #ff7043;
        transform: translateY(-2px);
    }
}

.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

/* 对话框样式 */
::v-deep .el-dialog {
    border-radius: 16px;
    overflow: hidden;
    
    .el-dialog__header {
        padding: 16px 20px;
        border-bottom: 1px solid rgba(0,0,0,0.05);
    }
    
    .el-dialog__title {
        font-weight: 500;
        font-size: 16px;
        color: #333;
    }
}

/* 分页组件样式 */
::v-deep .el-pagination {
    padding: 15px 0;
    
    .btn-prev, .btn-next, .el-pager li {
        border-radius: 8px;
        transition: all 0.3s ease;
    }
    
    .el-pager li.active {
        background-color: #ff5722;
        color: white;
    }
}

::v-deep .el-card__body {
    padding: 16px;
}

::v-deep .el-textarea__inner {
    border-radius: 10px;
    
    &:focus {
        border-color: #ff5722;
    }
}

::v-deep .el-radio__input.is-checked .el-radio__inner {
    background-color: #ff5722;
    border-color: #ff5722;
}

::v-deep .el-radio__input.is-checked + .el-radio__label {
    color: #ff5722;
}
</style>