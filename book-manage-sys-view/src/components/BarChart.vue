<template>
  <div class="line-main">
    <div>
      <span class="tag">{{ tag }}</span>
    </div>
    <div ref="chart" :style="{ width: '100%', height: height }"></div>
  </div>
</template>
<script>
// 柱状图组件
import * as echarts from 'echarts'
export default {
  name: 'BarChart',
  props: {
    height: {
      type: String,
      default: '300px'
    },
    tag: {
      type: String,
      default: '柱状图'
    },
    values: {
      type: Array,
      required: true
    },
    date: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      chart: null,
    }
  },
  mounted() {
    this.init();
  },
  methods: {
    // 柱状图加载
    init() {
      this.chart = echarts.init(this.$refs.chart)
      let option = {
        grid: {
          left: 30,
          right: 5,
          top: 10,
          borderWidth: 5,
        },
        title: { text: '' },
        tooltip: {},
        xAxis: {
          data: this.date,
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: { // 添加这一部分来设置X轴文字颜色
            color: 'rgb(102, 102, 102)',
            interval: 1, // 显示所有标签
            rotate: 0, // 旋转45度，防止标签重叠
          },
        },
        yAxis: {
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: {
            color: 'rgb(102, 102, 102)',
            fontSize: '12'
          },
        },
        series: [{
          name: '',
          type: 'bar',
          data: this.values,
          axisLine: { show: false },
          axisTick: { show: false },
          axisLabel: { // 添加这一部分来设置y轴文字颜色
            color: 'rgb(102, 102, 102)',
          },
          itemStyle: {
            normal: {
              color: function (params) {
                const colorList = [
                  '#e2e1e4',
                  '#bc84a8',
                  '#5e616d',
                  '#57c3c2',
                  '#87CEEB',
                  '#ADD8E6'
                ];
                return colorList[params.dataIndex % colorList.length];
              }
            }
          },
        }]
      }
      this.chart.setOption(option)
    }
  },
  beforeDestroy() {
    if (!this.chart) {
      return
    }
    this.chart.dispose()
  }
}
</script>
<style scoped lang="scss">
.line-main {
  margin-bottom: 5px;
  border-radius: 3px;

  .tag {
    font-size: 16px;
    padding: 15px 6px;
    display: inline-block;
    color: #333;
    font-weight: bold;
  }

}
</style>