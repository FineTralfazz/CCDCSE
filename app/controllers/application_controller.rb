class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_auth

  def require_auth
    authenticate_or_request_with_http_basic do |name, password|
      name == 'admin' && password == ENV['CCDCSE_ADMIN_PASSWORD']
    end
  end
end
