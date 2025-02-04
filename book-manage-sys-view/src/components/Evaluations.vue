<template>
    <div style="width: 100%;">
        <el-row style="margin: 5px 0;">
            <h2 class="commentHeader">评论&nbsp;{{ evaluationsCount }}</h2>
            <el-row style="margin: 15px 0;">
                <el-col :span="2">
                    <el-avatar :src="userData.userAvatar"></el-avatar>
                </el-col>
                <el-col :span="22">
                    <div class="parent-comment"
                        :style="{ backgroundColor: bgColor, height: isFocused ? '120px' : '70px', borderColor: isFocused ? '#007bff' : 'transparent' }">
                        <textarea class="comment-parent-input" v-model="content" placeholder="请友好交流" @focus="onFocus"
                            @blur="onBlur"></textarea>
                        <div>
                            <span class="comment-input-number">{{ content.length }} / 300</span>
                            <el-button
                                :style="{ backgroundColor: isFocused ? '#007bff' : '#666', borderColor: isFocused ? '#007bff' : '#666' }"
                                @click="commentClick" class="comment-clike" size="mini" type="primary">评论</el-button>
                        </div>
                    </div>
                </el-col>
            </el-row>
        </el-row>
        <el-row style="margin: 5px 0px;">
            <el-row v-for="(comment, index) in commentList " :key="index" style="padding: 10px 0;">
                <el-row>
                    <el-col :span="2">
                        <el-avatar size="large" :src="comment.userAvatar"></el-avatar>
                    </el-col>
                    <el-col :span="22">
                        <span style="height: 40px;line-height: 40px;font-size: 16px;color: #515767;">{{
                            comment.userName }}</span>
                        <span v-if="comment.userId == userId" class="my-body-tag">我自己</span>
                    </el-col>
                </el-row>
                <el-row style="padding: 8px 0;">
                    <el-col :span="22" :offset="2">
                        <span style="font-size: 16px;color: #252933;">{{ comment.content }}</span>
                    </el-col>
                </el-row>
                <el-row style="padding: 8px 0;">
                    <el-col :span="22" :offset="2">
                        <span style="font-size: 14px;color: #8A919F;">{{ comment.time }}</span>
                        <el-popconfirm confirm-button-text='好的' cancel-button-text='不删了' icon="el-icon-info"
                            icon-color="red" title="删除该条评论？" v-if="comment.userId == userId"
                            @confirm="deleteComment(comment)">
                            <span slot="reference"
                                style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                                <i class="el-icon-delete"></i>
                                删除
                            </span>
                        </el-popconfirm>
                        <span @click="toggleReplyInput(comment)"
                            style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                            <i class="el-icon-chat-dot-round"></i>
                            回复<span v-if="comment.childTotal != 0">({{ comment.childTotal }})</span>
                        </span>
                        <span @click="upvote(comment)"
                            style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                            <i class="el-icon-discount" v-if="!comment.upvoteFlag">点赞</i>
                            <i class="el-icon-discount" v-else style="color: #1E80FF;">&nbsp;{{ comment.upvoteCount
                                }}</i>
                        </span>
                    </el-col>
                </el-row>
                <!-- 父级评论的回复按钮和输入框 -->
                <el-row v-if="comment.showReplyInput" style="padding: 10px 0;">
                    <el-col :span="22" :offset="2">
                        <div class="parent-comment"
                            :style="{ backgroundColor: bgColor, height: '110px', borderColor: '#007bff' }">
                            <textarea class="comment-parent-input" v-model="replyContent"
                                :placeholder="replyText"></textarea>
                            <div>
                                <span class="comment-input-number">{{ replyContent.length }} / 300</span>
                                <el-button style="background-color: #007bff;user-select: none;"
                                    @click="submitReply(comment)" class="comment-clike" size="mini"
                                    type="primary">评论</el-button>
                            </div>
                        </div>
                    </el-col>
                </el-row>
                <!-- 子级评论 -->
                <el-row v-for="(commentChild, index) in comment.commentChildVOS " :key="index"
                    style="padding: 10px 15px;font-size: 16px;">
                    <el-row>
                        <el-col :span="22" :offset="2">
                            <el-row style="display: flex; align-items: center; flex-wrap: wrap;">
                                <el-avatar size="small" :src="commentChild.userAvatar"
                                    style="margin-right: 5px;"></el-avatar>
                                <span style="color: #515767; padding: 0 5px;">{{ commentChild.userName }}</span>
                                <span v-if="commentChild.userId == userId" class="my-body-tag">我自己</span>
                                <span v-if="commentChild.replierName != null"
                                    style="margin:0 15px;color: #1c1c1c;user-select: none;font-size: 12px;">
                                    回复
                                </span>
                                <el-avatar v-if="commentChild.replierName != null" size="small"
                                    :src="commentChild.replierAvatar" style="margin-right: 5px;"></el-avatar>
                                <span v-if="commentChild.replierName != null" style="color: #515767;padding: 0 5px;">{{
                                    commentChild.replierName }}</span>
                                <span v-if="commentChild.replierId == userId" class="my-body-tag">我自己</span>
                                <span
                                    style="letter-spacing: 1px;font-size: 16px; color: #252933; white-space: normal; margin-left: 5px;padding: 6px 0;">
                                    : {{ commentChild.content }}
                                </span>
                            </el-row>
                            <el-row style="padding: 10px 0;">
                                <span style="font-size: 14px;color: #8A919F;">{{ commentChild.time }}</span>
                                <el-popconfirm confirm-button-text='好的' cancel-button-text='不删了' icon="el-icon-info"
                                    icon-color="red" title="删除该条评论？" v-if="commentChild.userId == userId"
                                    @confirm="deleteComment(commentChild)">
                                    <span slot="reference"
                                        style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                                        <i class="el-icon-delete"></i>
                                        删除
                                    </span>
                                </el-popconfirm>
                                <span @click="toggleReplyInput1(commentChild)"
                                    style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                                    <i class="el-icon-chat-dot-round"></i>
                                    回复
                                </span>
                                <span @click="upvote(commentChild)"
                                    style="cursor: pointer;margin-left: 15px;font-size: 14px;color: #8A919F;user-select: none;">
                                    <i class="el-icon-discount" v-if="!commentChild.upvoteFlag">点赞</i>
                                    <i class="el-icon-discount" v-else style="color: #1E80FF;">&nbsp;{{
                                        commentChild.upvoteCount }}</i>
                                </span>
                            </el-row>
                            <!-- 子级评论的回复按钮和输入框 -->
                            <el-row v-if="commentChild.replyInputStatus" style="padding: 10px 0;">
                                <el-col :span="24">
                                    <div class="parent-comment"
                                        :style="{ backgroundColor: bgColor, height: '110px', borderColor: '#007bff' }">
                                        <textarea class="comment-parent-input" v-model="replyChildContent"
                                            :placeholder="replyText"></textarea>
                                        <div>
                                            <span class="comment-input-number">{{ replyChildContent.length }} /
                                                300</span>
                                            <el-button style="background-color: #007bff;"
                                                @click="submitReply1(commentChild)" class="comment-clike" size="mini"
                                                type="primary">评论</el-button>
                                        </div>
                                    </div>
                                </el-col>
                            </el-row>
                        </el-col>
                    </el-row>
                </el-row>
            </el-row>
        </el-row>
        <!-- 举报反馈对话框 -->
        <el-dialog style="user-select: none;border-radius: 5px;" title="我要举报" :visible.sync="dialogVisibleReport"
            width="30%">
            <el-row v-for="(item, index) in reports" :key="index" style="margin-top: 10px;">
                <el-row style="padding-bottom: 10px;user-select: none;">*{{ item.name }}</el-row>
                <el-row>
                    <span v-for="(itemChild, indexChild) in item.list" :key="indexChild"
                        @click="reportItemClick(itemChild)">
                        <button :style="{ border: itemChild.isSelected ? '1px solid #4b87bc' : '1px solid #f4f4f4' }"
                            class="reportItem">
                            {{ itemChild.name }}
                        </button>
                    </span>
                </el-row>
            </el-row>
            <span slot="footer" class="dialog-footer">
                <button class="cannel-btn" @click="dialogVisibleReport = false">取消</button>
                <button class="yes-btn" @click="operationReport">确定举报</button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import { timeAgo } from '@/utils/data'
export default {
    props: {
        contentId: {
            type: Number,
            default: ''
        },
        contentType: {
            type: String,
            default: ''
        }
    },
    data() {
        return {
            userData: {},
            noteData: {},
            commentContent: '',
            content: '',
            commentList: [],
            replyContent: '',
            id: null,
            isFocused: false,
            bgColor: 'rgb(245 245 245)',
            strLength: '0/300',
            replyText: '',
            userId: '',
            dialogVisibleReport: false,
            reports: [],
            selectdStatus: false,
            evaluationsCount: 0,
            comment: {},
            replyChildContent: '',
        };
    },
    watch: {
        contentId(newVal,oldVal){
            if(newVal !== oldVal){
                this.loadCommentList();
            }
        },
        content() {
            if (this.content === '') {
                this.isFocused = false;
                return;
            }
        },
    },
    created() {
        this.getUserInfo();
        this.loadCommentList();
    },
    methods: {
        getUserInfo() {
            const userInfo = sessionStorage.getItem("userInfo");
            this.userData = JSON.parse(userInfo);
            this.userId = this.userData.id;
        },
        // 点赞 或 取消点赞
        upvote(comment) {
            let upvoteList = comment.upvoteList ? comment.upvoteList.split(',') : [];
            if (upvoteList.length) {
                // 界面反映
                if (comment.upvoteFlag) {
                    // 取消点赞
                    let index = upvoteList.indexOf(this.userData.id.toString());
                    if (index !== -1) {
                        upvoteList.splice(index, 1); // 移除用户ID
                    }
                } else {
                    // 点赞
                    if (!upvoteList.includes(this.userData.userId.toString())) {
                        upvoteList.push(this.userData.userId.toString()); // 添加用户ID
                    }
                }
            }
            let evalustions = {
                id: comment.id,
                upvoteList: upvoteList.length ? upvoteList.join(',') : this.userData.id
            }
            this.$axios.put(`evaluations/update`, evalustions).then(res => {
                if (res.data.code == 200) {
                    comment.upvoteList = upvoteList.join(','); // 更新upvoteList字符串
                    comment.upvoteFlag = !comment.upvoteFlag; // 切换点赞状态标志
                    comment.upvoteCount += 1;
                }
            }).catch(err => {
                console.error(`点赞状态设置异常 -> `, err);
            })
        },
        // 确定举报
        operationReport() {
            let reportItem = [];
            this.reports.forEach(entity => {
                let entityReport = entity.list.filter(child => child.isSelected);
                if (entityReport.length != 0) {
                    reportItem = entityReport;
                }
            });
            if (!reportItem.length) {
                this.$message(`请选中举报项`);
                return;
            }
            this.$axios.get(`evaluations-reports/report/${this.comment.id}/${reportItem[0].name}`).then(res => {
                this.dialogVisibleReport = false;
                if (res.data.code == 200) {
                    this.$swal.fire({
                        title: '举报操作',
                        text: '举报成功',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1100
                    });
                } else {
                    this.$swal.fire({
                        title: '举报操作',
                        text: res.data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 1100
                    });
                }
            }).catch(err => {
                console.error(`评论举报异常 -> `, err);
            })
        },
        // 选中举报项
        reportItemClick(itemChild) {
            this.reports.forEach(entity => {
                entity.list.forEach(child => {
                    child.isSelected = false;
                })
            })
            itemChild.isSelected = true;
        },
        reportList() {
            this.$axios.get(`evaluations/reportList`).then(res => {
                if (res.data.code == 200) {
                    this.reports = [];
                    res.data.data.forEach(entity => {
                        let report = { name: entity.name };
                        let resportList = [];
                        entity.list.forEach(listItem => {
                            let reportChild = {};
                            reportChild.name = listItem;
                            reportChild.isSelected = false;
                            resportList.push(reportChild);
                        })
                        report.list = resportList;
                        this.reports.push(report);
                    })
                }
            }).catch(err => {
                console.error(`举报项加载失败 -> `, err);
            })
        },
        reportComment(comment) {
            this.reportList();
            this.dialogVisibleReport = true;
            this.comment = comment;
        },
        deleteComment(comment) { // 删除评论
            this.$axios.delete(`evaluations/delete/${comment.id}`).then(res => {
                if (res.data.code == 200) {
                    this.$message.success(res.data.msg);
                    this.loadCommentList();
                }
            }).catch(err => {
                console.error(`评论异常 -> `, err);
            })
        },
        onFocus() {
            this.isFocused = true;
        },
        // 输入框失去焦点
        onBlur() {
            if (this.content === '') {
                this.isFocused = false;
                return;
            }
            this.isFocused = true;
        },
        commentClick() {
            if (this.content == '') {
                this.$swal.fire({
                    title: '内容提示',
                    text: '评论内容为空',
                    icon: 'success',
                    showConfirmButton: false,
                    timer: 800
                });
                return;
            }
            const evaluations = {
                contentType: this.contentType,
                content: this.content,
                contentId: this.contentId,
            }
            this.$axios.post(`evaluations/insert`, evaluations).then(res => {
                if (res.data.code == 200) {
                    this.content = '';
                    this.$swal.fire({
                        title: '评论操作',
                        text: '评论成功',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1100
                    });
                    setTimeout(() => {
                        this.loadCommentList()
                    }, 1100)
                }else{
                    this.$swal.fire({
                        title: '评论异常',
                        text: res.data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 1100
                    });
                }
            }).catch(err => {
                console.error(`评论异常 -> `, err);
            })
        },
        // 父级评论回复点击
        toggleReplyInput(comment) {
            this.replyText = `回复${comment.userName}...`;
            if (comment.showReplyInput == null) {
                comment.showReplyInput = false;
            }
            comment.showReplyInput = !comment.showReplyInput;
        },
        // 子级评论回复点击
        toggleReplyInput1(comment) {
            if (comment.replyInputStatus == null) {
                comment.replyInputStatus = false;
            }
            comment.replyInputStatus = !comment.replyInputStatus;
        },
        // 父级评论回复提交
        submitReply(comment) {
            if (this.replyContent == '') {
                this.$message(`评论内容不能为空`);
                return;
            }
            const evaluationsDTO = {
                contentType: this.contentType,
                content: this.replyContent,
                contentId: this.contentId,
                parentId: comment.id
            }
            this.$axios.post(`evaluations/insert`, evaluationsDTO).then(res => {
                if (res.data.code == 200) {
                    this.replyContent = '';
                    comment.showReplyInput = false;
                    this.$swal.fire({
                        title: '回复操作',
                        text: '回复成功',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1300
                    });
                    setTimeout(() => {
                        // 重新加载评论列表
                        this.loadCommentList();
                    }, 1300)
                }else{
                    this.$swal.fire({
                        title: '评论异常',
                        text: res.data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 1100
                    });
                }
            }).catch(err => {
                console.error(`评论异常 -> `, err);
            })
        },
        // 子级评论回复提交
        submitReply1(comment) {
            if (this.replyChildContent == '') {
                this.$message(`评论内容不能为空`);
                return;
            }
            const evaluationsDTO = {
                replierId: comment.userId,
                contentType: this.contentType,
                content: this.replyChildContent,
                contentId: this.contentId,
                parentId: comment.parentId
            }
            this.$axios.post(`evaluations/insert`, evaluationsDTO).then(res => {
                if (res.data.code == 200) {
                    this.content = '';
                    comment.replyInputStatus = false;
                    this.$swal.fire({
                        title: '回复操作',
                        text: '回复成功',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 1300
                    });
                    setTimeout(() => {
                        // 重新加载评论列表
                        this.loadCommentList();
                    }, 1300)
                }else{
                    this.$swal.fire({
                        title: '评论异常',
                        text: res.data.msg,
                        icon: 'error',
                        showConfirmButton: false,
                        timer: 1100
                    });
                }
            }).catch(err => {
                console.error(`评论异常 -> `, err);
            })
        },
        goBack() {
            // 返回上一级
            this.$router.go(-1);
        },
        // 加载评论列表
        loadCommentList() {
            this.$axios.get(`evaluations/list/${this.contentId}/${this.contentType}`).then(res => {
                if (res.data.code == 200) {
                    this.commentList = res.data.data.data;
                    this.evaluationsCount = res.data.data.evaluationsCount;
                    // 父级评论
                    this.commentList.forEach(entity => {
                        // 时间转换
                        entity.time = timeAgo(entity.createTime);
                        // 子级评论
                        entity.commentChildVOS.forEach(entity => entity.time = timeAgo(entity.createTime));
                    });
                }
            }).catch(err => {
                console.error(`评论查询异常异常 -> `, err);
            })
        },
    }
};  
</script>
<style lang="scss">
.cannel-btn,
.yes-btn {
    padding: 0px 15px 5px 15px;
    font-size: 14px !important;
    margin: 0 10px;
    border-radius: 3px;
    border: none;
}

.cannel-btn {
    color: #1c1c1c;
}

.yes-btn {
    background-color: #4b87bc;
    color: #EAF2FF;
}

.cannel-btn:hover {
    background-color: #f5f5f5;
}

.yes-btn:hover {
    background-color: #66a8e1;
}

.commentHeader {
    color: #252933;
    font-size: 18px;
    font-weight: 600;
    line-height: 30px;
}

.comment-parent-input {
    outline: none;
    border: none;
    background-color: rgb(245 245 245);
    font-size: 16px;
    padding: 6px;
    width: 100%;
    min-height: 60px;
    overflow: auto;
    resize: vertical;
    user-select: none;
    margin: 0 0 20px 0;
    display: block;
}

.parent-comment {
    padding: 6px 12px;
    border-radius: 3px;
    transition: height 0.3s ease, border-color 0.3s ease;
    border: 1px solid transparent;
    user-select: none;
    position: relative;
}

.comment-input-number {
    position: absolute;
    left: 10px;
    bottom: 5px;
    padding: 0 6px;
    font-size: 12px;
    color: #666;
}

.comment-clike {
    position: absolute;
    right: 10px;
    bottom: 5px;
}

.my-body-tag {
    font-size: 12px;
    padding: 3px 4px;
    color: #1E80FF;
    background-color: #EAF2FF;
    margin-left: 5px;
}

.reportItem {
    display: inline-block;
    padding: 8px 22px;
    background-color: #f4f4f4;
    border: 1px solid #f4f4f4;
    margin: 5px 3px 5px 0;
    border-radius: 3px;
    cursor: pointer;
    user-select: none;
}

.reportItem:hover {
    border: 1px solid #4b87bc;
    color: #4b87bc;
}
</style>