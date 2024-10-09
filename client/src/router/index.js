import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/views/Home.vue'; // Assure-toi d'avoir ce composant
import ClockManager from '@/views/ClockManager.vue'; // Ton composant ClockManager
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
  },   {
    path: '/workingTimes/:userID',
    name: 'WorkingTimes',
    component: WorkingTimes
  },
  // Ajoute d'autres routes ici
];

const router = createRouter({
  history: createWebHistory(), // Utilise l'historique HTML5 pour les URL sans hash
  routes
});

export default router;
