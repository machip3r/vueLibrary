const express = require("express");
const router = express.Router();
const connection = require("../connection.js");

router.get("/allLoans", async (request, result) => {
  try {
    const query =
      "SELECT l.id_loan, u.id_user, CONCAT_WS(' ', u.u_name, u.u_last_name, u.u_m_last_name) AS user_name, l.l_date, l.l_return_date, l.l_real_return_date FROM loan l INNER JOIN user u ON l.id_user = u.id_user";
    const loans = await connection.query(query);

    result.json(loans);
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/deleteLoan", async (request, result) => {
  try {
    const id_loan = request.body.id_loan;
    const query = "DELETE FROM loan WHERE id_loan = ?";
    await connection.query(query, [id_loan]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/addLoan", async (request, result) => {
  try {
    const body = request.body;
    const query =
      "INSERT INTO loan(id_user, l_date, l_return_date, l_real_return_date) VALUES(?, ?, ?, ?)";
    await connection.query(query, [
      body.id_user,
      body.l_date,
      body.l_return_date,
      body.l_real_return_date,
    ]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/addLDetails", async (request, result) => {
  try {
    const body = request.body;
    const query = "INSERT INTO loanDetails(id_loan, id_book) VALUES(?, ?)";
    await connection.query(query, [body.id_loan, body.id_book]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

router.get("/allBooksLoan/:id_loan", async (request, result) => {
  try {
    const id_loan = request.params.id_loan;
    const query =
      "SELECT b.b_title FROM loanDetails ld INNER JOIN book b ON b.id_book = ld.id_book WHERE ld.id_loan = ?";
    const booksLoan = await connection.query(query, [id_loan]);

    result.json(booksLoan);
  } catch (error) {
    return result.json({ error: error });
  }
});

module.exports = router;
