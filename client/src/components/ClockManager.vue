<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Gotham Time Tracker</h2>
    
    <div class="mb-6">
      <p v-if="clockIn" class="text-bat-blue font-semibold">
        Vigilance active depuis : <span class="text-bat-yellow">{{ startDateTime }}</span>
      </p>
      <p v-else class="text-bat-silver">Aucune patrouille en cours.</p>
    </div>

    <button
      @click="clock"
      :disabled="loading"
      :class="[
        clockIn ? 'bg-bat-blue' : 'bg-bat-yellow',
        'text-bat-black font-bold py-3 px-6 rounded-full shadow-bat hover:opacity-90 transition duration-300 w-full mb-4',
        loading ? 'opacity-50 cursor-not-allowed' : ''
      ]"
    >
      {{ clockIn ? 'Terminer la patrouille' : 'Débuter la patrouille' }}
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
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue';
import { useRoute } from 'vue-router';
import api from '@/services/api';

export default {
  setup() {
    const route = useRoute();
    const clockIn = ref(false);
    const startDateTime = ref(null);
    const loading = ref(false);
    const userId = ref(null);
    const error = ref(null);

    const refresh = async () => {
      if (!userId.value) {
        error.value = "Aucun utilisateur sélectionné";
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        const response = await api.getClocks(userId.value);
        console.log('API response:', response);
        if (response.data && response.data.length > 0) {
          const lastClock = response.data[response.data.length - 1];
          clockIn.value = lastClock.status === 'false';
          startDateTime.value = clockIn.value ? new Date(lastClock.time).toLocaleString() : null;
        } else {
          clockIn.value = false;
          startDateTime.value = null;
        }
        console.log('État rafraîchi');
      } catch (err) {
        console.error('Erreur lors du rafraîchissement:', err);
        error.value = "Erreur lors de la récupération des données";
      } finally {
        loading.value = false;
      }
    };

    const clock = async () => {
      if (!userId.value) {
        error.value = "Aucun utilisateur sélectionné";
        return;
      }
      loading.value = true;
      error.value = null;
      try {
        const newStatus = !clockIn.value;
        const response = await api.postClock(userId.value, new Date().toISOString(), newStatus);
        console.log('API response:', response);
        clockIn.value = newStatus;
        startDateTime.value = newStatus ? new Date().toLocaleString() : null;
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
      clockIn,
      startDateTime,
      loading,
      userId,
      error,
      refresh,
      clock
    };
  }
};
</script>