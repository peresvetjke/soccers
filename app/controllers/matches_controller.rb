class MatchesController < ApplicationController
  expose :matches, ->{ Match.all }
  expose :match


  def index

  end
end