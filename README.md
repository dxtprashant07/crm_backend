# 🗂️ CRM Backend API

A production-ready **Customer Relationship Management (CRM) REST API** built with **Ruby on Rails 7.1**.  
Manage contacts, companies, deals, and activities — with JWT authentication, role-based access, and a sales pipeline dashboard.

---

## 🚀 Features

| Module | Capabilities |
|---|---|
| 🔐 **Auth** | Signup, Login, JWT token auth, Role-based access (Admin / Manager / Agent) |
| 👤 **Contacts** | Full CRUD, search, filter by status, linked deals & activities |
| 🏢 **Companies** | Full CRUD, search, linked contacts & deals |
| 💼 **Deals** | Full CRUD, 6-stage sales pipeline, stage progression, revenue tracking |
| 📋 **Activities** | Log calls, emails, meetings, notes, tasks — linked to contacts & deals |
| 📊 **Dashboard** | Overview stats, pipeline summary, monthly revenue, top deals |

---

## 🛠️ Tech Stack

- **Ruby on Rails 7.1** (API-only mode)
- **SQLite3** (development) / **PostgreSQL** (production-ready)
- **JWT** for stateless authentication
- **bcrypt** for password hashing
- **Kaminari** for pagination
- **Rack::CORS** for cross-origin support

---

## ⚡ Quick Start

### Prerequisites
- Ruby 3.2.0+
- Bundler

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/crm-backend.git
cd crm-backend

# 2. Install dependencies
bundle install

# 3. Setup database
rails db:create db:migrate db:seed

# 4. Start the server
rails server
```

The API will be live at **`http://localhost:3000`**

---

## 🔐 Authentication

All endpoints require a Bearer token in the `Authorization` header.

```
Authorization: Bearer <your_jwt_token>
```

### Get a token

```bash
# Signup
POST /api/v1/auth/signup
{
  "name": "Prashant Dixit",
  "email": "prashant@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}

# Login
POST /api/v1/auth/login
{
  "email": "agent1@crm.com",
  "password": "password123"
}
```

### Seeded test accounts

| Role    | Email                | Password    |
|---------|----------------------|-------------|
| Admin   | admin@crm.com        | password123 |
| Manager | manager@crm.com      | password123 |
| Agent   | agent1@crm.com       | password123 |

---

## 📡 API Endpoints

### Auth
| Method | Endpoint              | Description        |
|--------|-----------------------|--------------------|
| POST   | /api/v1/auth/signup   | Register new user  |
| POST   | /api/v1/auth/login    | Login & get token  |
| GET    | /api/v1/auth/me       | Get current user   |

### Contacts
| Method | Endpoint                          | Description              |
|--------|-----------------------------------|--------------------------|
| GET    | /api/v1/contacts                  | List all contacts        |
| POST   | /api/v1/contacts                  | Create contact           |
| GET    | /api/v1/contacts/:id              | Get contact details      |
| PUT    | /api/v1/contacts/:id              | Update contact           |
| DELETE | /api/v1/contacts/:id              | Delete contact           |
| GET    | /api/v1/contacts/:id/deals        | Get contact's deals      |
| GET    | /api/v1/contacts/:id/activities   | Get contact's activities |

**Query params:** `?q=search_term` `?status=lead|prospect|customer|churned` `?page=1` `?per_page=20`

### Companies
| Method | Endpoint                           | Description               |
|--------|------------------------------------|---------------------------|
| GET    | /api/v1/companies                  | List all companies        |
| POST   | /api/v1/companies                  | Create company            |
| GET    | /api/v1/companies/:id              | Get company details       |
| PUT    | /api/v1/companies/:id              | Update company            |
| DELETE | /api/v1/companies/:id              | Delete company            |
| GET    | /api/v1/companies/:id/contacts     | Get company's contacts    |
| GET    | /api/v1/companies/:id/deals        | Get company's deals       |

### Deals
| Method | Endpoint                           | Description              |
|--------|------------------------------------|--------------------------|
| GET    | /api/v1/deals                      | List deals + pipeline    |
| POST   | /api/v1/deals                      | Create deal              |
| GET    | /api/v1/deals/:id                  | Get deal details         |
| PUT    | /api/v1/deals/:id                  | Update deal              |
| PATCH  | /api/v1/deals/:id/update_stage     | Move deal to new stage   |
| DELETE | /api/v1/deals/:id                  | Delete deal              |

**Pipeline stages:** `prospecting` → `qualification` → `proposal` → `negotiation` → `closed_won` / `closed_lost`

### Activities
| Method | Endpoint                | Description           |
|--------|-------------------------|-----------------------|
| GET    | /api/v1/activities      | List all activities   |
| POST   | /api/v1/activities      | Log an activity       |
| GET    | /api/v1/activities/:id  | Get activity details  |
| PUT    | /api/v1/activities/:id  | Update activity       |
| DELETE | /api/v1/activities/:id  | Delete activity       |

**Activity types:** `call` `email` `meeting` `note` `task`

### Dashboard
| Method | Endpoint                   | Description            |
|--------|----------------------------|------------------------|
| GET    | /api/v1/dashboard/stats    | Full CRM stats         |

---

## 📦 Example Requests

### Create a Contact
```bash
curl -X POST http://localhost:3000/api/v1/contacts \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Rahul",
    "last_name": "Verma",
    "email": "rahul@example.com",
    "phone": "9876543210",
    "job_title": "CTO",
    "status": "lead",
    "source": "referral"
  }'
```

### Create a Deal
```bash
curl -X POST http://localhost:3000/api/v1/deals \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Enterprise License Deal",
    "value": 250000,
    "stage": "proposal",
    "contact_id": 1,
    "expected_close_date": "2025-03-31"
  }'
```

### Move Deal Stage
```bash
curl -X PATCH http://localhost:3000/api/v1/deals/1/update_stage \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "stage": "negotiation" }'
```

### Get Dashboard Stats
```bash
curl http://localhost:3000/api/v1/dashboard/stats \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🗃️ Database Schema

```
users          → id, name, email, password_digest, role, active
companies      → id, name, industry, website, phone, city, country, size
contacts       → id, first_name, last_name, email, phone, job_title, status, source, company_id
deals          → id, title, value, stage, probability, expected_close_date, contact_id, company_id, owner_id
activities     → id, activity_type, subject, description, completed, scheduled_at, user_id, contact_id, deal_id
```

---

## 🚢 Production Deployment

Switch to PostgreSQL by updating `config/database.yml` and setting environment variables:

```bash
export DB_USERNAME=postgres
export DB_PASSWORD=your_password
export DB_HOST=localhost
export JWT_SECRET=your_strong_secret
export SECRET_KEY_BASE=$(rails secret)

rails db:create db:migrate db:seed RAILS_ENV=production
rails server -e production
```

---

## 👨‍💻 Author

**Prashant Dixit** — AI Engineer & Full Stack Developer  
[GitHub](https://github.com/dxtprashant07) · [LinkedIn](https://linkedin.com/in/Prashant-Dixit) · [Portfolio](https://pdxt.vercel.app)
