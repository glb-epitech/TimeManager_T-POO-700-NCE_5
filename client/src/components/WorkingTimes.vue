<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Gotham Patrol Logs for Vigilante {{ userId }}</h2>

    <div v-if="loading" class="text-center py-4">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
      <p class="mt-2 text-bat-silver">Accessing Bat-Computer...</p>
    </div>

    <div v-else-if="errorMessage" class="bg-red-900 border-l-4 border-bat-yellow text-bat-silver p-4 mb-4" role="alert">
      <p class="font-bold">Alert</p>
      <p>{{ errorMessage }}</p>
    </div>

    <div v-else-if="workingTimes.length" class="overflow-x-auto">
      <table class="w-full bg-bat-black">
        <thead class="bg-bat-gray">
          <tr>
            <th class="px-4 py-2 text-left text-bat-yellow">Mission ID</th>
            <th class="px-4 py-2 text-left text-bat-yellow">Patrol Start</th>
            <th class="px-4 py-2 text-left text-bat-yellow">Patrol End</th>
            <th class="px-4 py-2 text-left text-bat-yellow">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="time in workingTimes" :key="time.id" class="border-b border-bat-gray hover:bg-bat-gray transition duration-300">
            <td class="px-4 py-2 text-bat-silver">{{ time.id }}</td>
            <td class="px-4 py-2 text-bat-blue">{{ formatTime(time.start) }}</td>
            <td class="px-4 py-2 text-bat-blue">{{ formatTime(time.end) }}</td>
            <td class="px-4 py-2">
              <button @click="editWorkingTime(time.id)" class="mr-2 px-3 py-1 bg-bat-blue text-bat-black rounded hover:bg-opacity-80 transition duration-300">
                Edit
              </button>
              <button @click="deleteWorkingTime(time.id)" class="px-3 py-1 bg-red-600 text-bat-silver rounded hover:bg-opacity-80 transition duration-300">
                Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <p v-else class="text-center py-4 text-bat-silver">No patrol logs available. The night is young.</p>

    <div class="mt-6">
      <button @click="showAddForm = true" class="w-full px-4 py-2 bg-bat-yellow text-bat-black rounded-full shadow-bat hover:bg-opacity-90 transition duration-300 font-bold">
        Add New Patrol Log
      </button>
    </div>

    <!-- Add/Edit Form Modal -->
    <div v-if="showAddForm || editingId" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-bat-gray p-6 rounded-lg shadow-bat max-w-md w-full">
        <h3 class="text-xl font-bold mb-4 text-bat-yellow">{{ editingId ? 'Edit' : 'Add' }} Patrol Log</h3>
        <form @submit.prevent="submitForm" class="space-y-4">
          <div>
            <label for="startTime" class="block text-sm font-medium text-bat-silver mb-1">Patrol Start:</label>
            <input type="datetime-local" id="startTime" v-model="formData.start" required
                   class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow">
          </div>
          <div>
            <label for="endTime" class="block text-sm font-medium text-bat-silver mb-1">Patrol End:</label>
            <input type="datetime-local" id="endTime" v-model="formData.end" required
                   class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow">
          </div>
          <div class="flex justify-end space-x-4">
            <button type="button" @click="closeForm" class="px-4 py-2 bg-bat-gray text-bat-silver rounded-full shadow-bat hover:bg-opacity-90 transition duration-300 font-bold">
              Cancel
            </button>
            <button type="submit" class="px-4 py-2 bg-bat-yellow text-bat-black rounded-full shadow-bat hover:bg-opacity-90 transition duration-300 font-bold">
              {{ editingId ? 'Update' : 'Add' }} Log
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "WorkingTimes",
  data() {
    return {
      userId: null, 
      workingTimes: [],
      loading: true,
      errorMessage: null,
    };
  },
  methods: {
    async getWorkingTimes() {
      this.loading = true;
      this.errorMessage = null; 
      console.log(`Fetching working times for user ID: ${this.userId}`); 
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtimes/${this.userId}`
        );
        console.log('RESPONSE', response);
        
        if (response.data && response.data.data) {
          this.workingTimes = response.data.data;
        } else {
          this.errorMessage = "Invalid response structure.";
        }
      } catch (error) {
        this.errorMessage = error.response?.data?.message || "Erreur lors de la récupération des heures de travail.";
        console.error("Erreur lors de la récupération des heures de travail :", error);
      } finally {
        this.loading = false;
      }
    },

    formatTime(time) {
      const date = new Date(time);
      return date.toLocaleString();
    },
  },
  mounted() {
    this.userId = this.$route.params.userId; // Récupération de userId depuis les paramètres de route
    console.log('User ID from URL:', this.userId); 
    this.getWorkingTimes();
  },
};
</script>

