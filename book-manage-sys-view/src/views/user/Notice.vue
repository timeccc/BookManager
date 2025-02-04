<template>
    <el-row style="margin-top: 20px;">
        <!-- 条件搜索 -->
        <div class="word-search" v-if="noticeList.length !== 0">
            <div class="item">
                <input type="text" placeholder="标题" v-model="noticeQueryDto.name">
                <i class="el-icon-search" @click="fetchNoticeList"></i>
            </div>
        </div>
        <!-- 内容区 -->
        <el-row style="margin: 10px 0;box-sizing: border-box;">
            <el-row v-if="noticeList.length === 0">
                <el-empty description="暂无通知" style="margin-top: 200px;"></el-empty>
            </el-row>
            <div v-else style="display: flex;justify-content: center;align-items: center;margin-block: 20px;">
                <div>
                    <div class="save-book">
                        <div class="title">标题</div>
                        <div class="title">发布时间</div>
                        <div class="title">功能操作</div>
                    </div>
                    <div class="save-book" v-for="(notice, index) in noticeList" :key="index">
                        <div>
                            {{ notice.name }}
                        </div>
                        <div>
                            {{ notice.createTime }}
                        </div>
                        <div>
                            <span class="text-button" @click="seeContent(notice)">阅读</span>
                        </div>
                    </div>
                </div>
            </div>
        </el-row>
        <!-- 分页区 -->
        <div class="pager" v-if="noticeList.length !== 0">
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
            current: 1, // 当前页
            size: 10, // 页面大小
            totalCount: 0, // 总数据
            noticeList: [], // 数据项
            noticeQueryDto: {}, // 公告搜索条件
            routeNoticeDetail: '/noticeDetail',
            jsonNoticeInfoName: 'noticeInfo',
        };
    },
    created() {
        this.fetchNoticeList();
    },
    methods: {
        // 公告阅读
        seeContent(notice) {
            sessionStorage.setItem(this.jsonNoticeInfoName, JSON.stringify(notice));
            this.$router.push(this.routeNoticeDetail);
        },
        // 查询公告数据
        async fetchNoticeList() {
            try {
                const response = await this.$axios.post('/notice/query', this.noticeQueryDto);
                const { data } = response;
                if (data.code === 200) {
                    this.noticeList = data.data;
                    this.totalCount = data.total;
                }
            } catch (error) {
                this.$notify({
                    title: '公告查询异常',
                    message: error,
                    type: 'error'
                });
                console.error('系统公告信息异常:', error);
            }
        },
        // 分页页数大小切换
        handleSizeChange(size) {
            this.noticeQueryDto.size = size;
            this.noticeQueryDto.current = 1;
            this.fetchNoticeList();
        },
        // 分页页数切换
        handleCurrentChange(current) {
            this.noticeQueryDto.size = 10;
            this.noticeQueryDto.current = current;
            this.fetchNoticeList();
        }
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