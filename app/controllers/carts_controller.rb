class CartsController < ApplicationController
  def show
    render json: manager.serialize, status: :ok
  end

  def create
    add_product_and_respond
  end

  def add_item
    add_product_and_respond
  end

  def remove_item
    manager.remove_product(params[:product_id])
    render json: manager.serialize, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def manager
    @manager ||= CartManager.new(session)
  end

  def add_product_and_respond
    manager.add_product(params[:product_id], params[:quantity].to_i)
    render json: manager.serialize, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
