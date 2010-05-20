# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  after_filter :flash_to_headers

  def flash_to_headers
    return unless request.xhr?
    [:notice, :warning, :message, :error].each do |f_type|
      response.headers["X-Message"] = {:type => f_type, :message => flash[f_type]}.to_json unless flash[f_type].blank?
    end
    flash.discard  # don't want the flash to appear when you reload page
  end
  
  def load_flash
    render :partial => "layouts/flash", :status => 204
  end
end
