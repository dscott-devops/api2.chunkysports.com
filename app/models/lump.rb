class Lump < ApplicationRecord
  belongs_to :source
  before_create :createindex
  has_many :comments
  has_many :clicks
  has_many_attached :images

  def createindex
    templink = self.link
    if templink.to_s.include?("https://")
      templink = templink.gsub("https://", "")
    else
      templink = templink.gsub("http://", "")
    end
    templink = templink.gsub("/",".")
    templink = templink.gsub("#comments","")
    self.lumpindex = templink
  end
end