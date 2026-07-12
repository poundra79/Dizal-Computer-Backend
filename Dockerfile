# Stage 1: Development
FROM node:20-alpine AS development

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

# Run build to generate dist folder
RUN npm run build

# Default CMD for development
CMD ["npm", "run", "start:dev"]

# Stage 2: Production Build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY --from=development /app/node_modules ./node_modules
COPY . .

RUN npm run build
RUN npm prune --production

# Stage 3: Production Runner
FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main"]
