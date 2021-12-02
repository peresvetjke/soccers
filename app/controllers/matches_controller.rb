class MatchesController < ApplicationController
  before_action :authenticate_user!, only: %i[add_to_tracked remove_from_tracked]  
  before_action :find_matches, only: :index
  before_action :find_tracked, only: :index
  before_action :find_match,   only: %i[add_to_tracked remove_from_tracked]

  def index
    
  end

  def tracked
    @matches = Match.tracked_by_user(current_user)
    @tracked_ids = @matches.ids
    render :index
  end

  def add_to_tracked
    @match.add_to_tracked(current_user)
    respond_to do |format|
      format.json { render json: @match }
    end
  end

  def remove_from_tracked
    @match.remove_from_tracked(current_user)
    respond_to do |format|
      format.json { render json: @match }
    end
  end  

  private

  def find_match
    @match = Match.find(params[:id])
  end

  def find_matches
    @matches = Match.includes([:league, :home_team, :away_team]).all
    
    @matches = @matches.top(params[:rating]) if params[:rating].present?
    @matches = @matches.where(league_id: params[:league_id]) if params[:league_id].present?
    @matches = @matches.or(Match.matches_of_favorites_by_user(current_user)) if params[:include_favorites].present?
  end

  def find_tracked
    @tracked_ids = @matches.tracked_by_user(current_user).pluck(:match_id)
  end
end