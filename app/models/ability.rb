class Ability
  include CanCan::Ability

  def initialize(user)

    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    can :read, :all
    can :manage, Favorite
    user.roles.each do |role|
        send(role.name)
    end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def admin
    can :manage, :all
    can :approve, :all
  end

  def trailblazer
    can :approve, :all
    can :manage, Trip
    can :manage, Trailhead
    can :manage, Campground
    can :manage, Photo
    can :manage, Map
  end

  def baynature_trailblazer
    trailblazer
  end

  def agency_trailblazer
    trailblazer
    can :override_park, Trailhead
    can :override_agency, Trailhead
    can :override_non_profit_partner, Trailhead
  end

  def baynature_admin
    baynature_trailblazer
  end
end
