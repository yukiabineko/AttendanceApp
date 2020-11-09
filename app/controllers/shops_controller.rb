class ShopsController < ApplicationController
  before_action :set_shop, only:[:edit]
  
  def index
    @shop = Shop.new
    @shops = Shop.all
  end

  def create
    @shop = Shop.new(shop_parameter)
  
    if @shop.save
      redirect_to shops_path, notice: '拠点を追加しました。'
    else
      render :index
    end
  end

  def edit
    
  end
  
  
private
  def shop_parameter
    params.require(:shop).permit(:number, :name, :category)
  end

  def set_shop
    @shop = Shop.find( params[:id] )
  end
  
end
