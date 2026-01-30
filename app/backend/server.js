/**
 * Entry point for ElectroMart backend service
 * Designed for containerized & cloud-native environments (ECS, Docker)
 */

import express from 'express';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import cors from 'cors';
import orderRoutes from './routes/orderRoutes.js';

// Load environment variables
dotenv.config();

// -------------------------------------------------------------------
// Environment Validation (Fail Fast)
// -------------------------------------------------------------------
if (!process.env.MONGO_URI) {
  console.error('[FATAL] MONGO_URI is not defined');
  process.exit(1);
}

const PORT = process.env.PORT || 5000;
const FRONTEND_ORIGIN = process.env.FRONTEND_ORIGIN || '*';

const app = express();

// -------------------------------------------------------------------
// Middleware
// -------------------------------------------------------------------

// CORS configuration (environment-driven)
app.use(cors({
  origin: FRONTEND_ORIGIN,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Enable preflight requests
app.options('*', cors());

// JSON body parser
app.use(express.json());

// -------------------------------------------------------------------
// Health Check (required for ALB / ECS)
// -------------------------------------------------------------------
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'electromart-backend',
    timestamp: new Date().toISOString()
  });
});

// -------------------------------------------------------------------
// API Routes
// -------------------------------------------------------------------
app.use('/api/orders', orderRoutes);

// -------------------------------------------------------------------
// Database Connection (Non-blocking)
// -------------------------------------------------------------------
mongoose.connect(process.env.MONGO_URI)
  .then((conn) => {
    console.log(`[DB] MongoDB connected: ${conn.connection.host}`);
  })
  .catch((err) => {
    console.error('[DB] MongoDB connection failed');
    console.error('[DB] Running in degraded mode:', err.message);
  });

// Runtime DB error listener
mongoose.connection.on('error', (err) => {
  console.error('[DB] Runtime MongoDB error:', err.message);
});

// -------------------------------------------------------------------
// Server Startup
// -------------------------------------------------------------------
const server = app.listen(PORT, '0.0.0.0', () => {
  console.log('[APP] Backend service started');
  console.log(`[APP] Listening on port ${PORT}`);
});

// -------------------------------------------------------------------
// Graceful Shutdown (Containers / ECS Safe)
// -------------------------------------------------------------------
const shutdown = () => {
  console.log('[APP] Shutdown signal received');
  server.close(() => {
    console.log('[APP] HTTP server closed');
    mongoose.connection.close(false, () => {
      console.log('[DB] MongoDB connection closed');
      process.exit(0);
    });
  });
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);
