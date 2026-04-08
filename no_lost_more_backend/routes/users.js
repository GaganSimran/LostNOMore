const express = require('express');
const router = express.Router();
const pool = require('../db');

//
// 🔥 SIGNUP
//
router.post('/signup', async (req, res) => {
  try {
    console.log("BODY:", req.body);

    const { firebase_uid, email, name, course, phone, address } = req.body;

    const userExists = await pool.query(
      'SELECT * FROM users WHERE firebase_uid = $1',
      [firebase_uid]
    );

    if (userExists.rows.length > 0) {
      return res.status(400).json({
        message: "User already exists"
      });
    }

    const newUser = await pool.query(
      `INSERT INTO users
       (firebase_uid, email, name, course, phone, address)
       VALUES ($1,$2,$3,$4,$5,$6)
       RETURNING *`,
      [firebase_uid, email, name, course, phone, address]
    );

    res.status(201).json(newUser.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

//
// 🔐 LOGIN
//
router.post('/login', async (req, res) => {
  try {
    const { firebase_uid } = req.body;

    const user = await pool.query(
      'SELECT * FROM users WHERE firebase_uid = $1',
      [firebase_uid]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({
        message: "User not found"
      });
    }

    res.json(user.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;