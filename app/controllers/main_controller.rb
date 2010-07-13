class MainController < ApplicationController
  def index
    unless logged_in?
      redirect_to login_url
    end
  end
end
