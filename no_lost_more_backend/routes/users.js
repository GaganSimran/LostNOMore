const express = require('express');
const router = express.Router();
const pool = require('../db');

router.post('/login', async (req, res) => {
try {
const { firebase_uid, email, name, course, phone, address } = req.body;

let user = await pool.query(
'SELECT * FROM users WHERE firebase_uid=$1',
[firebase_uid]
);

if (user.rows.length === 0) {
user = await pool.query(
`INSERT INTO users
(firebase_uid, email, name, course, phone, address)
VALUES ($1,$2,$3,$4,$5,$6)
RETURNING *`,
[firebase_uid, email, name, course, phone, address]
);
}

res.json(user.rows[0]);

} catch (err) {
console.error(err);
res.status(500).send("Error");
}
});

module.exports = router;