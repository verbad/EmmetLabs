module MilestonesHelper
  def milestone_label(milestone, prefix)
    return '' unless milestone
    [
      prefix, 
      (Date::ABBR_MONTHNAMES[milestone.month] if milestone.month?), 
      [milestone.day, milestone.year, milestone.name].reject { |i| i.blank? }.join(', '), 
    ].reject { |i| i.blank? }.join(' ')
  end  
end