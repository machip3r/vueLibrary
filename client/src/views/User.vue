<template>
  <v-container>
    <v-data-table
      :headers="headers"
      :items="users"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>Usuarios</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn color="warning" @click="nuDialog = true">Nuevo usuario</v-btn>
        </v-toolbar>
      </template>

      <template v-slot:[`item.actions`]="{ item }">
        <v-icon small>
          fas fa-edit
        </v-icon>

        <v-icon small @click="deleteUser(item)">
          fas fa-trash
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="nuDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <h3>Nuevo usuario</h3>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="6">
                <v-text-field
                  label="Nombre(s)"
                  v-model="newUser.u_name"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  label="Apellido Paterno"
                  v-model="newUser.u_last_name"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="6">
                <v-text-field
                  label="Apellido Materno"
                  v-model="newUser.u_m_last_name"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  label="Correo Electrónico"
                  v-model="newUser.u_email"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="cancelAddUser()"
            >Cancelar</v-btn
          >
          <v-btn color="green darken-1" text @click="addUser()">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  name: "Usuario",

  data() {
    return {
      headers: [
        { text: "ID", align: "center", sortable: false, value: "id_user" },
        { text: "Nombre(s)", align: "center", value: "u_name" },
        { text: "Apellido Paterno", align: "center", value: "u_last_name" },
        { text: "Apellido Materno", align: "center", value: "u_m_last_name" },
        { text: "Correo Electrónico", align: "center", value: "u_email" },
        { text: "Estado", align: "center", value: "u_status" },
        { text: "Acciones", align: "center", value: "actions" },
      ],
      users: [],
      newUser: {
        u_name: "",
        u_last_name: "",
        u_m_last_name: "",
        u_email: "",
        /* u_status: "", */
      },
      nuDialog: false,
    };
  },

  watch: {
    nuDialog(isOpen) {
      if (!isOpen) this.newUser = {};
    },
  },

  created() {
    this.getUsers();
  },

  methods: {
    async getUsers() {
      const apiData = await this.axios.get("users/allUsers/");
      this.users = apiData.data;
    },

    async deleteUser(item) {
      const body = { id_user: item.id_user };
      await this.axios.post("users/deleteUser/", body);

      this.getUsers();
    },

    cancelAddUser() {
      this.newUser = {};
      this.nuDialog = false;
    },

    async addUser() {
      await this.axios.post("users/addUser/", this.newUser);

      this.getUsers();
      this.cancelAddUser();
    },
  },

  components: {},
};
</script>
