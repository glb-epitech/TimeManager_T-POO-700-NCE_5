<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <div class="bg-bat-black min-h-screen p-4 md:p-8 font-gotham text-bat-silver">
    <h1 class="text-3xl md:text-5xl font-bold mb-8 text-center text-bat-yellow">Gotham Time Manager</h1>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Clock Manager Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-2xl font-bold mb-4 text-bat-yellow">Clock Manager</h2>
        <ClockManager />
      </div>

      <!-- User Management Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-2xl font-bold mb-4 text-bat-yellow">User Management</h2>
        <User />
      </div>

      <!-- Working Times Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-2xl font-bold mb-4 text-bat-yellow">Working Times</h2>
        <WorkingTimes />
      </div>

      <!-- Chart Manager Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 lg:col-span-3">
        <h2 class="text-2xl font-bold mb-4 text-bat-yellow">Vigilante Analytics</h2>
        <ChartManager :userId="currentUserId" />
      </div>
    </div>
  </div>

  <div>
    <h1>Time Tracking Dashboard</h1>
    <DailyHoursChart />
    <WeeklySummaryChart />
    <TimeBreakdownChart />
  </div>
</template>

<script setup>
  import { ref } from 'vue';
  import ClockManager from '@/components/ClockManager.vue';
  import User from '@/components/User.vue';
  import WorkingTimes from '@/components/WorkingTimes.vue';
  import ChartManager from '@/components/ChartManager.vue';

  const currentUserId = ref('15'); // Remplacez par l'ID de l'utilisateur actuel ou une logique pour l'obtenir

  import DailyHoursChart from '@/components/charts/user/DailyHoursChart.vue'
</script>

<style>
  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

  body {
    font-family: 'Roboto', sans-serif; /* Fallback to Roboto if Gotham is not available */
  }
</style>