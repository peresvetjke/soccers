class TeamsController < ApplicationController

  before_action :find_teams, only: :index

  def index

  end

  private

  def find_teams
    @teams = Team.all

    if params[:rating].present?
      @teams = @teams.top(params[:rating])
    end
  end
end