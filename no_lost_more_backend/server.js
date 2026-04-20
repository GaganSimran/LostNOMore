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

   const PORT = process.env.PORT || 5000;

   app.listen(PORT, '0.0.0.0', () => {
     console.log(`🚀 Server running on port ${PORT}`);
   });