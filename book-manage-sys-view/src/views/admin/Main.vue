<template>
    <div style="padding: 0 10px;overflow-y: hidden;overflow-x: hidden;">
        <el-row>
            <el-col :span="8">
                <div style="padding: 10px;box-sizing: border-box;">
                    <PieChart fontColor="#000" bag="rgb(236, 245, 255)" tag="基础数据" :values="pieValues"
                        :types="pieTypes" />
                </div>
                <div style="padding: 10px 20px;box-sizing: border-box;">
                    <h3>最新公告</h3>
                    <div style="background-color: rgb(236, 245, 255);border-radius: 5px;padding: 5px 10px;">
                        <div style="margin-bottom: 20px;margin-top: 5px;" v-for="(notice, index) in noticeList" :key="index">
                            <div style="margin: 5px 0;cursor: pointer;">
                                <span style="font-size: 14px;">{{ notice.name }}</span>
                            </div>
                            <div>
                                <span style="font-size: 14px;">时间：{{ notice.createTime }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </el-col>
            <el-col :span="16">
                <div style="padding: 8px;box-sizing: border-box;">
                    <LineChart height="310px" tag="用户数" @on-selected="userDatesSelected" :values="userValues"
                        :date="userDates" />
                </div>
                <div style="padding: 8px;box-sizing: border-box;">
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
.status-success {
    display: inline-block;
    padding: 1px 5px;
    border-radius: 2px;
    background-color: rgb(201, 237, 249);
    color: rgb(111, 106, 196);
    font-size: 12px;
}

.status-error {
    display: inline-block;
    padding: 1px 5px;
    border-radius: 2px;
    background-color: rgb(233, 226, 134);
    color: rgb(131, 138, 142);
    color: rgb(111, 106, 196);
    font-size: 12px;
}
</style>