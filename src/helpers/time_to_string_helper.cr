module Helpers::TimeToStringHelper
  extend self

  def time_to_string(time)
    time.to_s("%B %d, %Y")
  end
end
