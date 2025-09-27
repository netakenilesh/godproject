FROM node:20-alpine

# Install OpenSSL and other required dependencies
RUN apk add --no-cache openssl openssl-dev

WORKDIR /app

# Copy package files and Prisma schema
COPY package*.json ./
COPY prisma ./prisma/

# Install dependencies
RUN npm install

# Generate Prisma Client
RUN npx prisma generate

# Copy source code
COPY . .

# Build TypeScript code
RUN npm run build

EXPOSE 4000

CMD ["npm", "start"]