class AuthController < ApplicationController
  def logout
    render file: 'public/401.html', status: :unauthorized
  end
end