class Service < ApplicationRecord
  has_many :checks
  after_initialize :init

  def address(team)
    self.address_format.sub('?', team.number.to_s)
  end
end
