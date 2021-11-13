class League < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true

  def scrap_schedule!
    raise ArgumentError if self.url.nil?
    ms = MatchesScrapper.new(self.url)
    ms.call
  end
end
