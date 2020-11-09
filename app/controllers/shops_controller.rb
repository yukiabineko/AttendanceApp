class ShopsController < ApplicationController
  before_action :set_shop, only:[:edit, :update, :destroy,]
  
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

  def update
    if @shop.update_attributes(shop_parameter)
      redirect_to shops_path, notice: '拠点を編集しました。'
    else  
      render :index
    end  
  end

  def destroy
    @shop.destroy
    redirect_to shops_path, notice: '拠点を削除しました。'
  end
  
  
private
  def shop_parameter
    params.require(:shop).permit(:number, :name, :category)
  end

  def set_shop
    @shop = Shop.find( params[:id] )
  end
  
end
