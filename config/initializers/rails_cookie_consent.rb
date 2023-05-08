RailsCookieConsent.configure do |config|
  # check RailsCookieConsent::DEFAULT_CONFIG for options
  config.cookie_types = [
    { value: 'necessary', readonly: true, enabled: true, required: true },
    { value: 'required', readonly: false, enabled: false, required: false }
  ]
end
