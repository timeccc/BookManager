<template>
  <div class="line-main" :style="{ backgroundColor: bag }">
    <div>
      <span class="tag" :style="{ color: fontColor }">
        {{ tag }}</span>
    </div>
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
      default: '243px'
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
    }
  },
  mounted() {
    this.initChart();
  },
  methods: {
    initChart() {
      this.chart = echarts.init(this.$refs.chart)
      let option = {
        title: {
          text: '',
          subtext: '',
          left: 'center'
        },
        tooltip: {
          trigger: 'item'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          show: false,
        },
        series: [
          {
            name: '',
            type: 'pie',
            radius: '70%',
            avoidLabelOverlap: false,
            label: {
              show: false,
              position: 'center'
            },
            emphasis: {
              label: {
                show: false,
                fontSize: '24',
                fontWeight: '600'
              }
            },
            labelLine: {
              show: true
            },
            label: {
              show: true,
              position: 'outer',
              formatter: '{d}%'
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
                  '#E4E7ED',
                  '#F2F6FC', 
                ];
                return colorList[params.dataIndex % colorList.length];
              }
            }
          }
        ]
      }
      this.chart.setOption(option)
    }
  },
  beforeDestroy() {
    if (this.chart) {
      this.chart.dispose()
    }
  }
}  
</script>

<style scoped lang="scss">
.line-main {
  padding-top: 10px;
  margin-bottom: 5px;
  border-radius: 3px;
  background-color: #000000;

  .tag {
    font-size: 14px;
    text-align: center;
    padding: 15px 6px;
    display: block;
  }

}
</style>