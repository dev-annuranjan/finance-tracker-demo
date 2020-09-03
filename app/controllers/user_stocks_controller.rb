class UserStocksController < ApplicationController
  def create
    stock = Stock.find_stock_by_symbol params[:ticker]
    if stock.blank?
      stock = Stock.create(ticker: params[:ticker], name: params[:name], last_price: params[:last_price])
      stock.save
      @user_stock = UserStock.create(user: current_user, stock: stock).save
      flash[:notice] = "Stock #{stock.ticker} successfully added to portfolio"
    else
      @user_stock = UserStock.where(stock_id: stock.id, user_id: current_user.id).first
      stock.last_price = params[:last_price]
      stock.save
      if @user_stock.present?
        flash[:notice] = "You are already tracking this stock"
      else
        @user_stock = UserStock.create(user: current_user, stock: stock).save
        flash[:notice] = "Stock #{stock.ticker} was successfully added to portfolio"
      end
    end
    redirect_back(fallback_location: my_portfolio_path)
  end

  def destroy
    stock = Stock.find(params[:id])
    UserStock.where(stock_id: params[:id], user_id: current_user.id ).first.destroy
    flash[:success] = "#{stock.name} was successfully removed from your portfolio"
    redirect_to my_portfolio_path
  end
end
