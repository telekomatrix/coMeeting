class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # ensure locale persists
  def default_url_options(options={})
    {:locale => I18n.locale == I18n.default_locale ? nil : I18n.locale}
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end
end