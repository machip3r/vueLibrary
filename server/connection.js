const mysql = require("mysql");
const { promisify } = require("util");

// Configuración de conexión
const connection = mysql.createPool({
    host: "localhost",
    user: "test",
    password: "machip3rtest",
    database: "biblioteca_db"
});

// Función para la conexión
connection.getConnection((error, connect) => {
    if (error) console.log("Error al conectar a la base de datos");
    if (connect) console.log("Conexión correcta a la base de datos");

    return;
});

// Consultas asíncronas
connection.query = promisify(connection.query);

// Exportación de módulo para su uso en todo el proyecto
module.exports = connection;