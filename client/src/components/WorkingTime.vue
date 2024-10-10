<template>
    <div class="flex flex-col items-center justify-center h-screen">
      <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4">Management des Working Times</h1>
  
        <div class="flex items-center mb-4">
            <input 
              v-model="startTime" 
              type="datetime-local" 
              class="mr-2 p-2 border rounded"
            />
            <input 
              v-model="endTime" 
              type="datetime-local" 
              class="mr-2 p-2 border rounded"
            />
            <button 
              @click="createWorkingTime({ working_time: { start: startTime, end: endTime } })"
              class="font-bold py-2 px-4 rounded"
            >Create Working Time</button>
        </div>
        <div class="flex items-center mb-4">
            <input 
              v-model="startTime" 
              type="datetime-local" 
              class="mr-2 p-2 border rounded"
            />
            <input 
              v-model="endTime" 
              type="datetime-local" 
              class="mr-2 p-2 border rounded"
            />
            <button 
              @click="updateWorkingTime({ working_time: { start: startTime, end: endTime } })"
              class="font-bold py-2 px-4 rounded"
            >Update Working Time</button>
            <button 
              @click="deleteWorkingTime()"
              class="font-bold py-2 px-4 rounded mb-4 w-full"
            >Delete Working Time
            </button>
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
  