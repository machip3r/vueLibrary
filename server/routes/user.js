const express = require("express");
const router = express.Router();
const connection = require("../connection.js");

router.get("/allUsers", async (request, result) => {
  try {
    const query = "SELECT * FROM user";
    const users = await connection.query(query);

    result.json(users);
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/deleteUser", async (request, result) => {
  try {
    const id_user = request.body.id_user;
    const query = "DELETE FROM user WHERE id_user = ?";
    await connection.query(query, [id_user]);

    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

router.post("/addUser", async (request, result) => {
  try {
    const body = request.body;
    const query =
      "INSERT INTO user(u_name, u_last_name, u_m_last_name, u_email) VALUES(?, ?, ?, ?)";
    await connection.query(query, [
      body.u_name,
      body.u_last_name,
      body.u_m_last_name,
      body.u_email,
    ]);
    result.json("ok");
  } catch (error) {
    return result.json({ error: error });
  }
});

module.exports = router;
