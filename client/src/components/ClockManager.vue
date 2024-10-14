<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Gotham Time Tracker</h2>
    
    <div class="mb-6">
      <p v-if="isClockedIn" class="text-bat-blue font-semibold">
        Vigilance active depuis : <span class="text-bat-yellow">{{ startTime }}</span>
      </p>
      <p v-else-if="endTime" class="text-bat-silver">
        Patrouille terminée à : <span class="text-bat-yellow">{{ endTime }}</span>
      </p>
    </div>

    <button
      @click="toggleClock"
      :disabled="loading"
      :class="[
        isClockedIn ? 'bg-bat-blue' : 'bg-bat-yellow',
        'text-bat-black font-bold py-3 px-6 rounded-full shadow-bat hover:opacity-90 transition duration-300 w-full mb-4',
        loading ? 'opacity-50 cursor-not-allowed' : ''
      ]"
    >
      {{ isClockedIn ? 'Terminer la patrouille' : 'Débuter la patrouille' }}
    </button>

    <button
      @click="refresh"
      :disabled="loading"
      :class="loading ? 'opacity-50 cursor-not-allowed' : ''"
      class="bg-bat-gray border border-bat-yellow text-bat-yellow font-bold py-3 px-6 rounded-full shadow-bat hover:bg-bat-yellow hover:text-bat-black transition duration-300 w-full"
    >
      Actualiser le statut
    </button>

    <div v-if="loading" class="mt-4 text-center">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
    </div>

    <div v-if="error" class="mt-4 text-red-500">
      {{ error }}
    </div>

    <div v-if="apiResponse" class="mt-4">
      <h3 class="text-xl font-bold mb-2">Détails de la réponse API :</h3>
      <table class="min-w-full bg-gray-200 border border-gray-400 rounded-lg overflow-hidden">
        <thead>
          <tr class="bg-bat-yellow text-bat-black">
            <!-- <th class="py-2 px-4 border-b border-gray-400">ID de la patrouille</th> -->
            <th class="py-2 px-4 border-b border-gray-400">Statut</th>
            <th class="py-2 px-4 border-b border-gray-400">Heure de début</th>
            <th class="py-2 px-4 border-b border-gray-400">Heure de fin</th>
            <!-- <th class="py-2 px-4 border-b border-gray-400">ID de l'utilisateur</th> -->
          </tr>
        </thead>
        <tbody>
          <tr>
            <!-- <td class="py-2 px-4 border-b border-gray-400">{{ patrolId }}</td> -->
            <td class="py-2 px-4 border-b border-gray-400">{{ isClockedIn ? 'En cours' : (endTime ? 'Terminée' : '') }}</td>
            <td class="py-2 px-4 border-b border-gray-400">{{ startTime }}</td>
            <td class="py-2 px-4 border-b border-gray-400">{{ endTime }}</td>
            <!-- <td class="py-2 px-4 border-b border-gray-400">{{ userId }}</td> -->
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import api from '@/services/api';

export default {
  setup() {
    const route = useRoute();
    const isClockedIn = ref(false); 
    const startTime = ref(null); 
    const endTime = ref(null); 
    const loading = ref(false);
    const userId = ref(null);
    const error = ref(null);
    const apiResponse = ref(null); 

    
    const patrolId = ref(null); 

    const refresh = async () => {
      if (!userId.value) {
        error.value = "Aucun utilisateur sélectionné";
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        const response = await api.getClocks(userId.value);
        apiResponse.value = response.data; 
        console.log('API response:', response);
        if (response.data && response.data.length > 0) {
          const lastClock = response.data[response.data.length - 1];
          isClockedIn.value = lastClock.status === 'true'; 
          startTime.value = isClockedIn.value ? new Date(lastClock.time).toLocaleString() : startTime.value; 
          endTime.value = !isClockedIn.value ? new Date(lastClock.time).toLocaleString() : endTime.value; 
        } else {
          isClockedIn.value = false;
          startTime.value = null;
          endTime.value = null;
        }
        console.log('État rafraîchi');
      } catch (err) {
        console.error('Erreur lors du rafraîchissement:', err);
        error.value = "Erreur lors de la récupération des données";
      } finally {
        loading.value = false;
      }
    };

    const toggleClock = async () => {
      if (!userId.value) {
        error.value = "Aucun utilisateur sélectionné";
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        const newStatus = !isClockedIn.value;
        const response = await api.postClock(userId.value, new Date().toISOString(), newStatus);
        apiResponse.value = response.data; 

       
        patrolId.value = response.data.data.id;
        isClockedIn.value = newStatus;

        if (newStatus) {
          startTime.value = new Date().toLocaleString(); 
          endTime.value = null; 
        } else {
          endTime.value = new Date().toLocaleString();
        }

        console.log('API response:', response);
        console.log(newStatus ? 'Début du travail' : 'Arrêt du travail');
      } catch (err) {
        console.error('Erreur lors du changement d\'état:', err);
        error.value = "Erreur lors du changement d'état";
      } finally {
        loading.value = false;
      }
    };

    onMounted(() => {
      userId.value = route.query.id;
      console.log("User ID from URL:", userId.value);
      if (userId.value) {
        refresh();
      } else {
        error.value = "Aucun utilisateur sélectionné";
      }
    });

    watch(() => route.query.id, (newId) => {
      userId.value = newId;
      console.log("User ID changed to:", userId.value);
      if (userId.value) {
        refresh();
      } else {
        error.value = "Aucun utilisateur sélectionné";
      }
    });

    return {
      isClockedIn,
      startTime,
      endTime,
      loading,
      userId,
      error,
      apiResponse, 
      patrolId, 
      refresh,
      toggleClock
    };
  }
};
</script>

