# 🚀 CRM Deployment Guide
## Backend → Render (Free) | Frontend → Vercel (Free)

---

## PART 1 — Deploy Backend on Render

### Step 1: Push backend to GitHub
```bash
cd crm_backend
git add .
git commit -m "Add Render deployment config"
git remote add origin https://github.com/YOUR_USERNAME/crm-backend.git
git branch -M main
git push -u origin main
```

### Step 2: Create a free PostgreSQL database on Render
1. Go to https://dashboard.render.com
2. Click **New +** → **PostgreSQL**
3. Fill in:
   - Name: `crm-db`
   - Region: **Singapore** (closest to India)
   - Plan: **Free**
4. Click **Create Database**
5. Wait ~1 min, then **copy the "Internal Database URL"** — you'll need it in Step 3

### Step 3: Create the Web Service on Render
1. Click **New +** → **Web Service**
2. Connect your GitHub → select `crm-backend`
3. Fill in:
   - Name: `crm-backend`
   - Region: **Singapore**
   - Branch: `main`
   - Runtime: **Ruby**
   - Build Command:
     ```
     bundle install && bundle exec rails db:migrate && bundle exec rails db:seed
     ```
   - Start Command:
     ```
     bundle exec puma -C config/puma.rb
     ```
   - Plan: **Free**

4. Under **Environment Variables**, add:

   | Key | Value |
   |-----|-------|
   | `RAILS_ENV` | `production` |
   | `RAILS_SERVE_STATIC_FILES` | `true` |
   | `RAILS_LOG_TO_STDOUT` | `true` |
   | `SECRET_KEY_BASE` | *(click Generate)* |
   | `JWT_SECRET` | *(click Generate)* |
   | `DATABASE_URL` | *(paste the Internal DB URL from Step 2)* |

5. Click **Create Web Service**

6. Wait ~3-5 minutes for first deploy

7. Your backend will be live at:
   ```
   https://crm-backend.onrender.com
   ```

8. Test it:
   ```bash
   curl https://crm-backend.onrender.com/up
   # Should return: OK
   ```

---

## PART 2 — Deploy Frontend on Vercel

### Step 1: Push frontend to GitHub
```bash
cd crm_frontend
git add .
git commit -m "Add Vercel deployment config"
git remote add origin https://github.com/YOUR_USERNAME/crm-frontend.git
git branch -M main
git push -u origin main
```

### Step 2: Deploy on Vercel
1. Go to https://vercel.com → Sign up with GitHub (free)
2. Click **Add New Project**
3. Import your `crm-frontend` repo
4. Vercel auto-detects Vite — settings will be:
   - Framework: **Vite**
   - Build Command: `npm run build`
   - Output Directory: `dist`
5. Under **Environment Variables**, add:

   | Key | Value |
   |-----|-------|
   | `VITE_API_URL` | `https://crm-backend.onrender.com/api/v1` |

6. Click **Deploy**

7. Wait ~1-2 minutes

8. Your frontend will be live at:
   ```
   https://crm-frontend.vercel.app
   ```

---

## PART 3 — Connect Frontend URL to Backend CORS

After you get your Vercel URL:

1. Go to Render dashboard → `crm-backend` → Environment
2. Add one more variable:

   | Key | Value |
   |-----|-------|
   | `FRONTEND_URL` | `https://crm-frontend.vercel.app` |

3. Render will auto-redeploy — takes ~1 min

---

## ✅ Final Checklist

- [ ] Backend live at `https://crm-backend.onrender.com`
- [ ] `GET /up` returns `OK`
- [ ] Frontend live at `https://crm-frontend.vercel.app`
- [ ] Can log in with `agent1@crm.com / password123`
- [ ] Dashboard loads with charts
- [ ] Can create a contact, deal, and activity

---

## ⚠️ Free Tier Limitations

| Service | Limitation | Workaround |
|---------|-----------|------------|
| Render (backend) | Spins down after 15 min inactivity — first request takes ~30s | Expected on free tier |
| Render (DB) | 90-day free PostgreSQL | Upgrade to $7/mo when needed |
| Vercel (frontend) | 100GB bandwidth/month | More than enough |

---

## 🔗 Share with Client

Once deployed, share these two links:
- **Live App:** `https://crm-frontend.vercel.app`
- **API Docs:** Share the Postman collection from `CRM_API.postman_collection.json`
- **Backend Repo:** `https://github.com/YOUR_USERNAME/crm-backend`
- **Frontend Repo:** `https://github.com/YOUR_USERNAME/crm-frontend`
