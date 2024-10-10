import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/views/Home.vue';
import ClockManager from '@/components/ClockManager.vue';
import User from '@/components/User.vue';
import WorkingTimes from '@/components/WorkingTimes.vue';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/clock',
    name: 'ClockManager',
    component: ClockManager
  },
  {
    path: '/user',
    name: 'User',
    component: User
  },
  {
    path: '/working-times/:userId',
    name: 'WorkingTimes',
    component: WorkingTimes,
    props: true
  },
  // Vous pouvez ajouter d'autres routes ici si nécessaire
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;