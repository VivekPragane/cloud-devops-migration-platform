import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import cors from 'cors';
import orderRoutes from './routes/orderRoutes.js';

dotenv.config();

// Fail fast if required environment variables are missing
if (!process.env.MONGO_URI) {
  console.error('MONGO_URI is not defined');
  process.exit(1);
}

const app = express();

// Environment-driven CORS configuration
const FRONTEND_ORIGIN = process.env.FRONTEND_ORIGIN || '*';

app.use(cors({
  origin: FRONTEND_ORIGIN,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.options('*', cors()); // enable preflight for all routes

app.use(express.json());

// Health check endpoint (required for cloud orchestration)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.use('/api/orders', orderRoutes);

const PORT = process.env.PORT || 5000;

// Updated connect options (useNewUrlParser and useUnifiedTopology are deprecated)
mongoose.connect(process.env.MONGO_URI)
  .then((conn) => {
    console.log(`MongoDB Connected: ${conn.connection.host}`);

    app.listen(PORT, '0.0.0.0', () => {
      console.log('Backend service started');
      console.log(`Listening on port ${PORT}`);
    });
  })
  .catch(err => {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  });

// Listener for runtime MongoDB errors
mongoose.connection.on('error', err => {
  console.log(`MongoDB runtime error: ${err.message}`);
});
