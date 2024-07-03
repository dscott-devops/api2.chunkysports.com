class Game < ApplicationRecord
  before_create :createindex
  belongs_to :source
  validates :eventname, presence: true
  validates :teamname, presence: true

  def createindex
    index = self.eventname + self.teamname
    index = index.downcase
    index = index.gsub(" ", "")
    self.gameindex = index
  end
end
