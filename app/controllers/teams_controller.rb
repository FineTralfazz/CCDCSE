class TeamsController < ApplicationController
    def index
        @teams = Team.all
    end

    def new
    end

    def create
        Team.create teams_params
        redirect_to teams_path, notice: "Team created."
      end
    
      def destroy
        Team.find(params[:id]).destroy
        redirect_to teams_path, notice: "Team deleted."
      end
    
      private
      def teams_params
        params.permit :number
      end
end
