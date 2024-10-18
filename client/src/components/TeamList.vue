<template>
    <div>
      <h1>Teams</h1>
      <ul>
        <li v-for="team in teams" :key="team.id">
          {{ team.name }} - Manager: {{ team.manager_id }}
          <button @click="deleteTeam(team.id)">Delete</button>
        </li>
      </ul>
  
      <h2>Create Team</h2>
      <form @submit.prevent="createTeam">
        <input v-model="newTeam.name" placeholder="Team Name" required />
        <input v-model="newTeam.manager_id" placeholder="Manager ID" required />
        <button type="submit">Create</button>
      </form>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        teams: [],
        newTeam: {
          name: '',
          manager_id: ''
        }
      };
    },
    created() {
      this.fetchTeams();
    },
    methods: {
      fetchTeams() {
        axios.get('/api/teams')
          .then(response => {
            this.teams = response.data.data;
          })
          .catch(error => {
            console.error('Error fetching teams:', error);
          });
      },
      createTeam() {
        axios.post('/api/teams', { team: this.newTeam })
          .then(() => {
            this.fetchTeams();
            this.newTeam.name = '';
            this.newTeam.manager_id = '';
          })
          .catch(error => {
            console.error('Error creating team:', error);
          });
      },
      deleteTeam(teamId) {
        axios.delete(`/api/teams/${teamId}`)
          .then(() => {
            this.fetchTeams();
          })
          .catch(error => {
            console.error('Error deleting team:', error);
          });
      }
    }
  };
  </script>
  