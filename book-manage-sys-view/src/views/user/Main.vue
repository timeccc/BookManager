<template>
    <el-row class="main-proposal-container">
            <!-- 搜索框 -->
        <div class="word-search">
            <div class="item">
                        <i class="el-icon-search"></i>
                        <input type="text" placeholder="搜索用户留言" v-model="readerProposalQueryDto.content">
                        <span class="search-text" @click="fetchReaderProposal">搜索</span>
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
                    <div class="list-title">
                    <span class="title-text">用户留言</span>
                    <div class="line-decoration"></div>
                </div>

                    <div v-for="(proposal, index) in proposals" 
                        :key="index"
                        class="message-card"
                        :class="getCardClass(index, proposal)">
                        
                    <div class="message-icon">
                        <i class="el-icon-chat-dot-square"></i>
                    </div>
                    <div class="message-main">
                        <!-- 卡片头部 -->
                        <div class="card-header">
                            <div class="user-info">
                                <el-avatar :src="proposal.userAvatar" :size="36"></el-avatar>
                                <div class="user-name">{{ proposal.userName }}</div>
                            </div>
                            <div class="message-actions">
                                <span class="message-time">{{ proposal.createTime }}</span>
                                <span v-if="proposal.replyTime !== null" class="reply-tag">已回复</span>
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
                                <i class="el-icon-s-custom"></i>
                                <span>管理员回复</span>
                                <span class="reply-time">{{ proposal.replyTime }}</span>
                            </div>
                            <div class="reply-content">
                                {{ proposal.replyContent }}
                            </div>
                        </div>
                    </div>
                </div>
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

        <!-- 留言对话框 -->
        <el-dialog 
            :visible.sync="dialogWordOperation"
            :show-close="false"
            width="520px"
            custom-class="modern-dialog"
            :append-to-body="true">
            <!-- 对话框内容 -->
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
    </el-row>
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
            readerProposalQueryDto: {
                current: 1,
                size: 5
            },
            proposals: [],
            totalCount: 0,
            size: 5,
            current: 1,
            queryUser: false,
            publishItemSelected: '公开',
            dialogWordOperation: false,
            cardColors: ['blue-card', 'green-card', 'orange-card', 'purple-card', 'cyan-card']
        };
    },
    created() {
        this.fetchReaderProposal();
    },
    methods: {
        // 获取卡片样式类
        getCardClass(index, proposal) {
            return this.cardColors[index % this.cardColors.length];
        },
            
        // 发表留言
        postProposal() {
            this.$refs.proposalForm.validate(valid => {
                if (!valid) return;
                
                this.$axios.post(`/readerProposal/save`, this.proposal)
                    .then(res => {
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
                    })
                    .catch(error => {
                        this.$notify({
                            title: '留言发表',
                            message: error.message || '发表失败',
                            type: 'error'
                        });
                        console.log("留言发表异常：", error);
                    });
            });
        },
        
        // 取消操作
        cannel() {
            this.dialogWordOperation = false;
            this.proposal = {};
            if (this.$refs.proposalForm) {
                this.$refs.proposalForm.resetFields();
            }
        },
        
        // 打开留言对话框
        postWord() {
            this.dialogWordOperation = true;
        },
        
        // 检查是否是当前用户的留言
        myContent(proposal) {
            const userId = sessionStorage.getItem('userId');
            return proposal.userId === Number(userId);
        },
        
        // 确认删除留言
        confirmDel(proposal) {
            const ids = [proposal.id];
            this.$axios.post(`/readerProposal/batchDelete`, ids)
                .then(res => {
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
                })
                .catch(error => {
                this.$notify({
                    title: '留言删除',
                    message: error.message || '删除失败',
                    type: 'error'
                });
                console.log("删除留言异常：", error);
            });
        },
        
        // 分页大小变化
        handleSizeChange(size) {
            this.size = size;
            this.readerProposalQueryDto.size = size;
            this.fetchReaderProposal();
        },
        
        // 当前页变化
        handleCurrentChange(current) {
            this.current = current;
            this.readerProposalQueryDto.current = current;
            this.fetchReaderProposal();
        },
        
        // 筛选标签点击
        condition(tag) {
            this.tagSelected = tag;
            this.paramCondition(tag);
        },
        
        // 设置查询参数
        paramCondition(tag) {
            switch (tag) {
                case '全部':
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = null;
                    break;
                case '已回复':
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = true;
                    break;
                case '未回复':
                this.queryUser = false;
                this.readerProposalQueryDto.isReply = false;
                    break;
                case '我的发布':
                this.queryUser = true;
                    break;
            }
            this.fetchReaderProposal();
        },
        
        // 查询留言列表
        fetchReaderProposal() {
            this.readerProposalQueryDto.size = this.size;
            this.readerProposalQueryDto.current = this.current;
            
            const endpoint = this.queryUser ? '/readerProposal/queryUser' : '/readerProposal/query';
            
            this.$axios.post(endpoint, this.readerProposalQueryDto)
                .then(res => {
                const { data } = res;
                if (data.code === 200) {
                    this.proposals = data.data;
                    this.totalCount = data.total;
                }
                })
                .catch(error => {
                console.log("查询用户留言异常：", error);
            });
        }
    },
};
</script>
<style scoped lang="scss">
// 颜色变量
$primary-color: #ff5722;
$primary-light: rgba(255, 87, 34, 0.08);
$primary-border: rgba(255, 87, 34, 0.2);
$card-shadow: 0 4px 12px rgba(0,0,0,0.08);
$hover-shadow: 0 6px 16px rgba(0,0,0,0.12);
$text-primary: #333;
$text-secondary: #666;
$text-light: #999;
$border-light: #eee;
$background-light: #f8f9fa;

// 公共动画
@mixin hover-transform {
  transition: all 0.3s ease;
  &:hover {
    transform: translateY(-2px);
  }
}

.main-proposal-container {
    width: 100%;
    background-color: transparent;
    box-shadow: none;
    margin-bottom: 0;
    position: relative;
}

// 列表标题样式
.list-title {
    margin-bottom: 30px;
    position: relative;
    display: flex;
    align-items: center;
    padding: 0 10px;
    
    .title-text {
        font-size: 20px;
        font-weight: 600;
        color: $text-primary;
        margin-right: 20px;
        position: relative;
        
        &:after {
            content: '';
            position: absolute;
            bottom: -6px;
            left: 0;
            width: 40px;
            height: 3px;
            background: $primary-color;
            border-radius: 3px;
        }
    }
    
    .line-decoration {
        flex: 1;
        height: 1px;
        background: linear-gradient(to right, rgba(0,0,0,0.1), rgba(0,0,0,0.02));
    }
}

// 搜索框样式
.word-search {
        display: flex;
    justify-content: center;
    margin-bottom: 15px;
    margin-top: 15px;
        
    .item {
        padding: 10px 20px;
        width: 500px;
            background-color: white;
            border-radius: 40px;
        display: flex;
        justify-content: space-between;
            align-items: center;
            box-sizing: border-box;
        box-shadow: $card-shadow;
        border: 1px solid $border-light;
            transition: all 0.3s ease;
            
            &:hover, &:focus-within {
            box-shadow: $hover-shadow;
            border-color: $primary-border;
            }
            
            input {
                flex: 1;
                border: none;
                background-color: transparent;
                outline: none;
                font-size: 16px;
            color: $text-primary;
                margin: 0 15px;
                height: 24px;
            }

        i {
            font-size: 18px;
            color: $primary-color;
        }
            
            .search-text {
                display: inline-block;
                padding: 6px 16px;
                border-radius: 20px;
            background-color: $primary-color;
                color: white;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                
                &:hover {
                background-color: darken($primary-color, 5%);
                    transform: translateY(-1px);
            }
        }
    }
}

// 分类标签样式
.category-container {
    display: flex;
    flex-wrap: wrap;
    margin-bottom: 15px;
    gap: 10px;
    justify-content: center;
}

.category {
    padding: 8px 16px;
    border-radius: 10px;
    background-color: white;
    color: $text-secondary;
    font-size: 14px;
    cursor: pointer;
    @include hover-transform;
    border: 1px solid $border-light;
    box-shadow: 0 2px 6px rgba(0,0,0,0.03);
    
    &:hover {
        background-color: $primary-light;
        color: $primary-color;
        border-color: $primary-border;
    }
    
    &.active-category {
        background-color: $primary-light;
        color: $primary-color;
        font-weight: 500;
        border-color: $primary-border;
    }
}

// 内容区域样式
.content-section {
    background-color: transparent;
    min-height: 500px;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    padding: 0 20px;
}

// 卡片列表样式
.card-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
    width: 100%;
    max-width: 900px;
    margin: 0 auto;
}

// 留言卡片样式
.message-card {
    display: flex;
    margin-bottom: 20px;
    border-radius: 16px;
    overflow: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    background-color: white;
    border: 1px solid #f0f0f0;
    position: relative;
    
    &:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    }
    
    // 根据列表位置交替背景色
    &:nth-child(odd) {
        background-color: #f8fbff;
    }
    
    &:nth-child(even) {
        background-color: #f5fcf5;
    }
    
    // 图标区域
    .message-icon {
        width: 80px;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: $primary-light;
        color: $primary-color;
        
        i {
            font-size: 30px;
        }
    }
    
    // 内容区域
    .message-main {
        flex: 1;
        padding: 20px;
    }
    
    // 颜色变体
    &.blue-card .message-icon {
        background-color: rgba(64, 158, 255, 0.15);
        color: #409EFF;
    }
    
    &.green-card .message-icon {
        background-color: rgba(103, 194, 58, 0.15);
            color: #67C23A;
    }
    
    &.orange-card .message-icon {
        background-color: rgba(255, 87, 34, 0.15);
        color: $primary-color;
    }
    
    &.purple-card .message-icon {
        background-color: rgba(145, 94, 251, 0.15);
        color: #915EFB;
    }
    
    &.cyan-card .message-icon {
        background-color: rgba(94, 203, 251, 0.15);
        color: #5ECBFB;
    }
}

// 卡片头部样式
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 10px;
        
        .user-name {
            font-weight: 500;
            color: $text-primary;
        }
    }
    
    .message-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        
        .message-time {
            color: $text-light;
            font-size: 12px;
            margin-right: 5px;
        }
        
        .reply-tag {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            background-color: rgba(103, 194, 58, 0.1);
            color: #67C23A;
            font-size: 12px;
            font-weight: 500;
        }
    }
}

// 卡片内容样式
.card-content {
    margin-bottom: 15px;
    line-height: 1.6;
    color: $text-primary;
    position: relative;
    padding: 12px 16px;
    background: rgba(0,0,0,0.02);
    border-radius: 8px;
    border-left: 3px solid rgba(255, 87, 34, 0.3);
}

// 回复区域样式
.card-reply {
    background-color: #f9f9f9;
    border-radius: 10px;
    padding: 12px;
    margin-top: 10px;
    
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
            color: $text-light;
            margin-left: auto;
        }
    }
    
    .reply-content {
        color: #555;
        line-height: 1.6;
        position: relative;
        padding: 12px 16px;
        background: rgba(0,0,0,0.01);
        border-radius: 8px;
        border-left: 3px solid rgba(64, 158, 255, 0.3);
    }
}

// 分页样式
.pager {
    margin-top: 20px;
    display: flex;
    justify-content: center;
}

// 对话框样式
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

// 对话框头部
.dialog-header {
    display: flex;
    align-items: center;
    padding: 18px 22px;
    background: linear-gradient(135deg, #ff7043 0%, $primary-color 100%);
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

// 表单样式
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
            border-color: $primary-color;
            box-shadow: 0 0 0 3px rgba(255, 87, 34, 0.1);
        }
    }
    
    ::v-deep .el-textarea__word-count {
        color: $text-light;
        font-size: 12px;
        background: rgba(0,0,0,0.04);
        padding: 2px 8px;
        border-radius: 16px;
        bottom: -22px;
        right: 5px;
    }
}

// 可见性设置区域
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
            color: $primary-color;
            margin-right: 6px;
        }
        
        span {
            font-size: 14px;
            font-weight: 500;
            color: $text-primary;
        }
    }
}

// 可见性选项卡片
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
        border-color: $primary-color;
        background-color: $primary-light;
        
        .card-icon {
            background-color: $primary-color;
            
            i {
                color: white;
            }
        }
        
        h4 {
            color: $primary-color;
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
            color: $text-secondary;
        }
    }
    
    .card-content {
        flex: 1;
        padding: 0;
        margin: 0;
        background: none;
        border: none;
        
        h4 {
            margin: 0 0 2px 0;
            font-size: 14px;
            font-weight: 500;
            color: $text-primary;
            transition: color 0.3s;
        }
        
        p {
            margin: 0;
            font-size: 12px;
            color: $text-light;
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
            background-color: $primary-color;
        }
    }
    
    &.active .card-radio {
        border-color: $primary-color;
    }
}

// 操作按钮
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
        color: $text-secondary;
        font-size: 14px;
        
        &:hover {
            background-color: #eee;
            transform: translateY(-2px);
        }
    }
    
    .submit-button {
        background: linear-gradient(to right, #ff7043, $primary-color);
        color: white;
        font-size: 14px;
        box-shadow: 0 3px 8px rgba(255,87,34,0.3);
        
        &:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255,87,34,0.4);
        }
    }
}

// Element UI 组件样式覆盖
::v-deep .el-pagination {
    padding: 15px 0;
    
    .btn-prev, .btn-next, .el-pager li {
        border-radius: 8px;
        transition: all 0.3s ease;
    }
    
    .el-pager li.active {
        background-color: $primary-color;
        color: white;
    }
}

::v-deep .el-card__body {
    padding: 16px;
}

::v-deep .el-textarea__inner {
    border-radius: 10px;
    
    &:focus {
        border-color: $primary-color;
    }
}

::v-deep .el-radio__input.is-checked .el-radio__inner {
    background-color: $primary-color;
    border-color: $primary-color;
}

::v-deep .el-radio__input.is-checked + .el-radio__label {
    color: $primary-color;
}
</style>