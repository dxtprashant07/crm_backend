Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow localhost in development and your Vercel app in production
    # After deploying frontend, replace the Vercel URL below with your actual URL
    origins(
      "http://localhost:5173",
      "http://localhost:3000",
      /\Ahttps:\/\/.*\.vercel\.app\z/,           # any Vercel preview URL
      ENV.fetch("FRONTEND_URL", "")               # set this in Render dashboard
    )

    resource "*",
      headers: :any,
      expose:  ["Authorization"],
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
