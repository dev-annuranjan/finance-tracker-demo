class FriendshipsController < ApplicationController
  def create
    new_friend = params[:friend]
    begin
      Friendship.create(user_id: current_user.id, friend_id: params[:friend][:id]).save
      flash[:success] = "You are now following #{new_friend[:full_name]}"
    rescue
      flash[:error] = "#{new_friend[:full_name]} couldn't be added"
    ensure
      redirect_to my_friends_path
    end

  end

  def destroy
    begin
      friend = User.find(params[:id])
      Friendship.where( friend_id: friend.id).first.destroy
      flash[:success] = "Friend unfollowed successfully"
    rescue StandardError => e
      puts e.message
      flash[:alert] = "Friend couldn't be destroyed"
    ensure
      redirect_to my_friends_path
    end
  end
end
