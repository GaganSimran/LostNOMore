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

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});