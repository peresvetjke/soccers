

class RatingsParser
  
  attr_reader :rating_infos
  attr_accessor :result

  def initialize(rating_infos)
    @rating_infos = rating_infos
    @result = { updated: [], not_found: [] }
  end

  def call
    self.rating_infos.each do |rating_info|
      #binding.pry
      team = TeamAlias.find_team_by_title(rating_info[:title]) || Team.find_by(title: rating_info[:title])
      if team.present?
        team.assign_attributes(rating: rating_info[:rating], rating_points: rating_info[:rating_points])
        if team.changed?
          team.save!
          self.result[:updated] << team.title
        end
      else
        self.result[:not_found] << rating_info[:title]
      end
    end
    self.result
  end
end

=begin
    [
      {:title=>"Аталанта", :rating=>24},
      {:title=>"Манчестер Юн.", :rating=>9}
    ]
=end