FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy dependency definitions first (better caching)
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy application source
COPY . .

# Document the port the app listens on
EXPOSE 5000

# Start the backend
CMD ["npm", "start"]
