const express = require('express');
const router = express.Router();
const pool = require('../db');

// Create a report (claim/report)
router.post('/', async (req, res) => {
  try {
    const { item_id, user_id, type, message } = req.body;
    const newReport = await pool.query(
      `INSERT INTO reports (item_id, user_id, type, message) 
       VALUES ($1,$2,$3,$4) RETURNING *`,
      [item_id, user_id, type, message]
    );
    res.json(newReport.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error creating report");
  }
});

// Get all reports
router.get('/', async (req, res) => {
  try {
    const reports = await pool.query('SELECT * FROM reports ORDER BY created_at DESC');
    res.json(reports.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching reports");
  }
});

// Update report status (pending/approved/rejected)
router.put('/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const updated = await pool.query(
      `UPDATE reports 
       SET status=$1 
       WHERE id=$2 RETURNING *`,
      [status, id]
    );

    res.json(updated.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error updating report");
  }
});

module.exports = router;