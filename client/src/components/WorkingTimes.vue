<template>
  <div class="working-times">
    <h2>Working Times for User {{ userId }}</h2>

    <p v-if="loading">Loading...</p>
    <p v-if="errorMessage">{{ errorMessage }}</p>

    <table v-if="workingTimes.length && !loading">
      <thead>
        <tr>
          <th>ID</th>
          <th>Start Time</th>
          <th>End Time</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="time in workingTimes" :key="time.id">
          <td>{{ time.id }}</td>
          <td>{{ formatTime(time.start) }}</td>
          <td>{{ formatTime(time.end) }}</td>
        </tr>
      </tbody>
    </table>

    <p v-else>No working times available.</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "WorkingTimes",
  props: {
    userId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      workingTimes: [],
      loading: true,
      errorMessage: null,
    };
  },
  methods: {
    async getWorkingTimes() {
      this.loading = true;
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtimes/${this.userId}`
        );
        console.log(response);
        this.workingTimes = response.data.data;
        console.log(response.data.data);
      } catch (error) {
        this.errorMessage =
          "Erreur lors de la récupération des heures de travail.";
        console.error(
          "Erreur lors de la récupération des heures de travail :",
          error
        );
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
    this.getWorkingTimes();
    console.log("TOTO");
  },
};
</script>

<style scoped>
.working-times {
  margin: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid #ccc;
  padding: 8px;
  text-align: left;
}

th {
  background-color: #f4f4f4;
}
</style>
