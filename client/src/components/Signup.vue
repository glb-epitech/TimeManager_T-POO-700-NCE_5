<template>
    <div class="bg-bat-gray rounded-lg shadow-bat p-6 max-w-md mx-auto">
      <h2 id="signup-title" class="text-2xl font-bold mb-6 text-bat-yellow">Rejoindre la Bat-Famille</h2>
      
      <form @submit.prevent="handleSignup" aria-labelledby="signup-title">
        <div class="mb-4">
          <label for="username" class="block text-bat-silver mb-2">Nom de code</label>
          <input
            type="text"
            id="username"
            v-model="username"
            required
            class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
            aria-describedby="username-error"
          >
          <p id="username-error" class="text-red-500 text-sm mt-1" v-if="errors.username">{{ errors.username }}</p>
        </div>
  
        <div class="mb-4">
          <label for="email" class="block text-bat-silver mb-2">Adresse de communication</label>
          <input
            type="email"
            id="email"
            v-model="email"
            required
            class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
            aria-describedby="email-error"
          >
          <p id="email-error" class="text-red-500 text-sm mt-1" v-if="errors.email">{{ errors.email }}</p>
        </div>
        
        <div class="mb-4">
          <label for="password" class="block text-bat-silver mb-2">Code d'accès secret</label>
          <input
            type="password"
            id="password"
            v-model="password"
            required
            class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
            aria-describedby="password-error"
          >
          <p id="password-error" class="text-red-500 text-sm mt-1" v-if="errors.password">{{ errors.password }}</p>
        </div>
        
        <div class="mb-6">
          <label for="confirmPassword" class="block text-bat-silver mb-2">Confirmer le code d'accès</label>
          <input
            type="password"
            id="confirmPassword"
            v-model="confirmPassword"
            required
            class="w-full px-3 py-2 bg-bat-black border border-bat-silver rounded-md text-bat-silver focus:outline-none focus:border-bat-yellow"
            aria-describedby="confirmPassword-error"
          >
          <p id="confirmPassword-error" class="text-red-500 text-sm mt-1" v-if="errors.confirmPassword">{{ errors.confirmPassword }}</p>
        </div>
        
        <button
          type="submit"
          class="bat-button bat-button-yellow w-full"
          :disabled="isLoading"
          aria-busy="isLoading"
        >
          {{ isLoading ? 'Inscription en cours...' : 'Rejoindre' }}
        </button>
      </form>
      
      <p class="mt-4 text-bat-silver text-center">
        Déjà membre ?
        <router-link to="/login" class="text-bat-yellow hover:underline">Se connecter</router-link>
      </p>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Sign-up',
    data() {
      return {
        username: '',
        email: '',
        password: '',
        confirmPassword: '',
        errors: {},
        isLoading: false
      }
    },
    methods: {
      async handleSignup() {
        this.errors = {};
        this.isLoading = true;
        
        // Vérification des mots de passe
        if (this.password !== this.confirmPassword) {
          this.errors.confirmPassword = "Les codes d'accès ne correspondent pas.";
          this.isLoading = false;
          return;
        }
        
        try {
          // Simulons une attente pour l'API
          await new Promise(resolve => setTimeout(resolve, 1000));
          
          // Logique d'inscription ici
          console.log('Tentative d\'inscription avec:', this.username, this.email);
          
          // Redirection après inscription réussie
          this.$router.push('/login');
        } catch (error) {
          this.errors = { general: "Échec de l'inscription. Veuillez réessayer." };
        } finally {
          this.isLoading = false;
        }
      }
    }
  }
  </script>
