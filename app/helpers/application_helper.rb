module ApplicationHelper
  def user_label(user)
    if user.nil?
      result = ""
    elsif user.profile && !user.profile.organization_name.blank?
      web_url = user.profile.organization_url || user.profile.website_address
      if !web_url.blank?
        if !(web_url.match /^http/)
          web_url = "http://" + web_url
        end
        result = link_to user.profile.organization_name, web_url, :target => :blank
      else
        result = user.profile.organization_name
      end
    elsif user.profile && !user.profile.firstname.blank?
      result = user.profile.firstname
      if !user.profile.lastname.blank?
        result += " " + user.profile.lastname
      end
    else
      result = user.username
    end
    return result
  end

  def organization_label(user)
    if user.nil?
      result = ""
    elsif user.profile && !user.profile.organization_name.blank?
      if !user.profile.organization_url.blank?
        result = link_to user.profile.organization_name, user.profile.organization_url, :target => :blank
      else
        result = user.profile.organization_name
      end
    else
      result = ""
    end
    return result
  end

  def asset_url asset
    "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
  end
end
