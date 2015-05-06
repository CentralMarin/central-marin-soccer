module ContactHelper
  def contact_name(name)
    if name.blank?
      "Open"
    else
      name
    end
  end
end
