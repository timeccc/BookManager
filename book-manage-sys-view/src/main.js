import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import 'element-ui/lib/theme-chalk/index.css';  
import { provinceAndCityData, regionData } from 'element-china-area-data';  
import VueSweetalert2 from 'vue-sweetalert2';
import 'sweetalert2/dist/sweetalert2.min.css';
import './assets/css/editor.scss'
import './assets/css/button.scss'
import './assets/css/elementui-cover.scss'
import './assets/css/basic.scss'
import './assets/css/dialog.scss'
import './assets/css/input.scss'
import request from '@/utils/request'
import md5 from 'js-md5';

Vue.config.productionTip = false;
Vue.use(VueSweetalert2);
Vue.prototype.$md5 = md5;
Vue.prototype.$axios = request;
import swalPlugin from '@/utils/swalPlugin';
Vue.use(swalPlugin);

new Vue({
  router,
  regionData,
  provinceAndCityData,
  VueSweetalert2,
  render: h => h(App)
}).$mount("#app");
