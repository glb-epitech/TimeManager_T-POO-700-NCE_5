<template>
  <div class="bg-bat-black min-h-screen p-6 text-bat-silver font-gotham">
    <header class="mb-8">
      <h1 class="text-3xl font-bold text-bat-yellow">Tableau de Bord du Vigilant en Chef</h1>
    </header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- Manager Profile Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-user-tie mr-2"></i> Profil du Manager
        </h2>
        <User />
      </div>

      <!-- Clock Manager Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-clock mr-2"></i> Tracker de Patrouille Personnel
        </h2>
        <ClockManager :userId="currentUserId" />
      </div>

      <!-- Team Management Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-users mr-2"></i> Gestion de l'Équipe
        </h2>
        <TeamList />
      </div>

      <!-- Employee Selector -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-user-check mr-2"></i> Sélection de l'Agent
        </h2>
        <select v-model="selectedEmployeeId" class="w-full p-2 bg-bat-black text-bat-silver border border-bat-gray rounded focus:outline-none focus:border-bat-yellow">
          <option value="">Sélectionner un agent</option>
          <option v-for="employee in teamEmployees" :key="employee.id" :value="employee.id">
            {{ employee.name }}
          </option>
        </select>
      </div>

      <!-- Employee Working Times Card -->
      <div v-if="selectedEmployeeId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-calendar-alt mr-2"></i> Journal de Patrouille de l'Agent
        </h2>
        <WorkingTimes :userId="selectedEmployeeId" />
      </div>

      <!-- Employee Chart Manager Card -->
      <div v-if="selectedEmployeeId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-bar mr-2"></i> Analyse des Patrouilles de l'Agent
        </h2>
        <ChartManager :userId="selectedEmployeeId" />
      </div>

      <!-- Employee Daily Hours Chart Card -->
      <div v-if="selectedEmployeeId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-line mr-2"></i> Heures Quotidiennes de l'Agent
        </h2>
        <DailyHoursChart :userId="selectedEmployeeId" />
      </div>

      <!-- Employee Line Chart Card -->
      <div v-if="selectedEmployeeId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-line mr-2"></i> Activité de Patrouille de l'Agent
        </h2>
        <LineChart :userId="selectedEmployeeId" />
      </div>
    </div>
  </div>
</template>

<script>
import User from '@/components/User.vue';
import ClockManager from '@/components/ClockManager.vue';
import WorkingTimes from '@/components/WorkingTimes.vue';
import ChartManager from '@/components/ChartManager.vue';
import DailyHoursChart from '@/components/charts/user/DailyHoursChart.vue';
import LineChart from '@/components/LineChart.vue';
import TeamList from '@/components/TeamList.vue';

export default {
  name: 'ManagerDashboard',
  components: {
    User,
    ClockManager,
    WorkingTimes,
    ChartManager,
    DailyHoursChart,
    LineChart,
    TeamList
  },
  data() {
    return {
      currentUserId: '123', // Example manager ID
      selectedEmployeeId: '',
      teamEmployees: [
        { id: '1', name: 'John Doe' },
        { id: '2', name: 'Jane Smith' },
        // ... other team members
      ]
    }
  }
}
</script>

<style scoped>
/* You can add any additional styles here if needed */
</style>