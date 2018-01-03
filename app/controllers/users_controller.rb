class UsersController < ApplicationController
  def index
    @teams = Team.all
  end

  def upload
    if request.post?
      path = "/tmp/#{ rand(36**10).to_s(36) }.csv"
      File.open(path, 'wb') do |file|
        file.write(params[:file].read())
      end
      CSV.foreach path do |row|
        user = User.find_or_create_by team_id: params[:team_id], name: row[0].strip
        user.password = row[1].strip
        user.save
      end
      File.delete(path)
      redirect_to '/users', notice: "Uploaded users."
    else
      @team = Team.find params[:team_id]
    end
  end
end
