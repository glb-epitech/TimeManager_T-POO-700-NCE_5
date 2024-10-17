Linechart


<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-1xl font-bold mb-6 text-bat-yellow">Daily Hours Chart</h2>

    <!-- Date picker to select the start of the week -->
    <div class="date-picker">
      <label for="start-date" class="block text-sm font-medium text-bat-silver mb-1">Select Start Date:</label>
      <input
        type="date"
        id="start-date"
        v-model="selectedStartDate"
        @change="fetchChartData"
        class="px-3 py-2 bg-bat-gray border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
      />
    </div>

    <!-- Chart container -->
    <div class="chart-container">
      <LineChart v-if="chartData" :chart-data="chartData" :options="chartOptions" />
      <p v-else>{{ loadingMessage }}</p>
    </div>

    <!-- Total hours worked for the week -->
    <div v-if="totalHours !== null" class="total-hours">
      <p>Total hours worked for the week: <strong>{{ totalHours }}</strong></p>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { LineChart } from "vue-chart-3";
import axios from "axios";
import "chart.js/auto";

export default defineComponent({
  components: {
    LineChart,
  },
  setup() {
    const chartData = ref(null);
    const loadingMessage = ref("Loading chart...");
    const totalHours = ref(null); // For holding the total hours worked for the week
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
    const workingTimes = ref([]); // To store the working times fetched from the new API
    const weeklyHours = ref([]); // To store the weekly_hours data
    const totalWorkingHours = ref(0); // Total hours from workingTimes
    const totalReportedHours = ref(0); // Total hours from weekly_hours

    // Function to fetch data from both APIs
    const fetchChartData = async () => {
      if (!selectedStartDate.value || !userId.value) {
        loadingMessage.value = "Please select a start date and user.";
        return;
      }

      const startDate = selectedStartDate.value;
      const currentWeekDates = getCurrentWeekDates(startDate);
      const endDate = currentWeekDates[6];

      await fetchWorkingTimesData(); // Fetch data from workingTimes API
      await fetchWeeklyHoursData(startDate, endDate); // Fetch data from weekly_hours API

      processChartData(currentWeekDates); // Process both data sets
    };

    // Fetch data from workingTimes API
    const fetchWorkingTimesData = async () => {
      try {
        const response = await axios.get(`http://localhost:4000/api/clocks/${userId.value}`);
        console.log("WorkingTimes API response:", response.data);
        workingTimes.value = response.data.data;
      } catch (error) {
        console.error("Error fetching workingTimes:", error);
        loadingMessage.value = "Error fetching working times.";
      }
    };

    // Fetch data from weekly_hours API
    const fetchWeeklyHoursData = async (startDate, endDate) => {
      try {
        const response = await axios.get("http://localhost:4000/api/reports/weekly_hours", {
          params: { user_id: userId.value, start_date: startDate, end_date: endDate },
          headers: { Accept: "application/json" },
        });
        console.log("WeeklyHours API response:", response.data);
        weeklyHours.value = response.data.hours_by_day;
      } catch (error) {
        console.error("Error fetching weekly_hours:", error);
        loadingMessage.value = "Error fetching weekly hours.";
      }
    };

    const processChartData = (currentWeekDates) => {
  const labels = currentWeekDates.map((date) => formatDateToLabel(date));
  const workingHoursByDay = {};

  // Vérifiez que les données de workingTimes.value sont correctes
  console.log('Working Times:', workingTimes.value);

  let startTime = null;

  workingTimes.value.sort((a, b) => new Date(a.time) - new Date(b.time));

workingTimes.value.forEach((entry) => {
  const dateKey = entry.time.split("T")[0];
  const entryTime = new Date(entry.time).getTime();

  if (entry.status === true) {
    startTime = entryTime;
    console.log(`Début de la période pour ${dateKey}: ${new Date(startTime).toISOString()}`);
  } else if (entry.status === false && startTime !== null && entryTime > startTime) {
    const duration = (entryTime - startTime) / (1000 * 60 * 60); // Durée en heures
    workingHoursByDay[dateKey] = (workingHoursByDay[dateKey] || 0) + duration;
    console.log(`Fin de la période. Durée pour ${dateKey}: ${duration}, Total: ${workingHoursByDay[dateKey]}`);
    startTime = null; // Réinitialiser après calcul
  } else {
    console.warn(`Durée ignorée pour ${dateKey} à cause de données incohérentes.`);
  }
  });

  const workingTimesData = labels.map((label) => {
    const date = label.split(", ")[1]; 
    return (workingHoursByDay[date] || 0); // Retourner les heures ou 0 si non trouvé
  });

  // Process weekly_hours data
  const weeklyHoursData = labels.map((label, index) => {
    const date = currentWeekDates[index]; 
    return (weeklyHours.value[date] || 0); 
  });

  // Calculez le total pour les deux datasets
  totalWorkingHours.value = workingTimesData.reduce((total, hours) => total + hours, 0);
  totalReportedHours.value = weeklyHoursData.reduce((total, hours) => total + hours, 0);

  // Combinez les datasets dans les données du graphique
  chartData.value = {
    labels,
    datasets: [
      {
        label: "Clock Times",
        backgroundColor: "rgba(66, 165, 245, 0.5)",
        borderColor: "#42A5F5",
        fill: false,
        data: workingTimesData,
      },
      {
        label: "Reported Weekly Hours",
        backgroundColor: "rgba(102, 187, 106, 0.5)",
        borderColor: "#66BB6A",
        fill: false,
        data: weeklyHoursData,
      },
    ],
  };

  totalHours.value = totalWorkingHours.value + totalReportedHours.value;
};




    // Helper function to get dates for the week based on the selected start date
    const getCurrentWeekDates = (startDate) => {
      const start = new Date(startDate);
      const dates = [];
      for (let i = 0; i < 7; i++) {
        const date = new Date(start);
        date.setDate(start.getDate() + i); // Calculate each date (Monday to Sunday)
        dates.push(date.toISOString().split("T")[0]); // Format as YYYY-MM-DD
      }
      return dates;
    };

    // Helper function to format the date as "MMM DD, YYYY" (e.g., "Oct 15, 2024")
    const formatDateToLabel = (dateString) => {
      const date = new Date(dateString);
      const formatter = new Intl.DateTimeFormat("en-US", { month: "short", day: "numeric", year: "numeric" });
      return formatter.format(date);
    };

    // When the component mounts, set the initial selected date to today and fetch data
    onMounted(() => {
      const today = new Date().toISOString().split("T")[0]; // Set to today as the default
      selectedStartDate.value = today;
      fetchChartData(); // Fetch the initial data based on today's date
    });

    return {
      chartData,
      chartOptions,
      selectedStartDate,
      fetchChartData,
      loadingMessage,
      totalHours,
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

.total-hours {
  margin-top: 20px;
  font-size: 16px;
}
</style>

