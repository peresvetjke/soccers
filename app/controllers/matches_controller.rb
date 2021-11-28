class MatchesController < ApplicationController
  
  before_action :find_matches, only: :index

  def index

  end

  private

  def find_matches
    @matches = Match.all
    
    if params[:rating].present?
      @matches = @matches.top(params[:rating])
    end
  end
end