<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Analytique du Vigilant de Gotham - Utilisateur {{ userId }}</h2>

    <div v-if="loading" class="text-center py-4">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
      <p class="mt-2 text-bat-silver">Accès au Bat-Ordinateur en cours...</p>
    </div>

    <div v-else-if="errorMessage" class="bg-red-900 border-l-4 border-bat-yellow text-bat-silver p-4 mb-4" role="alert">
      <p class="font-bold">Alerte</p>
      <p>{{ errorMessage }}</p>
    </div>

    <div v-else-if="!chartData.datasets.length" class="text-center py-4 text-bat-silver">
      Aucune donnée de patrouille disponible pour ce vigilant.
    </div>

    <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="bg-bat-black p-4 rounded-lg shadow-inner" style="height: 400px;">
        <h3 class="text-xl font-bold mb-4 text-bat-yellow">Répartition du Temps de Patrouille</h3>
        <Pie :data="chartData" :options="chartOptions" />
      </div>
    </div>

    <button @click="fetchData" class="mt-4 bg-bat-blue text-white py-2 px-4 rounded hover:bg-bat-blue-dark">
      Actualiser les Données
    </button>
  </div>
</template>
  
  <script>
  import { ref, onMounted, computed } from 'vue';
  import axios from 'axios';
  import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js'
  import { Pie } from 'vue-chartjs'
  
  ChartJS.register(ArcElement, Tooltip, Legend)
  
  export default {
    name: 'ChartManager',
    components: { Pie },
    props: {
      userId: {
        type: String,
        required: true,
      },
    },
    setup(props) {
      const loading = ref(true);
      const errorMessage = ref(null);
      const workingTimes = ref([]);
      const timeDistributionData = ref(null);
  
      const batColors = {
        yellow: '#FFFF00',
        silver: '#C0C0C0',
        black: '#0A0A0A',
      };
  
      const chartOptions = {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            labels: {
              color: batColors.silver,
            },
          },
          tooltip: {
            callbacks: {
              label: (context) => {
                const label = context.label || '';
                const value = context.raw || 0;
                const total = context.chart.data.datasets[0].data.reduce((a, b) => a + b, 0);
                const percentage = ((value / total) * 100).toFixed(1);
                return `${label}: ${percentage}% (${formatDuration(value)})`;
              },
            },
          },
        },
      };
  
      const formatDuration = (minutes) => {
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return `${hours}h ${mins}m`;
      };
  
      const fetchData = async () => {
        loading.value = true;
        errorMessage.value = null;
        try {
          const response = await axios.get(`http://localhost:4000/api/workingtimes/${props.userId}`);
          workingTimes.value = response.data.data;
          processChartData();
        } catch (error) {
          errorMessage.value = "Error accessing Bat-Computer. Try again.";
          console.error("Error retrieving working times:", error);
        } finally {
          loading.value = false;
        }
      };
  
      const processChartData = () => {
        const timeData = workingTimes.value.map(time => {
          const start = new Date(time.start);
          const end = new Date(time.end);
          return (end - start) / (1000 * 60); // duration in minutes
        });
  
        timeDistributionData.value = {
          labels: workingTimes.value.map((_, index) => `Patrol ${index + 1}`),
          datasets: [{
            data: timeData,
            backgroundColor: Object.values(batColors),
          }],
        };
      };
  
      onMounted(fetchData);
  
      const chartData = computed(() => ({
        labels: timeDistributionData.value ? timeDistributionData.value.labels : [],
        datasets: timeDistributionData.value ? timeDistributionData.value.datasets : []
      }));
  
      return {
        loading,
        errorMessage,
        chartData,
        chartOptions,
        fetchData,
      };
    },
  };
  </script>