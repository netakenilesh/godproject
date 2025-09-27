#!/bin/bash

APP_DIR="/opt/app"
REPO_URL="https://github.com/yourusername/your-repo.git"  # Update with your repo

echo "🚀 Starting deployment with EC2 build..."

cd $APP_DIR

# Pull latest code from GitHub
if [ -d ".git" ]; then
    echo "📥 Pulling latest code from GitHub..."
    git pull origin main
else
    echo "📥 Cloning repository..."
    git clone $REPO_URL .
fi

# Check if environment file exists
if [ ! -f .env.production ]; then
    echo "❌ Error: .env.production file not found!"
    echo "Please create .env.production file with database credentials"
    exit 1
fi

echo "📋 Environment file found"

# Stop existing containers
echo "🛑 Stopping existing containers..."
sudo docker-compose -f docker-compose.prod.yml down

# Build and start new containers
echo "🏗️ Building containers on EC2..."
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