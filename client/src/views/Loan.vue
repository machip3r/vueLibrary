<template>
  <v-container>
    <v-data-table
      :headers="headers"
      :items="loans"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>Préstamos</v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn color="warning" @click="nlDialog = true">Nuevo préstamo</v-btn>
        </v-toolbar>
      </template>

      <template v-slot:[`item.actions`]="{ item }">
        <v-icon small @click="openLDetailsDialog(item)">
          fas fa-plus
        </v-icon>
        <v-icon small class="mx-3" @click="showLoanDetails(item)">
          fas fa-eye
        </v-icon>
        <v-icon small @click="deleteLoan(item)">
          fas fa-trash
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="nlDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <h3>Nuevo préstamo</h3>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="6">
                <v-select
                  :items="users"
                  v-model="newLoan.id_user"
                  label="Selecciona un usuario"
                >
                </v-select>
              </v-col>
              <v-col cols="6">
                <v-menu
                  v-model="menuLDate"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="newLoan.l_date"
                      label="Fecha del préstamo"
                      prepend-icon="fas fa-calendar-alt"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="newLoan.l_date"
                    @input="menuLDate = false"
                  ></v-date-picker>
                </v-menu>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="6">
                <v-menu
                  v-model="menuLReturnDate"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="newLoan.l_return_date"
                      label="Fecha de entrega"
                      prepend-icon="fas fa-calendar-alt"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="newLoan.l_return_date"
                    @input="menuLReturnDate = false"
                  ></v-date-picker>
                </v-menu>
              </v-col>
              <v-col cols="6">
                <v-menu
                  v-model="menuLRealReturnDate"
                  :close-on-content-click="false"
                  :nudge-right="40"
                  transition="scale-transition"
                  offset-y
                  min-width="auto"
                >
                  <template v-slot:activator="{ on, attrs }">
                    <v-text-field
                      v-model="newLoan.l_real_return_date"
                      label="Fecha de entrega real"
                      prepend-icon="fas fa-calendar-alt"
                      readonly
                      v-bind="attrs"
                      v-on="on"
                    ></v-text-field>
                  </template>
                  <v-date-picker
                    v-model="newLoan.l_real_return_date"
                    @input="menuLRealReturnDate = false"
                  ></v-date-picker>
                </v-menu>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="cancelAddLoan()">
            Cancelar
          </v-btn>
          <v-btn color="green darken-1" text @click="addLoan()">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="nldDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <h3>Libros</h3>
          <v-spacer></v-spacer>
          <v-btn color="warning" @click="addBookRow()">Agregar libro</v-btn>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row v-for="(book, index) in lDetails" v-bind:key="index">
              <v-col cols="12">
                <v-select
                  :items="books"
                  v-model="book.id_book"
                  label="Selecciona un libro"
                >
                </v-select>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="cancelAddLDBooks()">
            Cancelar
          </v-btn>
          <v-btn color="green darken-1" text @click="addLDBooks()">
            Guardar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-dialog v-model="ldDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <h3>Libros del préstamo</h3>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row v-for="(book, index) in booksLoan" v-bind:key="index">
              <v-col cols="12">
                <v-text-field
                  label="Libro"
                  v-model="book.b_title"
                  outlined
                  disabled
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="cancelBooksLoan()">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  name: "Prestamo",

  data() {
    return {
      headers: [
        { text: "ID", align: "center", sortable: false, value: "id_loan" },
        { text: "Nombre del usuario", align: "center", value: "user_name" },
        { text: "Fecha del préstamo", align: "center", value: "l_date" },
        { text: "Fecha de entrega", align: "center", value: "l_return_date" },
        {
          text: "Fecha de entrega real",
          align: "center",
          value: "l_real_return_date",
        },
        { text: "Acciones", align: "center", value: "actions" },
      ],
      loans: [],
      users: [],
      books: [],
      lDetails: [],
      booksLoan: [],
      idLoan: "",
      newLoan: {
        id_user: "",
        l_date: "",
        l_return_date: "",
        l_real_return_date: null,
      },
      menuLDate: false,
      menuLReturnDate: false,
      menuLRealReturnDate: false,
      nlDialog: false,
      nldDialog: false,
      ldDialog: false,
    };
  },

  watch: {
    nlDialog(isOpen) {
      !isOpen ? (this.newLoan = {}) : this.getUsers();
    },

    nldDialog(isOpen) {
      !isOpen ? (this.lDetails = {}) : this.getBooks();
    },
  },

  created() {
    this.getLoans();
  },

  methods: {
    async getLoans() {
      const apiData = await this.axios.get("loans/allLoans/");

      this.loans = apiData.data;
    },

    async getUsers() {
      const apiData = await this.axios.get("users/allUsers/");
      apiData.data.forEach((user) =>
        this.users.push({
          text: user.u_name + " " + user.u_last_name + " " + user.u_m_last_name,
          value: user.id_user,
        })
      );
    },

    async getBooks() {
      const apiData = await this.axios.get("books/allBooks/");
      apiData.data.forEach((book) =>
        this.books.push({
          text: book.b_title,
          value: book.id_book,
        })
      );
    },

    async getBooksLoan(item) {
      const apiData = await this.axios.get(
        "loans/allBooksLoan/" + item.id_loan.toString()
      );

      this.booksLoan = apiData.data;
    },

    async deleteLoan(item) {
      const body = { id_loan: item.id_loan };
      await this.axios.post("loans/deleteLoan/", body);

      this.getLoans();
    },

    cancelAddLoan() {
      this.newLoan = {};
      this.nlDialog = false;
    },

    cancelAddLDBooks() {
      this.lDetails = {};
      this.idLoan = "";
      this.nldDialog = false;
    },

    cancelBooksLoan() {
      this.booksLoan = {};
      this.ldDialog = false;
    },

    openLDetailsDialog(item) {
      this.idLoan = item.id_loan;
      this.nldDialog = true;
    },

    showLoanDetails(item) {
      this.ldDialog = true;
      this.getBooksLoan(item);
    },

    async addLoan() {
      await this.axios.post("loans/addLoan/", this.newLoan);

      this.getLoans();
      this.cancelAddLoan();
    },

    async addLDBooks() {
      const body = {
        id_loan: this.idLoan,
        id_book: "",
      };

      this.lDetails.forEach(async (book) => {
        body.id_book = book.id_book;
        await this.axios.post("loans/addLDetails/", body);
      });

      this.cancelAddLDBooks();
    },

    addBookRow() {
      this.lDetails.push({
        id_book: "",
      });
    },
  },

  components: {},
};
</script>
