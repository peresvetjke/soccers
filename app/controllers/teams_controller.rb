class TeamsController < ApplicationController
  expose :teams, ->{ Team.all }
  expose :team

  def index

  end
end