const express = require('express');
const router = express.Router();
const admin = require('../firebaseAdmin');


router.post('/create', async (req, res) => {
  try {
    const { email, password, displayName } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }


    const userRecord = await admin.auth().createUser({
      email,
      password,
      displayName: displayName || '',
    });


    await admin.auth().setCustomUserClaims(userRecord.uid, { admin: true });

    return res.status(201).json({
      message: 'Admin user created successfully',
      uid: userRecord.uid,
      email: userRecord.email,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      error: err.message || 'Failed to create admin user'
    });
  }
});

module.exports = router;