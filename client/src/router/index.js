import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/views/Home.vue'; // Assure-toi d'avoir ce composant
import ClockManager from '@/views/ClockManager.vue'; // Ton composant ClockManager

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
  // Ajoute d'autres routes ici
];

const router = createRouter({
  history: createWebHistory(), // Utilise l'historique HTML5 pour les URL sans hash
  routes
});

export default router;
