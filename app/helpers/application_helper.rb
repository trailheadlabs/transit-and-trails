module ApplicationHelper
  def user_label(user)
    if user.nil?
      result = ""
    elsif user.profile && !user.profile.firstname.blank?
      result = user.profile.firstname
      if !user.profile.lastname.blank?
        result += " " + user.profile.lastname
      end
    elsif user.profile && !user.profile.organization_name.blank?
      result = user.profile.organization_name
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
        result = link_to user.profile.organization_name, user.profile.organization_url
      else
        result = user.profile.organization_name
      end
    else
      result = ""
    end
    return result
  end

end
