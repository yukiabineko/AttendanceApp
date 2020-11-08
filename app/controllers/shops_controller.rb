class ShopsController < ApplicationController
  def index
    @shop = Shop.new
  end

  def create
    
  end
  
private
  def shop_parameter
    params.require(:shop).permit(:number, :name, :category)
  end
  
end
