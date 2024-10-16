<template>
    <div class="bg-bat-gray rounded-lg shadow-bat p-6 max-w-md mx-auto">
      <h2 id="login-title" class="text-2xl font-bold mb-6 text-bat-yellow">Accès au Bat-Ordinateur</h2>
      
      <form @submit.prevent="handleLogin" aria-labelledby="login-title">
        <div class="mb-4">
          <label for="email" class="block text-bat-silver mb-2">Identifiant</label>
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
        
        <div class="mb-6">
          <label for="password" class="block text-bat-silver mb-2">Code d'accès</label>
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
        
        <button
          type="submit"
          class="bat-button bat-button-yellow w-full"
          :disabled="isLoading"
          aria-busy="isLoading"
        >
          {{ isLoading ? 'Connexion en cours...' : 'Se connecter' }}
        </button>
      </form>
      
      <p class="mt-4 text-bat-silver text-center">
        Pas encore de compte ?
        <router-link to="/signup" class="text-bat-yellow hover:underline">S'inscrire</router-link>
      </p>
    </div>
  </template>
  
  <script>
  export default {
    name: 'Log-in',
    data() {
      return {
        email: '',
        password: '',
        errors: {},
        isLoading: false
      }
    },
    methods: {
      async handleLogin() {
        this.errors = {};
        this.isLoading = true;
        
        // Ici, vous implémenteriez la logique de connexion
        // Par exemple, en utilisant une API ou un service d'authentification
        
        try {
          // Simulons une attente pour l'API
          await new Promise(resolve => setTimeout(resolve, 1000));
          
          // Logique de connexion ici
          console.log('Tentative de connexion avec:', this.email);
          
          // Redirection après connexion réussie
          this.$router.push('/dashboard');
        } catch (error) {
          this.errors = { general: "Échec de la connexion. Veuillez réessayer." };
        } finally {
          this.isLoading = false;
        }
      }
    }
  }
  </script>