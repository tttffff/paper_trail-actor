class ProductsController < ApplicationController
  def create
    Product.create!(name: params[:name], price_in_cents: params[:price_in_cents])
    head :ok
  end

  private

  def current_user
    # Even if session[:brand_id] it nil, instantiate a brand.
    # Only retrun nil from this method when session does not have a :brand_id key
    Brand.find(session[:brand_id]) if session[:brand_id]
  end
end
