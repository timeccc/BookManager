<template>
    <div class="notice-container">
        <!-- 条件搜索 -->
        <div class="search-wrapper" v-if="noticeList.length !== 0">
            <div class="search-input">
                <div class="custom-input">
                    <i class="el-icon-search"></i>
                    <input type="text" placeholder="搜索公告标题" v-model="noticeQueryDto.name" @keyup.enter="fetchNoticeList">
                    <span class="search-text" @click="fetchNoticeList">搜索</span>
                </div>
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
                <div class="notice-list-header">
                    <div class="notice-list-header-item title-col">标题</div>
                    <div class="notice-list-header-item time-col">发布时间</div>
                    <div class="notice-list-header-item action-col">功能操作</div>
                    </div>
                
                <div 
                    v-for="(notice, index) in noticeList" 
                    :key="index"
                    class="notice-item">
                    <div class="notice-content title-col">{{ notice.name }}</div>
                    <div class="notice-time time-col">{{ notice.createTime }}</div>
                    <div class="notice-action action-col">
                        <button 
                            class="read-btn" 
                            @click="seeContent(notice)">
                            <i class="el-icon-reading"></i> 阅读
                        </button>
                    </div>
                </div>
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
    padding: 10px 20px 20px;
    
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
                
                .search-btn {
                    display: none;
                }
            }
        }
    }
    
    .content-wrapper {
        background-color: transparent;
        min-height: 500px;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        
        .notice-list {
            width: 100%;
            
            .notice-list-header {
                display: flex;
                margin-bottom: 16px;
                background-color: #f5f7fa;
                border-radius: 12px;
                overflow: hidden;
                padding: 16px 20px;
                font-weight: 600;
                color: #333;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
                border: 1px solid #ebeef5;
                
                .notice-list-header-item {
                    text-align: center;
                }
            }
            
            .notice-item {
    display: flex;
                margin-bottom: 12px;
                border-radius: 12px;
                transition: all 0.3s;
                background-color: white;
                padding: 16px 20px;
    align-items: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
                border: 1px solid #ebeef5;
                
                &:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 6px 16px rgba(0,0,0,0.08);
                    border-color: rgba(255, 87, 34, 0.1);
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
                font-size: 14px;
            }
            
            .action-col {
                flex: 2;
                text-align: center;
                
                .read-btn {
                    display: inline-flex;
                    align-items: center;
    justify-content: center;
                    padding: 8px 16px;
                    border-radius: 20px;
                    background-color: rgba(255, 87, 34, 0.08);
                    color: #ff5722;
                    border: 1px solid rgba(255, 87, 34, 0.2);
                    font-size: 14px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    
                    i {
                        margin-right: 5px;
                    }
                    
                    &:hover {
                        background-color: rgba(255, 87, 34, 0.12);
                        transform: translateY(-1px);
                        box-shadow: 0 3px 8px rgba(255, 87, 34, 0.15);
                    }
                }
            }
        }
    }
    
    .pagination-wrapper {
        display: flex;
        justify-content: center;
        margin-top: 24px;
        
        ::v-deep .el-pagination {
            padding: 8px 16px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
            
            .el-pagination__sizes .el-input .el-input__inner {
                border-radius: 6px;
            }
            
            button, .btn-prev, .btn-next {
                border-radius: 6px;
                transition: all 0.2s;
                
                &:hover {
                    background-color: rgba(255, 87, 34, 0.1);
                }
            }
            
            .el-pager li {
                border-radius: 6px;
                transition: all 0.2s;
                
                &:hover:not(.active) {
                    background-color: rgba(255, 87, 34, 0.1);
                }
                
                &.active {
                    background-color: #ff5722;
                    color: #fff;
                    font-weight: bold;
                }
            }
        }
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
}
</style>