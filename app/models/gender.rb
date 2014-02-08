class Gender

  def self.all
    [0,1].each.map do |id|
      Gender.new(id)
    end
  end

  def initialize(id)
    @id = id
  end

  def id
    @id
  end

  def name
    Gender.names[@id]
  end

protected
  def self.names
    [I18n.t('team.gender.boys'), I18n.t('team.gender.girls')]
  end
end