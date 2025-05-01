<template>
  <div class="chart-container">
    <div ref="chart" :style="{ width: '100%', height: height }"></div>
  </div>
</template>
<script>
// 折线图组件
import * as echarts from 'echarts';
export default {
  name: 'DialogLine',
  props: {
    tag: {
      type: String,
      default: '折线图'
    },
    values: {
      type: Array,
      required: true
    },
    date: {
      type: Array,
      required: true
    },
    height: {
      type: String,
      default: '280px'
    },
  },
  watch: {
    values(v1, v2) {
      this.initChart();
    },
    date(v1, v2) {
      this.initChart();
    }
  },
  data() {
    return {
      chart: null
    }
  },
  mounted() {
    this.initChart();
    window.addEventListener('resize', this.handleResize);
  },
  methods: {
    handleResize() {
      if (this.chart) {
        this.chart.resize();
      }
    },
    // 图表初始化
    initChart() {
      if (this.chart) {
        this.chart.dispose();
      }
      this.chart = echarts.init(this.$refs.chart);
      let option = {
        grid: {
          left: 30,
          right: 30,
          top: 50,
          bottom: 30,
          borderWidth: 0,
          containLabel: true
        },
        title: {
          text: '',
          color: '#333',
        },
        tooltip: {
          trigger: 'axis',
          backgroundColor: 'rgba(255, 255, 255, 0.9)',
          borderColor: '#eee',
          borderWidth: 1,
          textStyle: {
            color: '#333'
          },
          axisPointer: {
            type: 'shadow',
            shadowStyle: {
              color: 'rgba(0, 0, 0, 0.03)'
            }
          },
          formatter: function(params) {
            if (params[0]) {
              return params[0].name + ': ' + params[0].value;
            }
            return '';
          },
          padding: [10, 15]
        },
        legend: {
          data: [this.tag],
          bottom: '0',
          itemWidth: 10,
          itemHeight: 10,
          textStyle: {
            color: '#666',
            fontSize: 12
          },
          icon: 'circle'
        },
        xAxis: {
          data: this.date,
          axisLine: { 
            show: true,
            lineStyle: {
              color: '#eee'
            }
          },
          axisTick: { show: false },
          axisLabel: {
            color: '#666',
            fontSize: 12,
            margin: 12
          },
        },
        yAxis: {
          axisLine: { show: false },
          axisTick: { show: false },
          splitLine: {
            show: true,
            lineStyle: {
              color: '#eee',
              type: 'dashed'
            }
          },
          axisLabel: {
            color: '#666',
            fontSize: 12,
            margin: 12,
            formatter: '{value}'
          },
        },
        series: [{
          name: this.tag,
          type: 'line',
          smooth: true,
          data: this.values,
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(64, 158, 255, 0.25)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.05)' }
            ])
          },
          lineStyle: {
            width: 3,
            color: '#409EFF'
          },
          itemStyle: {
            color: '#409EFF',
            borderColor: '#fff',
            borderWidth: 2,
            shadowColor: 'rgba(0, 0, 0, 0.1)',
            shadowBlur: 5
          },
          label: {
            show: true,
            position: 'top',
            color: '#666',
            fontSize: 12,
            fontWeight: 'normal'
          },
          emphasis: {
            itemStyle: {
              color: '#409EFF',
              borderColor: '#fff',
              borderWidth: 3,
              shadowColor: 'rgba(0, 0, 0, 0.2)',
              shadowBlur: 10
            }
          }
        }]
      };
      this.chart.setOption(option);
    },
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
    if (!this.chart) {
      return;
    }
    this.chart.dispose();
  },
};  
</script>
<style scoped lang="scss">
.chart-container {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}
</style>