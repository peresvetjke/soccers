class MatchesController < ApplicationController
  
  before_action :find_matches, only: :index

  def index
    respond_to do |format|
      format.html
      format.json { render json: Match.with_titles(@matches) }
    end
  end

  private

  def find_matches
    @matches = Match.includes([:league, :home_team, :away_team]).all
    
    @matches = @matches.top(params[:rating]) if params[:rating].present?
    @matches = @matches.where(league_id: params[:league_id]) if params[:league_id].present?
    @matches = @matches.or(Match.matches_of_favorites_by_user(current_user)) if params[:include_favorites].present?
  end
end