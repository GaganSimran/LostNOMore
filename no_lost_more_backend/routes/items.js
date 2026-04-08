const express = require('express');
const router = express.Router();
const pool = require('../db');

//
// CREATE ITEM
//
router.post('/', async (req, res) => {
  try {
    console.log("ITEM BODY:", req.body);

    const { user_id, item_code, title, description, category, location, image_url, type } = req.body;

    const newItem = await pool.query(
      `INSERT INTO items
      (user_id, item_code, title, description, category, location, image_url, type)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
      RETURNING *`,
      [user_id, item_code, title, description, category, location, image_url, type]
    );

    res.json(newItem.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

//
// GET ALL ITEMS
//
router.get('/', async (req, res) => {
  try {
    const items = await pool.query(
      'SELECT * FROM items ORDER BY created_at DESC'
    );
    res.json(items.rows);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

//
// UPDATE ITEM
//
router.put('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status, handed_to_security, is_approved } = req.body;

    const updated = await pool.query(
      `UPDATE items
       SET status=$1, handed_to_security=$2, is_approved=$3, updated_at=NOW()
       WHERE id=$4 RETURNING *`,
      [status, handed_to_security, is_approved, id]
    );

    res.json(updated.rows[0]);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;