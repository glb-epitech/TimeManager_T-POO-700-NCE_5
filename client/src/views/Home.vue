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
        <WorkingTimes :userId="1" />
      </div>
    </div>
  </div>
</template>

<script setup>
import ClockManager from '@/components/ClockManager.vue';
import User from '@/components/User.vue';
import WorkingTimes from '@/components/WorkingTimes.vue';
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

body {
  font-family: 'Roboto', sans-serif; /* Fallback to Roboto if Gotham is not available */
}
</style>