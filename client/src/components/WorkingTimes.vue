<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Journal de Patrouille de Gotham</h2>

    <!-- Loading indicator -->
    <div v-if="loading" class="text-center py-4">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
      <p class="mt-2 text-bat-silver">Accès au Bat-Ordinateur en cours...</p>
    </div>

    <!-- Error message -->
    <div v-else-if="errorMessage" class="bg-red-900 border-l-4 border-bat-yellow text-bat-silver p-4 mb-4" role="alert">
      <p class="font-bold">Alerte</p>
      <p>{{ errorMessage }}</p>
    </div>

    <div v-else-if="workingTimes.length > 0" class="space-y-4">
      <div v-for="workingTime in workingTimes" :key="workingTime.id"
        class="bg-bat-black p-4 rounded-lg shadow-inner">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <div>
            <p class="text-bat-yellow font-semibold">ID de Mission :</p>
            <p class="text-bat-silver">{{ workingTime.id }}</p>
          </div>
          <div>
            <p class="text-bat-yellow font-semibold">ID du Vigilant :</p>
            <p class="text-bat-silver">{{ workingTime.user_id }}</p>
          </div>
          <div>
            <p class="text-bat-yellow font-semibold">Début de Patrouille :</p>
            <p class="text-bat-blue">{{ formatTimeForDisplay(workingTime.start) }}</p>
          </div>
          <div>
            <p class="text-bat-yellow font-semibold">Fin de Patrouille :</p>
            <p class="text-bat-blue">{{ formatTimeForDisplay(workingTime.end) }}</p>
          </div>
        </div>
        <div class="flex gap-2 mt-2">
          <button @click="editWorkingTime(workingTime)" class="bat-button bat-button-blue flex-1">
            Modifier le Journal
          </button>
          <button @click="deleteWorkingTime(workingTime.id)" class="bat-button bat-button-red flex-1">
            Supprimer le Journal
          </button>
        </div>
      </div>
    </div>

    <div v-else class="text-center py-4 text-bat-silver">
      Aucun journal de patrouille trouvé. La nuit est calme.
    </div>

    <button @click="showCreateForm" class="bat-button bat-button-yellow w-full mt-4">
      Créer un nouveau Journal
    </button>

    <!-- Create form -->
    <div v-if="createMode" class="mt-8 bg-bat-black p-6 rounded-lg shadow-bat">
      <h3 class="text-lg font-semibold mb-4 text-bat-yellow">
        Créer un Nouveau Journal de Patrouille
      </h3>
      <form @submit.prevent="createWorkingTime" class="space-y-4">
        <div>
          <label for="newStartTime" class="block text-sm font-medium text-bat-silver mb-1">Début de Patrouille :</label>
          <input type="datetime-local" id="newStartTime" v-model="newWorkingTime.start" required
            class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow" />
        </div>
        <div>
          <label for="newEndTime" class="block text-sm font-medium text-bat-silver mb-1">Fin de Patrouille :</label>
          <input type="datetime-local" id="newEndTime" v-model="newWorkingTime.end" required
            class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow" />
        </div>
        <div class="flex justify-end space-x-4">
          <button type="button" @click="createMode = false" class="bat-button bat-button-gray">
            Annuler
          </button>
          <button type="submit" class="bat-button bat-button-yellow">
            Créer le Journal
          </button>
        </div>
      </form>
    </div>

    <!-- Edit form -->
    <div v-if="editMode" class="mt-8 bg-bat-black p-6 rounded-lg shadow-bat">
      <h3 class="text-lg font-semibold mb-4 text-bat-yellow">
        Modifier le Journal de Patrouille
      </h3>
      <form @submit.prevent="updateWorkingTime" class="space-y-4">
        <div>
          <label for="editStartTime" class="block text-sm font-medium text-bat-silver mb-1">Début de Patrouille :</label>
          <input type="datetime-local" id="editStartTime" v-model="editForm.start" required
            class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow" />
        </div>
        <div>
          <label for="editEndTime" class="block text-sm font-medium text-bat-silver mb-1">Fin de Patrouille :</label>
          <input type="datetime-local" id="editEndTime" v-model="editForm.end" required
            class="w-full px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow" />
        </div>
        <div class="flex justify-end space-x-4">
          <button type="button" @click="editMode = false" class="bat-button bat-button-gray">
            Annuler
          </button>
          <button type="submit" class="bat-button bat-button-yellow">
            Mettre à Jour le Journal
          </button>
        </div>
      </form>
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
      workingTime: null,
      editMode: false,
      editForm: {
        start: "",
        end: "",
      },
      createMode: false,


      newWorkingTime: {
        start: "",
        end: "",
      },
    };
  },
  methods: {
    async getWorkingTimes() {
      this.loading = true;
      this.errorMessage = null;
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtimes/${this.userId}`
        );
        if (
          response.data &&
          response.data.data &&
          response.data.data.length > 0
        ) {
          this.workingTimes = response.data.data;
          this.workingTime = this.workingTimes[0];
        } else {
          this.errorMessage = "No patrol logs found for this user.";
        }
      } catch (error) {
        this.errorMessage =
          error.response?.data?.message ||
          "Erreur lors de la récupération des heures de travail.";
        console.error(
          "Erreur lors de la récupération des heures de travail :",
          error
        );
      } finally {
        this.loading = false;
      }
    },

    async deleteWorkingTime(id) {
      try {
        const response = await axios.delete(
          `http://localhost:4000/api/workingtime/${id}`
        );
        console.log("Working time deleted:", response.data);
        this.workingTimes = this.workingTimes.filter(
          (workingTime) => workingTime.id !== id
        );
      } catch (error) {
        console.error("Error deleting working time:", error);
        this.errorMessage = "Erreur lors de la suppression du journal.";
      }
    },

    editWorkingTime(workingTime) {
      this.editForm = {
        id: workingTime.id,
        start: this.formatTimeForInput(workingTime.start),
        end: this.formatTimeForInput(workingTime.end),
      };
      this.editMode = true;
    },

    async updateWorkingTime() {
      try {
        if (!this.editForm.start || !this.editForm.end) {
          console.error("Start or end time is missing.");
          return;
        }

        const startUTC = new Date(this.editForm.start).toISOString();
        const endUTC = new Date(this.editForm.end).toISOString();

        const data = {
          working_time: {
            start: startUTC,
            end: endUTC,
          }
        };

        const response = await axios.put(
          `http://localhost:4000/api/workingtime/${this.editForm.id}`,
          data
        );

        console.log("Working time updated:", response.data);

        const index = this.workingTimes.findIndex(workingTime => workingTime.id === this.editForm.id);
        if (index !== -1) {
          this.workingTimes[index] = {
            ...this.workingTimes[index],
            start: startUTC,
            end: endUTC,
          };
        }

        this.editMode = false;
        this.editForm = {
          start: "",
          end: "",
        };
      } catch (error) {
        console.error("Error updating working time:", error.response ? error.response.data : error);
        this.errorMessage = "Erreur lors de la mise à jour du journal.";
      }
    },


    showCreateForm() {
    this.createMode = true;
    this.newWorkingTime = { start: "", end: "" }; // Réinitialiser le formulaire
  },

  async createWorkingTime() {
    // console.log('TOTO')
    try {
      if (!this.newWorkingTime.start || !this.newWorkingTime.end) {
        console.error("Start or end time is missing.");
        return;
      }
      const startUTC = new Date(this.newWorkingTime.start).toISOString();
      const endUTC = new Date(this.newWorkingTime.end).toISOString();
      const data = {
        working_time: {
          start: startUTC,
          end: endUTC,
        }
      };
      const response = await axios.post(
        `http://localhost:4000/api/workingtime/${this.userId}`,
        data
      );
      this.getWorkingTimes();
      // console.log('RESPONSE CREATE',response)
      this.workingTimes.push(response.data); 
      this.createMode = false; 
      this.newWorkingTime = { start: "", end: "" }; 
    } catch (error) {
      console.error("Error creating working time:", error);
      this.errorMessage = "Erreur lors de la création du journal.";
    }
  },


    formatTimeForInput(dateString) {
      const date = new Date(dateString);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, "0");
      const day = String(date.getDate()).padStart(2, "0");
      const hours = String(date.getHours()).padStart(2, "0");
      const minutes = String(date.getMinutes()).padStart(2, "0");

      return `${year}-${month}-${day}T${hours}:${minutes}`;
    },

    formatTimeForDisplay(time) {
      const date = new Date(time);
      return date.toLocaleString();
    },
  },

  mounted() {
    this.userId = this.$route.query.id;
    this.getWorkingTimes();
  },

  //   formatTime(time) {
  //   const date = new Date(time);
  //   date.setHours(date.getHours() - 2);
  //   return date.toLocaleString();
  // },


  watch: {
    "$route.query.id": function (newId) {
      this.userId = newId;
      this.getWorkingTimes();
    },
  },
};
</script>
