class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  validates :first_name, :last_name, :email, presence: true
  # validates :password, presence: true, only: []

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search_user search_term, current_user_id
    search_term = search_term.strip
    # @terms = search_term.split(" ")
    # search_length = @terms.count
    # if search_length == 1
      return exclude_self(where("first_name LIKE ?", "%#{search_term}%" )
        .or(where("last_name LIKE ?", "%#{search_term}%" ))
        .or(where("email LIKE ?", "%#{search_term}%" )).all, current_user_id)
    # else
    #   return where( :conditions => [(["first_name LIKE? OR last_name LIKE ? OR email LIKE ?"] * search_length).join(' AND ')] + search_term.split.map { |name| "%#{name}%" })
    # end
  end

  def self.search_user_by_id user_id
    find(user_id)
  end

  def user_is_tracking? ticker
    stock = Stock.where(ticker: ticker).first
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def stock_count_under_limit?
    stocks.count < 10
  end

  def can_track_stock? ticker
    stock_count_under_limit? && !user_is_tracking?(ticker)
  end

  def already_a_friend? f_id
    friends.where(id: f_id).exists?
  end

  def self.exclude_self users, current_user_id
    users.reject { |user| user.id === current_user_id }
  end
end
