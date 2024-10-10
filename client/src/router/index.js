import { createRouter, createWebHistory } from 'vue-router';
<<<<<<< Updated upstream
import Home from '@/views/Home.vue'; // Assure-toi d'avoir ce composant
import ClockManager from '@/views/ClockManager.vue'; // Ton composant ClockManager
import WorkingTimes from '@/components/WorkingTimes.vue';

import WorkingTime from '@/components/WorkingTime.vue';
=======
import Home from '@/views/Home.vue';
import ClockManager from '@/components/ClockManager.vue';
import User from '@/components/User.vue';
import WorkingTimes from '@/components/WorkingTimes.vue';
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
    path: '/workingTimes/:userId',
    name: 'WorkingTimes',
    component: WorkingTimes,
    prop: true,
=======
    path: '/user',
    name: 'User',
    component: User
  },
  {
    path: '/working-times/:userId',
    name: 'WorkingTimes',
    component: WorkingTimes,
    props: true
>>>>>>> Stashed changes
  },
  // Vous pouvez ajouter d'autres routes ici si nécessaire
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;