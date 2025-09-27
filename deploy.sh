#!/bin/bash

APP_DIR="/opt/app"

echo "🚀 Starting deployment..."

cd $APP_DIR

# Check if environment file exists
if [ ! -f .env.production ]; then
    echo "❌ Error: .env.production file not found!"
    echo "Please create .env.production file with database credentials"
    exit 1
fi

# Load environment variables (simpler method for Ubuntu)
set -a
source .env.production
set +a

echo "📋 Loaded environment variables"

# Stop existing containers
echo "🛑 Stopping existing containers..."
sudo docker-compose -f docker-compose.prod.yml down

# Build and start new containers
echo "📦 Building and starting containers..."
sudo docker-compose -f docker-compose.prod.yml up --build -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Run database migrations
echo "🗃️ Running database migrations..."
sudo docker-compose -f docker-compose.prod.yml exec backend npx prisma db push

# Check service health
echo "🏥 Checking service health..."
curl -f http://localhost/api/health || echo "Health check failed"

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "✅ Deployment complete!"
echo "🌐 Application should be available at: http://$PUBLIC_IP"