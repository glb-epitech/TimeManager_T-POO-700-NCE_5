<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-100 to-indigo-200 flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden">
      <div class="bg-indigo-600 p-6">
        <h1 class="text-3xl font-extrabold text-white text-center">Gestion du Temps</h1>
      </div>
      
      <div class="p-6 space-y-6">
        <div class="text-center">
          <p v-if="clockIn" class="text-lg font-medium text-green-600">
            <span class="block text-sm text-gray-500">En service depuis :</span>
            {{ startDateTime }}
          </p>
          <p v-else class="text-lg font-medium text-red-600">
            Vous n'êtes pas en service actuellement.
          </p>
        </div>

        <button
          @click="clock"
          :class="clockIn ? 'bg-red-500 hover:bg-red-600 focus:ring-red-300' : 'bg-green-500 hover:bg-green-600 focus:ring-green-300'"
          class="w-full py-3 px-4 text-white font-bold rounded-lg shadow-md transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4"
        >
          {{ clockIn ? 'Terminer le service' : 'Commencer le service' }}
        </button>

        <button
          @click="refresh"
          class="w-full py-3 px-4 bg-indigo-500 text-white font-bold rounded-lg shadow-md hover:bg-indigo-600 transition duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-4 focus:ring-indigo-300"
        >
          Actualiser
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const clockIn = ref(false);
const startDateTime = ref(null);

const refresh = () => {
  clockIn.value = false;
  startDateTime.value = null;
  console.log('État actualisé');
};

const clock = () => {
  if (clockIn.value) {
    clockIn.value = false;
    startDateTime.value = null;
    console.log('Service terminé');
  } else {
    clockIn.value = true;
    startDateTime.value = new Date().toLocaleString();
    console.log('Service commencé à :', startDateTime.value);
  }
};
</script>