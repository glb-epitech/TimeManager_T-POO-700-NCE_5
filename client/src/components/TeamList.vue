<template>
    <div>
      <!-- <h1 class="text-2xl font-bold mb-4">Team Management</h1> -->
  
      <!-- Liste des équipes -->
      <ul v-if="teams.length">
        <li v-for="team in teams" :key="team.id" class="mb-4 p-4 bg-gray-200 rounded shadow">
          <h3 class="text-xl font-bold mb-2">{{ team.name }}</h3>
          <p class="text-sm text-gray-600">Managed by ID: {{ team.manager_id }}</p>
  
          <h4 class="mt-2 font-semibold">Members:</h4>
          <ul class="ml-4 list-disc">
            <li v-for="member in team.members" :key="member.id" class="mt-1">
              {{ member.username }} ({{ member.email }})
            </li>
          </ul>
  
          <!-- Formulaire pour ajouter un membre -->
          <div class="mt-4">
            <h5 class="font-semibold">Add a Member</h5>
            <input v-model="newMemberId[team.id]" placeholder="User ID" type="number" class="border p-2 rounded w-full mb-2" />
            <button @click="addUserToTeam(team.id)" class="bg-green-500 text-white p-2 rounded hover:bg-green-700">
              Add Member
            </button>
          </div>
  
          <!-- Bouton pour supprimer l'équipe -->
          <button @click="deleteTeam(team.id)" class="mt-4 bg-red-500 text-white p-2 rounded hover:bg-red-700">
            Delete Team
          </button>
        </li>
      </ul>
  
      <!-- Affichage si aucune équipe n'est présente -->
      <p v-else class="text-gray-500">No teams found.</p>
  
      <!-- Formulaire de création d'équipe -->
      <div class="mt-6">
        <h2 class="text-bat-yellow text-xl font-semibold mb-2">Create a new team</h2>
        <form @submit.prevent="createTeam" class="bg-bat-gray p-4 rounded shadow">
          <div class="mb-4">
            <label class="block mb-2 text-bat-yellow">Team Name:</label>
            <input v-model="newTeam.name" type="text" class="border p-2 rounded w-full" required />
          </div>
  
          <div class="mb-4">
            <label class="block mb-2 text-bat-yellow">Manager ID:</label>
            <input v-model="newTeam.manager_id" type="number" class="border p-2 rounded w-full" required />
          </div>
  
          <button type="submit" class="bg-blue-500 text-white p-2 rounded hover:bg-blue-700">
            Create Team
          </button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        teams: [], // Liste des équipes
        newTeam: {
          name: '',
          manager_id: ''
        },
        newMemberId: {} // Objet pour stocker l'ID de l'utilisateur à ajouter par équipe
      };
    },
    created() {
      this.fetchTeams(); // Récupérer la liste des équipes à la création du composant
    },
    methods: {
      // Récupérer la liste des équipes depuis l'API
      fetchTeams() {
        axios.get('/api/teams')
          .then(response => {
            this.teams = response.data.data;
          })
          .catch(error => {
            console.error('Error fetching teams:', error);
          });
      },
  
      // Créer une nouvelle équipe
      createTeam() {
        axios.post('/api/teams', { team: this.newTeam })
          .then(() => {
            this.fetchTeams(); // Recharger la liste des équipes après création
            this.newTeam.name = '';
            this.newTeam.manager_id = '';
          })
          .catch(error => {
            console.error('Error creating team:', error);
          });
      },
  
      // Ajouter un utilisateur à une équipe
      addUserToTeam(teamId) {
        const userId = this.newMemberId[teamId]; // Récupérer l'ID de l'utilisateur pour l'équipe spécifique
  
        if (!userId) {
          alert('Please enter a user ID');
          return;
        }
  
        axios.put(`/api/teams/${teamId}/users/${userId}`)
          .then(() => {
            this.fetchTeams(); // Recharger la liste des équipes après avoir ajouté un utilisateur
            this.newMemberId[teamId] = ''; // Réinitialiser le champ de saisie après l'ajout
          })
          .catch(error => {
            console.error('Error adding user to team:', error);
          });
      },
  
      // Supprimer une équipe
      deleteTeam(teamId) {
        axios.delete(`/api/teams/${teamId}`)
          .then(() => {
            this.fetchTeams(); // Recharger la liste des équipes après suppression
          })
          .catch(error => {
            console.error('Error deleting team:', error);
          });
      }
    }
  };
  </script>
  
  <style scoped>
  ul {
    list-style-type: none;
    padding: 0;
  }
  
  ul li {
    margin-bottom: 10px;
  }
  </style>
  