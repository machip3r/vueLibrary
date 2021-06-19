const express = require("express");
const router = express.Router();
const connection = require("../connection.js");

router.get("/allBooks", async (request, result) => {
  try {
    const query = "SELECT * FROM book";
    const books = await connection.query(query);

    result.json(books);
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/deleteBook", async (request, result) => {
  try {
    const id_book = request.body.id_book;
    const query = "DELETE FROM book WHERE id_book = ?";
    await connection.query(query, [id_book]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/addBook", async (request, result) => {
  try {
    const body = request.body;
    const query =
      "INSERT INTO book(b_title, b_author, b_editorial, b_edition) VALUES(?, ?, ?, ?)";
    await connection.query(query, [
      body.b_title,
      body.b_author,
      body.b_editorial,
      body.b_edition,
    ]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

module.exports = router;
