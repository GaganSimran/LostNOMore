router.get('/posts', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT
        i.id,
        i.title AS item_name,
        i.type,
        u.name AS owner,
        u.name AS reported_by,
        i.status,
        i.created_at
      FROM items i
      JOIN users u ON i.user_id = u.id
      ORDER BY i.created_at DESC
    `);

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Failed to fetch posts' });
  }
});