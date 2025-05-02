<template>
    <div>
        <el-row class="page-container">
            <!-- 搜索框 -->
            <div class="search-wrapper">
                <div class="search-input">
                    <div class="custom-input">
                        <i class="el-icon-search"></i>
                        <input type="text" placeholder="搜索用户留言" v-model="readerProposalQueryDto.content">
                        <span class="search-text" @click="fetchReaderProposal">搜索</span>
                    </div>
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
            :visible.sync="dialogWordOperation"
            :show-close="false"
            width="520px"
            custom-class="modern-dialog"
            :append-to-body="true">
            <div class="dialog-container">
                <!-- 对话框标题区 -->
                <div class="dialog-header">
                    <div class="header-icon">
                        <i class="el-icon-edit"></i>
                    </div>
                    <div class="header-content">
                        <h3 class="header-title">发表留言</h3>
                        <p class="header-subtitle">分享您的想法和建议</p>
                    </div>
                </div>
                
                <!-- 表单区域 -->
                <el-form :model="proposal" ref="proposalForm" class="proposal-form">
                    <!-- 输入区域 -->
                    <div class="input-section">
                        <el-form-item prop="content" :rules="[
                            { required: true, message: '请输入留言内容', trigger: 'blur' },
                            { max: 250, message: '留言内容不能超过250字', trigger: 'blur' }
                        ]">
                            <el-input 
                                type="textarea" 
                                :rows="4" 
                                placeholder="请输入留言内容，250字以内" 
                                v-model="proposal.content"
                                resize="none"
                                maxlength="250"
                                show-word-limit
                                class="content-textarea">
                            </el-input>
                        </el-form-item>
                    </div>
                    
                    <!-- 可见性选择区域 -->
                    <div class="visibility-section">
                        <div class="section-title">
                            <i class="el-icon-view"></i>
                            <span>留言可见性</span>
                        </div>
                        
                        <div class="option-cards">
                            <div 
                                class="option-card" 
                                :class="{'active': publishItemSelected === '公开'}"
                                @click="publishItemSelected = '公开'">
                                <div class="card-icon">
                                    <i class="el-icon-unlock"></i>
                                </div>
                                <div class="card-content">
                                    <h4>公开</h4>
                                    <p>所有用户可见</p>
                                </div>
                                <div class="card-radio">
                                    <div class="radio-inner" v-if="publishItemSelected === '公开'"></div>
                                </div>
                            </div>
                            
                            <div 
                                class="option-card" 
                                :class="{'active': publishItemSelected === '不公开'}"
                                @click="publishItemSelected = '不公开'">
                                <div class="card-icon">
                                    <i class="el-icon-lock"></i>
                                </div>
                                <div class="card-content">
                                    <h4>不公开</h4>
                                    <p>仅管理员可见</p>
                                </div>
                                <div class="card-radio">
                                    <div class="radio-inner" v-if="publishItemSelected === '不公开'"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </el-form>
                
                <!-- 按钮区域 -->
                <div class="action-buttons">
                    <button class="cancel-button" @click="cannel">
                        <i class="el-icon-close"></i>
                        <span>取消</span>
                    </button>
                    <button class="submit-button" @click="postProposal">
                        <i class="el-icon-s-promotion"></i>
                        <span>发表留言</span>
                    </button>
                </div>
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

.search-wrapper {
    margin-bottom: 15px;
    margin-top: -5px;
    
    .search-input {
        display: flex;
        max-width: 500px;
        margin: 0 auto;
        
        .custom-input {
            display: flex;
            width: 100%;
            background-color: white;
            border-radius: 40px;
            align-items: center;
            box-sizing: border-box;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: 1px solid #eee;
            transition: all 0.3s ease;
            padding: 10px 20px;
            
            &:hover, &:focus-within {
                box-shadow: 0 6px 16px rgba(255, 87, 34, 0.12);
                border-color: rgba(255, 87, 34, 0.2);
            }
            
            i {
                font-size: 18px;
                color: #ff5722;
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
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.message-card {
    border-radius: 10px;
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    width: 100%;
    position: relative;
    
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
        &::after {
            content: '已回复';
            position: absolute;
            top: 6px;
            right: 12px;
            font-size: 12px;
            padding: 3px 10px;
            border-radius: 12px;
            background-color: rgba(103, 194, 58, 0.1);
            color: #67C23A;
            font-weight: 500;
            box-shadow: 0 2px 4px rgba(103, 194, 58, 0.1);
        }
    }
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    padding-top: 10px;
    
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
            margin-right: 10px;
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

/* 现代化对话框样式 */
::v-deep .modern-dialog {
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 15px 40px rgba(0,0,0,0.2);
    
    .el-dialog__header,
    .el-dialog__body {
        padding: 0;
    }
    
    .el-dialog__headerbtn {
        display: none;
    }
}

.dialog-container {
    padding: 0;
}

.dialog-header {
    display: flex;
    align-items: center;
    padding: 18px 22px;
    background: linear-gradient(135deg, #ff7043 0%, #ff5722 100%);
    color: white;
    position: relative;
    overflow: hidden;

    &::before {
        content: '';
        position: absolute;
        top: 0;
        right: 0;
        width: 150px;
        height: 150px;
        background: rgba(255,255,255,0.1);
        border-radius: 50%;
        transform: translate(50%, -50%);
        z-index: 0;
    }

    .header-icon {
        width: 38px;
        height: 38px;
        background-color: rgba(255,255,255,0.2);
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 14px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        backdrop-filter: blur(5px);
        position: relative;
        z-index: 1;
        
        i {
            font-size: 20px;
            color: white;
        }
    }
    
    .header-content {
        position: relative;
        z-index: 1;
    }
    
    .header-title {
        font-size: 18px;
        font-weight: 600;
        margin: 0 0 3px 0;
    }
    
    .header-subtitle {
        font-size: 13px;
        margin: 0;
        opacity: 0.9;
    }
}

.proposal-form {
    padding: 18px 22px;
}

.input-section {
    margin-bottom: 20px;
    
    ::v-deep .el-textarea__inner {
        border-radius: 10px;
        padding: 12px;
        font-size: 14px;
        border: 1px solid #e0e0e0;
        box-shadow: inset 0 2px 4px rgba(0,0,0,0.03);
        transition: all 0.3s;
        
        &:hover {
            border-color: #ff9800;
        }
        
        &:focus {
            border-color: #ff5722;
            box-shadow: 0 0 0 3px rgba(255, 87, 34, 0.1);
        }
    }
    
    ::v-deep .el-textarea__word-count {
        color: #999;
        font-size: 12px;
        background: rgba(0,0,0,0.04);
        padding: 2px 8px;
        border-radius: 16px;
        bottom: -22px;
        right: 5px;
    }
}

.visibility-section {
    background-color: #f9f9f9;
    border-radius: 12px;
    padding: 16px;
    margin-bottom: 20px;
    
    .section-title {
        display: flex;
        align-items: center;
        margin-bottom: 12px;
        
        i {
            font-size: 16px;
            color: #ff5722;
            margin-right: 6px;
        }
        
        span {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }
    }
}

.option-cards {
    display: flex;
    gap: 12px;
}

.option-card {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px;
    background-color: white;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.2s ease;
    border: 2px solid transparent;
    position: relative;
    overflow: hidden;
    
    &::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(135deg, rgba(255,87,34,0.05) 0%, rgba(255,152,0,0.05) 100%);
        opacity: 0;
        transition: opacity 0.3s;
    }
    
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        
        &::before {
            opacity: 1;
        }
    }
    
    &.active {
        border-color: #ff5722;
        background-color: rgba(255,87,34,0.05);
        
        .card-icon {
            background-color: #ff5722;
            
            i {
                color: white;
            }
        }
        
        h4 {
            color: #ff5722;
        }
    }
    
    .card-icon {
        width: 32px;
        height: 32px;
        border-radius: 8px;
        background-color: #f5f5f5;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
        
        i {
            font-size: 16px;
            color: #666;
        }
    }
    
    .card-content {
        flex: 1;
        
        h4 {
            margin: 0 0 2px 0;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            transition: color 0.3s;
        }
        
        p {
            margin: 0;
            font-size: 12px;
            color: #999;
        }
    }
    
    .card-radio {
        width: 16px;
        height: 16px;
        border-radius: 50%;
        border: 2px solid #ddd;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
        
        .radio-inner {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background-color: #ff5722;
        }
    }
    
    &.active .card-radio {
        border-color: #ff5722;
    }
}

.action-buttons {
    display: flex;
    justify-content: flex-end;
    padding: 0 22px 22px;
    gap: 12px;
    
    button {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        height: 36px;
        padding: 0 18px;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.3s;
        
        i {
            font-size: 14px;
        }
    }
    
    .cancel-button {
        background-color: #f5f5f5;
        color: #666;
        font-size: 14px;
        
        &:hover {
            background-color: #eee;
            transform: translateY(-2px);
        }
    }
    
    .submit-button {
        background: linear-gradient(to right, #ff7043, #ff5722);
        color: white;
        font-size: 14px;
        box-shadow: 0 3px 8px rgba(255,87,34,0.3);
        
        &:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,87,34,0.4);
        }
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