class StocksController < ApplicationController

  def search
    if params[:stock].present?
      @searched_stock = Stock.lookup params[:stock]
      if @searched_stock
        respond_to do |format|
          format.js { render partial: "users/results" }
        end
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a valid symbol."
          format.js { render partial: "users/results" }
        end
      end
    else
      respond_to do |format|
        flash.now[:alert] = "Please enter a symbol to search."
        format.js { render partial: "users/results" }
      end
    end
  end

end
