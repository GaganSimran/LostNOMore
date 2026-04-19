const express = require('express');
const router = express.Router();
const pool = require('../db');

// Get all items
router.get('/', async (req, res) => {
  try {
    const items = await pool.query(
      'SELECT * FROM items ORDER BY created_at DESC'
    );
    res.status(200).json(items.rows);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'Error fetching items' });
  }
});

// Create item
router.post('/', async (req, res) => {
  try {
    const {
      user_id,
      item_code,
      title,
      description,
      category,
      location,
      image_url,
      type
    } = req.body;

    const newItem = await pool.query(
      `INSERT INTO items
      (user_id, item_code, title, description, category, location, image_url, type)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
      RETURNING *`,
      [user_id, item_code, title, description, category, location, image_url, type]
    );

    res.status(201).json(newItem.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'Error creating item' });
  }
});

// Update item status
router.put('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, handed_to_security, is_approved } = req.body;

    const updated = await pool.query(
      `UPDATE items
       SET status = $1,
           handed_to_security = $2,
           is_approved = $3,
           updated_at = NOW()
       WHERE id = $4
       RETURNING *`,
      [status, handed_to_security, is_approved, id]
    );

    res.status(200).json(updated.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ error: 'Error updating item' });
  }
});


module.exports = router;