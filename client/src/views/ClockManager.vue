<template>
    <div class="flex flex-col items-center justify-center h-screen bg-gray-100">
      <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4">Gestion des heures de travail</h1>
        
        <div class="mb-4">
          <p v-if="clockIn" class="text-green-500">Vous travaillez depuis : {{ startDateTime }}</p>
          <p v-else class="text-red-500">Vous n'êtes pas actuellement en train de travailler.</p>
        </div>
  
        <button
          @click="clock"
          :class="clockIn ? 'bg-red-500 hover:bg-red-600' : 'bg-green-500 hover:bg-green-600'"
          class="text-white font-bold py-2 px-4 rounded mb-4 w-full"
        >
          {{ clockIn ? 'Arrêter le travail' : 'Commencer le travail' }}
        </button>
  
        <button
          @click="refresh"
          class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded w-full"
        >
          Rafraîchir
        </button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const clockIn = ref(false);            // État pour savoir si l'utilisateur est clocké ou non
  const startDateTime = ref(null);       // Heure de début du travail
  
  // Méthode pour rafraîchir l'état actuel
  const refresh = () => {
    // Simuler la récupération de l'état depuis l'API
    clockIn.value = false;  // Exemple : Par défaut l'utilisateur n'est pas clocké
    startDateTime.value = null;
    console.log('État rafraîchi');
  };
  
  // Méthode pour gérer le clock in et clock out
  const clock = () => {
    if (clockIn.value) {
      // Arrêter le travail
      clockIn.value = false;
      startDateTime.value = null;
      console.log('Arrêt du travail');
    } else {
      // Commencer le travail
      clockIn.value = true;
      startDateTime.value = new Date().toLocaleString();  // Enregistre l'heure de début
      console.log('Début du travail à :', startDateTime.value);
    }
  };
  </script>
  
  <style scoped>
  /* Styles supplémentaires pour améliorer la présentation */
  </style>
  