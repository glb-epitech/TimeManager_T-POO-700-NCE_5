import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/views/Home.vue';
import Login from '@/components/Login.vue';
import Signup from '@/components/Signup.vue';
import EmployeeDashboard from '@/views/Dashboards/EmployeeDashboard.vue';
import ManagerDashboard from '@/views/Dashboards/ManagerDashboard.vue';
import GeneralManagerDashboard from '@/views/Dashboards/GeneralManagerDashboard.vue';
import AdminDashboard from '@/views/Dashboards/AdminDashboard.vue';
import { checkAuthentication, getUserRole } from './auth';

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/signup',
    name: 'Signup',
    component: Signup
  },
  {
    path: '/employee-dashboard',
    name: 'EmployeeDashboard',
    component: EmployeeDashboard,
    meta: { requiresAuth: true, role: 'employee' }
  },
  {
    path: '/manager-dashboard',
    name: 'ManagerDashboard',
    component: ManagerDashboard,
    meta: { requiresAuth: true, role: 'manager' }
  },
  {
    path: '/general-manager-dashboard',
    name: 'GeneralManagerDashboard',
    component: GeneralManagerDashboard,
    meta: { requiresAuth: true, role: 'general_manager' }
  },
  {
    path: '/admin-dashboard',
    name: 'AdminDashboard',
    component: AdminDashboard,
    meta: { requiresAuth: true, role: 'admin' }
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach((to, from, next) => {
  const isAuthenticated = checkAuthentication();
  const userRole = getUserRole();

  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/login');
  } else if (to.meta.role && to.meta.role !== userRole) {
    next('/'); // Redirect to home or an unauthorized page
  } else {
    next();
  }
});

export default router;