time_formats_hash = ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS
time_formats_hash[:dotted] = "%m.%d.%y"
time_formats_hash[:slashed] = "%m/%d/%y"
time_formats_hash[:long] = "%B %d, %Y"
time_formats_hash[:time_am_pm] = "%I:%M %p"
time_formats_hash[:solr] = "%Y-%m-%dT%H:%M:%SZ"
