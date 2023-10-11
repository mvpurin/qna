# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    guest_abilities
    return unless user.present?
    user_abilities(user)
    return unless user.admin?
    admin_abilities
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :me, User, id: user.id
    can :all, User
    can :subscribe, Question
    
    can :destroy, ActiveStorage::Attachment do |file|
      file.record.user_id == user.id
    end

    can :destroy, Link do |link|
      link.linkable.user_id == user.id
    end
    
    can :vote_for, [Question, Answer] do |res|
      res.user_id != user.id
    end
    
    can :vote_against, [Question, Answer] do |res|
      res.user_id != user.id
    end
  end
end
