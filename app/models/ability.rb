class Ability

  include CanCan::Ability

  def initialize(user)
    @user = user || User.new # for guest
    @user.roles.each { |role| send(role) }

    if @user.roles.size == 0
      can :read, :all #for guest without roles
    end
  end

  def team_manager
    #can :manage, Employee
  end

  def admin
    can :manage, :all
  end

  def board_member
  end

  def field_manager
  end

  def parent
  end

  def player
  end

  def coach

  end
end