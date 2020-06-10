module ApplicationHelper

  def absolute_url_for(options = {})
      url_for(options.merge(Rails.configuration.x.absolute_url_options || {}))
  end

end