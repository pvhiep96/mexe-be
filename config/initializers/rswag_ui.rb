unless Rails.env.production?
  Rswag::Ui.configure do |config|
    config.openapi_endpoint '/api-docs/v1/openapi.yaml', 'API V1 Docs'
  end
end
