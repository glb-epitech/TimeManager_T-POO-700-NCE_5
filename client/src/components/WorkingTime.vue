<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Journal de Patrouille de Gotham</h2>

    <div v-if="loading" class="text-center py-4">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
      <p class="mt-2 text-bat-silver">Accès au Bat-Ordinateur en cours...</p>
    </div>

    <div v-else-if="errorMessage" class="bg-red-900 border-l-4 border-bat-yellow text-bat-silver p-4 mb-4" role="alert">
      <p class="font-bold">Alerte</p>
      <p>{{ errorMessage }}</p>
    </div>

    <div v-else-if="workingTime" class="bg-bat-black p-6 rounded-lg shadow-inner">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div>
          <p class="text-bat-yellow font-semibold">ID de Mission :</p>
          <p class="text-bat-silver text-xl">{{ workingTime.id }}</p>
        </div>
        <div>
          <p class="text-bat-yellow font-semibold">ID du Vigilant :</p>
          <p class="text-bat-silver text-xl">{{ userId }}</p>
        </div>
        <div>
          <p class="text-bat-yellow font-semibold">Début de Patrouille :</p>
          <p class="text-bat-blue text-xl">{{ formatTime(workingTime.start) }}</p>
        </div>
        <div>
          <p class="text-bat-yellow font-semibold">Fin de Patrouille :</p>
          <p class="text-bat-blue text-xl">{{ formatTime(workingTime.end) }}</p>
        </div>
      </div>

      <div class="flex flex-wrap justify-between gap-2 mt-2">
        <button class="flex-grow bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600">
          Modifier le Journal de Patrouille
        </button>
        <button class="flex-grow bg-red-500 text-white py-2 px-4 rounded hover:bg-red-600">
          Supprimer le Journal
        </button>
      </div>
    </div>

    <div v-else class="text-center py-4 text-bat-silver">
      Aucun journal de patrouille trouvé. La nuit est calme.
    </div>

    <!-- Formulaire de modification -->
    <div v-if="editMode" class="mt-8 bg-bat-black p-6 rounded-lg shadow-bat">
      <h3 class="text-lg font-semibold mb-4 text-bat-yellow">Modifier le Journal de Patrouille</h3>
      <form @submit.prevent="updateWorkingTime" class="space-y-4">
        <div>
          <label for="editStartTime" class="block text-sm font-medium text-bat-silver mb-1">Début de Patrouille :</label>
          <input type="datetime-local" id="editStartTime" v-model="editForm.start" required
                 class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow">
        </div>
        <div>
          <label for="editEndTime" class="block text-sm font-medium text-bat-silver mb-1">Fin de Patrouille :</label>
          <input type="datetime-local" id="editEndTime" v-model="editForm.end" required
                 class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow">
        </div>
        <div class="flex justify-end space-x-4">
          <button type="button" @click="editMode = false" class="px-4 py-2 bg-bat-gray text-bat-silver rounded-full shadow-bat hover:bg-opacity-90 transition duration-300 font-bold">
            Annuler
          </button>
          <button type="submit" class="px-4 py-2 bg-bat-yellow text-bat-black rounded-full shadow-bat hover:bg-opacity-90 transition duration-300 font-bold">
            Mettre à Jour le Journal
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

  <script>
  import axios from 'axios';
  
  export default {
    name: 'WorkingTime',
    props: {
      userId: {
        type: String,
        required: true
      },
      workingTimeId: {
        type: String,
        default: null
      }
    },
    methods: {
      // async workingTimebyUser() {
      //   try {
      //     const response = await axios.get(`http://localhost:4000/api/`)
      //   } catch (error) {
      //     console.error('Error getting worktimes by user:', error);
      //   }
      // }
      async createWorkingTime(data) {
        try {
          console.log("start request : ", data)
          const response = await axios.post(`http://localhost:4000/api/workingtime/1`, data);
          console.log('Working time created:', response.data);
        } catch (error) {
          console.error('Error creating working time:', error);
        }
      },
      async updateWorkingTime(data) {
        try {
          const response = await axios.put(`http://localhost:4000/api/workingtime/9`, data);
          console.log('Working time updated:', response.data);
        } catch (error) {
          console.error('Error updating working time:', error);
        }
      },
      async deleteWorkingTime() {
        try {
          const response = await axios.put(`http://localhost:4000/api/workingtime/9`);

          console.log('Working time deleted:', response.data);
        } catch (error) {
          console.error('Error deleting working time:', error);
        }
      }
    }
  };
  </script>
  
  <style scoped>
  /* Your component styles here */
  </style>
  