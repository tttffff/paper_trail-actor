# Bad class name.
# This is controller to update a product that overwrites user_for_paper_trail to show that it is respected.

class OtherOrdersController < ApplicationController
  def update
    @order = Order.find(params[:id])
    @order.update!(order_number: params[:order_number])
    head :ok
  end

  def user_for_paper_trail
    "Other order controller"
  end

  private

  def current_user
    raise "Should never be called"
  end
end
