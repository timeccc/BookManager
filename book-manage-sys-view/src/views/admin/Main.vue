<template>
    <div class="dashboard-container">
        <el-row :gutter="16">
            <el-col :xs="24" :sm="24" :md="8" :lg="8" :xl="8">
                <div class="dashboard-card">
                    <PieChart fontColor="#333" bag="rgba(255, 255, 255, 0.6)" tag="基础数据" :values="pieValues"
                        :types="pieTypes" />
                </div>
                <div class="dashboard-card mt-16">
                    <h3 class="card-title">最新公告</h3>
                    <div class="notice-list">
                        <div class="notice-item" v-for="(notice, index) in noticeList" :key="index">
                            <div class="notice-title">
                                <span>{{ notice.name }}</span>
                            </div>
                            <div class="notice-time">
                                <span>时间：{{ notice.createTime }}</span>
                            </div>
                        </div>
                        <div class="empty-notice" v-if="noticeList.length === 0">
                            <span>暂无公告</span>
                        </div>
                    </div>
                </div>
            </el-col>
            <el-col :xs="24" :sm="24" :md="16" :lg="16" :xl="16">
                <div class="dashboard-card">
                    <LineChart height="310px" tag="用户数" @on-selected="userDatesSelected" :values="userValues"
                        :date="userDates" />
                </div>
                <div class="dashboard-card mt-16">
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
            noticeList: []
        }
    },
    created() {
        // 默认查7天
        this.userDatesSelected(365);
        // 默认查7天
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
            this.$axios.get(`/book/daysQuery/${time}`).then(response => {
                const { data } = response;
                if (data.code === 200) {
                    this.modelValues = data.data.map(entity => entity.count);
                    this.modelDates = data.data.map(entity => entity.name);
                }
            })
        },
        userDatesSelected(time) {
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
    padding: 16px;
    box-sizing: border-box;
    overflow: auto;
}

.dashboard-card {
    background-color: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
    border-radius: 16px;
    padding: 16px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    border: 1px solid rgba(255, 255, 255, 0.2);
    
    &:hover {
        box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        transform: translateY(-2px);
    }
}

.mt-16 {
    margin-top: 16px;
}

.card-title {
    margin-top: 0;
    margin-bottom: 16px;
    font-size: 18px;
    font-weight: 600;
    color: #333;
}

.notice-list {
    background-color: rgba(236, 245, 255, 0.5);
    border-radius: 12px;
    padding: 12px;
}

.notice-item {
    margin-bottom: 16px;
    padding-bottom: 16px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    
    &:last-child {
        margin-bottom: 0;
        padding-bottom: 0;
        border-bottom: none;
    }
}

.notice-title {
    margin: 5px 0;
    cursor: pointer;
    font-weight: 500;
    
    span {
        font-size: 15px;
        color: #333;
    }
    
    &:hover span {
        color: #3a8ee6;
    }
}

.notice-time {
    span {
        font-size: 13px;
        color: #666;
    }
}

.empty-notice {
    text-align: center;
    padding: 20px 0;
    color: #999;
    font-size: 14px;
}

.status-success {
    display: inline-block;
    padding: 3px 8px;
    border-radius: 4px;
    background-color: rgba(201, 237, 249, 0.7);
    color: #5e81ac;
    font-size: 12px;
}

.status-error {
    display: inline-block;
    padding: 3px 8px;
    border-radius: 4px;
    background-color: rgba(233, 226, 134, 0.7);
    color: #6f6ac4;
    font-size: 12px;
}
</style>