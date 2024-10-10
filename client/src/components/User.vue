<!-- eslint-disable vue/multi-word-component-names -->
<template>
    <div class="user-container">
        <!-- Card for Input Fields and Buttons -->
        <div class="card left-card">
            <label for="userName">Name:</label>
            <input type="text" v-model="userName" placeholder="Enter user name" />
    
            <label for="userEmail">Email:</label>
            <input type="email" v-model="userEmail" placeholder="Enter user email" />

            <label for="userId">Id:</label>
            <input type="id" v-model="userId" placeholder="Enter user id" />
    
            <button class="create" @click="createUser">Create User</button>
            <button class="getAll" @click="getAllUsers">Get All Users</button>
            <button class="get" @click="getUser">Get User</button>
            <button class="update" @click="updateUser">Update User</button>
            <button class="delete" @click="deleteUser">Delete User</button>
        </div>
    
        <!-- Card for User Info -->
        <div class="card right-card" v-if="userData">
            <h2>User Info</h2>
            <p><strong>ID:</strong> {{ userData.data.id }}</p>
            <p><strong>Name:</strong> {{ userData.data.username }}</p>
            <p><strong>Email:</strong> {{ userData.data.email }}</p>
        </div>

        <!-- Display All Users -->
        <div class="card" v-if="users.data">
            <h2>All Users</h2>
            <ul>
                <li v-for="user in users.data" :key="user.id">
                    {{ user.id }} - {{ user.username }} - {{ user.email }}
                </li>
            </ul>
        </div>
    </div>
</template> 
  
<script>
import axios from 'axios';

export default {
  data() {
    return {
      userName: '',
      userEmail: '',
      userId: '', // This will be used to get or delete a specific user
      userData: null, // To store a single user's data
      users: [] // To store all users when calling getAllUsers
    };
  },
//   mounted() {
//     // Automatically fetch all users when the component is mounted
//     this.getAllUsers();
//   },
  methods: {
    async createUser() {
      try {
        const response = await axios.post(`http://localhost:4000/api/users`, {
          user: {
            username: this.userName,
            email: this.userEmail,
          },
        });
        this.userData = response.data;
        alert('User created successfully');
      } catch (error) {
        this.handleError(error, 'creating user');
      }
    },
    async getUser() {
      try {
        const response = await axios.get(`http://localhost:4000/api/users/${this.userId}`);
        this.userData = response.data;
      } catch (error) {
        this.handleError(error, 'getting user');
      }
    },
    async getAllUsers() {
      try {
        const response = await axios.get(`http://localhost:4000/api/users`);
        this.users = response.data; 
        console.log(this.users); 
        alert('Get all users successful');
      } catch (error) {
        this.handleError(error, 'getting all users');
      }
    },
    async updateUser() {
      try {
        const response = await axios.put(`http://localhost:4000/api/users/${this.userId}`, {
            user: {
                username: this.userName,
                email: this.userEmail,
            }
        });
        this.userData = response.data;
        alert('User updated successfully');
      } catch (error) {
        this.handleError(error, 'updating user');
      }
    },
    async deleteUser() {
      try {
        await axios.delete(`http://localhost:4000/api/users/${this.userId}`);
        this.userData = null; // Clear the data after deletion
        alert('User deleted successfully');
      } catch (error) {
        this.handleError(error, 'deleting user');
      }
    },
    handleError(error, action) {
      if (error.response) {
        const status = error.response.status;
        const message = error.response.data.message || error.response.statusText;
        alert(`Error ${status}: ${message} while ${action}`);
      } else if (error.request) {
        alert(`No response received from server while ${action}. Please check your network or try again later.`);
      } else {
        alert(`Error while ${action}: ${error.message}`);
      }
    }
  }
};
</script>

