class TeamsController < ApplicationController

  before_action :find_team, only: %i[add_to_favorites remove_from_favorites]
  before_action :find_teams, only: :index

  def index

  end

  def add_to_favorites
    @team.add_to_favorites!(current_user)
    redirect_to teams_path
  end

  def remove_from_favorites
    @team.remove_from_favorites!(current_user)
    redirect_to teams_path
  end

  private

  def find_team
    @team = Team.find(params[:id])
  end

  def find_teams
    @teams = Team.all

    if params[:rating].present?
      @teams = @teams.top(params[:rating])
    end
  end
end