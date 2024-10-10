<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">
      Gotham Citizens Database
    </h2>

    <!-- Input Fields -->
    <div class="space-y-4 mb-6">
      <div>
        <label
          for="userName"
          class="block text-sm font-medium text-bat-silver mb-1"
          >Alias:</label
        >
        <input
          type="text"
          v-model="userName"
          id="userName"
          placeholder="Enter citizen's alias"
          class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
        />
      </div>

      <div>
        <label
          for="userEmail"
          class="block text-sm font-medium text-bat-silver mb-1"
          >Communication Channel:</label
        >
        <input
          type="email"
          v-model="userEmail"
          id="userEmail"
          placeholder="Enter secure email"
          class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
        />
      </div>

      <div>
        <label
          for="userId"
          class="block text-sm font-medium text-bat-silver mb-1"
          >Identification Code:</label
        >
        <input
          type="text"
          v-model="userId"
          id="userId"
          placeholder="Enter unique ID"
          class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
        />
      </div>
    </div>

    <!-- Action Buttons -->
    <div class="grid grid-cols-2 gap-4 mb-6">
      <button @click="createUser" class="bat-button bg-bat-blue">
        Register Citizen
      </button>
      <button
        @click="getAllUsers"
        class="bat-button bg-bat-yellow text-bat-black"
      >
        View All Citizens
      </button>
      <button @click="getUser" class="bat-button bg-bat-silver text-bat-black">
        Locate Citizen
      </button>
      <button @click="updateUser" class="bat-button bg-bat-blue">
        Update Records
      </button>
      <button @click="deleteUser" class="bat-button bg-red-600 col-span-2">
        Expunge Records
      </button>
    </div>

    <!-- User Info Display -->
    <div
      v-if="userData"
      class="mt-6 p-4 bg-bat-black rounded-lg border border-bat-yellow"
    >
      <h3 class="text-lg font-semibold mb-2 text-bat-yellow">
        Citizen Profile
      </h3>
      <p class="text-bat-silver">
        <strong class="text-bat-blue">ID:</strong> {{ userData.data.id }}
      </p>
      <p class="text-bat-silver">
        <strong class="text-bat-blue">Alias:</strong>
        {{ userData.data.username }}
      </p>
      <p class="text-bat-silver">
        <strong class="text-bat-blue">Channel:</strong>
        {{ userData.data.email }}
      </p>
    </div>

    <!-- All Users Display -->
    <div v-if="users.data && users.data.length" class="mt-6">
      <h3 class="text-lg font-semibold mb-2 text-bat-yellow">
        Gotham Citizens Registry
      </h3>
      <ul class="bg-bat-black rounded-lg divide-y divide-bat-gray">
        <li
          v-for="user in users.data"
          :key="user.id"
          class="px-4 py-3 text-bat-silver"
        >
          {{ user.id }} - {{ user.username }} - {{ user.email }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      userName: "",
      userEmail: "",
      userId: "", // This will be used to get or delete a specific user
      userData: null, // To store a single user's data
      users: [], // To store all users when calling getAllUsers
    };
  },
  //   mounted() {
  //     // Automatically fetch all users when the component is mounted
  //     this.getAllUsers();
  //   },
  methods: {
    async createUser() {
      try {
        // Clear the list of users
        this.users = []

        const response = await axios.post(`http://localhost:4000/api/users`, {
          user: {
            username: this.userName,
            email: this.userEmail,
          },
        });
        this.userData = response.data;
        alert("User created successfully");
      } catch (error) {
        this.handleError(error, "creating user");
      }
    },
    async getUser() {
      try {
        if (this.userName && this.userEmail) {
          // Fetch user data by username and email
          const response = await axios.get(
            `http://localhost:4000/api/users/user`,
            {
              params: {
                username: this.userName,
                email: this.userEmail,
              },
            }
          );
          this.userData = response.data;
          
          // Add query params to the URL for userId
          this.$router.push({
            path: "/",
            query: {
                id: this.userData.data.id
            },
          });
        } else if (this.userId) {
          // Add query params to the URL for userId
          this.$router.push({
            path: "/",
            query: {
              id: this.userId,
            },
          });

          // Fetch user data by userId
          const response = await axios.get(
            `http://localhost:4000/api/users/${this.userId}`
          );
          this.userData = response.data;
        } else {
          // Handle missing input
          alert("Please provide either username & email or user ID.");
        }
      } catch (error) {
        this.handleError(error, "getting user");
      }
    },
    async getAllUsers() {
      try {
        // Clear the individual user
        this.userData = null;

        const response = await axios.get(`http://localhost:4000/api/users`);
        this.users = response.data;
        console.log(this.users);
        alert("Get all users successful");
      } catch (error) {
        this.handleError(error, "getting all users");
      }
    },
    async updateUser() {
      try {
        const response = await axios.put(
          `http://localhost:4000/api/users/${this.userId}`,
          {
            user: {
              username: this.userName,
              email: this.userEmail,
            },
          }
        );
        this.userData = response.data;
        alert("User updated successfully");
      } catch (error) {
        this.handleError(error, "updating user");
      }
    },
    async deleteUser() {
      try {
        await axios.delete(`http://localhost:4000/api/users/${this.userId}`);
        this.userData = null; // Clear the data after deletion
        alert("User deleted successfully");
      } catch (error) {
        this.handleError(error, "deleting user");
      }
    },
    handleError(error, action) {
      if (error.response) {
        const status = error.response.status;
        const message =
          error.response.data.message || error.response.statusText;
        alert(`Error ${status}: ${message} while ${action}`);
      } else if (error.request) {
        alert(
          `No response received from server while ${action}. Please check your network or try again later.`
        );
      } else {
        alert(`Error while ${action}: ${error.message}`);
      }
    },
  },
};
</script>
