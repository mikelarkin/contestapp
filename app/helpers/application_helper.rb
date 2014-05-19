module ApplicationHelper
  def obscure_string(string, count)
    return string if count.blank?
    substring = string.slice(0..(-1 * count - 1))
    return string.gsub(substring, "*" * substring.length)
  end
end
