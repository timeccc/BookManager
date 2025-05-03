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
                    <div class="notice-icon">
                        <i class="el-icon-bell"></i>
                    </div>
                    <div class="notice-main">
                        <div class="notice-header">
                            <h3 class="notice-title">{{ notice.name }}</h3>
                            <span class="notice-date">{{ notice.createTime }}</span>
                        </div>
                        <div class="notice-summary">
                            <div v-if="notice.content" class="preview-content" v-html="getContentPreview(notice.content)"></div>
                            <div v-else class="preview-placeholder">暂无内容预览，点击阅读查看详情...</div>
                        </div>
                        <div class="notice-footer">
                            <button 
                                class="read-btn" 
                                @click="seeContent(notice)">
                                <i class="el-icon-reading"></i> 阅读全文
                            </button>
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
    width: 100%;
    padding: 10px 20px 20px 20px;
    box-sizing: border-box;
    background-color: #fafafa;
}

.word-search {
    display: flex;
    justify-content: center;
    margin-bottom: 15px;
    margin-top: -5px;

    .item {
        padding: 10px 20px;
        width: 500px;
        background-color: white;
        border-radius: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-sizing: border-box;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        border: 1px solid #eee;
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
        
        .page-title {
            margin-bottom: 24px;
            position: relative;
            display: flex;
            align-items: center;
            
            .title-text {
                font-size: 20px;
                font-weight: 600;
                color: #333;
                margin-right: 20px;
                position: relative;
                
                &:after {
                    content: '';
                    position: absolute;
                    bottom: -6px;
                    left: 0;
                    width: 40px;
                    height: 3px;
                    background: linear-gradient(to right, #ff5722, #ff9800);
                    border-radius: 3px;
                }
            }
            
            .line-decoration {
                flex: 1;
                height: 1px;
                background: linear-gradient(to right, rgba(0,0,0,0.1), rgba(0,0,0,0.02));
            }
        }
        
        .notice-card {
            display: flex;
            margin-bottom: 20px;
            border-radius: 16px;
            transition: all 0.3s;
            background-color: white;
            padding: 0;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            border: 1px solid #f0f0f0;
            overflow: hidden;
            
            &:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            }
            
            .notice-icon {
                width: 80px;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: rgba(255, 87, 34, 0.08);
                color: #ff5722;
                
                i {
                    font-size: 30px;
                }
            }
            
            .notice-main {
                flex: 1;
                padding: 20px;
                
                .notice-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 10px;
                    
                    .notice-title {
                        font-size: 18px;
                        font-weight: 600;
                        color: #333;
                        margin: 0;
                        line-height: 1.4;
                        flex: 1;
                        padding-right: 20px;
                    }
                    
                    .notice-date {
                        font-size: 14px;
                        color: #909399;
                        white-space: nowrap;
                    }
                }
                
                .notice-summary {
                    margin-bottom: 16px;
                    color: #606266;
                    font-size: 14px;
                    line-height: 1.6;
                    position: relative;
                    padding: 12px 16px;
                    background: rgba(0,0,0,0.02);
                    border-radius: 8px;
                    border-left: 3px solid rgba(255, 87, 34, 0.3);
                    
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
                            background: linear-gradient(to bottom, rgba(0,0,0,0), rgba(0,0,0,0.02));
                            pointer-events: none;
                        }
                    }
                    
                    .preview-placeholder {
                        color: #909399;
                        font-style: italic;
                    }
                }
                
                .notice-footer {
                    display: flex;
                    justify-content: flex-end;
                    
                    .read-btn {
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        padding: 8px 20px;
                        border-radius: 20px;
                        background-color: rgba(255, 87, 34, 0.08);
                        color: #ff5722;
                        border: 1px solid rgba(255, 87, 34, 0.2);
                        font-size: 14px;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        font-weight: 500;
                        
                        i {
                            margin-right: 6px;
                            font-size: 16px;
                        }
                        
                        &:hover {
                            background-color: #ff5722;
                            color: white;
                            border-color: #ff5722;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(255, 87, 34, 0.25);
                        }
                    }
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
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0,0,0,0.06);
        
        .el-pagination__sizes .el-input .el-input__inner {
            border-radius: 8px;
        }
        
        button, .btn-prev, .btn-next {
            border-radius: 8px;
            transition: all 0.2s;
            
            &:hover {
                background-color: rgba(255, 87, 34, 0.1);
            }
        }
        
        .el-pager li {
            border-radius: 8px;
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
</style>