# Auth Service

A JWT-based authentication microservice built with Ruby on Rails. Responsible for user registration, login, and token validation for the Web Scraping Manager system.

---

## 🏗️ Architecture

This service is part of a microservices system:

```
webscraping-manager  →  auth-service (this)
                     →  notification-service
```

---

## 🛠️ Tech Stack

- **Ruby** 3.2.3
- **Rails** 8.1.2 (API mode)
- **PostgreSQL** 16
- **JWT** for authentication
- **Bcrypt** for password encryption

---

## 📋 Requirements

- Ruby 3.2.3
- Rails 8.1.2
- PostgreSQL 16
- Docker (optional)

---

## 🚀 Getting Started

### With Docker (recommended)

Clone the main repository and run from the `webscraping-manager` folder:

```bash
git clone https://github.com/your-username/webscraping-manager.git
cd webscraping-manager
cp .env.example .env
docker compose up --build
```

The auth-service will be available at `http://localhost:3001`

### Without Docker

1. Clone the repository:
```bash
git clone https://github.com/your-username/auth-service.git
cd auth-service
```

2. Install dependencies:
```bash
bundle install
```

3. Create the `.env` file:
```bash
cp .env.example .env
```

4. Fill in the environment variables in `.env`

5. Create and migrate the database:
```bash
rails db:create db:migrate
```

6. Start the server:
```bash
rails server -p 3001
```

---

## 📝 Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection URL | `postgresql://dev:dev@localhost:5432/auth_service_development` |
| `JWT_SECRET` | Secret key for JWT signing | `your_secret_key` |
| `RAILS_ENV` | Rails environment | `development` |

---

## 🔌 API Endpoints

### Register User

```
POST /auth/register
```

**Request:**
```json
{
  "email": "user@email.com",
  "password": "123456",
  "password_confirmation": "123456"
}
```

**Response (201 Created):**
```json
{
  "message": "Usuario criado com sucesso",
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Response (422 Unprocessable Entity):**
```json
{
  "errors": ["Email has already been taken"]
}
```

---

### Login

```
POST /auth/login
```

**Request:**
```json
{
  "email": "user@email.com",
  "password": "123456"
}
```

**Response (200 OK):**
```json
{
  "message": "Login realizado com sucesso",
  "token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

**Response (401 Unauthorized):**
```json
{
  "error": "Email ou senha invalidos"
}
```

---

### Validate Token

```
GET /auth/validate
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "valid": true,
  "user": {
    "id": 1,
    "email": "user@email.com"
  }
}
```

**Response (401 Unauthorized):**
```json
{
  "valid": false,
  "error": "Token invalido ou expirado"
}
```

---

## 🗄️ Database

**Table: users**

| Column | Type | Description |
|--------|------|-------------|
| id | string (uuid) | Primary key |
| email | string | User email (unique) |
| password_digest | string | Bcrypt encrypted password |
| created_at | datetime | Creation timestamp |
| updated_at | datetime | Update timestamp |

---

## 🧪 Running Tests

```bash
bundle exec rspec
```

---

## 🐳 Docker

The service is containerized and managed by the `docker-compose.yml` in the `webscraping-manager` repository.

```bash
# Build and start all services
docker compose up --build

# Start only auth-service
docker compose up auth-service
```