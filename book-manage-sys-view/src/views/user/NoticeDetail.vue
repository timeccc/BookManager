<template>
    <div class="notice-detail-container">
        <el-card class="notice-card">
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
            
            <el-divider></el-divider>
            
            <div class="notice-content">
                <div v-html="notice.content" class="rich-content"></div>
            </div>
        </el-card>
    </div>
</template>

<script>
export default {
    data() {
        return {
            notice: {},
        };
    },
    created() {
        this.loadNoticeInfo();
    },
    methods: {
        returnPage(){
            this.$router.go(-1);
        },
        loadNoticeInfo() {
            const jsonNiticeInfo = sessionStorage.getItem('noticeInfo');
            this.notice = JSON.parse(jsonNiticeInfo);
        },
    },
};
</script>
<style scoped lang="scss">
.notice-detail-container {
    padding: 20px;
    max-width: 900px;
    margin: 0 auto;
    
    .notice-card {
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
        background-color: #fff;
        
        ::v-deep .el-card__body {
            padding: 25px;
        }
    }
    
    .notice-header {
        padding-bottom: 10px;
        
        .return-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 8px 12px;
            border-radius: 6px;
            background-color: #f5f7fa;
            color: #606266;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-bottom: 20px;
            
            i {
                font-size: 14px;
            }
            
            &:hover {
                background-color: #e6f1fc;
                color: #409EFF;
                transform: translateX(-3px);
            }
        }
        
        .notice-title {
            font-size: 24px;
            font-weight: 600;
            color: #303133;
            margin-bottom: 15px;
            line-height: 1.4;
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
                }
            }
        }
    }
    
    .notice-content {
        padding: 10px 0;
        line-height: 1.8;
        color: #303133;
        
        .rich-content {
            ::v-deep img {
                max-width: 100%;
                border-radius: 4px;
            }
            
            ::v-deep p {
                margin-bottom: 15px;
            }
            
            ::v-deep a {
                color: #409EFF;
                text-decoration: none;
                
                &:hover {
                    text-decoration: underline;
                }
            }
            
            ::v-deep ul, ::v-deep ol {
                padding-left: 20px;
                margin-bottom: 15px;
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
    }
}
</style>