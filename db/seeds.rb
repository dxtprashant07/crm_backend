puts "🌱 Seeding CRM database..."

# ── Users ─────────────────────────────────────────────────────────────────────
admin = User.find_or_create_by!(email: "admin@crm.com") do |u|
  u.name     = "Admin User"
  u.password = "password123"
  u.role     = :admin
end

manager = User.find_or_create_by!(email: "manager@crm.com") do |u|
  u.name     = "Sales Manager"
  u.password = "password123"
  u.role     = :manager
end

agent1 = User.find_or_create_by!(email: "agent1@crm.com") do |u|
  u.name     = "Prashant Dixit"
  u.password = "password123"
  u.role     = :agent
end

agent2 = User.find_or_create_by!(email: "agent2@crm.com") do |u|
  u.name     = "Riya Sharma"
  u.password = "password123"
  u.role     = :agent
end

puts "  ✅ #{User.count} users"

# ── Companies ─────────────────────────────────────────────────────────────────
companies_data = [
  { name: "TechNova Solutions",   industry: "Software",        city: "Bangalore",  country: "India",  size: :large,      website: "https://technova.io" },
  { name: "Infra Systems Ltd",    industry: "IT Services",     city: "Mumbai",     country: "India",  size: :enterprise, website: "https://infrasys.com" },
  { name: "GreenLeaf Analytics",  industry: "Data Analytics",  city: "Hyderabad",  country: "India",  size: :medium,     website: "https://greenleaf.ai" },
  { name: "SwiftPay Fintech",     industry: "Fintech",         city: "Pune",       country: "India",  size: :startup,    website: "https://swiftpay.in" },
  { name: "MediCore Health",      industry: "Healthcare",      city: "Chennai",    country: "India",  size: :medium,     website: "https://medicore.in" },
  { name: "EduBridge Online",     industry: "EdTech",          city: "Delhi",      country: "India",  size: :small,      website: "https://edubridge.co" },
  { name: "LogiTrack Corp",       industry: "Logistics",       city: "Kolkata",    country: "India",  size: :large,      website: "https://logitrack.com" },
  { name: "CloudNine Hosting",    industry: "Cloud Services",  city: "Noida",      country: "India",  size: :medium,     website: "https://cloudnine.io" },
]

companies = companies_data.map do |data|
  Company.find_or_create_by!(name: data[:name]) do |c|
    c.assign_attributes(data)
  end
end

puts "  ✅ #{Company.count} companies"

# ── Contacts ──────────────────────────────────────────────────────────────────
contacts_data = [
  { first_name: "Arjun",   last_name: "Mehta",    email: "arjun.mehta@technova.io",    phone: "9810001001", job_title: "CTO",             status: :customer,  source: :referral,      company: companies[0] },
  { first_name: "Sneha",   last_name: "Patil",    email: "sneha.patil@infrasys.com",   phone: "9820001002", job_title: "Procurement Head", status: :prospect,  source: :cold_outreach, company: companies[1] },
  { first_name: "Rahul",   last_name: "Verma",    email: "rahul.v@greenleaf.ai",       phone: "9830001003", job_title: "CEO",              status: :lead,      source: :website,       company: companies[2] },
  { first_name: "Pooja",   last_name: "Singh",    email: "pooja.singh@swiftpay.in",    phone: "9840001004", job_title: "VP Engineering",   status: :customer,  source: :event,         company: companies[3] },
  { first_name: "Kiran",   last_name: "Nair",     email: "kiran.nair@medicore.in",     phone: "9850001005", job_title: "IT Manager",       status: :prospect,  source: :social_media,  company: companies[4] },
  { first_name: "Amit",    last_name: "Joshi",    email: "amit.joshi@edubridge.co",    phone: "9860001006", job_title: "Director",         status: :lead,      source: :referral,      company: companies[5] },
  { first_name: "Priya",   last_name: "Kapoor",   email: "priya.k@logitrack.com",      phone: "9870001007", job_title: "Operations Head",  status: :customer,  source: :website,       company: companies[6] },
  { first_name: "Vikram",  last_name: "Rao",      email: "vikram.rao@cloudnine.io",    phone: "9880001008", job_title: "Founder",          status: :prospect,  source: :cold_outreach, company: companies[7] },
  { first_name: "Neha",    last_name: "Gupta",    email: "neha.gupta@gmail.com",       phone: "9890001009", job_title: "Independent",      status: :lead,      source: :website,       company: nil },
  { first_name: "Suresh",  last_name: "Iyer",     email: "suresh.iyer@techcorp.com",   phone: "9900001010", job_title: "CIO",              status: :churned,   source: :event,         company: nil },
]

contacts = contacts_data.map do |data|
  Contact.find_or_create_by!(email: data[:email]) do |c|
    c.assign_attributes(data)
  end
end

puts "  ✅ #{Contact.count} contacts"

# ── Deals (idempotent by title) ───────────────────────────────────────────────
deals_data = [
  { title: "TechNova – Enterprise License",    value: 450000, stage: "closed_won",    probability: 100, contact: contacts[0], company: companies[0], owner: agent1, expected_close_date: 30.days.ago },
  { title: "Infra Systems – Support Contract", value: 180000, stage: "negotiation",   probability: 75,  contact: contacts[1], company: companies[1], owner: agent1, expected_close_date: 15.days.from_now },
  { title: "GreenLeaf – Analytics Suite",      value: 95000,  stage: "proposal",      probability: 50,  contact: contacts[2], company: companies[2], owner: agent2, expected_close_date: 30.days.from_now },
  { title: "SwiftPay – API Integration",       value: 220000, stage: "closed_won",    probability: 100, contact: contacts[3], company: companies[3], owner: agent2, expected_close_date: 45.days.ago },
  { title: "MediCore – Health Data Platform",  value: 310000, stage: "qualification", probability: 25,  contact: contacts[4], company: companies[4], owner: agent1, expected_close_date: 60.days.from_now },
  { title: "EduBridge – LMS Deployment",       value: 75000,  stage: "prospecting",   probability: 10,  contact: contacts[5], company: companies[5], owner: agent2, expected_close_date: 90.days.from_now },
  { title: "LogiTrack – Fleet Management",     value: 530000, stage: "closed_won",    probability: 100, contact: contacts[6], company: companies[6], owner: manager, expected_close_date: 60.days.ago },
  { title: "CloudNine – Hosting Plan",         value: 48000,  stage: "proposal",      probability: 50,  contact: contacts[7], company: companies[7], owner: agent1, expected_close_date: 20.days.from_now },
  { title: "Neha Gupta – Consulting",          value: 25000,  stage: "closed_lost",   probability: 0,   contact: contacts[8], company: nil,          owner: agent2, expected_close_date: 20.days.ago },
  { title: "Suresh Iyer – Renewal",            value: 140000, stage: "negotiation",   probability: 75,  contact: contacts[9], company: nil,          owner: manager, expected_close_date: 10.days.from_now },
]

deals = deals_data.map do |data|
  Deal.find_or_create_by!(title: data[:title]) do |d|
    d.assign_attributes(data)
  end
end

puts "  ✅ #{Deal.count} deals"

# ── Activities (idempotent by subject) ────────────────────────────────────────
activity_seeds = [
  { activity_type: "call",    subject: "Intro call with Arjun Mehta",         contact: contacts[0], deal: deals[0],  user: agent1,   completed: true,  created_at: 10.days.ago },
  { activity_type: "email",   subject: "Sent proposal to Sneha Patil",        contact: contacts[1], deal: deals[1],  user: agent1,   completed: true,  created_at: 7.days.ago },
  { activity_type: "meeting", subject: "Product demo – GreenLeaf Analytics",  contact: contacts[2], deal: deals[2],  user: agent2,   completed: true,  created_at: 5.days.ago },
  { activity_type: "call",    subject: "Follow-up with Pooja Singh",          contact: contacts[3], deal: deals[3],  user: agent2,   completed: true,  created_at: 4.days.ago },
  { activity_type: "email",   subject: "Sent contract to MediCore",           contact: contacts[4], deal: deals[4],  user: agent1,   completed: false, created_at: 3.days.ago },
  { activity_type: "task",    subject: "Prepare custom proposal for EduBridge", contact: contacts[5], deal: deals[5], user: agent2,  completed: false, created_at: 2.days.ago },
  { activity_type: "meeting", subject: "Quarterly review – LogiTrack",        contact: contacts[6], deal: deals[6],  user: manager,  completed: true,  created_at: 1.day.ago },
  { activity_type: "note",    subject: "CloudNine needs 2-week eval period",  contact: contacts[7], deal: deals[7],  user: agent1,   completed: true,  created_at: 6.hours.ago },
  { activity_type: "call",    subject: "Re-engagement call – Suresh Iyer",    contact: contacts[9], deal: deals[9],  user: manager,  completed: false, created_at: 1.hour.ago },
  { activity_type: "email",   subject: "Welcome email sent to new customer",  contact: contacts[0], deal: nil,       user: admin,    completed: true,  created_at: 12.days.ago },
]

activity_seeds.each do |data|
  Activity.find_or_create_by!(subject: data[:subject]) do |a|
    a.assign_attributes(data)
  end
end

puts "  ✅ #{Activity.count} activities"

puts ""
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "✅  Seeding complete!"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts ""
puts "🔐  Test Credentials:"
puts "    Admin:   admin@crm.com   / password123"
puts "    Manager: manager@crm.com / password123"
puts "    Agent:   agent1@crm.com  / password123"
puts ""
puts "🌐  Start server: rails server"
puts "    Base URL:      http://localhost:3000/api/v1"
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
