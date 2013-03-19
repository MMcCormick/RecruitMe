module ApplicationHelper
  def yes_or_no(bool)
    bool ? "Yes" : "No"
  end

  def time_in_months(days)
    days = days + 30 # so we don't have 0 months (aka round up)
    string = ""

    if days > 365
      string += "#{pluralize((days / 365).to_int, "year")}"
      days = days % 365
      string += ", " if days > 29
    end
    string += pluralize(((days / 30) % 12).to_int, "month") if days > 29

    string
  end
end
