class UsersController < ApplicationController
  def my_portfolio
    @user_stocks = current_user.stocks
  end

  def my_friends
    @user_friends = current_user.friends
  end

  def search_friend
    self_id = current_user.id
    if params[:search_text].present?
      @searched_friends = User.search_user( params[:search_text], self_id)
      respond_to do |format|
        format.js { render partial: "users/friend_search" }
      end
    else
      flash.now[:alert] = "Enter a name or email to search"
      respond_to do |format|
        format.js { render partial: "users/friend_search" }
      end
    end
  end

  def show
    unless current_user.id.to_s == params[:id].to_s
      @friend = User.search_user_by_id(params[:id])
      @user_stocks = @friend.stocks
    else
      redirect_to my_portfolio_path
    end
  end
end
