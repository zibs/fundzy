module ApplicationHelper
  def formatted_date_time(datetime)
    datetime.strftime("%Y-%B-%d %H:%M")
  end
end
