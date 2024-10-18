<template>
  <div class="employee-dashboard bg-bat-black min-h-screen p-6">
    <header class="mb-8">
      <h1 class="text-3xl font-bold text-bat-yellow">Tableau de Bord du Vigilant</h1>
      <p class="text-bat-silver mt-2">Bienvenue, {{ currentUser.username }}</p>
    </header>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Colonne de gauche -->
      <div class="lg:col-span-1 space-y-6">
        <!-- Profil Utilisateur -->
        <div class="bg-bat-gray rounded-lg shadow-bat p-6">
          <h2 class="text-xl font-bold mb-4 text-bat-yellow">Profil du Vigilant</h2>
          <User 
            :user="currentUser" 
            @update-user="updateUserInfo" 
            @delete-account="deleteAccount"
          />
        </div>

        <!-- Gestion du Temps -->
        <div class="bg-bat-gray rounded-lg shadow-bat p-6">
          <h2 class="text-xl font-bold mb-4 text-bat-yellow">Tracker de Patrouille</h2>
          <ClockManager 
            :userId="currentUser.id" 
            @clock-in="clockIn" 
            @clock-out="clockOut"
          />
        </div>
      </div>

      <!-- Colonne centrale et de droite -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Résumé rapide -->
        <div class="bg-bat-blue rounded-lg shadow-bat p-6">
          <h2 class="text-xl font-bold mb-4 text-bat-yellow">Résumé de la Semaine</h2>
          <div class="grid grid-cols-3 gap-4 text-center">
            <div>
              <p class="text-bat-silver">Heures Patrouillées</p>
              <p class="text-2xl font-bold text-white">{{ weeklyHours }}</p>
            </div>
            <div>
              <p class="text-bat-silver">Missions Accomplies</p>
              <p class="text-2xl font-bold text-white">{{ weeklyMissions }}</p>
            </div>
            <div>
              <p class="text-bat-silver">Score de Vigilance</p>
              <p class="text-2xl font-bold text-white">{{ vigilanceScore }}</p>
            </div>
          </div>
        </div>

        <!-- Analyse des Heures -->
        <div class="bg-bat-gray rounded-lg shadow-bat p-6">
          <h2 class="text-xl font-bold mb-4 text-bat-yellow">Analyse des Patrouilles</h2>
          <ChartManager :userId="currentUser.id" />
        </div>

        <!-- Journal de Patrouille -->
        <div class="bg-bat-gray rounded-lg shadow-bat p-6">
          <h2 class="text-xl font-bold mb-4 text-bat-yellow">Journal de Patrouille</h2>
          <WorkingTimes :userId="currentUser.id" />
        </div>
      </div>
    </div>

    <!-- Modal de confirmation pour la suppression du compte -->
    <div v-if="showDeleteConfirmation" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-bat-gray p-6 rounded-lg">
        <h3 class="text-xl font-bold text-bat-yellow mb-4">Confirmer la suppression du compte</h3>
        <p class="text-bat-silver mb-4">Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.</p>
        <div class="flex justify-end space-x-4">
          <button @click="cancelDelete" class="bg-bat-blue text-white px-4 py-2 rounded">Annuler</button>
          <button @click="confirmDelete" class="bg-red-600 text-white px-4 py-2 rounded">Supprimer</button>
        </div>
      </div>
    </div>
  </div>


  <div class="mt-6 bg-bat-gray rounded-lg shadow-bat p-4">
        <h3 class="text-xl font-bold mb-4 text-bat-yellow">Gestionnaire d'équipe</h3>
        <TeamList  />
      </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import User from '@/components/User.vue';
import ClockManager from '@/components/ClockManager.vue';
import WorkingTimes from '@/components/WorkingTimes.vue';
import ChartManager from '@/components/ChartManager.vue';
import api from '@/services/api';
import TeamList from '@/components/TeamList.vue';

const router = useRouter();
const currentUser = ref({});
const weeklyHours = ref(0);
const weeklyMissions = ref(0);
const vigilanceScore = ref(0);
const showDeleteConfirmation = ref(false);

onMounted(async () => {
  await loadUserData();
  await loadDashboardData();
});

const loadUserData = async () => {
  try {
    const response = await api.getCurrentUser();
    currentUser.value = response.data;
  } catch (error) {
    console.error('Erreur lors du chargement des données utilisateur:', error);
    // Gérer l'erreur (par exemple, rediriger vers la page de connexion si non authentifié)
  }
};

const loadDashboardData = async () => {
  try {
    const now = new Date();
    const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay()));
    const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 6));
    
    const weeklyHoursResponse = await api.getWeeklyHours(currentUser.value.id, startOfWeek.toISOString(), endOfWeek.toISOString());
    weeklyHours.value = weeklyHoursResponse.data.total_hours || 0;

    // Pour weeklyMissions et vigilanceScore, nous utiliserons des valeurs simulées
    // car ces endpoints n'existent pas dans l'API actuelle
    weeklyMissions.value = Math.floor(Math.random() * 10) + 5;
    vigilanceScore.value = Math.floor(Math.random() * 50) + 50;
  } catch (error) {
    console.error('Erreur lors du chargement des données du tableau de bord:', error);
  }
};

const updateUserInfo = async (updatedInfo) => {
  try {
    await api.updateUser(currentUser.value.id, updatedInfo);
    await loadUserData(); // Recharger les données de l'utilisateur
  } catch (error) {
    console.error('Erreur lors de la mise à jour des informations utilisateur:', error);
  }
};

const deleteAccount = () => {
  showDeleteConfirmation.value = true;
};

const cancelDelete = () => {
  showDeleteConfirmation.value = false;
};

const confirmDelete = async () => {
  try {
    await api.deleteUser(currentUser.value.id);
    router.push('/login');
  } catch (error) {
    console.error('Erreur lors de la suppression du compte:', error);
  }
};

const clockIn = async () => {
  try {
    await api.postClock(currentUser.value.id, new Date().toISOString(), true);
    await loadDashboardData();
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'heure d\'arrivée:', error);
  }
};

const clockOut = async () => {
  try {
    await api.postClock(currentUser.value.id, new Date().toISOString(), false);
    await loadDashboardData();
  } catch (error) {
    console.error('Erreur lors de l\'enregistrement de l\'heure de départ:', error);
  }
};

// Ces méthodes ne sont plus nécessaires car nous utilisons directement l'API
// dans loadDashboardData, mais nous les gardons au cas où nous aurions besoin
// de les utiliser séparément plus tard
/* const fetchWeeklyHours = async () => {
  const now = new Date();
  const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay()));
  const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 6));
  
  try {
    const response = await api.getWeeklyHours(currentUser.value.id, startOfWeek.toISOString(), endOfWeek.toISOString());
    return response.data.total_hours || 0;
  } catch (error) {
    console.error('Erreur lors de la récupération des heures hebdomadaires:', error);
    return 0;
  }
}; */

/* const fetchWeeklyMissions = async () => {
  // Cette fonctionnalité n'existe pas dans l'API actuelle
  // Vous devrez l'implémenter côté serveur si nécessaire
  return Math.floor(Math.random() * 10) + 5;
}; */

/* const calculateVigilanceScore = async () => {
  // Cette fonctionnalité n'existe pas dans l'API actuelle
  // Vous devrez l'implémenter côté serveur si nécessaire
  return Math.floor(Math.random() * 50) + 50;
}; */
</script>