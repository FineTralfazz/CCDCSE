class Team < ApplicationRecord
  has_many :checks
  has_many :users
end
