class Gender

  def self.all
    [0,1].each.map do |id|
      Gender.new(id)
    end
  end

  def self.id (name)
    self.names.each_with_index do |gender_name, index|
      if (gender_name == name)
        return index
      end
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

  def to_s
    name
  end

protected
  def self.names
    [I18n.t('team.gender.boys'), I18n.t('team.gender.girls')]
  end
end