class League < ApplicationRecord
  validates :title, presence: true
  validates :title, uniqueness: true


  def scrap_schedule!
    raise ArgumentError if self.url.nil?

    ms = MatchesScrapper.new(base_url: self.url, m_from: -2, m_to: 2)
    ms.call
  end
end
