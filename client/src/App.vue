<template>
  <div id="app" class="flex flex-col min-h-screen">
    <header class="flex justify-between items-center w-full p-4 bg-bat-black border-b border-bat-yellow">
    <div class="flex items-center">
      <img src="./assets/logo-de-batman.jpg" alt="Gotham City Logo" class="h-12 mr-4" />
      <h1 class="text-bat-yellow text-2xl font-bold">Gotham City Management</h1>
    </div>
    </header>
    <main class="flex-grow">
      <router-view></router-view> <!-- Affiche le composant correspondant à la route -->
    </main>

    <footer class="bg-bat-black border-t border-bat-yellow text-bat-silver p-4">
    <div class="container mx-auto flex justify-between items-center">
      <p>&copy; 2024 Gotham City Time Management. All rights reserved.</p>
      <div class="flex space-x-4">
        <a href="#" class="hover:text-bat-yellow transition duration-300">Privacy Policy</a>
        <a href="#" class="hover:text-bat-yellow transition duration-300">Terms of Service</a>
        <a href="#" class="hover:text-bat-yellow transition duration-300">Contact</a>
      </div>
    </div>
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
