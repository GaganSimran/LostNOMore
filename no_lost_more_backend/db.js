const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  }
});

pool.connect()
  .then(() => console.log("✅ DB Connected")) // Can give idea in the render deployment re run
  .catch(err => console.error("❌ DB Connection Error FULL:", err));

module.exports = pool;