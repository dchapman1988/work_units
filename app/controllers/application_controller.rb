class ApplicationController < ActionController::Base
  protect_from_forgery

  def total_work_units_this_month
    start_date = Date.current.beginning_of_month
    end_date   = Date.current.end_of_month
    units = current_user.work_units.all(:order      => 'DATE(created_at) DESC',
                                        :group      => ["DATE(created_at)"],
                                        :conditions => ["created_at BETWEEN ? AND ?", start_date, end_date])
    n = []
    if units
      units.each do |u|
        n << u.number_of_units
      end
    end
    n.sum
  end

  def days_worked_this_month
    start_date = Date.current.beginning_of_month
    end_date   = Date.current.end_of_month
    units = current_user.work_units.count(:order      => 'DATE(created_at) DESC',
                                          :group      => ["DATE(created_at)"],
                                          :conditions => ["created_at BETWEEN ? AND ?", start_date, end_date])
    units.count
  end

  def average_work_units_current_month
    begin
      (total_work_units_this_month / days_worked_this_month)
    rescue ZeroDivisionError
      0
    end
  end

  def total_work_units_custom(start_date, end_date)
    unit_count = 0
    units = current_user.work_units.all(:order      => 'DATE(created_at) DESC',
                                        :group      => ["DATE(created_at)"],
                                        :conditions => ["created_at BETWEEN ? AND ?", start_date, end_date])
    units.each do |u|
      unit_count = unit_count + u.try(:number_of_units).to_i
    end
    unit_count
  end

  def total_days_worked_custom(start_date, end_date)
    units = current_user.work_units.count(:order      => 'DATE(created_at) DESC',
                                          :group      => ["DATE(created_at)"],
                                          :conditions => ["created_at BETWEEN ? AND ?", start_date, end_date])
    units.count
  end

end
