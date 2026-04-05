const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

// Import routes
const userRoutes = require('./routes/users');
const itemRoutes = require('./routes/items');
const reportRoutes = require('./routes/reports');
const notificationRoutes = require('./routes/notifications');

// Use routes
app.use('/users', userRoutes);
app.use('/items', itemRoutes);
app.use('/reports', reportRoutes);
app.use('/notifications', notificationRoutes);

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});