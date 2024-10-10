
<template>
  <div id="app" class="flex flex-col min-h-screen">
    <header class="flex justify-between items-center w-full p-4 bg-gray-800 text-white">
      <img src="./assets/logo.png" alt="Logo" class="logo h-12" />
      <nav>
        <router-link to="/" class="p-2 hover:bg-gray-700 rounded">Home</router-link>
        <router-link to="/clock" class="p-2 hover:bg-gray-700 rounded">Clock Manager</router-link>
        <router-link to="/workingtimes" class="p-2 hover:bg-gray-700 rounded">workingTimes</router-link>
      </nav>
    </header>
    <main class="flex-grow">
      <router-view></router-view> <!-- Affiche le composant correspondant à la route -->
    </main>
    <footer class="bg-gray-800 text-white text-center p-4">
      <p>&copy; 2024 Time Manager. Tous droits réservés.</p>
    </footer>
  </div>
</template>

<script setup>
</script>

<style scoped>
.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
