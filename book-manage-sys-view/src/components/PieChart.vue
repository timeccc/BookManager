<template>
  <div class="chart-container" :style="{ backgroundColor: bag }">
    <div ref="chart" :style="{ width: width, height: height }"></div>
  </div>
</template>
<script>
import * as echarts from 'echarts'
export default {
  name: 'PieChart',
  props: {
    types: {
      type: Array,
      default: []
    },
    values: {
      type: Array,
      default: []
    },
    width: {
      type: String,
      default: '100%'
    },
    tag: {
      type: String,
      default: '饼状图'
    },
    height: {
      type: String,
      default: '280px'
    },
    bag: {
      type: String,
      default: '#fff'
    },
    fontColor:{
      type: String,
      default: '#333'
    },
  },
  data() {
    return {
      chart: null,
    }
  },
  watch: {
    types(v1, v2) {
      this.initChart();
    },
    values(v1, v2) {
      this.initChart();
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
    initChart() {
      if (this.chart) {
        this.chart.dispose();
      }
      this.chart = echarts.init(this.$refs.chart)
      let option = {
        title: {
          text: '',
          subtext: '',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)',
          backgroundColor: 'rgba(255, 255, 255, 0.9)',
          borderColor: '#eee',
          borderWidth: 1,
          textStyle: {
            color: '#333'
          },
          padding: [10, 15]
        },
        legend: {
          orient: 'horizontal',
          bottom: '0%',
          left: 'center',
          show: true,
          itemWidth: 10,
          itemHeight: 10,
          textStyle: {
            color: '#666',
            fontSize: 12
          },
          icon: 'circle'
        },
        series: [
          {
            name: this.tag,
            type: 'pie',
            radius: ['40%', '70%'],
            center: ['50%', '45%'],
            avoidLabelOverlap: true,
            emphasis: {
              label: {
                show: true,
                fontSize: 14,
                fontWeight: 'bold'
              },
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.2)'
              }
            },
            labelLine: {
              show: true,
              smooth: true,
              length: 10,
              length2: 10
            },
            label: {
              show: true,
              formatter: '{d}%',
              fontSize: 12
            },
            data: this.values.map((value, index) => ({
              name: this.types[index],
              value: value,
            })),
            itemStyle: {
              color: function (params) {
                const colorList = [
                  '#409EFF', 
                  '#67C23A', 
                  '#E6A23C',
                  '#F56C6C', 
                  '#909399',
                  '#7265e6',
                  '#ffbf00', 
                ];
                return colorList[params.dataIndex % colorList.length];
              },
              borderRadius: 4,
              borderWidth: 2,
              borderColor: '#fff'
            }
          }
        ]
      }
      this.chart.setOption(option)
    }
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize);
    if (this.chart) {
      this.chart.dispose()
    }
  }
}  
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