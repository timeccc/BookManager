<template>
    <div class="notice-container">
        <!-- 条件搜索 -->
        <div class="word-search" v-if="noticeList.length !== 0">
            <div class="item">
                    <i class="el-icon-search"></i>
                    <input type="text" placeholder="搜索公告标题" v-model="noticeQueryDto.name" @keyup.enter="fetchNoticeList">
                    <span class="search-text" @click="fetchNoticeList">搜索</span>
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
                <div class="page-title">
                    <span class="title-text">系统公告</span>
                    <div class="line-decoration"></div>
                </div>
                
                <div 
                    v-for="(notice, index) in noticeList" 
                    :key="index"
                    class="notice-card">
                    <div class="time-marker"></div>
                    <div class="notice-content">
                        <div class="notice-date">{{ notice.createTime }}</div>
                        <h3 class="notice-title">{{ notice.name }}</h3>
                        <div class="notice-summary">
                            <div v-if="notice.content" class="preview-content" v-html="getContentPreview(notice.content)"></div>
                            <div v-else class="preview-placeholder">暂无内容预览，点击查看详情...</div>
                        </div>
                        <div class="btn-container">
                            <el-button 
                                type="warning" 
                                size="small" 
                                circle
                                @click="seeContent(notice)"
                                class="detail-btn">
                                <i class="el-icon-view"></i>
                            </el-button>
                            <span class="btn-text">查看详情</span>
                        </div>
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
            previewMaxLength: 120, // 预览内容最大长度
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
        // 获取内容预览
        getContentPreview(htmlContent) {
            if (!htmlContent) return '';
            
            // 创建临时元素提取纯文本
            const tempDiv = document.createElement('div');
            tempDiv.innerHTML = htmlContent;
            let plainText = tempDiv.textContent || tempDiv.innerText || '';
            
            // 移除多余空白
            plainText = plainText.replace(/\s+/g, ' ').trim();
            
            // 限制长度并添加省略号
            if (plainText.length > this.previewMaxLength) {
                return plainText.substring(0, this.previewMaxLength) + '...';
            }
            
            return plainText;
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
    padding: 10px;
    border-radius: 16px;
    background-color: transparent;
    backdrop-filter: none;
    box-shadow: none;
}

.word-search {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
        
    .item {
        padding: 10px 20px;
        width: 500px;
        background-color: rgba(255, 255, 255, 0.8);
        backdrop-filter: blur(10px);
        border-radius: 40px;
            display: flex;
        justify-content: space-between;
                align-items: center;
                box-sizing: border-box;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        border: 1px solid rgba(255, 255, 255, 0.3);
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
    
    .content-wrapper {
        background-color: transparent;
        min-height: 500px;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        
        .notice-list {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            
            /* 时间轴垂直线 */
            &::before {
                content: '';
                position: absolute;
                top: 0;
                bottom: 0;
                left: 20px;
                width: 2px;
                background: linear-gradient(to bottom, #FFB74D, #FFCC80);
                z-index: 0;
            }
            
            .page-title {
                margin-bottom: 24px;
                position: relative;
                display: flex;
                align-items: center;
                padding-left: 50px;
                
                .title-text {
                    font-size: 20px;
                    font-weight: 600;
                    color: #E65100;
                    margin-right: 20px;
                    position: relative;
                    
                    &:after {
                        content: '';
                        position: absolute;
                        bottom: -6px;
                        left: 0;
                        width: 40px;
                        height: 3px;
                        background: linear-gradient(to right, #FF8A65, #FFB74D);
                        border-radius: 3px;
                    }
                }
                
                .line-decoration {
                    flex: 1;
                    height: 1px;
                    background: linear-gradient(to right, rgba(255, 138, 101, 0.2), rgba(255, 138, 101, 0.05));
                }
            }
            
            .notice-card {
                position: relative;
                margin-bottom: 30px;
                padding-left: 50px;
                display: block;
                transition: all 0.3s;
                
                &:hover {
                    transform: translateX(5px);
                    
                    .time-marker {
                        transform: scale(1.1);
                        box-shadow: 0 0 12px rgba(255, 183, 77, 0.3);
                    }
                }
                
                /* 时间标记点 */
                .time-marker {
                    position: absolute;
                    left: 10px;
                    top: 0;
                    width: 20px;
                    height: 20px;
                    background-color: #FFB74D;
                    border: 3px solid #FFF3E0;
                    border-radius: 50%;
                    z-index: 1;
                    transform-origin: center;
                    transition: all 0.3s ease;
                    box-shadow: 0 0 6px rgba(255, 183, 77, 0.2);
                }
                
                .notice-content {
                    background-color: #FFF3E0;
                    border-radius: 6px;
                    box-shadow: 0 1px 3px rgba(255, 165, 0, 0.08);
                    border: 1px solid #FFE0B2;
                    padding: 16px;
                    overflow: hidden;
                    
                    .notice-date {
                        display: inline-block;
                        font-size: 14px;
                        color: #FFFFFF;
                        background-color: #FF8A65;
                        padding: 4px 12px;
                        border-radius: 15px;
                        margin-bottom: 10px;
                        font-weight: 500;
                    }
                    
                    .notice-title {
                        font-size: 18px;
                        font-weight: 600;
                        color: #E65100;
                        margin: 0 0 12px 0;
                        line-height: 1.4;
                    }
                    
                    .notice-summary {
                        margin-bottom: 16px;
                        color: #424242;
                        font-size: 14px;
                        line-height: 1.6;
                        position: relative;
                        background: rgba(255, 243, 224, 0.5);
                        padding: 12px;
                        border-radius: 4px;
                        border-left: 3px solid #FFB74D;
                        
                        .preview-content {
                            position: relative;
                            overflow: hidden;
                            
                            &::after {
                                content: '';
                                position: absolute;
                                bottom: 0;
                                left: 0;
                                width: 100%;
                                height: 24px;
                                background: linear-gradient(to bottom, rgba(255, 243, 224, 0), rgba(255, 243, 224, 0.5));
                                pointer-events: none;
                            }
                        }
                        
                        .preview-placeholder {
                            color: #795548;
                            font-style: italic;
                        }
                    }
                    
                    .btn-container {
                        text-align: right;
                    }
                }
            }
        }
    }
    
    .pagination-wrapper {
        display: flex;
        justify-content: center;
        margin-top: 30px;
        
        ::v-deep .el-pagination {
            padding: 12px 20px;
            background: #FFF3E0;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(255, 165, 0, 0.08);
            border: 1px solid #FFE0B2;
            
            .el-pagination__sizes .el-input .el-input__inner {
                border-radius: 4px;
                background-color: rgba(255, 255, 255, 0.7);
                border-color: #FFE0B2;
            }
            
            button, .btn-prev, .btn-next {
                border-radius: 4px;
                transition: all 0.2s;
                background-color: rgba(255, 255, 255, 0.5);
                
                &:hover {
                    background-color: rgba(255, 183, 77, 0.2);
                    color: #FF8A65;
                }
            }
            
            .el-pager li {
                border-radius: 4px;
                transition: all 0.2s;
                background-color: rgba(255, 255, 255, 0.5);
                
                &:hover:not(.active) {
                    background-color: rgba(255, 183, 77, 0.2);
                    color: #FF8A65;
                }
                
                &.active {
                    background-color: #FFB74D;
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

@media screen and (max-width: 768px) {
    .notice-container {
        .content-wrapper .notice-list .notice-card {
            flex-direction: column;
            
            .notice-icon {
                width: 100%;
                height: 60px;
            }
            
            .notice-main .notice-header {
                flex-direction: column;
                
                .notice-date {
                    margin-top: 8px;
                }
            }
        }
    }
}

/* 自定义Element UI按钮 */
::v-deep .el-button--warning {
    background-color: #ffb74d;
    border-color: #ffb74d;
    color: #fff;
    
    &:hover, &:focus {
        background-color: #ff9800;
        border-color: #ff9800;
    }
}

.btn-container {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    margin-top: 15px;
}

/* 修改El-button样式为圆形带图标 */
::v-deep .el-button--small.el-button--circle {
    width: 36px;
    height: 36px;
    padding: 0;
    margin-right: 8px;
    box-shadow: 0 2px 4px rgba(255, 183, 77, 0.2);
    
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(255, 183, 77, 0.3);
    }
    
    i {
        font-size: 16px;
    }
}

.btn-text {
    color: #ff8a65;
    font-size: 14px;
    font-weight: 500;
}
</style>