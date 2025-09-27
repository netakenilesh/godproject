version: "3.8"
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.prod
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}
      NODE_ENV: production
      PORT: 4000
    ports:
      - "4000:4000"
    depends_on:
      - postgres
    restart: unless-stopped

volumes:
  postgres_data:
