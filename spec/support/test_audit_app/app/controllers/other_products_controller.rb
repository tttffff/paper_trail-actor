# Bad class name.
# This is controller to create a product that allows setting the current user to other potential cases.

class OtherProductsController < ApplicationController
  def create
    Product.create!(name: params[:name], price_in_cents: params[:price_in_cents])
    head :ok
  end

  private

  def current_user
    return Admin.new if session[:other_item] == "new_admin"
    Job.new if session[:other_item] == "job"
  end
end
