module TimeHelper
  def month_long month
    t('calendar.monthNames')[month.to_i - 1]
  end

  def month_short month
    t('calendar.monthNamesShort')[month.to_i - 1]
  end
end
