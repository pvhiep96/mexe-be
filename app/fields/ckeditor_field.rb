require "administrate/field/base"

class CkeditorField < Administrate::Field::Base
  def to_s
    data.present? ? data.html_safe : ""
  end

  def truncate
    data.to_s.length > 50 ? "#{data.to_s[0..50]}..." : data.to_s
  end
end