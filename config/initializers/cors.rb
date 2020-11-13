Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:3000'
  
      resource '*',
               headers: :any,
               methods: %i[get post put patch delete options head],
               credentials: true,
               expose: %w[access-token uid client expiry]
    end
  end