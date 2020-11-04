class MonthsController < ApplicationController
  def update
    @month = Month.find( params[:id] )
    if @month.update_attributes(month_parameter)
       redirect_to user_path(@month.user, params:{first_day: params[:first_day]}),notice: "申請しました。"
    else
      redirect_to user_path(@month.user, params:{first_day: params[:first_day]}),notice: "申告先を選択してください。"
    end    
  end

private
  def month_parameter
    params.require(:month).permit(:permit_month, :superior_name)
  end
end
