import { createRouter, createWebHistory } from 'vue-router';
import Home from '../views/Home.vue';
import Information from '../views/Information.vue';
import NotFoundView from '../views/404.vue';
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/info',
    name: 'Information',
    component: Information
  },
  {
    path: "/:catchAll(.*)",
    name: "NotFound",
    component: NotFoundView
  }

];

const router = createRouter({
    history: createWebHistory(),
    routes
  });
  

export default router;
