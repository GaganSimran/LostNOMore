const express = require('express');
const router = express.Router();
const pool = require('../db');


router.post('/', async (req, res) => {
  try {
    const { user_id, message } = req.body;
    const newNotification = await pool.query(
      `INSERT INTO notifications (user_id, message) VALUES ($1,$2) RETURNING *`,
      [user_id, message]
    );
    res.json(newNotification.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error creating notification");
  }
});


router.get('/:user_id', async (req, res) => {
  try {
    const { user_id } = req.params;
    const notifications = await pool.query(
      `SELECT * FROM notifications WHERE user_id=$1 ORDER BY created_at DESC`,
      [user_id]
    );
    res.json(notifications.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching notifications");
  }
});

router.put('/:id/read', async (req, res) => {
  try {
    const { id } = req.params;
    const updated = await pool.query(
      `UPDATE notifications SET is_read=TRUE WHERE id=$1 RETURNING *`,
      [id]
    );
    res.json(updated.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error updating notification");
  }
});

module.exports = router;