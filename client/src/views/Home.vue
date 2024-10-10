<!-- eslint-disable vue/multi-word-component-names -->
<template>
    <div class="flex flex-col items-center justify-center h-screen bg-gray-100">
      <h1 class="text-4xl font-bold mb-4">Bienvenue dans Time Manager!</h1>
      <p class="text-lg mb-6">Gérez vos heures de travail efficacement.</p>
      <router-link to="/clock" class="bg-blue-500 text-white font-bold py-2 px-4 rounded hover:bg-blue-600">
        Accéder au Clock Manager
      </router-link>
      <router-link to="/user" class="mt-4 bg-green-500 text-white font-bold py-2 px-4 rounded hover:bg-green-600">
        Gérer les utilisateurs
      </router-link>
    </div>
  </template>
  
  <script setup>
  // Tu peux ajouter des logiques spécifiques ou des données ici si nécessaire
  </script>
  
  <style scoped>
  /* Styles supplémentaires pour améliorer la présentation */
  </style>
  