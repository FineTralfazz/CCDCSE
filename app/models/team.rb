class Team < ApplicationRecord
  has_many :checks, dependent: :destroy
  has_many :users, dependent: :destroy
  after_initialize :init

  def init
    self.points = 0 if self.points == nil
  end
end
