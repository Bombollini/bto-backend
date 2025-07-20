# Dockerfile for a NestJS (TypeScript) backend application
# Optimized multi-stage build

# --------------- BUILD STAGE ---------------
FROM node:18-alpine AS builder
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies needed for build)
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# --------------- DEVELOPMENT STAGE ---------------
FROM node:18-alpine AS development
WORKDIR /app

# Copy package files and install all dependencies for development
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Start in development mode
CMD ["npm", "run", "start:dev"]

# --------------- PRODUCTION STAGE ---------------
FROM node:18-alpine AS production
WORKDIR /app

# Set NODE_ENV
ENV NODE_ENV=production
ENV PORT=3001

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev

# Copy only the built files from the builder stage
COPY --from=builder /app/dist ./dist
# Copy necessary files and folders for running the app
COPY --from=builder /app/node_modules ./node_modules
# Copy any additional configuration files that might be needed at runtime
COPY --from=builder /app/package.json ./package.json

# Expose port
EXPOSE 3001

# Start in production mode
CMD ["npm", "run", "start:prod"]

