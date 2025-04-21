# Session is used to set current_user in further requests.
# This is an alternative to mocking out the objects that we are ultimately testing against.

class SessionsController < ApplicationController
  def create
    session[:admin_id] = params[:admin_id]
    session[:brand_id] = params[:brand_id]
    session[:other_item] = params[:other_item]
  end
end
