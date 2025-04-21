class PublicFacingController < ActionController::Base
  # Wouldn't normally call this unless a #current_user or an overwritten #user_for_paper_trail is available.
  # This file exists to test the ususual case where this is true.
  before_action :set_paper_trail_whodunnit

  def update_order
    @order = Order.find(params[:id])
    @order.update!(order_number: params[:order_number])
    head :ok
  end
end
