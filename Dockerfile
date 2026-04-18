# Multi-stage Dockerfile for MERN app

# Build client
FROM node:18 AS client-builder
WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci
COPY client/ ./
RUN npm run build

# Final image with server and built client as sibling directories
FROM node:18
WORKDIR /app

# Install server dependencies
COPY server/package*.json ./server/
RUN cd server && npm ci --production

# Copy server source
COPY server/ ./server/

# Copy client build from builder
COPY --from=client-builder /app/client/build ./client/build

WORKDIR /app/server
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "server.js"]
