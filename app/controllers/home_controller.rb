# Home page controller
class HomeController < ApplicationController
  include Concerns::Languages

  # GET /home/index
  def index
    return unless params.key?(:q)
    @results = search(params[:q]).map { |r| r[:name] }
  end
end
