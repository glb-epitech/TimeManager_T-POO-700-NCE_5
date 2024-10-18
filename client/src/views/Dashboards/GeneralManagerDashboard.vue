<template>
    <div class="general-manager-dashboard">
      <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Tableau de Bord du Directeur Général</h2>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-bat-gray rounded-lg shadow-bat p-4">
          <h3 class="text-xl font-bold mb-4 text-bat-silver">Gestion Globale des Utilisateurs</h3>
          <User />
        </div>
        
        <div class="bg-bat-gray rounded-lg shadow-bat p-4">
          <h3 class="text-xl font-bold mb-4 text-bat-silver">Gestion du Temps</h3>
          <ClockManager :userId="selectedUserId" />
        </div>
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Heures de Travail</h3>
        <WorkingTimes :userId="selectedUserId" />
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Analyse des Heures</h3>
        <ChartManager :userId="selectedUserId" />
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Heures Quotidiennes</h3>
        <DailyHoursChart :userId="selectedUserId" />
      </div>
      
      <div class="mt-6">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Sélection d'Utilisateur</h3>
        <select v-model="selectedUserId" class="w-full p-2 bg-bat-black text-bat-silver border border-bat-gray rounded">
          <option value="">Sélectionner un utilisateur</option>
          <option v-for="user in allUsers" :key="user.id" :value="user.id">
            {{ user.name }} - {{ user.role }}
          </option>
        </select>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import User from '@/components/User.vue';
  import ClockManager from '@/components/ClockManager.vue';
  import WorkingTimes from '@/components/WorkingTimes.vue';
  import ChartManager from '@/components/ChartManager.vue';
  import DailyHoursChart from '@/components/charts/user/DailyHoursChart.vue';
  
  const selectedUserId = ref('');
  const allUsers = ref([]);
  
  onMounted(async () => {
    await fetchAllUsers();
  });
  
  const fetchAllUsers = async () => {
    // Simuler un appel API pour obtenir la liste de tous les utilisateurs
    allUsers.value = await new Promise(resolve => setTimeout(() => resolve([
      { id: '1', name: 'John Doe', role: 'Manager' },
      { id: '2', name: 'Jane Smith', role: 'Employee' },
      { id: '3', name: 'Mike Johnson', role: 'Manager' },
      { id: '4', name: 'Emily Brown', role: 'Employee' }
    ]), 500));
  };
  </script>