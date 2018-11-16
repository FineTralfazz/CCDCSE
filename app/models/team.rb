class Team < ApplicationRecord
  has_many :checks
  has_many :users
  after_initialize :init

  def init
    self.points = 0
  end
end
