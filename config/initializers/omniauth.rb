Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.credentials.github.token,
                    Settings.credentials.github.secret
end
