class TechniciansController < ApplicationController
  require "shellwords"

  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :technician_params, only: :create

  def index
    get_category_names
    @search_result = search(params)
    if params[:category] == "Todas las categorias"
      @technicians = Technician.all
    else
      @search_result
    end
  end

  def show
    @technician = Technician.find(params[:id])
  end


  # METHODS THAT ALLOW technician TO PUT HIMSELF ONLINE/OFFLINE

  def online
    @technician = Technician.find(params[:lawyer_id])
    @technician.is_online = true
    @technician.save
    render "update_online"
  end

  def offline
    @technician = Technician.find(params[:lawyer_id])
    @technician.is_online = false
    @technician.save
    render "update_online"
  end

  def new
    @technician = Technician.new
  end

  def create
    @technician = Technician.new
    @technician.user = current_user
    @technician.description = params['technician']['description']
    @technician.photo = params['technician']['photo']
    @technician.save
    # redirect_to url_stripe redirect somewhere
  end

  def stripe
    auth_code = params['code']
    api_key = ENV['STRIPE_SECRET_KEY']

    args = [ "-X", "POST",
         "-d", "client_secret=#{api_key}",
         "-d", "code=#{auth_code}",
         "-d", "grant_type=authorization_code",
         "https://connect.stripe.com/oauth/token" ]

    response = `curl #{args.shelljoin}`
    result = JSON.parse(response)
    technician = current_user.technician
    technician.stripe_id = result['stripe_user_id']
    technician.save

    # redirect
    flash[:notice] = "Stripe Account Correctly Linked"
    redirect_to technician_consultations_path(technician)
  end


  private

  def search(params)
    @technicians = Technician.all
    if params[:is_online].present?
      @technicians = @technicians.where(is_online: params[:is_online])
    end
    if params[:min_price].present?
      price_in_cents = params[:min_price].to_i * 100
      sql_query = "hourly_rate_cents > :query"
      @technicians = @technicians.where(sql_query, query: "#{price_in_cents}")
    end
    if params[:max_price].present?
      price_in_cents = params[:min_price].to_i * 100
      sql_query = "hourly_rate_cents < :query"
      @technicians = @technicians.where(sql_query, query: "#{price_in_cents}")
    end
    if params[:category].present?
      @technicians = @technicians.joins(:specialties).joins(:categories).where(categories: { name: params[:category] }).uniq
    end
    return @technicians
  end

  def get_category_names
    @category_names = []
    Category.all.each do |category|
      @category_names << category.name
    end
    return @category_names
  end

  def technician_params
    params.require(:technician).permit(:description, :years_of_experience, :hourly_rate, :is_first_consultation_free, :photo)
  end

end



