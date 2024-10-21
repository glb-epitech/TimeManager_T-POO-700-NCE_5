<template>
  <div class="bg-bat-black min-h-screen p-6 text-bat-silver font-gotham">
    <header class="mb-8">
      <h1 class="text-3xl font-bold text-bat-yellow">Tableau de Bord du Maître de Gotham</h1>
    </header>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <!-- General Manager Profile Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-user-tie mr-2"></i> Profil du Maître de Gotham
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

      <!-- Organization Overview Card -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-building mr-2"></i> Vue d'Ensemble de l'Organisation
        </h2>
        <TeamList />
      </div>

      <!-- User Type Selector -->
      <div class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-users-cog mr-2"></i> Sélection du Type d'Utilisateur
        </h2>
        <select v-model="selectedUserType" class="w-full p-2 mb-4 bg-bat-black text-bat-silver border border-bat-gray rounded focus:outline-none focus:border-bat-yellow">
          <option value="employee">Employés</option>
          <option value="manager">Managers</option>
        </select>
        <select v-model="selectedUserId" class="w-full p-2 bg-bat-black text-bat-silver border border-bat-gray rounded focus:outline-none focus:border-bat-yellow">
          <option value="">Sélectionner un utilisateur</option>
          <option v-for="user in filteredUsers" :key="user.id" :value="user.id">
            {{ user.name }} - {{ user.role }}
          </option>
        </select>
      </div>

      <!-- Selected User Working Times Card -->
      <div v-if="selectedUserId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-calendar-alt mr-2"></i> Journal de Patrouille de l'Utilisateur
        </h2>
        <WorkingTimes :userId="selectedUserId" />
      </div>

      <!-- Selected User Chart Manager Card -->
      <div v-if="selectedUserId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-bar mr-2"></i> Analyse des Patrouilles de l'Utilisateur
        </h2>
        <ChartManager :userId="selectedUserId" />
      </div>

      <!-- Selected User Daily Hours Chart Card -->
      <div v-if="selectedUserId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-line mr-2"></i> Heures Quotidiennes de l'Utilisateur
        </h2>
        <DailyHoursChart :userId="selectedUserId" />
      </div>

      <!-- Selected User Line Chart Card -->
      <div v-if="selectedUserId" class="bg-bat-gray rounded-lg shadow-bat p-6 hover:bg-opacity-90 transition duration-300 col-span-1 md:col-span-2 lg:col-span-3">
        <h2 class="text-xl font-bold mb-4 text-bat-yellow flex items-center">
          <i class="fas fa-chart-line mr-2"></i> Activité de Patrouille de l'Utilisateur
        </h2>
        <LineChart :userId="selectedUserId" />
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
  name: 'GeneralManagerDashboard',
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
      currentUserId: '123', // Example general manager ID
      selectedUserType: 'employee',
      selectedUserId: '',
      allUsers: [
        { id: '1', name: 'John Doe', role: 'employee' },
        { id: '2', name: 'Jane Smith', role: 'employee' },
        { id: '3', name: 'Mike Johnson', role: 'manager' },
        // ... other users
      ]
    }
  },
  computed: {
    filteredUsers() {
      return this.allUsers.filter(user => user.role === this.selectedUserType);
    }
  }
}
</script>

<style scoped>
/* You can add any additional styles here if needed */
</style>