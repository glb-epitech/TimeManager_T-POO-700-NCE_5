<template>
    <div class="flex flex-col items-center justify-center h-screen">
      <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4">Gestion des heures de travail</h1>
  
        <button 
          @click="createWorkingTime({ working_time: { start: '2023-10-08T09:00:00Z', end: '2023-10-08T17:00:00Z' } })"
          class="font-bold py-2 px-4 rounded mb-4 w-full"
          >Create Working Time
        </button>
        <button 
          @click="updateWorkingTime({ working_time: { start: '2023-10-08T09:00:00Z', end: '2024-10-08T17:00:00Z' } })"
          class="font-bold py-2 px-4 rounded mb-4 w-full"
          >Update Working Time
        </button>
        <button 
          @click="deleteWorkingTime()"
          class="font-bold py-2 px-4 rounded mb-4 w-full"
          >Delete Working Time</button>
  
        <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md mt-4">
      <h2 class="text-xl font-bold mb-4">Working Times</h2>
      <ul>
        <li v-for="workingTime in workingTimes" :key="workingTime.id">
          {{ workingTime.start }} - {{ workingTime.end }}
        </li>
      </ul>
    </div>

      </div>
    </div>
    <div>

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
      async createWorkingTime(data) {
        try {
          console.log("start request : ", data)
          const response = await axios.post(`http://localhost:4000/api/workingtime/1`, data);
          console.log(response)
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
  