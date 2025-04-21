class OrdersController < ApplicationController
  def update
    @order = Order.find(params[:id])
    @order.update!(order_number: params[:order_number])
    head :ok
  end

  private

  def current_user
    Admin.find_by(id: session[:admin_id]) || "Public user"
  end
end
