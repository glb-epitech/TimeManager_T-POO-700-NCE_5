<template>
    <div>
        <button @click="createWorkingTime({ startTime: '09:00', endTime: '17:00' })">Create Working Time</button>
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
          const response = await axios.post(`/workingTime/${userId}`, data);
          console.log('Working time created:', response.data);
        } catch (error) {
          console.error('Error creating working time:', error);
        }
      },
      async updateWorkingTime(data) {
        try {
          const response = await axios.put(`/workingTime/${userId}/${this.workingTimeId}`, data);
          console.log('Working time updated:', response.data);
        } catch (error) {
          console.error('Error updating working time:', error);
        }
      },
      async deleteWorkingTime() {
        try {
          const response = await axios.delete(`/workingTime/${this.userId}/${this.workingTimeId}`);
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
  