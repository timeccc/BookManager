<template>
    <div class="notice-container">
        <!-- 条件搜索 -->
        <div class="search-wrapper" v-if="noticeList.length !== 0">
            <div class="search-input">
                <el-input 
                    placeholder="搜索公告标题" 
                    v-model="noticeQueryDto.name" 
                    prefix-icon="el-icon-search"
                    @keyup.enter.native="fetchNoticeList"
                    clearable>
                </el-input>
                <el-button type="primary" icon="el-icon-search" @click="fetchNoticeList">搜索</el-button>
            </div>
        </div>

        <!-- 内容区 -->
        <div class="content-wrapper">
            <el-empty 
                v-if="noticeList.length === 0" 
                description="暂无公告" 
                :image-size="200">
            </el-empty>
            
            <div v-else class="notice-list">
                <el-card shadow="hover" class="notice-list-header">
                    <div class="notice-list-header-item title-col">标题</div>
                    <div class="notice-list-header-item time-col">发布时间</div>
                    <div class="notice-list-header-item action-col">功能操作</div>
                </el-card>
                
                <el-card 
                    v-for="(notice, index) in noticeList" 
                    :key="index"
                    shadow="hover" 
                    class="notice-item">
                    <div class="notice-content title-col">{{ notice.name }}</div>
                    <div class="notice-time time-col">{{ notice.createTime }}</div>
                    <div class="notice-action action-col">
                        <el-button 
                            type="primary" 
                            size="small" 
                            icon="el-icon-reading" 
                            @click="seeContent(notice)">
                            阅读
                        </el-button>
                    </div>
                </el-card>
            </div>
        </div>

        <!-- 分页区 -->
        <div class="pagination-wrapper" v-if="noticeList.length !== 0">
            <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page.sync="current"
                :page-size="size"
                :page-sizes="[10, 20, 50, 100]"
                layout="total, sizes, prev, pager, next, jumper"
                :total="totalCount">
            </el-pagination>
        </div>
    </div>
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
.notice-container {
    padding: 20px;
    
    .search-wrapper {
        margin-bottom: 20px;
        
        .search-input {
            display: flex;
            max-width: 600px;
            margin: 0 auto;
            
            .el-input {
                margin-right: 10px;
                
                ::v-deep .el-input__inner {
                    border-radius: 8px;
                }
            }
            
            ::v-deep .el-button {
                border-radius: 8px;
            }
        }
    }
    
    .content-wrapper {
        background-color: #fff;
        min-height: 500px;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        
        .notice-list {
            width: 100%;
            
            .notice-list-header {
                display: flex;
                margin-bottom: 10px;
                background-color: #f5f7fa;
                border-radius: 8px;
                overflow: hidden;
                
                ::v-deep .el-card__body {
                    width: 100%;
                    padding: 15px;
                    display: flex;
                    font-weight: 600;
                }
                
                .notice-list-header-item {
                    text-align: center;
                }
            }
            
            .notice-item {
                display: flex;
                margin-bottom: 10px;
                border-radius: 8px;
                transition: all 0.3s;
                
                &:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                }
                
                ::v-deep .el-card__body {
                    width: 100%;
                    padding: 15px;
                    display: flex;
                    align-items: center;
                }
            }
            
            .title-col {
                flex: 5;
                padding: 0 10px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            
            .time-col {
                flex: 3;
                text-align: center;
                color: #666;
            }
            
            .action-col {
                flex: 2;
                text-align: center;
            }
        }
    }
    
    .pagination-wrapper {
        display: flex;
        justify-content: center;
        margin-top: 20px;
        
        ::v-deep .el-pagination {
            .el-pagination__sizes .el-input .el-input__inner {
                border-radius: 6px;
            }
            
            button, .btn-prev, .btn-next {
                border-radius: 6px;
            }
            
            .el-pager li {
                border-radius: 6px;
            }
        }
    }
    
    .el-empty {
        margin: 100px 0;
    }
}
</style>