Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001', 'http://localhost:3000', 'http://127.0.0.1:3001', 'http://127.0.0.1:3000', 'http://47.129.168.239', 'https://47.129.168.239',
              'http://47.129.168.239:80', 'http://47.129.168.239:3000',
              'https://47.129.168.239:80', 'https://47.129.168.239:3000'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      expose: ['access-token', 'expiry', 'token-type', 'Authorization']
  end
end 