# Dockerfile for a NestJS (TypeScript) backend application
# Multi-stage build for development and production

# Base stage
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# Development stage
FROM base AS development
ENV NODE_ENV=development
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "run", "start:dev"]

# Production stage
FROM base AS production
ENV NODE_ENV=production
# Install all dependencies (including dev dependencies needed for build)
RUN npm ci
COPY . .
# Install NestJS CLI globally to ensure it's available for the build
RUN npm install -g @nestjs/cli
# Build the application
RUN npm run build
# Remove dev dependencies to make the image smaller
RUN npm ci --omit=dev
EXPOSE 3000
CMD ["npm", "run", "start:prod"]


#test deploy 2

