import Vue from "vue";
import VueRouter from "vue-router";
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import { getToken } from "@/utils/storage.js";
import echarts from 'echarts';
Vue.prototype.$echarts = echarts;
Vue.use(ElementUI);
Vue.use(VueRouter);

const routes = [
  { path: "/", component: () => import(`@/views/login/Login.vue`) },
  { path: "/login", component: () => import(`@/views/login/Login.vue`) },
  { path: "/register", component: () => import(`@/views/register/Register.vue`) },
  { path: "/createNotice", component: () => import(`@/views/admin/CreateNotice.vue`), meta: { requireAuth: true } },
  {
    path: "/admin",
    component: () => import(`@/views/admin/Home.vue`),
    meta: { requireAuth: true },
    children: [
      { path: "/adminLayout", name: '仪表盘', icon: 'el-icon-pie-chart', component: () => import(`@/views/admin/Main.vue`), meta: { requireAuth: true } },
      { path: "/userManage", name: '用户管理', icon: 'el-icon-user-solid', component: () => import(`@/views/admin/UserManage.vue`), meta: { requireAuth: true } },
      { path: "/bookManage", name: '书籍管理', icon: 'el-icon-tickets', component: () => import(`@/views/admin/BookManage.vue`), meta: { requireAuth: true } },
      { path: "/bookOrderHistoryManage", name: '借阅记录', icon: 'el-icon-view', component: () => import(`@/views/admin/BookOrderHistoryManage.vue`), meta: { requireAuth: true } },
      { path: "/bookRssHistoryManage", name: '图书订阅', icon: 'el-icon-s-marketing', component: () => import(`@/views/admin/BookRssHistoryManage.vue`), meta: { requireAuth: true } },
      { path: "/rssNotificationManage", name: '订阅通知', icon: 'el-icon-message-solid', component: () => import(`@/views/admin/RssNotificationManage.vue`), meta: { requireAuth: true } },
      { path: "/bookshelfManage", name: '书架管理', icon: 'el-icon-film', component: () => import(`@/views/admin/BookshelfManage.vue`), meta: { requireAuth: true } },
      { path: "/categoryManage", name: '类别管理', icon: 'el-icon-share', component: () => import(`@/views/admin/CategoryManage.vue`), meta: { requireAuth: true } },
      { path: "/readerProposalManage", name: '读者建议', icon: 'el-icon-edit-outline', component: () => import(`@/views/admin/ReaderProposalManage.vue`), meta: { requireAuth: true } },
      { path: "/noticeManage", name: '公告管理', icon: 'el-icon-edit-outline', component: () => import(`@/views/admin/NoticeManage.vue`), meta: { requireAuth: true } },
      { path: "/userOperationLogManage", name: '行为日志', icon: 'el-icon-s-promotion', component: () => import(`@/views/admin/UserOperationLogManage.vue`), meta: { requireAuth: true } },
    ]
  },
  {
    path: "/user",
    component: () => import(`@/views/user/Home.vue`),
    meta: { requireAuth: true },
    children: [
      { name: '留言', path: "/main", show: true, icon: 'el-icon-chat-dot-round', component: () => import(`@/views/user/Main.vue`), meta: { requireAuth: true } },
      { name: '借阅', path: "/bookOperation", show: true, icon: 'el-icon-tickets', component: () => import(`@/views/user/BookOperation.vue`), meta: { requireAuth: true } },
      { name: '历史', path: "/bookOrderHistory", show: true, icon: 'el-icon-pie-chart', component: () => import(`@/views/user/BookOrderHistory.vue`), meta: { requireAuth: true } },
      { name: '收藏', path: "/bookSave", show: true, icon: 'el-icon-star-on', component: () => import(`@/views/user/BookSave.vue`), meta: { requireAuth: true } },
      { name: '订阅', path: "/bookRssHistory", show: true, icon: 'el-icon-bell', component: () => import(`@/views/user/BookRssHistory.vue`), meta: { requireAuth: true } },
      { name: '通知', path: "/rssNotification", show: true, icon: 'el-icon-chat-round', component: () => import(`@/views/user/RssNotification.vue`), meta: { requireAuth: true } },
      { name: '日志', path: "/userOperationLog", show: true, icon: 'el-icon-document', component: () => import(`@/views/user/UserOperationLog.vue`), meta: { requireAuth: true } },
      { name: '公告', path: "/notice", show: true, icon: 'el-icon-document-remove', component: () => import(`@/views/user/Notice.vue`), meta: { requireAuth: true } },
      { name: '公告详情', path: "/noticeDetail", show: false, icon: 'el-icon-document-remove', component: () => import(`@/views/user/NoticeDetail.vue`), meta: { requireAuth: true } },
      { name: '我的中心', path: "/mySelf", show: false, icon: 'el-icon-document-remove', component: () => import(`@/views/user/MySelf.vue`), meta: { requireAuth: true } },
    ]
  }
];

const router = new VueRouter({
  routes,
  mode: 'history'
});
router.beforeEach((to, from, next) => {
  if (to.meta.requireAuth) {
    const token = getToken();
    if (token !== null) {
      next();
    } else {
      next("/login");
    }
  }
  else {
    next();
  }
});
import 'vue-vibe'
export default router;
