class WorkUnitsController < ApplicationController
  before_filter :authenticate_user!


  def average
    @start_date  = params[:start_date].to_a.map{ |e| e[1] }.join("-").to_date
    @end_date    = params[:end_date].to_a.map{|e| e[1] }.join("-").to_date
    @work_units  = total_work_units_custom(@start_date, @end_date)
    @days_worked = total_days_worked_custom(@start_date, @end_date)
    @day_diff    = ((@end_date.to_time(:utc) - @start_date.to_time(:utc)) / (24*60*60) + 1).to_i
    @average = begin
      (@work_units / @days_worked)
    rescue ZeroDivisionError
      0
    end
  end

  def new_average
  end

  def index
    @average_per_day_this_month = average_work_units_current_month
    @worked_days = days_worked_this_month
    @work_units_this_month = total_work_units_this_month
    @days_in_month = (Date.new(Time.now.year, 12, 31).to_date << (12-Date.current.month)).day
    if current_user
      @work_units = current_user.work_units
    else
      redirect_to new_user_session_path, :alert => 'Login to see your work units.'
    end
  end

  def show
    @work_unit = WorkUnit.find params[:id]
  end

  def new
    @work_unit = WorkUnit.new params[:work_unit]
  end

  def create
    @work_unit = WorkUnit.new params[:work_unit]
    @work_unit.user = current_user
    if @work_unit.save
      redirect_to work_units_path, :notice => "Work unit created."
    else
      redirect_to create_work_unit_path, :notice => "Failed to create work unit."
    end
  end

  def edit
    @work_unit = WorkUnit.find params[:id]
  end

  def update
    @work_unit = WorkUnit.find params[:id]
    if @work_unit.update_attributes params[:work_unit]
      redirect_to work_units_path, :notice => "Work unit updated."
    else
      redirect_to work_unit_path(@work_unit), :alert => "Failed to update work unit."
    end
  end

  def destroy
    @work_unit = WorkUnit.find params[:id]
    if @work_unit.destroy
      redirect_to work_units_path, :notice => "Work unit deleted."
    else
      redirect_to work_unit_path(@work_unit), :alert => "Failed to delete work unit."
    end
  end

end
