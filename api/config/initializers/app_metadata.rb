Rails.application.config.x.app_metadata = {
  project: ENV.fetch("APP_PROJECT_NAME", "Mercado API"),
  version: ENV.fetch("APP_VERSION", "1.0.0"),
  environment: Rails.env,
  status: "operational",
  documentation_url: ENV.fetch("APP_DOCUMENTATION_URL", nil),
  support_contact: ENV.fetch("APP_SUPPORT_CONTACT", "suporte@seudominio.com")
}
