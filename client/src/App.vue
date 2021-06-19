<template>
  <v-app>
    <v-app-bar app color="primary" dark>
      <div class="d-flex align-center"></div>
    </v-app-bar>

    <v-main>
      <v-row class="my-5">
        <v-spacer></v-spacer>
        <router-link class="mr-3" :to="{ name: 'Book' }">Libros</router-link>
        <router-link class="mx-3" :to="{ name: 'User' }">Usuarios</router-link>
        <router-link class="ml-3" :to="{ name: 'Loan' }">Prestamos</router-link>
        <v-spacer></v-spacer>
      </v-row>
      <router-view />
    </v-main>
  </v-app>
</template>

<script>
export default {
  name: "App",

  data: () => ({
    //
  }),
};
</script>
