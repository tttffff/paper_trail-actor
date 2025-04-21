module TestAuditApp
  class Application < Rails::Application
  end
end

TestAuditApp::Application.configure do
  config.eager_load = false
end

TestAuditApp::Application.initialize!
