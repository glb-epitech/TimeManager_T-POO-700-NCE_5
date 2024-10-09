import Vue from 'vue';
import Router from 'vue-router';
import WorkingTimes from '@/components/WorkingTimes.vue';

Vue.use(Router);

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/workingTimes/:userID',
      name: 'WorkingTimes',
      component: WorkingTimes
    },
   
  ]
});


