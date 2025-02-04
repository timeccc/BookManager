<template>
    <el-row style="margin-top: 20px;">
        <!-- 条件搜索 -->
        <div class="word-search">
            <div class="item">
                <input type="text" placeholder="搜索用户留言" v-model="readerProposalQueryDto.content">
                <i class="el-icon-search" @click="fetchReaderProposal"></i>
            </div>
        </div>
        <!-- 条件选择 -->
        <div class="tag">
            <div class="item">
                <div>
                    <span :style="{
                        fontWeight: tagSelected === tagItem ? '800' : '',
                        color: tagSelected === tagItem ? 'rgb(51,51,51)' : '',
                        backgroundColor: tagSelected === tagItem ? 'rgb(247, 247, 247)' : ''
                    }" @click="condition(tagItem)" v-for="(tagItem, index) in tags" :key="index">
                        {{ tagItem }}
                    </span>
                </div>
                <div>
                    <span class="post-word" @click="postWord">
                        <i class="el-icon-position"></i>
                        我要留言
                    </span>
                </div>
            </div>
        </div>
        <div class="content">
            <div>
                <div v-if="proposals.length === 0">
                    <el-empty description="留言为空"></el-empty>
                </div>
                <div v-else class="content-item" v-for="(proposal, index) in proposals" :key="index">
                    <div>
                        <img :src="proposal.userAvatar" alt="">
                    </div>
                    <div>
                        <div class="title">{{ proposal.userName }}</div>
                        <div class="time">
                            <span>提出了问题</span>
                            <span>{{ proposal.createTime }}</span>
                            <el-popconfirm v-if="myContent(proposal)" title="删除自己的留言？" @confirm="confirmDel(proposal)">
                                <span slot="reference" class="text-button">删除</span>
                            </el-popconfirm>
                        </div>
                        <div class="detail">{{ proposal.content }}</div>
                        <div class="reply" v-if="proposal.replyTime !== null">
                            <div style="margin-bottom: 4px;">
                                <span>
                                    回复于
                                </span>
                                <span>
                                    {{ proposal.replyTime }}
                                </span>
                            </div>
                            <div>
                                {{ proposal.replyContent }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="pager">
            <div>
                <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange"
                    :current-page.sync="current" :page-size="size" layout="total, prev, pager, next"
                    :total="totalCount">
                </el-pagination>
            </div>
        </div>
        <el-dialog :show-close="false" :visible.sync="dialogWordOperation" width="22%">
            <div style="padding:30px 20px 20px 20px;">
                <el-row>
                    <p>*内容</p>
                    <el-input type="textarea" :rows="8" placeholder="留言内容，250字以内" v-model="proposal.content">
                    </el-input>
                </el-row>
                <el-row>
                    <p>*是否公开</p>
                    <span class="publish" :style="{
                        fontWeight: publishItemSelected === publishItem ? '800' : '',
                        color: publishItemSelected === publishItem ? 'rgb(51,51,51)' : '',
                        backgroundColor: publishItemSelected === publishItem ? 'rgb(247, 247, 247)' : ''
                    }" @click="publishChoose(publishItem)" v-for="(publishItem, index) in publishList" :key="index">
                        {{ publishItem }}
                    </span>
                </el-row>
            </div>
            <span slot="footer" class="dialog-footer">
                <span class="channel-button" @click="cannel()">
                    取消操作
                </span>
                <span class="edit-button" @click="postProposal()">
                    确定留言
                </span>
            </span>
        </el-dialog>
    </el-row>
</template>

<script>
export default {
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
            dialogWordOperation: false
        };
    },
    created() {
        this.fetchReaderProposal();
    },
    methods: {
        publishChoose(publish) {
            this.publishItemSelected = publish;
        },
        postProposal() {
            this.$axios.post(`/readerProposal/save`, this.proposal).then(res => {
                const { data } = res;
                if (data.code === 200) {
                    this.$notify({
                        duration: 1000,
                        title: '留言',
                        message: '留言新增成功',
                        type: 'success'
                    });
                    this.paramCondition('我的发布');
                    this.cannel();
                }
            }).catch(error => {
                console.log("查询用户留言异常：", error);
            });
        },
        cannel() {
            this.dialogWordOperation = false;
            this.proposal = {};
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
                console.log("查询用户留言异常：", error);
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
.publish {
    font-size: 16px;
    color: rgb(114, 114, 114);
    cursor: pointer;
    display: inline-block;
    transition: all .2s;
    padding: 10px 20px;
    border-radius: 10px;
}

.pager {
    display: flex;
    margin-block: 20px;
    justify-content: center;
    align-items: center;
}

.content {
    display: flex;
    justify-content: center;
    align-items: center;

    .content-item {
        width: 800px;
        display: flex;
        justify-content: left;
        align-items: center;
        gap: 20px;
        margin-block: 10px;
        padding-block: 8px;
        padding-left: 24px;

        img {
            width: 50px;
            height: 50px;
            border-radius: 25px;
        }

        .title {
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .time {
            display: flex;
            justify-content: left;
            gap: 8px;
            color: rgb(170, 170, 170);
            font-size: 14px;

        }

        .detail {
            margin-block: 8px;
            font-size: 14px;
            color: rgb(51, 51, 51);
        }

        .reply {
            background-color: rgb(250, 250, 250);
            padding: 12px;
            border-radius: 5px;
            font-size: 12px;
        }

    }
}

.tag {
    .item {
        width: 800px;
        padding-block: 10px;
        margin-block: 20px;
        display: flex;
        justify-content: space-between;
        gap: 4px;

        span {
            font-size: 16px;
            color: rgb(114, 114, 114);
            cursor: pointer;
            display: inline-block;
            transition: all .2s;
            padding: 10px 20px;
            border-radius: 10px;
        }

        .post-word {
            background-color: rgb(6, 174, 251);
            color: rgb(245, 245, 245);
        }

        .post-word:hover {
            background-color: rgb(15, 171, 243);
        }

    }

    display: flex;
    justify-content: center;
    align-items: center;
}

.word-search {
    display: flex;
    justify-content: center;

    .item {
        padding: 14px;
        width: 800px;
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