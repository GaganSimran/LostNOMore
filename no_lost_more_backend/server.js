const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/users', require('./routes/users'));
app.use('/items', require('./routes/items'));
app.use('/reports', require('./routes/reports'));
app.use('/notifications', require('./routes/notifications'));

app.listen(3000, '0.0.0.0', () => {
  console.log("🚀 Server running on port 3000");
});