class UsersController < ApplicationController
  def index
    @teams = Team.order(number: :asc).all
  end

  def upload
    team = Team.find_by number: params[:team_id]
    if request.post?
      path = "/tmp/#{ rand(36**10).to_s(36) }.csv"
      File.open(path, 'wb') do |file|
        file.write(params[:file].read())
      end
      CSV.foreach path do |row|
        user = User.find_or_create_by team: team, name: row[0].strip
        user.password = row[1].strip
        user.save
      end
      File.delete(path)
      redirect_to '/users', notice: "Uploaded users."
    else
      @team = Team.find_by number: params[:team_id]
    end
  end
end
