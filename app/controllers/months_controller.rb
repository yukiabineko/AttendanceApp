class MonthsController < ApplicationController
  def update
    @month = Month.find( params[:id] )
    if @month.update_attributes(month_parameter)
       redirect_to user_path(@month.user, params:{first_day: params[:first_day]}),notice: "申請しました。"
    else
      redirect_to user_path(@month.user, params:{first_day: params[:first_day]}),notice: "申告先を選択してください。"
    end    
  end

  #上長一ヶ月申請依頼処理
  def response_superior
    @user = User.find( params[:id] )
    months_parameters.each do |id, item|
      if item[:check] == '1'
        month = Month.find id
        month.update_attributes(item)
      end
    end
    redirect_to user_url(@user,params:{first_day: params[:day]}),notice: '申請処理しました。'
  end
  

private
  def month_parameter
    params.require(:month).permit(:permit_month, :superior_name)
  end

  def months_parameters
    params.require(:user).permit(months:[:permit_month, :check])[:months]
  end
end
