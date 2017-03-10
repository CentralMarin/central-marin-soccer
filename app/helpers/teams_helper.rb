module TeamsHelper
  def team_name team
    "#{team['year']} #{team['gender']} #{team['level']}"
  end

  protected

  def find_position(members, position)

    logger.info "Find_position"

    results = []
    members.each do |member|
      if not member['is_player'] and not member['position'].blank?

        member['position'].downcase!
        if member['position'].include? position
          results << "#{member['name']} - #{member['position']}"
        end
      end
    end

    if results.length == 0
      results << "TBD - #{position.humanize}"
    end

    logger.info results
    results
  end
end
