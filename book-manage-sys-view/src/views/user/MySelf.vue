<template>
    <div class="myself-container">
        <el-card class="page-header-card">
            <div class="page-header">
                <div class="return-btn" @click="returnPage">
                <i class="el-icon-back"></i>
                    <span>返回</span>
                </div>
                <div class="page-title">个人中心</div>
            </div>
        </el-card>
        
        <el-card class="tab-container">
            <el-tabs v-model="tagSelected" @tab-click="condition">
                <el-tab-pane v-for="(tagItem, index) in tags" :key="index" :label="tagItem" :name="tagItem">
                </el-tab-pane>
            </el-tabs>
            
            <div class="tab-content">
        <div v-if="tagSelected === '修改资料'">
            <Self />
        </div>
        <div v-else-if="tagSelected === '修改密码'">
            <ResetPwd />
        </div>
        <div v-else-if="tagSelected === '退出登录'">
                    <el-result icon="warning" title="退出登录" subTitle="退出后将重新登录">
                <template slot="extra">
                            <button class="logout-button" @click="loginout">
                                <i class="el-icon-switch-button"></i>
                                <span>确认退出</span>
                            </button>
                </template>
            </el-result>
        </div>
            </div>
        </el-card>
    </div>
</template>

<script>
import ResetPwd from '@/views/user/ResetPwd'
import Self from '@/views/user/Self'
export default {
    components: { ResetPwd, Self },
    data() {
        return {
            tags: ['修改资料', '修改密码', '退出登录'],
            tagSelected: '',
            defaultPath: '修改资料',
        };
    },
    created() {
        this.condition(this.defaultPath);
    },
    methods: {
        loginout() {
            sessionStorage.setItem('token', null);
            this.$router.push('/login');
            this.$notify({
                title: '退出成功',
                message: '您已安全退出系统',
                type: 'success',
                duration: 2000
            });
        },
        condition(tag) {
            this.tagSelected = typeof tag === 'string' ? tag : tag.name;
        },
        returnPage() {
            this.$router.go(-1);
        },
    },
};
</script>
<style scoped lang="scss">
.myself-container {
    padding: 20px;
    max-width: 800px;
    margin: 0 auto;
    
    .page-header-card {
        margin-bottom: 20px;
        border-radius: 12px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        
        ::v-deep .el-card__body {
            padding: 20px;
        }
    }
    
    .page-header {
        display: flex;
        align-items: center;
        gap: 16px;

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
            
            i {
                font-size: 14px;
            }
            
            &:hover {
                background-color: #e6f1fc;
                color: #409EFF;
                transform: translateX(-3px);
            }
        }
        
        .page-title {
            font-size: 20px;
            font-weight: 600;
            color: #303133;
        }
    }
    
    .tab-container {
        border-radius: 12px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        
        ::v-deep .el-card__body {
            padding: 20px;
        }
        
        ::v-deep .el-tabs__header {
            margin-bottom: 20px;
        }
        
        ::v-deep .el-tabs__item {
            font-size: 15px;
            padding: 0 20px;
            height: 40px;
            line-height: 40px;
            
            &.is-active {
                color: #ff5722;
            }
        }
        
        ::v-deep .el-tabs__active-bar {
            background-color: #ff5722;
        }
        
        .tab-content {
            min-height: 400px;
            padding: 10px;
        }
    }
}

@media screen and (max-width: 768px) {
    .myself-container {
        padding: 10px;
    }
}

.logout-button {
    background: linear-gradient(45deg, #ff7676, #f56c6c);
    border: none;
    font-size: 11px;
    padding: 6px 16px;
    border-radius: 30px;
    box-shadow: 0 2px 12px rgba(245, 108, 108, 0.25);
    transition: all 0.3s ease;
    color: white;
    height: auto;
    line-height: 1.3;
    font-weight: 500;
    letter-spacing: 0.5px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    cursor: pointer;
    outline: none;
    position: relative;
    overflow: hidden;
    
    &:before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(45deg, rgba(255, 255, 255, 0.1), rgba(255, 255, 255, 0));
        border-radius: 30px;
    }
    
    i {
        font-size: 12px;
    }
    
    &:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(245, 108, 108, 0.35);
        background: linear-gradient(45deg, #ff8989, #ff6c6c);
    }
    
    &:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px rgba(245, 108, 108, 0.2);
    }
}
</style>