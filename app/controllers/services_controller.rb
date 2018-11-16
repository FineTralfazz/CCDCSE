class ServicesController < ApplicationController
  http_basic_authenticate_with name: 'admin', password: ENV['CCDCSE_ADMIN_PASS'], except: :score_all

  def index
    @services = Service.all
  end

  def score_all
    Service.all.each do |service|
      Team.all.each do |team|
        CheckJob.perform_later service, team
      end
    end
    render html: 'Scoring tasks queued.'
  end

  def new
  end

  def create
    Service.create services_params
    redirect_to services_path, notice: "Service created."
  end

  def destroy
    Service.find(params[:id]).destroy
    redirect_to services_path, notice: "Service deleted."
  end

  private
  def services_params
    params.permit :name, :protocol, :address_format, :port, :arg1, :arg2
  end
end
