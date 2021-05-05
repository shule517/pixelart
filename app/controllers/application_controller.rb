class ApplicationController < ActionController::Base
  if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
  end

  def render_404
    render template: 'errors/404'
  end
end
