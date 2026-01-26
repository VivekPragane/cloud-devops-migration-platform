import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import cors from 'cors';
import orderRoutes from './routes/orderRoutes.js';

dotenv.config();

const app = express();

app.use(cors({
  origin: FRONTEND_ORIGIN,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.options('*', cors()); // enable preflight for all routes



app.use(express.json());

app.use('/api/orders', orderRoutes);

const PORT = process.env.PORT || 5000;

// Updated connect options (useNewUrlParser and useUnifiedTopology are deprecated)
mongoose.connect(process.env.MONGO_URI)
  .then((conn) => {
    // --- ADDED LOG ---
    // This will prove you are connected to the correct database.
    console.log(`MongoDB Connected: ${conn.connection.host}`);
    // -----------------
  app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));
  })
  .catch(err => {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  });

// Add a listener for any errors that happen *after* connection
mongoose.connection.on('error', err => {
  console.log(`MongoDB runtime error: ${err.message}`);
});
