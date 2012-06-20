class UsersController < ApplicationController
  def index
    render :json => { :hello => 'world' }
  end

  def show
    render :json => params
  end

  def create
    render :json => params
  end

  def update
    render :json => params
  end

  def destroy
    render :json => params
  end
end
