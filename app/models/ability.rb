# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Blog, Blog.published, &:published?
    if user&.admin?
      can :manage, :all
    elsif user.present?
      can :manage, Blog, user_id: user.id
      can :manage, User, id: user.id
    end
  end
end
