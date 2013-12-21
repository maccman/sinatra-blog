module Blog
  module Helpers
    ::Date::DATE_FORMATS[:short_ordinal] = lambda { |date|
      day_format = ActiveSupport::Inflector.ordinalize(date.day)
      date.strftime("%b #{day_format}, %Y") # => "Dec 25th, 2007"
    }
  end
end