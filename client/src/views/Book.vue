<template>
  <v-container>
    <v-data-table
      :headers="headers"
      :items="books"
      :items-per-page="5"
      class="elevation-1"
    >
      <template v-slot:top>
        <v-toolbar flat>
          <v-toolbar-title>Libros </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn color="warning" @click="nbDialog = true">Nuevo libro</v-btn>
        </v-toolbar>
      </template>

      <template v-slot:[`item.actions`]="{ item }">
        <v-icon small>
          fas fa-edit
        </v-icon>

        <v-icon small @click="deleteBook(item)">
          fas fa-trash
        </v-icon>
      </template>
    </v-data-table>

    <v-dialog v-model="nbDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <h3>Nuevo libro</h3>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-row>
              <v-col cols="6">
                <v-text-field
                  label="Título"
                  v-model="newBook.b_title"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  label="Autor"
                  v-model="newBook.b_author"
                ></v-text-field>
              </v-col>
            </v-row>
            <v-row>
              <v-col cols="6">
                <v-text-field
                  label="Editorial"
                  v-model="newBook.b_editorial"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  label="Edición"
                  type="number"
                  v-model="newBook.b_edition"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="cancelAddBook()"
            >Cancelar</v-btn
          >
          <v-btn color="green darken-1" text @click="addBook()">Guardar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  name: "Libro",

  data() {
    return {
      headers: [
        { text: "ID", align: "center", sortable: false, value: "id_book" },
        { text: "Título", align: "center", value: "b_title" },
        { text: "Autor", align: "center", value: "b_author" },
        { text: "Editorial", align: "center", value: "b_editorial" },
        { text: "Edición", align: "center", value: "b_edition" },
        { text: "Acciones", align: "center", value: "actions" },
      ],
      books: [],
      newBook: {
        b_title: "",
        b_author: "",
        b_editorial: "",
        b_edition: "",
      },
      nbDialog: false,
    };
  },

  watch: {
    nbDialog(isOpen) {
      if (!isOpen) this.newBook = {};
    },
  },

  created() {
    this.getBooks();
  },

  methods: {
    async getBooks() {
      const apiData = await this.axios.get("books/allBooks/");
      this.books = apiData.data;
    },

    async deleteBook(item) {
      const body = { id_book: item.id_book };
      await this.axios.post("books/deleteBook/", body);

      this.getBooks();
    },

    cancelAddBook() {
      this.newBook = {};
      this.nbDialog = false;
    },

    async addBook() {
      await this.axios.post("books/addBook/", this.newBook);
      this.getBooks();
      this.cancelAddBook();
    },
  },

  components: {},
};
</script>
