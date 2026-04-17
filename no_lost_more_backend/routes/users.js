router.get('/reports', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT u.name, COUNT(r.id) AS report_count
      FROM reports r
      JOIN users u ON r.firebase_uid = u.firebase_uid
      GROUP BY u.name
      ORDER BY report_count DESC
    `);

    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error');
  }
});