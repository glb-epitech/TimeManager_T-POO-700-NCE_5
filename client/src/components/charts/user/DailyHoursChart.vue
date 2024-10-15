<template>
    <div>
      <!-- Date picker to select the start of the week -->
      <div class="date-picker">
        <label for="start-date">Select Start Date:</label>
        <input type="date" id="start-date" v-model="selectedStartDate" @change="fetchChartData" />
      </div>
  
      <!-- Chart container -->
      <div class="chart-container">
        <BarChart v-if="chartData" :chart-data="chartData" :options="chartOptions" />
        <p v-else>{{ loadingMessage }}</p>
      </div>
    </div>
  </template>
  
  <script>
    import { defineComponent, ref, onMounted } from "vue";
    import { useRoute } from "vue-router";
    import { BarChart } from "vue-chart-3";
    import axios from "axios";
    import "chart.js/auto";
  
    export default defineComponent({
      components: {
        BarChart,
      },
      setup() {
        const chartData = ref(null);
        const loadingMessage = ref("Loading chart...");
        const chartOptions = ref({
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: "Hours Worked",
              },
            },
            x: {
              title: {
                display: true,
                text: "Days of the Week",
              },
            },
          },
        });
  
        const route = useRoute();
        const userId = ref(route.query.id);
        const selectedStartDate = ref(null); // For the date picker
  
        // Function to fetch chart data
        const fetchChartData = async () => {
          try {
            if (!selectedStartDate.value) {
              loadingMessage.value = "Please select a start date.";
              return;
            }
  
            const startDate = selectedStartDate.value;
            const currentWeekDates = getCurrentWeekDates(startDate); // Get the week's dates based on the selected start date
            const endDate = currentWeekDates[6];  // End date is 6 days after start date
  
            console.log(`Fetching data for user ID: ${userId.value}, from ${startDate} to ${endDate}`);
  
            // Fetch the weekly data from the backend
            const response = await axios.get("http://localhost:4000/api/reports/weekly_hours", {
              params: { user_id: userId.value, start_date: startDate, end_date: endDate },
              headers: { 'Accept': 'application/json' }
            });
  
            console.log("API Response:", response.data);
  
            if (typeof response.data === 'string' && response.data.includes('<!DOCTYPE html>')) {
              throw new Error('Received HTML instead of JSON. Check API endpoint and server configuration.');
            }
  
            const hoursByDay = response.data.hours_by_day || {};
            const labels = currentWeekDates.map(date => formatDateToLabel(date));
  
            const hoursWorked = labels.map((label, index) => {
              const date = currentWeekDates[index]; // Use the ISO format for data lookup
              const hours = hoursByDay[date] || 0;
              return hours;
            });
  
            chartData.value = {
              labels, // Use formatted labels
              datasets: [
                {
                  label: "Hours Worked",
                  backgroundColor: "#42A5F5",
                  data: hoursWorked,
                },
              ],
            };
          } catch (error) {
            console.error("Error fetching chart data:", error);
            loadingMessage.value = "Error loading chart data. Please try again later.";
          }
        };
  
        // Helper function to get dates for the week based on the selected start date
        const getCurrentWeekDates = (startDate) => {
          const start = new Date(startDate);
          const dates = [];
          for (let i = 0; i < 7; i++) {
            const date = new Date(start);
            date.setDate(start.getDate() + i);  // Calculate each date (Monday to Sunday)
            dates.push(date.toISOString().split('T')[0]);  // Format as YYYY-MM-DD
          }
          return dates;
        };
  
        // Helper function to format the date as "MMM DD, YYYY" (e.g., "Oct 15, 2024")
        const formatDateToLabel = (dateString) => {
          const date = new Date(dateString);
          const formatter = new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
          return formatter.format(date);
        };
  
        // When the component mounts, set the initial selected date to today (if needed)
        onMounted(() => {
          const today = new Date().toISOString().split('T')[0]; // Set to today as the default
          selectedStartDate.value = today;
          fetchChartData();  // Fetch the initial data based on today's date
        });
  
        return {
          chartData,
          chartOptions,
          selectedStartDate,
          fetchChartData,
          loadingMessage,
        };
      },
    });
  </script>
  
  <style scoped>
    .date-picker {
      margin-bottom: 20px;
    }
  
    .chart-container {
      width: 100%;
      height: 400px;
    }
  </style>
  







<!-- <template>
  <div class="chart-container">
    <BarChart
      v-if="chartData"
      :chart-data="chartData"
      :options="chartOptions"
    />
    <p v-else>Loading chart...</p>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import { useRoute } from "vue-router"; // To access the query parameters
import { BarChart } from "vue-chart-3";
import axios from "axios";
import "chart.js/auto";

export default defineComponent({
  components: {
    BarChart,
  },
  setup() {
    const chartData = ref(null);
    const chartOptions = ref({
      responsive: true,
      scales: {
        y: {
          beginAtZero: true,
          title: {
            display: true,
            text: "Hours Worked",
          },
        },
        x: {
          title: {
            display: true,
            text: "Days of the Week",
          },
        },
      },
    });

    const route = useRoute(); // Get the route object
    const userId = ref(route.query.id); // Extract the user_id from the URL query parameters

    const fetchChartData = async () => {
      try {
        const currentWeekDates = getCurrentWeekDates(); // Get an array of dates for the current week
        const hoursWorked = [];

        console.log("Current Week Dates:", currentWeekDates); // Check the dates being used for API calls

        // Fetch data for each day of the week
        for (const date of currentWeekDates) {
          const response = await axios.get(`/api/reports/daily_hours`, {
            params: { user_id: userId.value, date },
          });

          console.log(`API response for ${date}:`, response.data); // Log the API response for each day

          // Extract hours worked from API response (assuming response format: { hours_worked: number })
          hoursWorked.push(response.data.hours_worked);
        }

        console.log("Hours Worked Data:", hoursWorked); // Check the hours data

        // Set up chart data
        chartData.value = {
          labels: [
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Sunday",
          ],
          datasets: [
            {
              label: "Hours Worked",
              backgroundColor: "#42A5F5",
              data: hoursWorked, // Add hours worked data for each day
            },
          ],
        };
      } catch (error) {
        console.error("Error fetching chart data:", error);
      }
    };

    // Helper function to get dates for the current week (Monday to Sunday)
    const getCurrentWeekDates = () => {
      const today = new Date();
      const firstDayOfWeek = today.getDate() - today.getDay() + 1; // Get Monday of the current week
      const dates = [];

      for (let i = 0; i < 7; i++) {
        const date = new Date(today.setDate(firstDayOfWeek + i))
          .toISOString()
          .split("T")[0]; // Format as YYYY-MM-DD
        dates.push(date);
      }

      return dates; // Return an array of dates for the current week
    };

    onMounted(() => {
      fetchChartData();
    });

    return {
      chartData,
      chartOptions,
      userId,
    };
  },
});
</script>

<style scoped>
.chart-container {
  width: 100%;
  height: 400px;
  margin-top: 20px;
}
</style> -->
