class Admin::StatisticsController < ApplicationController
  layout "admin"

  authorize_resource class: Admin::StatisticsController

  def index; end

  def accounts
    render json: Account.customer.group_by_month(:created_at).count
  end

  def revenue
    render json: Order.finished.group_by_month(:created_at).sum(:total_price)
  end

  def staffs
    render json: Account.staff.group_by_month(:created_at).count
  end

  def reviews
    render json: Review.group_by_month(:created_at).count
  end
end
