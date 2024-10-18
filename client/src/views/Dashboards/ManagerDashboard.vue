<!-- eslint-disable no-unused-vars -->
<template>
    <div class="manager-dashboard">
      <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Tableau de Bord du Manager</h2>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-bat-gray rounded-lg shadow-bat p-4">
          <h3 class="text-xl font-bold mb-4 text-bat-silver">Gestion des Utilisateurs</h3>
          <User />
        </div>
        
        <div class="bg-bat-gray rounded-lg shadow-bat p-4">
          <h3 class="text-xl font-bold mb-4 text-bat-silver">Gestion du Temps</h3>
          <ClockManager :userId="selectedEmployeeId" />
        </div>
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Heures de Travail de l'Équipe</h3>
        <WorkingTimes :userId="selectedEmployeeId" />
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Analyse des Heures de l'Équipe</h3>
        <ChartManager :userId="selectedEmployeeId" />
      </div>
      
      <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Heures Quotidiennes de l'Équipe</h3>
        <DailyHoursChart :userId="selectedEmployeeId" />
      </div>
      
      <div class="mt-6">
        <h3 class="text-xl font-bold mb-4 text-bat-silver">Sélection d'Employé</h3>
        <select v-model="selectedEmployeeId" class="w-full p-2 bg-bat-black text-bat-silver border border-bat-gray rounded">
          <option value="">Sélectionner un employé</option>
          <option v-for="employee in teamEmployees" :key="employee.id" :value="employee.id">
            {{ employee.name }}
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
  
  // eslint-disable-next-line no-unused-vars
  const props = defineProps({
    managerId: {
      type: String,
      required: true
    }
  });
  
  const selectedEmployeeId = ref('');
  const teamEmployees = ref([]);
  
  onMounted(async () => {
    await fetchTeamEmployees();
  });
  
  const fetchTeamEmployees = async () => {
    // Simuler un appel API pour obtenir la liste des employés de l'équipe
    teamEmployees.value = await new Promise(resolve => setTimeout(() => resolve([
      { id: '1', name: 'Alice' },
      { id: '2', name: 'Bob' },
      { id: '3', name: 'Charlie' }
    ]), 500));
  };
  </script>