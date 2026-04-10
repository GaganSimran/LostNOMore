const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcrypt');

//
// SIGNUP (FROM FIREBASE VERIFIED USER)
//
router.post('/signup', async (req, res) => {
  try {
    const { firebase_uid, email, name, phone, course, password } = req.body;

    const userExists = await pool.query(
      'SELECT * FROM users WHERE email=$1',
      [email]
    );

    if (userExists.rows.length > 0) {
      return res.status(400).json({
        message: "User already exists"
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await pool.query(
      `INSERT INTO users
       (firebase_uid, name, email, phone, course, password)
       VALUES ($1,$2,$3,$4,$5,$6)
       RETURNING *`,
      [firebase_uid, name, email, phone, course, hashedPassword]
    );

    res.status(201).json(newUser.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

//
// ✅ LOGIN (FETCH USER NAME)
//
router.post('/login', async (req, res) => {
  try {
    const { email } = req.body;

    const user = await pool.query(
      'SELECT * FROM users WHERE email=$1',
      [email]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json(user.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;