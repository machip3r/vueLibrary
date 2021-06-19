const express = require("express");
const morgan = require("morgan");
const cors = require("cors");
const historyApiFallback = require("connect-history-api-fallback");
const path = require("path");
const app = express();

app.use(cors());
app.use(morgan("tiny"));
app.use(historyApiFallback());

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, "public")));

app.use("/books", require("./routes/book"));
app.use("/users", require("./routes/user"));
app.use("/loans", require("./routes/loan"));

/*
    API REST --> HTTP --> Web.
    GET, POST --> Enviar y recuperar información.
    GET --> No modifica el estado de la base de datos.
    HEAD
    POST --> Sí modifica el estado de la base de datos.
    PUT
*/

// Primera petición
/* app.get('/', function(request, result) {
    result.send('¡Hola mundo!');
}); */

// En qué puerto escuchar la API
app.listen(3000, function () {
  console.log("¡La API está corriendo!");
});
