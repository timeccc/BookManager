<template>
    <div class="notice-detail-container">
        <el-card class="notice-card">
            <div class="card-decoration"></div>
            <div class="notice-header">
                <div class="return-btn" @click="returnPage">
                    <i class="el-icon-back"></i>
                    <span>返回列表</span>
                </div>
                <div class="notice-title">{{ notice.name }}</div>
                <div class="notice-meta">
                    <span class="publish-time">
                        <i class="el-icon-time"></i>
                        {{ notice.createTime }}
                    </span>
                </div>
            </div>
            
            <div class="notice-content">
                <div v-if="notice.content" v-html="notice.content" class="rich-content"></div>
                <div v-else class="no-content">暂无内容</div>
            </div>
        </el-card>
    </div>
</template>

<script>
export default {
    name: 'NoticeDetail',
    data() {
        return {
            notice: {},
        };
    },
    created() {
        this.loadNoticeInfo();
    },
    methods: {
        returnPage() {
            this.$router.go(-1);
        },
        loadNoticeInfo() {
            try {
                const jsonNoticeInfo = sessionStorage.getItem('noticeInfo');
                if (!jsonNoticeInfo) {
                    this.$message.error('公告信息获取失败');
                    setTimeout(() => this.returnPage(), 1000);
                    return;
                }
                this.notice = JSON.parse(jsonNoticeInfo);
            } catch (error) {
                console.error('解析公告信息失败:', error);
                this.$message.error('公告信息解析失败');
                setTimeout(() => this.returnPage(), 1000);
            }
        },
    },
};
</script>
<style scoped lang="scss">
.notice-detail-container {
    padding: 15px;
    max-width: 900px;
    margin: 0 auto;
    
    .notice-card {
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(255, 87, 34, 0.08);
        background-color: #fff;
        position: relative;
        overflow: hidden;
        border: none;
        transition: transform 0.3s ease;
        
        &:hover {
            transform: translateY(-3px);
        }
        
        .card-decoration {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #ff5722, #ff9800);
        }
        
        ::v-deep .el-card__body {
            padding: 20px;
        }
    }
    
    .notice-header {
        padding-bottom: 10px;
        
        .return-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            border-radius: 20px;
            background-color: rgba(255, 87, 34, 0.08);
            color: #ff5722;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 15px;
            font-weight: 500;
            
            i {
                font-size: 14px;
            }
            
            &:hover {
                background-color: rgba(255, 87, 34, 0.15);
                transform: translateX(-3px);
            }
        }
        
        .notice-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
            line-height: 1.4;
            position: relative;
            padding-left: 12px;
            
            &:before {
                content: '';
                position: absolute;
                left: 0;
                top: 5px;
                bottom: 5px;
                width: 4px;
                background: linear-gradient(to bottom, #ff5722, #ff9800);
                border-radius: 4px;
            }
        }
        
        .notice-meta {
            display: flex;
            font-size: 14px;
            color: #909399;
            
            .publish-time {
                display: flex;
                align-items: center;
                gap: 5px;
                
                i {
                    font-size: 14px;
                    color: #ff9800;
                }
            }
        }
    }
    
    .notice-content {
        margin-top: 10px;
        padding: 15px;
        line-height: 1.7;
        color: #333;
        background-color: #fafafa;
        border-radius: 8px;
        
        .no-content {
            text-align: center;
            color: #909399;
            font-style: italic;
            padding: 10px 0;
        }
        
        .rich-content {
            ::v-deep img {
                max-width: 100%;
                border-radius: 8px;
                box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            }
            
            ::v-deep p {
                margin-bottom: 15px;
            }
            
            ::v-deep a {
                color: #ff5722;
                text-decoration: none;
                
                &:hover {
                    color: #ff9800;
                    text-decoration: underline;
                }
            }
            
            ::v-deep ul, ::v-deep ol {
                padding-left: 20px;
                margin-bottom: 15px;
            }
            
            ::v-deep h1, ::v-deep h2, ::v-deep h3, ::v-deep h4 {
                color: #ff5722;
                margin: 15px 0 10px;
            }
            
            ::v-deep blockquote {
                border-left: 4px solid #ff9800;
                padding: 10px 15px;
                margin: 15px 0;
                background-color: rgba(255, 152, 0, 0.05);
                border-radius: 0 4px 4px 0;
            }
        }
    }
}

@media screen and (max-width: 768px) {
    .notice-detail-container {
        padding: 10px;
        
        .notice-card {
            ::v-deep .el-card__body {
                padding: 15px;
            }
        }
        
        .notice-header {
            .notice-title {
                font-size: 20px;
            }
        }
        
        .notice-content {
            padding: 12px;
        }
    }
}
</style>