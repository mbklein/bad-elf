class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?

    can :read, User do |u|
      user == u or user.elf_assignments.collect(&:recipient).include?(u)
    end
    can :update, User, :id => user.id

    if user.persisted?
      can :join, Exchange
      can :create, Exchange
    end
    can :update, Exchange, :owner_id => user.id
    can :read, Exchange do |exchange|
      exchange.participating?(user)
    end
  end
end
