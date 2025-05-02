<template>
    <div class="dashboard-container">
        <el-row :gutter="24">
            <el-col :xs="24" :sm="24" :md="8" :lg="8" :xl="8">
                <div class="dashboard-card data-card">
                    <div class="card-header">
                        <h3 class="card-title">基础数据</h3>
                    </div>
                    <PieChart fontColor="#333" bag="rgba(255, 255, 255, 0.6)" :values="pieValues"
                        :types="pieTypes" />
                </div>
                <div class="dashboard-card notice-card">
                    <div class="card-header">
                        <h3 class="card-title">最新公告</h3>
                        <div class="card-actions">
                            <el-button type="text" size="small" icon="el-icon-refresh" @click="loadMessage">刷新</el-button>
                        </div>
                    </div>
                    <div class="notice-list">
                        <div class="notice-item" v-for="(notice, index) in noticeList" :key="index">
                            <div class="notice-title">
                                <i class="el-icon-bell"></i>
                                <span>{{ notice.name }}</span>
                            </div>
                            <div class="notice-time">
                                <i class="el-icon-time"></i>
                                <span>{{ notice.createTime }}</span>
                            </div>
                        </div>
                        <div class="empty-notice" v-if="noticeList.length === 0">
                            <i class="el-icon-info"></i>
                            <span>暂无公告</span>
                        </div>
                    </div>
                </div>
            </el-col>
            <el-col :xs="24" :sm="24" :md="16" :lg="16" :xl="16">
                <div class="dashboard-card chart-card">
                    <div class="card-header">
                        <h3 class="card-title">用户数变化趋势</h3>
                        <div class="card-actions">
                            <el-radio-group v-model="userDateRange" size="small" @change="userDatesSelected">
                                <el-radio-button label="7">7天</el-radio-button>
                                <el-radio-button label="30">30天</el-radio-button>
                                <el-radio-button label="365">365天</el-radio-button>
                            </el-radio-group>
                        </div>
                    </div>
                    <LineChart height="310px" tag="用户数" @on-selected="userDatesSelected" :values="userValues"
                        :date="userDates" />
                </div>
                <div class="dashboard-card chart-card">
                    <div class="card-header">
                        <h3 class="card-title">图书上架趋势</h3>
                        <div class="card-actions">
                            <el-radio-group v-model="bookDateRange" size="small" @change="modelDatesSelected">
                                <el-radio-button label="7">7天</el-radio-button>
                                <el-radio-button label="30">30天</el-radio-button>
                                <el-radio-button label="365">365天</el-radio-button>
                            </el-radio-group>
                        </div>
                    </div>
                    <LineChart height="310px" tag="图书上架情况" @on-selected="modelDatesSelected" :values="modelValues"
                        :date="modelDates" />
                </div>
            </el-col>
        </el-row>
    </div>
</template>
<script>
import LineChart from "@/components/LineChart"
import PieChart from "@/components/PieChart"
export default {
    components: { LineChart, PieChart },
    data() {
        return {
            userValues: [],
            userDates: [],
            modelDates: [],
            modelValues: [],
            pieValues: [],
            pieTypes: [],
            noticeList: [],
            userDateRange: '365',
            bookDateRange: '365'
        }
    },
    created() {
        // 默认查365天
        this.userDatesSelected(365);
        // 默认查365天
        this.modelDatesSelected(365);
        this.loadPieCharts();
        this.loadMessage();
    },
    methods: {
        // 加载消息数据
        loadMessage() {
            const messageQueryDto = {
                current: 1,
                size: 4
            }
            this.$axios.post(`/notice/query`, messageQueryDto).then(response => {
                const { data } = response;
                if (data.code === 200) {
                    this.noticeList = data.data;
                }
            })
        },
        loadPieCharts() {
            this.$axios.get(`/views/staticControls`).then(response => {
                const { data } = response;
                if (data.code === 200) {
                    this.pieValues = data.data.map(entity => entity.count);
                    this.pieTypes = data.data.map(entity => entity.name);
                }
            })
        },
        modelDatesSelected(time) {
            if (typeof time === 'object') {
                time = this.bookDateRange;
            } else {
                this.bookDateRange = time.toString();
            }
            
            this.$axios.get(`/book/daysQuery/${time}`).then(response => {
                const { data } = response;
                if (data.code === 200) {
                    this.modelValues = data.data.map(entity => entity.count);
                    this.modelDates = data.data.map(entity => entity.name);
                }
            })
        },
        userDatesSelected(time) {
            if (typeof time === 'object') {
                time = this.userDateRange;
            } else {
                this.userDateRange = time.toString();
            }
            
            this.$axios.get(`/user/daysQuery/${time}`).then(response => {
                const { data } = response;
                if (data.code === 200) {
                    this.userValues = data.data.map(entity => entity.count);
                    this.userDates = data.data.map(entity => entity.name);
                }
            })
        },
    },
};
</script>
<style scoped lang="scss">
.dashboard-container {
    width: 100%;
    height: 100%;
    padding: 20px;
    box-sizing: border-box;
    overflow: auto;
    background-color: #ffffff;
}

.dashboard-card {
    background-color: #ffffff;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 3px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    border: 1px solid rgba(240, 240, 240, 0.8);
    margin-bottom: 24px;
    overflow: hidden;
    
    &:hover {
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        transform: translateY(-2px);
    }
}

.card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    padding-bottom: 12px;
}

.card-title {
    margin: 0;
    font-size: 18px;
    font-weight: 600;
    color: #333;
    position: relative;
    padding-left: 12px;
    
    &::before {
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        height: 16px;
        width: 4px;
        background-color: #409EFF;
        border-radius: 2px;
    }
}

.card-actions {
    display: flex;
    align-items: center;
}

.chart-card {
    height: calc(50% - 12px);
}

.data-card {
    height: calc(45% - 12px);
}

.notice-card {
    height: calc(55% - 12px);
}

.notice-list {
    overflow-y: auto;
    max-height: calc(100% - 50px);
    padding: 0 4px;
}

.notice-item {
    margin-bottom: 16px;
    padding: 12px;
    border-radius: 8px;
    background-color: #f9f9f9;
    transition: all 0.2s ease;
    
    &:hover {
        background-color: #f0f7ff;
        transform: translateX(4px);
    }
    
    &:last-child {
        margin-bottom: 0;
    }
}

.notice-title {
    margin: 4px 0 8px;
    cursor: pointer;
    
    i {
        margin-right: 6px;
        color: #409EFF;
    }
    
    span {
        font-size: 15px;
        color: #333;
        font-weight: 500;
    }
    
    &:hover span {
        color: #409EFF;
    }
}

.notice-time {
    i {
        margin-right: 6px;
        color: #909399;
        font-size: 12px;
    }
    
    span {
        font-size: 13px;
        color: #909399;
    }
}

.empty-notice {
    text-align: center;
    padding: 30px 0;
    color: #909399;
    
    i {
        font-size: 24px;
        margin-bottom: 8px;
        display: block;
    }
    
    span {
        font-size: 14px;
    }
}

@media screen and (max-width: 768px) {
    .dashboard-container {
        padding: 12px;
    }
    
    .dashboard-card {
        margin-bottom: 16px;
        padding: 16px;
    }
    
    .chart-card, .data-card, .notice-card {
        height: auto;
    }
}
</style>