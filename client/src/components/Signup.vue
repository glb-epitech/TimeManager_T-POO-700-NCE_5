<template>
  <div class="min-h-screen flex items-center justify-center bg-bat-black py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8 bg-bat-dark-gray rounded-lg p-8">
      <div>
        <img class="mx-auto h-24 w-auto" src="../assets/pngegg.png" alt="Logo Batman">
        <h2 class="mt-6 text-center text-3xl font-bold text-bat-yellow">Rejoindre la Bat-Famille</h2>
      </div>
      
      <form @submit.prevent="handleSignup" class="mt-8 space-y-6">
        <div class="rounded-md shadow-sm -space-y-px">
          <div>
            <label for="username" class="block text-bat-silver mb-2">Nom de code</label>
            <input
              type="text"
              id="username"
              v-model="username"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-bat-gray bg-bat-input text-bat-silver placeholder-bat-gray focus:outline-none focus:ring-bat-yellow focus:border-bat-yellow"
              placeholder="Entrez votre nom de code"
            >
          </div>
          <div class="mt-4">
            <label for="email" class="block text-bat-silver mb-2">Adresse de communication</label>
            <input
              type="email"
              id="email"
              v-model="email"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-bat-gray bg-bat-input text-bat-silver placeholder-bat-gray focus:outline-none focus:ring-bat-yellow focus:border-bat-yellow"
              placeholder="Entrez votre email"
            >
          </div>
          <div class="mt-4">
            <label for="password" class="block text-bat-silver mb-2">Code d'accès secret</label>
            <input
              type="password"
              id="password"
              v-model="password"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-bat-gray bg-bat-input text-bat-silver placeholder-bat-gray focus:outline-none focus:ring-bat-yellow focus:border-bat-yellow"
              placeholder="Entrez votre mot de passe"
            >
          </div>
          <div class="mt-4">
            <label for="confirmPassword" class="block text-bat-silver mb-2">Confirmer le code d'accès</label>
            <input
              type="password"
              id="confirmPassword"
              v-model="confirmPassword"
              required
              class="appearance-none rounded-md relative block w-full px-3 py-2 border border-bat-gray bg-bat-input text-bat-silver placeholder-bat-gray focus:outline-none focus:ring-bat-yellow focus:border-bat-yellow"
              placeholder="Confirmez votre mot de passe"
            >
          </div>
        </div>

        <div>
          <button
            type="submit"
            class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-bat-black bg-bat-yellow hover:bg-bat-yellow-light focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-bat-yellow"
            :disabled="isLoading"
          >
            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
              <svg class="h-5 w-5 text-bat-yellow-dark group-hover:text-bat-yellow-light" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
              </svg>
            </span>
            {{ isLoading ? 'Inscription en cours...' : 'Rejoindre' }}
          </button>
        </div>
      </form>
      
      <p class="mt-2 text-center text-sm text-bat-silver">
        Déjà membre ?
        <router-link to="/login" class="font-medium text-bat-yellow hover:text-bat-yellow-light">
          Se connecter
        </router-link>
      </p>
    </div>
  </div>
</template>

<style scoped>
.bg-bat-dark-gray {
  background-color: #1a1a1a;
}
.bg-bat-input {
  background-color: #333333;
}
</style>
  
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
