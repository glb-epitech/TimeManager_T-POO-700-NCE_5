<template>
    <div class="flex flex-col items-center justify-center h-screen">
      <div class="bg-white p-6 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold mb-4">Management des Working Times</h1>
  
        <button @click="getWorkingTimesByUserId" class="font-bold py-2 px-4 rounded mb-4 w-full">
          Load Working Times
        </button>

        <div v-if="workingTimes.length">
          <h2 class="text-xl font-bold mb-2">Working Times:</h2>
          <table class="table-auto w-full">
            <thead>
              <tr>
                <th class="px-4 py-2">ID</th>
                <th class="px-4 py-2">Start</th>
                <th class="px-4 py-2">End</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(time, index) in workingTimes" :key="index">
                <td class="border px-4 py-2">{{ time.id }}</td>
                <td class="border px-4 py-2">{{ time.start }}</td>
                <td class="border px-4 py-2">{{ time.end }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-else>
          <p>No working times available.</p>
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
              @click="createWorkingTime({ working_time: { start: startTime, end: endTime } })"
              class="font-bold py-2 px-4 rounded"
            >Create</button>
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
            >Update</button>
        </div>
 
        <div class="flex items-center mb-4">       
          <button 
              @click="deleteWorkingTime()"
              class="font-bold py-2 px-4 rounded mb-4 w-full"
            >Delete
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
  data() {
    return {
      workingTimes: [],
    };
  },
    methods: {
      async getWorkingTimesByUserId() {
        try {
          const response = await fetch(`http://localhost:4000/api/workingtimes/1?start=2022-10-08T09:00:00Z&end=2024-10-08T17:00:00Z`);
          const data = await response.json();
          this.workingTimes = data.data;
          console.log('Working times for user {{this.userId}}:', this.workingTimes);
        } catch (error) {
          console.error('Error getting working time:', error);
        }
      },
      async createWorkingTime(data) {
        try {
          const response = await axios.post(`http://localhost:4000/api/workingtime/1`, data);
          this.getWorkingTimesByUserId();
          console.log('Working time created:', response.data);
        } catch (error) {
          console.error('Error creating working time:', error);
        }
      },
      async updateWorkingTime(data) {
        try {
          const response = await axios.put(`http://localhost:4000/api/workingtime/9`, data);
          this.getWorkingTimesByUserId();
          console.log('Working time updated:', response.data);
        } catch (error) {
          console.error('Error updating working time:', error);
        }
      },
      async deleteWorkingTime() {
        try {
          const response = await axios.put(`http://localhost:4000/api/workingtime/9`);
          this.getWorkingTimesByUserId();
          console.log('Working time deleted:', response.data);
        } catch (error) {
          console.error('Error deleting working time:', error);
        }
      }
    },
    created() {
      this.getWorkingTimesByUserId();
    }
  };
  </script>
  
  <style scoped>
  /* Your component styles here */
  </style>
  