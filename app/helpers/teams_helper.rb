module TeamsHelper
  def coach members
    find_position(members, 'coach')
  end

  def manager members
    find_position(members, 'manager')
  end

  protected
  def find_position(members, position)
    members.each do |member|
      if not member['is_player'] and not member['position'].blank? and member['position'].casecmp(position) == 0
        return member['name']
      end
    end

    return "TBD"

  end
end
