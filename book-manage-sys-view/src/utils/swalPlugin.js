// swalPlugin.js
import Swal from 'sweetalert2';
// 五种图标： success\error\info\warning\question
// 提示框：
// this.$swal.fire({
//     title: '退出登录',
//     text: '您已成功退出登录。',
//     icon: 'success', // 使用'success'图标表示操作成功
//     showConfirmButton: false, // 隐藏确认按钮，使得弹窗只展示信息后自动关闭
//     timer: 2000, // 自动关闭弹窗的延迟时间，这里是2秒
//   });
const swalPlugin = {
  install(Vue) {
    Vue.prototype.$swalConfirm = async function(options = {}) {
      const defaultOptions = {
        title: '提示',
        text: '',
        icon: 'info',
        reverseButtons: true,
        showCancelButton: true,
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        customClass: {
          confirmButton: 'sweet-btn-primary',
        },
        ...options,
      };

      try {
        const result = await Swal.fire(defaultOptions);
        return result.isConfirmed;
      } catch (error) {
        console.error('Swal Error:', error);
        return false;
      }
    };
  },
};

export default swalPlugin;