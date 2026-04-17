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
// UPDATE USER PROFILE
router.put('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { name, bio, profile_image } = req.body;

    const updatedUser = await pool.query(
      `UPDATE users
       SET name = $1,
           bio = $2,
           profile_image = $3
       WHERE id = $4
       RETURNING *`,
      [name, bio, profile_image, id]
    );

    res.json(updatedUser.rows[0]);

  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
});
//
// DELETE USER (ACCOUNT DELETION)
//
router.delete('/:uid', async (req, res) => {
  try {
    const { uid } = req.params;

    if (!uid) {
      return res.status(400).json({
        success: false,
        message: "User ID is required"
      });
    }

    // delete from database using firebase_uid
    const deletedUser = await pool.query(
      'DELETE FROM users WHERE firebase_uid = $1 RETURNING *',
      [uid]
    );

    if (deletedUser.rowCount === 0) {
      return res.status(404).json({
        success: false,
        message: "User not found"
      });
    }

    return res.status(200).json({
      success: true,
      message: "User deleted successfully",
      user: deletedUser.rows[0]
    });

  } catch (err) {
    console.error("Delete user error:", err);

    return res.status(500).json({
      success: false,
      message: "Server error"
    });
  }
});


module.exports = router;