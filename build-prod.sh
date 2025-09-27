#!/bin/bash

echo "Building for production..."

# Build backend
cd backend
npm run build
cd ..

# Build frontend
cd frontend
npm run build
cd ..

echo "Build complete!"