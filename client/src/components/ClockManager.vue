<template>
  <div class="bg-bat-gray rounded-lg shadow-bat p-6">
    <h2 class="text-2xl font-bold mb-6 text-bat-yellow">Gotham Time Tracker</h2>
    
    <div class="mb-6">
      <p v-if="clockIn" class="text-bat-blue font-semibold">
        Vigilance active depuis : <span class="text-bat-yellow">{{ startDateTime }}</span>
      </p>
      <p v-else class="text-bat-silver">Aucune patrouille en cours.</p>
    </div>

    <button
      @click="clock"
      :disabled="loading"
      :class="[
        clockIn ? 'bg-bat-blue' : 'bg-bat-yellow',
        'text-bat-black font-bold py-3 px-6 rounded-full shadow-bat hover:opacity-90 transition duration-300 w-full mb-4',
        loading ? 'opacity-50 cursor-not-allowed' : ''
      ]"
    >
      {{ clockIn ? 'Terminer la patrouille' : 'Débuter la patrouille' }}
    </button>

    <button
      @click="refresh"
      :disabled="loading"
      :class="loading ? 'opacity-50 cursor-not-allowed' : ''"
      class="bg-bat-gray border border-bat-yellow text-bat-yellow font-bold py-3 px-6 rounded-full shadow-bat hover:bg-bat-yellow hover:text-bat-black transition duration-300 w-full"
    >
      Actualiser le statut
    </button>

    <div v-if="loading" class="mt-4 text-center">
      <div class="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-bat-yellow"></div>
    </div>
  </div>
</template>


<script>
import api from '@/services/api';

export default {
  data() {
    return {
      clockIn: false,
      startDateTime: null,
      loading: false,
      userId: null
       // Remplacez par l'ID de l'utilisateur actuel ou récupérez-le dynamiquement
    };
  },
  methods: {
    async refresh() {
      this.loading = true;
      try {
        const response = await api.getClocks(this.userId);
        if (response.data && response.data.length > 0) {
          const lastClock = response.data[response.data.length - 1];
          this.clockIn = lastClock.status === 'false'; // 'false' indique que l'utilisateur est en train de travailler
          this.startDateTime = this.clockIn ? new Date(lastClock.time).toLocaleString() : null;
        } else {
          this.clockIn = false;
          this.startDateTime = null;
        }
        console.log('État rafraîchi');
      } catch (error) {
        console.error('Erreur lors du rafraîchissement:', error);
      } finally {
        this.loading = false;
      }
    },

    async clock() {
      this.loading = true;
      try {
        const newStatus = !this.clockIn;
        const response = await api.postClock(this.userId, new Date().toISOString(), newStatus);
        console.log(response.data);
        this.clockIn = newStatus;
        this.startDateTime = newStatus ? new Date().toLocaleString() : null;
        console.log(newStatus ? 'Début du travail' : 'Arrêt du travail');
      } catch (error) {
        console.error('Erreur lors du changement d\'état:', error);
      } finally {
        this.loading = false;
      }
    }
  },
  mounted() {
    this.refresh(); // Charger l'état initial au montage du composant
    this.userId = this.$route.query.id;
    console.log("User ID from URL:", this.userId);
    this.getWorkingTimes();
  }
};
</script>
```

Voici les principales modifications apportées :

1. Intégration de l'API :
   - Les méthodes `refresh()` et `clock()` utilisent maintenant les fonctions du service API que vous avez défini.

2. Gestion asynchrone :
   - Les méthodes sont maintenant asynchrones (`async`) et utilisent `await` pour les appels API.

3. Gestion des erreurs :
   - Ajout de blocs try/catch pour gérer les erreurs potentielles lors des appels API.

4. État de chargement :
   - Ajout d'un état `loading` pour désactiver les boutons pendant les appels API.

5. Initialisation au montage :
   - Ajout d'un appel à `refresh()` dans le hook `mounted` pour charger l'état initial.

6. Adaptation à la structure de données de l'API :
   - La méthode `refresh()` interprète maintenant les données renvoyées par l'API pour déterminer l'état de travail actuel.

7. Gestion de l'ID utilisateur :
   - Ajout d'une propriété `userId` dans les données du composant. Vous devrez adapter cela pour récupérer l'ID de l'utilisateur actuel de manière appropriée dans votre application.

Pour que ce composant fonctionne correctement, assurez-vous que :

1. Le service API est correctement importé et configuré.
2. L'ID de l'utilisateur est correctement défini ou récupéré.
3. Les réponses de l'API correspondent à la structure attendue par le composant.

N'oubliez pas d'adapter la gestion des erreurs et les messages utilisateur selon vos besoins spécifiques. Vous pourriez par exemple ajouter des notifications pour informer l'utilisateur du succès ou de l'échec des opérations.