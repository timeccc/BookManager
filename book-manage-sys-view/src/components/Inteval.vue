<template>  
    <div>  
      <p>倒计时: {{ formattedTime }}</p>  
    </div>  
  </template>  
    
  <script>  
  export default {  
    props: {  
      // 接收来自父组件的初始分钟数  
      initialMinutes: {  
        type: Number,  
        required: true,  
        default: 0 // 如果未传递，则默认为0分钟  
      }  
    },  
    data() {  
      return {  
        // 将从props接收的分钟数转换为总秒数  
        totalSeconds: 0,  
        // 用于setInterval的引用，以便稍后清除  
        timerId: null  
      };  
    },  
    computed: {  
      // 格式化时间为 HH:MM:SS  
      formattedTime() {  
        let hours = Math.floor(this.totalSeconds / 3600);  
        let minutes = Math.floor((this.totalSeconds % 3600) / 60);  
        let seconds = this.totalSeconds % 60;  
    
        hours = hours.toString().padStart(2, '0');  
        minutes = minutes.toString().padStart(2, '0');  
        seconds = seconds.toString().padStart(2, '0');  
    
        return `${hours}:${minutes}:${seconds}`;  
      }  
    },  
    watch: {  
      // 监听initialMinutes的变化，并重新初始化倒计时  
      initialMinutes(newValue) {  
        if (this.timerId) {  
          // 如果定时器已经存在，先清除它  
          clearInterval(this.timerId);  
          this.timerId = null;  
        }  
        this.totalSeconds = newValue * 60; // 更新总秒数  
        // 重新启动定时器  
        this.startTimer();  
      }  
    },  
    created() {  
      // 组件创建时初始化倒计时  
      this.totalSeconds = this.initialMinutes * 60;  
      this.startTimer();  
    },  
    methods: {  
      startTimer() {  
        this.timerId = setInterval(() => {  
          if (this.totalSeconds > 0) {  
            this.totalSeconds--;  
          } else {  
            // 清除定时器  
            clearInterval(this.timerId);  
            this.timerId = null;  
            // 可选：发出倒计时结束事件  
            this.$emit('end');  
          }  
        }, 1000);  
      }  
    },  
    beforeDestroy() {  
      // 组件销毁前清除定时器  
      if (this.timerId) {  
        clearInterval(this.timerId);  
      }  
    }  
  };  
  </script>  
    
  <style scoped>  
  /* 添加你的样式 */  
  </style>