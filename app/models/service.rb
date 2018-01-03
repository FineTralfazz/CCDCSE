class Service < ApplicationRecord
  has_many :checks
  after_initialize :init

  def init
    self.consecutive_fails  ||= 0
  end

  def address(team)
    self.address_format.sub('?', team.number.to_s)
  end
end
