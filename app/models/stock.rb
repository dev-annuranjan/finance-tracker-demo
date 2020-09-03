class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.lookup ticker
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key],
      secret_token: Rails.application.credentials.iex_client[:api_token],
      endpoint: 'https://sandbox.iexapis.com/v1'
    )
    begin
      new(ticker: ticker.upcase, name: client.company(ticker).company_name, last_price: client.price(ticker))
    rescue
      return nil
    end
  end

  def self.find_stock_by_symbol ticker
    where(ticker: ticker).first
  end
end
