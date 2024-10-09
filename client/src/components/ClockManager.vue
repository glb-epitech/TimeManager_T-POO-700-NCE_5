<template>
    <div class="flex flex-col items-center justify-center h-screen">
      <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4">Gestion des heures de travail</h1>
        
        <div class="mb-4">
          <p v-if="clockIn" class="text-green-500">Vous êtes en train de travailler depuis : {{ startDateTime }}</p>
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
  
  <script>
  export default {
    data() {
      return {
        clockIn: false,          // État pour savoir si l'utilisateur est clocké ou non
        startDateTime: null,     // Heure de début du travail
      };
    },
    methods: {
      // Méthode pour rafraîchir l'état actuel (simulation d'une requête API)
      refresh() {
        // Simuler la récupération de l'état depuis l'API
        this.clockIn = false;  // Exemple : Par défaut l'utilisateur n'est pas clocké
        this.startDateTime = null;
        console.log('État rafraîchi');
      },
  
      // Méthode pour gérer le clock in et clock out
      clock() {
        if (this.clockIn) {
          // Cas où l'utilisateur arrête de travailler
          this.clockIn = false;
          this.startDateTime = null;
          console.log('Arrêt du travail');
        } else {
          // Cas où l'utilisateur commence à travailler
          this.clockIn = true;
          this.startDateTime = new Date().toLocaleString();  // Enregistre l'heure de début
          console.log('Début du travail à :', this.startDateTime);
        }
      }
    }
  };
  </script>
  
  <style scoped>
  /* Styles supplémentaires pour améliorer la présentation */
  </style>
  