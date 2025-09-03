# Configure session store
Rails.application.config.session_store :cookie_store, 
  key: '_mexe_session',
  expire_after: 2.weeks,
  secure: Rails.env.production?,
  same_site: :lax