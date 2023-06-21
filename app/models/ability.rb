# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Blog, Blog.published, &:published?
    can :read, Comment
    can :read, Category
    if user&.admin?
      can :manage, :all
    elsif user.present?
      can :manage, Blog, user_id: user.id
      can :manage, Comment, user_id: user.id
      can :manage, User, id: user.id
      can :read, ActiveAdmin::Page, name: 'Dashboard', namespace_name: 'admin'
    end
  end
end
